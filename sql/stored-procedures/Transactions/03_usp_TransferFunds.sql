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
Object Name  : dbo.usp_TransferFunds

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 2.0

Description:
Transfers funds from one account to another and records both
Debit and Credit transactions.

Business Rules

1. Source Account must exist.
2. Destination Account must exist.
3. Source and Destination Accounts cannot be the same.
4. Transfer Amount must be greater than zero.
5. Transaction Mode must be valid.
6. Both Accounts must be Active.
7. Source Account must have sufficient balance.
8. Debit Source Account.
9. Credit Destination Account.
10. Insert Debit Transaction.
11. Insert Credit Transaction.
12. Commit or Rollback as one transaction.

Return Codes

0       Success
4001    Invalid Transfer Amount
4002    Source and Destination Accounts cannot be same
4003    Source Account not found or inactive
4004    Destination Account not found or inactive
4005    Insufficient Balance
4006    Invalid Transaction Mode
9999    Unexpected SQL Error
******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_TransferFunds
(
      @FromAccountID          INT
    , @ToAccountID            INT
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
      @FromBalance        DECIMAL(18,2)
    , @ToBalance          DECIMAL(18,2)
    , @DebitTxnNo         VARCHAR(30)
    , @CreditTxnNo        VARCHAR(30);

BEGIN TRY

    BEGIN TRANSACTION;

    ------------------------------------------------------------
    -- Validate Amount
    ------------------------------------------------------------

    IF @Amount <= 0
    BEGIN

        SELECT

            NULL AS DebitTransactionNumber,
            NULL AS CreditTransactionNumber,
            4001 AS StatusCode,
            'Transfer amount must be greater than zero.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Same Account
    ------------------------------------------------------------

    IF @FromAccountID = @ToAccountID
    BEGIN

        SELECT

            NULL AS DebitTransactionNumber,
            NULL AS CreditTransactionNumber,
            4002 AS StatusCode,
            'Source and Destination Accounts cannot be the same.' AS StatusMessage;

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

            NULL AS DebitTransactionNumber,
            NULL AS CreditTransactionNumber,
            4006 AS StatusCode,
            'Invalid Transaction Mode.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Read & Lock Source Account
    ------------------------------------------------------------

    SELECT
        @FromBalance = Balance
    FROM core.Accounts
    WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @FromAccountID
      AND AccountStatus = 'Active'
      AND IsActive = 1;

    IF @FromBalance IS NULL
    BEGIN

        SELECT

            NULL AS DebitTransactionNumber,
            NULL AS CreditTransactionNumber,
            4003 AS StatusCode,
            'Source Account not found or inactive.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Read & Lock Destination Account
    ------------------------------------------------------------

    SELECT
        @ToBalance = Balance
    FROM core.Accounts
    WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @ToAccountID
      AND AccountStatus = 'Active'
      AND IsActive = 1;

    IF @ToBalance IS NULL
    BEGIN

        SELECT

            NULL AS DebitTransactionNumber,
            NULL AS CreditTransactionNumber,
            4004 AS StatusCode,
            'Destination Account not found or inactive.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Balance
    ------------------------------------------------------------

    IF @FromBalance < @Amount
    BEGIN

        SELECT

            NULL AS DebitTransactionNumber,
            NULL AS CreditTransactionNumber,
            4005 AS StatusCode,
            'Insufficient balance.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Calculate Balances
    ------------------------------------------------------------

    SET @FromBalance = @FromBalance - @Amount;
    SET @ToBalance   = @ToBalance + @Amount;

    ------------------------------------------------------------
    -- Update Source Account
    ------------------------------------------------------------

    UPDATE core.Accounts
    SET
          Balance = @FromBalance
        , AvailableBalance = @FromBalance
        , ModifiedDate = SYSDATETIME()
    WHERE AccountID = @FromAccountID;

    ------------------------------------------------------------
    -- Update Destination Account
    ------------------------------------------------------------

    UPDATE core.Accounts
    SET
          Balance = @ToBalance
        , AvailableBalance = @ToBalance
        , ModifiedDate = SYSDATETIME()
    WHERE AccountID = @ToAccountID;

    ------------------------------------------------------------
    -- Generate Debit Transaction Number
    ------------------------------------------------------------

    SET @DebitTxnNo =
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
    -- Generate Credit Transaction Number
    ------------------------------------------------------------

    SET @CreditTxnNo =
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
    -- Insert Debit Transaction
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
          @DebitTxnNo
        , @FromAccountID
        , @ProcessedByEmployeeID
        , 'Withdrawal'
        , @TransactionMode
        , @Amount
        , @FromBalance
        , 'Success'
        , ISNULL(@Remarks,'Fund Transfer - Debit')
    );

    ------------------------------------------------------------
    -- Insert Credit Transaction
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
          @CreditTxnNo
        , @ToAccountID
        , @ProcessedByEmployeeID
        , 'Deposit'
        , @TransactionMode
        , @Amount
        , @ToBalance
        , 'Success'
        , ISNULL(@Remarks,'Fund Transfer - Credit')
    );

    COMMIT TRANSACTION;

    ------------------------------------------------------------
    -- Success
    ------------------------------------------------------------

    SELECT

          @DebitTxnNo AS DebitTransactionNumber
        , @CreditTxnNo AS CreditTransactionNumber
        , @FromBalance AS SenderBalance
        , @ToBalance AS ReceiverBalance
        , 0 AS StatusCode
        , 'Fund transfer completed successfully.' AS StatusMessage;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT

          NULL AS DebitTransactionNumber
        , NULL AS CreditTransactionNumber
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