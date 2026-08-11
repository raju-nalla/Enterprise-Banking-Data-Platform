USE [EnterpriseBankingDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***************************************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Transaction Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_Deposit

Author       : Raju Nalla
Created On   : 11-Aug-2026
Version      : 2.0

Description:
Deposits money into an active customer account and records the transaction.

Business Rules

1. Deposit Amount must be greater than zero.
2. Account must exist and be Active.
3. Transaction Mode must be valid.
4. Account Balance and Available Balance are updated.
5. Transaction is recorded.
6. All operations execute within a single transaction.

Return Codes

0       Success
2001    Invalid Account
2002    Invalid Deposit Amount
2003    Invalid Transaction Mode
9999    Unexpected SQL Error

***************************************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_Deposit
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
    , @StatusCode INT = -1
    , @StatusMessage VARCHAR(200) = ''
    , @AccountNumber VARCHAR(20);

BEGIN TRY

    BEGIN TRANSACTION;

    ------------------------------------------------------------
    -- Clean Inputs
    ------------------------------------------------------------

    SET @TransactionMode = UPPER(LTRIM(RTRIM(@TransactionMode)));
    SET @Remarks = LEFT(LTRIM(RTRIM(ISNULL(@Remarks,''))),255);

    ------------------------------------------------------------
    -- Validate Deposit Amount
    ------------------------------------------------------------

    IF @Amount <= 0
    BEGIN

        SET @StatusCode = 2002;
        SET @StatusMessage = 'Deposit amount must be greater than zero.';

        SELECT
            NULL AS TransactionNumber,
            NULL AS AccountID,
            NULL AS AccountNumber,
            NULL AS CurrentBalance,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        ROLLBACK TRANSACTION;
        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Transaction Mode
    ------------------------------------------------------------

    IF @TransactionMode NOT IN
    (
        'CASH',
        'CHEQUE',
        'UPI',
        'NEFT',
        'RTGS',
        'IMPS'
    )
    BEGIN

        SET @StatusCode = 2003;
        SET @StatusMessage = 'Invalid Transaction Mode.';

        SELECT
            NULL AS TransactionNumber,
            NULL AS AccountID,
            NULL AS AccountNumber,
            NULL AS CurrentBalance,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        ROLLBACK TRANSACTION;
        RETURN;

    END;

    ------------------------------------------------------------
    -- Read Account
    ------------------------------------------------------------

    SELECT

          @CurrentBalance = Balance
        , @AccountNumber = AccountNumber

    FROM core.Accounts WITH (UPDLOCK, HOLDLOCK)

    WHERE AccountID = @AccountID
      AND AccountStatus = 'Active'
      AND IsActive = 1;

    IF @CurrentBalance IS NULL
    BEGIN

        SET @StatusCode = 2001;
        SET @StatusMessage = 'Account not found or inactive.';

        SELECT
            NULL AS TransactionNumber,
            NULL AS AccountID,
            NULL AS AccountNumber,
            NULL AS CurrentBalance,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        ROLLBACK TRANSACTION;
        RETURN;

    END;

    ------------------------------------------------------------
    -- Calculate Balance
    ------------------------------------------------------------

    SET @NewBalance = @CurrentBalance + @Amount;

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
        , 'Deposit'
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

    SET @StatusCode = 0;
    SET @StatusMessage = 'Deposit completed successfully.';

    SELECT

          @TransactionNumber AS TransactionNumber
        , @AccountID AS AccountID
        , @AccountNumber AS AccountNumber
        , @NewBalance AS CurrentBalance
        , @StatusCode AS StatusCode
        , @StatusMessage AS StatusMessage;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SET @StatusCode = 9999;

    SET @StatusMessage =
        CONCAT
        (
            'SQL Error ',
            ERROR_NUMBER(),
            ': ',
            ERROR_MESSAGE()
        );

    SELECT

          NULL AS TransactionNumber
        , NULL AS AccountID
        , NULL AS AccountNumber
        , NULL AS CurrentBalance
        , @StatusCode AS StatusCode
        , @StatusMessage AS StatusMessage;

END CATCH

END;
GO