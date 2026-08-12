CREATE OR ALTER PROCEDURE dbo.usp_TransferFunds
(
      @FromAccountID INT
    , @ToAccountID INT
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
      @FromBalance DECIMAL(18,2)
    , @ToBalance DECIMAL(18,2)
    , @DebitTxnNo VARCHAR(30)
    , @CreditTxnNo VARCHAR(30)
    , @FromAccountNumber VARCHAR(20)
    , @ToAccountNumber VARCHAR(20)
    , @StatusCode INT = -1
    , @StatusMessage VARCHAR(200);

BEGIN TRY

    BEGIN TRANSACTION;

    ------------------------------------------------------------
    -- Clean Inputs
    ------------------------------------------------------------

    SET @TransactionMode = UPPER(LTRIM(RTRIM(@TransactionMode)));

    SET @Remarks =
        LEFT(LTRIM(RTRIM(ISNULL(@Remarks,''))),255);

    ------------------------------------------------------------
    -- Validate Amount
    ------------------------------------------------------------

    IF @Amount <= 0
    BEGIN

        SET @StatusCode = 4001;
        SET @StatusMessage = 'Transfer amount must be greater than zero.';

        ROLLBACK TRANSACTION;

        SELECT
              NULL AS DebitTransactionNumber
            , NULL AS CreditTransactionNumber
            , NULL AS FromAccountNumber
            , NULL AS ToAccountNumber
            , NULL AS SenderBalance
            , NULL AS ReceiverBalance
            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Same Account
    ------------------------------------------------------------

    IF @FromAccountID = @ToAccountID
    BEGIN

        SET @StatusCode = 4002;
        SET @StatusMessage='Source and Destination Accounts cannot be the same.';

        ROLLBACK TRANSACTION;

        SELECT
              NULL,NULL,NULL,NULL,NULL,NULL,
              @StatusCode,
              @StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Transaction Mode
    ------------------------------------------------------------

    IF @TransactionMode NOT IN
    (
        'CASH',
        'ATM',
        'UPI',
        'NEFT',
        'RTGS',
        'IMPS',
        'INTERNAL'
    )
    BEGIN

        SET @StatusCode = 4006;
        SET @StatusMessage='Invalid Transaction Mode.';

        ROLLBACK TRANSACTION;

        SELECT
              NULL,NULL,NULL,NULL,NULL,NULL,
              @StatusCode,
              @StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Source Account
    ------------------------------------------------------------

    SELECT
          @FromBalance = Balance
        , @FromAccountNumber = AccountNumber
    FROM core.Accounts WITH (UPDLOCK,HOLDLOCK)
    WHERE AccountID=@FromAccountID
      AND AccountStatus='Active'
      AND IsActive=1;

    IF @FromBalance IS NULL
    BEGIN

        SET @StatusCode=4003;
        SET @StatusMessage='Source account not found or inactive.';

        ROLLBACK TRANSACTION;

        SELECT
              NULL,NULL,NULL,NULL,NULL,NULL,
              @StatusCode,
              @StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Destination Account
    ------------------------------------------------------------

    SELECT
          @ToBalance = Balance
        , @ToAccountNumber = AccountNumber
    FROM core.Accounts WITH (UPDLOCK,HOLDLOCK)
    WHERE AccountID=@ToAccountID
      AND AccountStatus='Active'
      AND IsActive=1;

    IF @ToBalance IS NULL
    BEGIN

        SET @StatusCode=4004;
        SET @StatusMessage='Destination account not found or inactive.';

        ROLLBACK TRANSACTION;

        SELECT
              NULL,NULL,NULL,NULL,NULL,NULL,
              @StatusCode,
              @StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Balance Validation
    ------------------------------------------------------------

    IF @FromBalance < @Amount
    BEGIN

        SET @StatusCode=4005;
        SET @StatusMessage='Insufficient balance.';

        ROLLBACK TRANSACTION;

        SELECT
              NULL,NULL,
              @FromAccountNumber,
              @ToAccountNumber,
              @FromBalance,
              @ToBalance,
              @StatusCode,
              @StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Calculate Balances
    ------------------------------------------------------------

    SET @FromBalance -= @Amount;
    SET @ToBalance += @Amount;

    ------------------------------------------------------------
    -- Update Accounts
    ------------------------------------------------------------

    UPDATE core.Accounts
    SET
          Balance=@FromBalance
        , AvailableBalance=@FromBalance
        , ModifiedDate=SYSDATETIME()
    WHERE AccountID=@FromAccountID;

    UPDATE core.Accounts
    SET
          Balance=@ToBalance
        , AvailableBalance=@ToBalance
        , ModifiedDate=SYSDATETIME()
    WHERE AccountID=@ToAccountID;

    ------------------------------------------------------------
    -- Transaction Numbers
    ------------------------------------------------------------

    SET @DebitTxnNo =
        CONCAT(
            'TXN-',
            YEAR(GETDATE()),
            '-',
            RIGHT(
                '000000000'
                + CAST(
                    NEXT VALUE FOR transactions.seq_TransactionNumber
                    AS VARCHAR(9)
                ),
                9
            )
        );

    SET @CreditTxnNo =
        CONCAT(
            'TXN-',
            YEAR(GETDATE()),
            '-',
            RIGHT(
                '000000000'
                + CAST(
                    NEXT VALUE FOR transactions.seq_TransactionNumber
                    AS VARCHAR(9)
                ),
                9
            )
        );

    ------------------------------------------------------------
    -- Debit Entry
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
        , 'Transfer'
        , @TransactionMode
        , @Amount
        , @FromBalance
        , 'Success'
        , ISNULL(@Remarks,'Fund Transfer - Debit')
    );

    ------------------------------------------------------------
    -- Credit Entry
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
        , 'Transfer'
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

    SET @StatusCode = 0;
    SET @StatusMessage='Fund transfer completed successfully.';

    SELECT
          @DebitTxnNo AS DebitTransactionNumber
        , @CreditTxnNo AS CreditTransactionNumber
        , @FromAccountNumber AS FromAccountNumber
        , @ToAccountNumber AS ToAccountNumber
        , @FromBalance AS SenderBalance
        , @ToBalance AS ReceiverBalance
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
          NULL AS DebitTransactionNumber
        , NULL AS CreditTransactionNumber
        , NULL AS FromAccountNumber
        , NULL AS ToAccountNumber
        , NULL AS SenderBalance
        , NULL AS ReceiverBalance
        , @StatusCode AS StatusCode
        , @StatusMessage AS StatusMessage;

END CATCH

END;