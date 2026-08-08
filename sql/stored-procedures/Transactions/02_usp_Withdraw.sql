/*
==============================================================================
Stored Procedure : dbo.usp_Withdraw
Author           : Raju Nalla
Project          : Enterprise Banking Data Platform
Description      : Withdraw money from a customer account.
==============================================================================
Business Rules
--------------
1. Account must exist.
2. Account must be Active.
3. Withdrawal amount must be greater than zero.
4. Sufficient balance must be available.
5. Update Account Balance.
6. Insert Transaction History.
7. Commit or Rollback as one transaction.
==============================================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_Withdraw
(
      @AccountID         INT
    , @Amount            DECIMAL(18,2)
    , @TransactionMode   VARCHAR(20)
    , @Remarks           VARCHAR(255) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
          @CurrentBalance        DECIMAL(18,2)
        , @NewBalance            DECIMAL(18,2)
        , @TransactionNumber     VARCHAR(30);

    -------------------------------------------------------------
    -- Validation
    -------------------------------------------------------------

    IF @Amount <= 0
    BEGIN
        THROW 50001, 'Withdrawal amount must be greater than zero.', 1;
    END

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID = @AccountID
    )
    BEGIN
        THROW 50002, 'Account does not exist.', 1;
    END

    IF EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID = @AccountID
          AND AccountStatus <> 'Active'
    )
    BEGIN
        THROW 50003, 'Account is not active.', 1;
    END

    -------------------------------------------------------------
    -- Get Current Balance
    -------------------------------------------------------------

    SELECT
        @CurrentBalance = Balance
    FROM core.Accounts
    WHERE AccountID = @AccountID;

    IF @CurrentBalance < @Amount
    BEGIN
        THROW 50004, 'Insufficient balance.', 1;
    END

    SET @NewBalance = @CurrentBalance - @Amount;

    -------------------------------------------------------------
    -- Generate Transaction Number
    -------------------------------------------------------------

    SET @TransactionNumber =
        CONCAT
        (
            'TXN-',
            YEAR(GETDATE()),
            '-',
            RIGHT
            (
                '0000000000'
                +
                CAST
                (
                    NEXT VALUE FOR transactions.seq_TransactionNumber
                    AS VARCHAR(10)
                ),
                10
            )
        );

    -------------------------------------------------------------
    -- Transaction
    -------------------------------------------------------------

    BEGIN TRY

        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Update Account
        ---------------------------------------------------------

        UPDATE core.Accounts
        SET
              Balance = @NewBalance
            , AvailableBalance = @NewBalance
            , ModifiedDate = SYSDATETIME()
        WHERE AccountID = @AccountID;

        ---------------------------------------------------------
        -- Insert Transaction
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
            , TransactionDate
            , Remarks
        )
        VALUES
        (
              @TransactionNumber
            , @AccountID
            , 'Withdrawal'
            , @TransactionMode
            , @Amount
            , @NewBalance
            , 'Success'
            , SYSDATETIME()
            , @Remarks
        );

        COMMIT TRANSACTION;

        ---------------------------------------------------------
        -- Return Result
        ---------------------------------------------------------

        SELECT
              @TransactionNumber AS TransactionNumber
            , @NewBalance AS CurrentBalance
            , 'Withdrawal completed successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO