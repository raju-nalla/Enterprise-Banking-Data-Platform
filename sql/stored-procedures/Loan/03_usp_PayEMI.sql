CREATE OR ALTER PROCEDURE dbo.usp_PayEMI
(
    @LoanID INT,
    @AccountID INT,
    @Amount DECIMAL(18,2),
    @TransactionMode VARCHAR(30),
    @Remarks VARCHAR(250) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE
            @OutstandingAmount DECIMAL(18,2),
            @EMIAmount DECIMAL(18,2),
            @Balance DECIMAL(18,2),
            @AvailableBalance DECIMAL(18,2),
            @LoanStatus VARCHAR(20),
            @CustomerID INT,
            @TransactionNumber VARCHAR(30),
            @RemainingOutstanding DECIMAL(18,2);

        ----------------------------------------------------------
        -- Validate Account
        ----------------------------------------------------------

        SELECT
            @Balance = Balance,
            @AvailableBalance = AvailableBalance,
            @CustomerID = CustomerID
        FROM core.Accounts WITH (UPDLOCK, ROWLOCK)
        WHERE AccountID = @AccountID
          AND AccountStatus = 'Active';

        IF @Balance IS NULL
            THROW 50001,'Invalid or inactive account.',1;

        ----------------------------------------------------------
        -- Validate Loan
        ----------------------------------------------------------

        SELECT
            @OutstandingAmount = OutstandingAmount,
            @EMIAmount = EMIAmount,
            @LoanStatus = LoanStatus
        FROM lending.Loans WITH (UPDLOCK, ROWLOCK)
        WHERE LoanID = @LoanID
          AND AccountID = @AccountID;

        IF @OutstandingAmount IS NULL
            THROW 50002,'Loan not found.',1;

        IF @LoanStatus = 'Closed'
            THROW 50003,'Loan is already closed.',1;

        IF @LoanStatus <> 'Approved'
            THROW 50004,'Loan must be approved before EMI payment.',1;

        ----------------------------------------------------------
        -- Business Validations
        ----------------------------------------------------------

        IF @Amount < @EMIAmount
            THROW 50005,'Payment amount cannot be less than EMI amount.',1;

        IF @Amount > @OutstandingAmount
            THROW 50006,'Payment amount exceeds outstanding balance.',1;

        IF @AvailableBalance < @Amount
            THROW 50007,'Insufficient account balance.',1;

        ----------------------------------------------------------
        -- Debit Customer Account
        ----------------------------------------------------------

        UPDATE core.Accounts
        SET
            Balance = Balance - @Amount,
            AvailableBalance = AvailableBalance - @Amount,
            ModifiedDate = SYSDATETIME()
        WHERE AccountID = @AccountID;

        SET @RemainingOutstanding = @OutstandingAmount - @Amount;

        ----------------------------------------------------------
        -- Update Loan
        ----------------------------------------------------------

        UPDATE lending.Loans
        SET
            OutstandingAmount = @RemainingOutstanding,

            LoanStatus =
                CASE
                    WHEN @RemainingOutstanding = 0
                        THEN 'Closed'
                    ELSE 'Approved'
                END,

            ClosedDate =
                CASE
                    WHEN @RemainingOutstanding = 0
                        THEN CAST(GETDATE() AS DATE)
                    ELSE ClosedDate
                END,

            IsActive =
                CASE
                    WHEN @RemainingOutstanding = 0
                        THEN 0
                    ELSE IsActive
                END,

            ModifiedDate = SYSDATETIME()

        WHERE LoanID = @LoanID;

        ----------------------------------------------------------
        -- Current Balance
        ----------------------------------------------------------

        SELECT
            @Balance = Balance
        FROM core.Accounts
        WHERE AccountID = @AccountID;

        ----------------------------------------------------------
        -- Generate Transaction Number
        ----------------------------------------------------------

        SET @TransactionNumber =
            'TXN-'
            + CONVERT(VARCHAR(4), YEAR(GETDATE()))
            + '-'
            + RIGHT(
                    '0000000000'
                    + CAST(
                        NEXT VALUE FOR transactions.Seq_TransactionNumber
                        AS VARCHAR(10)
                    ),
                    10
                );

        ----------------------------------------------------------
        -- Transaction Entry
        ----------------------------------------------------------

        INSERT INTO transactions.Transactions
        (
            TransactionNumber,
            AccountID,
            LoanID,
            TransactionType,
            TransactionMode,
            Amount,
            BalanceAfterTransaction,
            TransactionStatus,
            TransactionDate,
            Remarks
        )
        VALUES
        (
            @TransactionNumber,
            @AccountID,
            @LoanID,
            'EMI',
            @TransactionMode,
            @Amount,
            @Balance,
            'Success',
            SYSDATETIME(),
            ISNULL(@Remarks,'Loan EMI Payment')
        );

        ----------------------------------------------------------
        -- Audit Log
        ----------------------------------------------------------

        INSERT INTO audit.AuditLogs
        (
            TableName,
            RecordID,
            ActionType,
            PerformedByEmployeeID,
            ActionDate,
            Remarks
        )
        VALUES
        (
            'Loans',
            @LoanID,
            'EMI Payment',
            NULL,
            SYSDATETIME(),
            CONCAT('EMI Paid : ', @Amount)
        );

        COMMIT TRANSACTION;

        ----------------------------------------------------------
        -- Response
        ----------------------------------------------------------

        SELECT
            @TransactionNumber AS TransactionNumber,
            @Amount AS PaidAmount,
            @RemainingOutstanding AS OutstandingAmount,
            @Balance AS CurrentBalance,

            (
                SELECT LoanStatus
                FROM lending.Loans
                WHERE LoanID = @LoanID
            ) AS LoanStatus,

            'EMI payment processed successfully.' AS Message;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;
GO