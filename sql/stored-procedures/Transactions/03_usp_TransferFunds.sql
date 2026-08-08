/*
===============================================================================
Procedure Name : dbo.usp_TransferFunds
Author         : Raju Nalla
Description    : Transfers funds between two customer accounts.
                 Performs debit, credit, transaction logging and rollback
                 on failure.

Business Rules
--------------
1. Source account must exist.
2. Destination account must exist.
3. Accounts cannot be the same.
4. Amount must be greater than zero.
5. Both accounts must be Active.
6. Source account must have sufficient balance.
7. Entire transfer executes within one SQL transaction.

===============================================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_TransferFunds
(
      @FromAccountID     INT
    , @ToAccountID       INT
    , @Amount            DECIMAL(18,2)
    , @TransactionMode   VARCHAR(20)
    , @Remarks           VARCHAR(255) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
          @FromBalance DECIMAL(18,2)
        , @ToBalance DECIMAL(18,2)
        , @DebitTxnNo VARCHAR(30)
        , @CreditTxnNo VARCHAR(30);

    BEGIN TRY

        ---------------------------------------------------------
        -- Validations
        ---------------------------------------------------------

        IF @Amount <= 0
            THROW 50001, 'Transfer amount must be greater than zero.',1;

        IF @FromAccountID = @ToAccountID
            THROW 50002,'Source and destination accounts cannot be same.',1;

        ---------------------------------------------------------
        -- Begin Transaction
        ---------------------------------------------------------

        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Read Source Account
        ---------------------------------------------------------

        SELECT
            @FromBalance = Balance
        FROM core.Accounts WITH (UPDLOCK,HOLDLOCK)
        WHERE AccountID = @FromAccountID
        AND AccountStatus='Active';

        IF @FromBalance IS NULL
            THROW 50003,'Source account not found or inactive.',1;

        ---------------------------------------------------------
        -- Read Destination Account
        ---------------------------------------------------------

        SELECT
            @ToBalance = Balance
        FROM core.Accounts WITH (UPDLOCK,HOLDLOCK)
        WHERE AccountID=@ToAccountID
        AND AccountStatus='Active';

        IF @ToBalance IS NULL
            THROW 50004,'Destination account not found or inactive.',1;

        ---------------------------------------------------------
        -- Balance Validation
        ---------------------------------------------------------

        IF @FromBalance < @Amount
            THROW 50005,'Insufficient balance.',1;

        ---------------------------------------------------------
        -- Debit Source Account
        ---------------------------------------------------------

        UPDATE core.Accounts
        SET
              Balance = Balance - @Amount
            , AvailableBalance = AvailableBalance - @Amount
            , ModifiedDate = SYSDATETIME()
        WHERE AccountID=@FromAccountID;

        SET @FromBalance = @FromBalance - @Amount;

        ---------------------------------------------------------
        -- Credit Destination Account
        ---------------------------------------------------------

        UPDATE core.Accounts
        SET
              Balance = Balance + @Amount
            , AvailableBalance = AvailableBalance + @Amount
            , ModifiedDate = SYSDATETIME()
        WHERE AccountID=@ToAccountID;

        SET @ToBalance = @ToBalance + @Amount;

        ---------------------------------------------------------
        -- Debit Transaction Number
        ---------------------------------------------------------

        SET @DebitTxnNo =
            CONCAT(
                'TXN-',
                YEAR(GETDATE()),
                '-',
                RIGHT('0000000000'
                + CAST(NEXT VALUE FOR transactions.seq_TransactionNumber AS VARCHAR(10)),10)
            );

        ---------------------------------------------------------
        -- Credit Transaction Number
        ---------------------------------------------------------

        SET @CreditTxnNo =
            CONCAT(
                'TXN-',
                YEAR(GETDATE()),
                '-',
                RIGHT('0000000000'
                + CAST(NEXT VALUE FOR transactions.seq_TransactionNumber AS VARCHAR(10)),10)
            );

        ---------------------------------------------------------
        -- Insert Debit Transaction
        ---------------------------------------------------------

        INSERT INTO transactions.Transactions
        (
              TransactionNumber
            , AccountID
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
            , 'Withdrawal'
            , @TransactionMode
            , @Amount
            , @FromBalance
            , 'Success'
            , ISNULL(@Remarks,'Fund Transfer - Debit')
        );

        ---------------------------------------------------------
        -- Insert Credit Transaction
        ---------------------------------------------------------

        INSERT INTO transactions.Transactions
        (
              TransactionNumber
            , AccountID
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
            , 'Deposit'
            , @TransactionMode
            , @Amount
            , @ToBalance
            , 'Success'
            , ISNULL(@Remarks,'Fund Transfer - Credit')
        );

        ---------------------------------------------------------
        -- Commit
        ---------------------------------------------------------

        COMMIT TRANSACTION;

        SELECT
              @DebitTxnNo AS DebitTransactionNumber
            , @CreditTxnNo AS CreditTransactionNumber
            , @FromBalance AS SenderBalance
            , @ToBalance AS ReceiverBalance
            , 'Fund transfer completed successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO