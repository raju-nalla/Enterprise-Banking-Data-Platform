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

Author       : Raju Nalla
Created On   : 11-Aug-2026
Version      : 3.0

Description:
Withdraws money from an active customer account and records the transaction.

Business Rules

1. Withdrawal Amount must be greater than zero.
2. Account must exist and be Active.
3. Transaction Mode must be valid.
4. Sufficient Balance must be available.
5. Account Balance and Available Balance are updated.
6. Transaction is recorded.
7. All operations execute within a single transaction.

Return Codes

0       Success
3001    Invalid Withdrawal Amount
3002    Invalid Account
3003    Insufficient Balance
3004    Invalid Transaction Mode
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_Withdraw
(
      @AccountID INT
    , @Amount DECIMAL(18,2)
    , @TransactionMode VARCHAR(20)
    , @ProcessedByEmployeeID INT = NULL
    , @Remarks VARCHAR(255) = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE

      @CurrentBalance DECIMAL(18,2)
    , @NewBalance DECIMAL(18,2)
    , @TransactionNumber VARCHAR(30)
    , @AccountNumber VARCHAR(20)
    , @StatusCode INT = -1
    , @StatusMessage VARCHAR(200) = '';

BEGIN TRY

    ------------------------------------------------------------
    -- Clean Inputs
    ------------------------------------------------------------

    SET @TransactionMode = LTRIM(RTRIM(@TransactionMode));

    SET @Remarks =
        LEFT
        (
            LTRIM(RTRIM(ISNULL(@Remarks,''))),
            255
        );

    ------------------------------------------------------------
    -- Validate Amount
    ------------------------------------------------------------

    IF @Amount <= 0
    BEGIN

        SELECT

              NULL AS TransactionNumber
            , NULL AS AccountID
            , NULL AS AccountNumber
            , NULL AS CurrentBalance
            , 3001 AS StatusCode
            , 'Withdrawal amount must be greater than zero.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Transaction Mode
    ------------------------------------------------------------

    IF @TransactionMode NOT IN
    (
          'Cash'
        , 'ATM'
        , 'Card'
        , 'UPI'
        , 'IMPS'
        , 'NEFT'
        , 'RTGS'
        , 'Branch'
        , 'Internal'
        , 'Loan Disbursement'
    )
    BEGIN

        SELECT

              NULL AS TransactionNumber
            , NULL AS AccountID
            , NULL AS AccountNumber
            , NULL AS CurrentBalance
            , 3004 AS StatusCode
            , 'Invalid Transaction Mode.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Account
    ------------------------------------------------------------

    SELECT

          @CurrentBalance = Balance
        , @AccountNumber = AccountNumber

    FROM core.Accounts
    WITH (UPDLOCK, HOLDLOCK)

    WHERE AccountID = @AccountID
      AND AccountStatus = 'Active'
      AND IsActive = 1;

    IF @CurrentBalance IS NULL
    BEGIN

        SELECT

              NULL AS TransactionNumber
            , NULL AS AccountID
            , NULL AS AccountNumber
            , NULL AS CurrentBalance
            , 3002 AS StatusCode
            , 'Account not found or inactive.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Balance
    ------------------------------------------------------------

    IF @CurrentBalance < @Amount
    BEGIN

        SELECT

              NULL AS TransactionNumber
            , @AccountID AS AccountID
            , @AccountNumber AS AccountNumber
            , @CurrentBalance AS CurrentBalance
            , 3003 AS StatusCode
            , 'Insufficient balance.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Calculate New Balance
    ------------------------------------------------------------

    SET @NewBalance = @CurrentBalance - @Amount;

    ------------------------------------------------------------
    -- Begin Transaction
    ------------------------------------------------------------

    BEGIN TRANSACTION;

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
    -- Generate Transaction Number
    ------------------------------------------------------------

    SET @TransactionNumber =
            'TXN-'
        + CAST(YEAR(GETDATE()) AS VARCHAR(4))
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

    ------------------------------------------------------------
    -- Commit
    ------------------------------------------------------------

    COMMIT TRANSACTION;

    ------------------------------------------------------------
    -- Success
    ------------------------------------------------------------

    SELECT

          @TransactionNumber AS TransactionNumber
        , @AccountID AS AccountID
        , @AccountNumber AS AccountNumber
        , @NewBalance AS CurrentBalance
        , 0 AS StatusCode
        , 'Withdrawal completed successfully.' AS StatusMessage;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT

          NULL AS TransactionNumber
        , NULL AS AccountID
        , NULL AS AccountNumber
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