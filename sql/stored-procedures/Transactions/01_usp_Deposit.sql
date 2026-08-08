CREATE OR ALTER PROCEDURE dbo.usp_Deposit
(
      @AccountID INT,
      @Amount DECIMAL(18,2),
      @TransactionMode VARCHAR(20),
      @ProcessedByEmployeeID INT = NULL,
      @Remarks VARCHAR(255) = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
      @CurrentBalance DECIMAL(18,2),
      @NewBalance DECIMAL(18,2),
      @TransactionNumber VARCHAR(30);

BEGIN TRY

    BEGIN TRANSACTION;

    ---------------------------------------------------
    -- Validate Deposit Amount
    ---------------------------------------------------

    IF @Amount <= 0
        THROW 50001, 'Deposit amount must be greater than zero.', 1;

    ---------------------------------------------------
    -- Read Account
    ---------------------------------------------------

    SELECT
        @CurrentBalance = Balance
    FROM core.Accounts WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @AccountID
      AND AccountStatus = 'Active'
      AND IsActive = 1;

    IF @CurrentBalance IS NULL
        THROW 50002, 'Account not found or inactive.', 1;

    ---------------------------------------------------
    -- Calculate New Balance
    ---------------------------------------------------

    SET @NewBalance = @CurrentBalance + @Amount;

    ---------------------------------------------------
    -- Update Account
    ---------------------------------------------------

    UPDATE core.Accounts
    SET
        Balance = @NewBalance,
        AvailableBalance = @NewBalance,
        ModifiedDate = SYSDATETIME()
    WHERE AccountID = @AccountID;

    ---------------------------------------------------
    -- Generate Transaction Number
    ---------------------------------------------------

    SET @TransactionNumber =
            'TXN-'
            + FORMAT(GETDATE(),'yyyy')
            + '-'
            + RIGHT('000000000'
            + CAST(NEXT VALUE FOR transactions.seq_TransactionNumber AS VARCHAR(9)),9);

    ---------------------------------------------------
    -- Insert Transaction
    ---------------------------------------------------

    INSERT INTO transactions.Transactions
    (
        TransactionNumber,
        AccountID,
        ProcessedByEmployeeID,
        TransactionType,
        TransactionMode,
        Amount,
        BalanceAfterTransaction,
        TransactionStatus,
        Remarks
    )
    VALUES
    (
        @TransactionNumber,
        @AccountID,
        @ProcessedByEmployeeID,
        'Deposit',
        @TransactionMode,
        @Amount,
        @NewBalance,
        'Success',
        @Remarks
    );

    COMMIT TRANSACTION;

    SELECT
        @TransactionNumber AS TransactionNumber,
        @NewBalance AS CurrentBalance,
        'Deposit completed successfully.' AS Message;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO