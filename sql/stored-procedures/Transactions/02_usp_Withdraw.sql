USE [EnterpriseBankingDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Transaction Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_Withdraw

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 2.0

Description:
Withdraws money from an account and records the transaction.

Business Rules

1. Account must exist.
2. Account must be Active.
3. Withdrawal Amount must be greater than zero.
4. Transaction Mode must be valid.
5. Sufficient Balance must be available.
6. Updates Account Balance.
7. Inserts Transaction History.
8. Commit/Rollback as one transaction.

Return Codes

0       Success
3001    Invalid Amount
3002    Account not found or inactive
3003    Insufficient Balance
3004    Invalid Transaction Mode
9999    Unexpected SQL Error
******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_Withdraw
(
      @AccountID              INT
    , @Amount                 DECIMAL(18,2)
    , @TransactionMode        VARCHAR(20)
    , @ProcessedByEmployeeID  INT = NULL
    , @Remarks                VARCHAR(255) = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
      @CurrentBalance     DECIMAL(18,2)
    , @NewBalance         DECIMAL(18,2)
    , @TransactionNumber  VARCHAR(30);

BEGIN TRY

    BEGIN TRANSACTION;

    ------------------------------------------------------------
    -- Validate Amount
    ------------------------------------------------------------

    IF @Amount <= 0
    BEGIN

        SELECT

            NULL AS TransactionNumber,
            NULL AS CurrentBalance,
            3001 AS StatusCode,
            'Withdrawal amount must be greater than zero.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Transaction Mode
    ------------------------------------------------------------

    IF @TransactionMode NOT IN
    (
        'Cash',
        'Cheque',
        'UPI',
        'NEFT',
        'RTGS',
        'IMPS',
        'ATM'
    )
    BEGIN

        SELECT

            NULL AS TransactionNumber,
            NULL AS CurrentBalance,
            3004 AS StatusCode,
            'Invalid Transaction Mode.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Read & Lock Account
    ------------------------------------------------------------

    SELECT
        @CurrentBalance = Balance
    FROM core.Accounts
    WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @AccountID
      AND AccountStatus = 'Active'
      AND IsActive = 1;

    IF @CurrentBalance IS NULL
    BEGIN

        SELECT

            NULL AS TransactionNumber,
            NULL AS CurrentBalance,
            3002 AS StatusCode,
            'Account not found or inactive.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Balance
    ------------------------------------------------------------

    IF @CurrentBalance < @Amount
    BEGIN

        SELECT

            NULL AS TransactionNumber,
            @CurrentBalance AS CurrentBalance,
            3003 AS StatusCode,
            'Insufficient balance.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Calculate Balance
    ------------------------------------------------------------

    SET @NewBalance = @CurrentBalance - @Amount;

    ------------------------------------------------------------
    -- Generate Transaction Number
    ------------------------------------------------------------

    SET @TransactionNumber =
          'TXN-'
        + FORMAT(GETDATE(),'yyyy')
        + '-'
        + RIGHT
        (
            '000000000'
            + CAST
            (
                NEXT VALUE FOR transactions.seq_TransactionNumber
                AS VARCHAR(9)
            ),
            9
        );

    ------------------------------------------------------------
    -- Update Account
    ------------------------------------------------------------

    UPDATE core.Accounts
    SET
          Balance = @NewBalance
        , AvailableBalance = @NewBalance
        , ModifiedDate = SYSDATETIME()
    WHERE AccountID = @AccountID;

    ------------------------------------------------------------
    -- Insert Transaction
    ------------------------------------------------------------

    INSERT INTO transactions.Transactions
    (
          TransactionNumber
        , AccountID
        , ProcessedByEmployeeID
        , TransactionType
        , TransactionMode
        , Amount
        , BalanceAfterTransaction
        , TransactionStatus
        , Remarks
    )
    VALUES
    (
          @TransactionNumber
        , @AccountID
        , @ProcessedByEmployeeID
        , 'Withdrawal'
        , @TransactionMode
        , @Amount
        , @NewBalance
        , 'Success'
        , @Remarks
    );

    COMMIT TRANSACTION;

    ------------------------------------------------------------
    -- Success
    ------------------------------------------------------------

    SELECT

          @TransactionNumber AS TransactionNumber
        , @NewBalance AS CurrentBalance
        , 0 AS StatusCode
        , 'Withdrawal completed successfully.' AS StatusMessage;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT

          NULL AS TransactionNumber
        , NULL AS CurrentBalance
        , 9999 AS StatusCode
        , CONCAT
          (
                'SQL Error '
              , ERROR_NUMBER()
              , ': '
              , ERROR_MESSAGE()
          ) AS StatusMessage;

END CATCH

END;
GO