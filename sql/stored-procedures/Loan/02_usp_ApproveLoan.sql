CREATE OR ALTER PROCEDURE dbo.usp_ApproveLoan
(
      @LoanID INT,
      @ApprovedByEmployeeID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        --------------------------------------------------------
        -- Variables
        --------------------------------------------------------

        DECLARE
            @CustomerID INT,
            @AccountID INT,
            @OutstandingAmount DECIMAL(18,2),
            @LoanStatus VARCHAR(20),
            @TransactionNumber VARCHAR(30),
            @Balance DECIMAL(18,2);

        --------------------------------------------------------
        -- Employee Validation
        --------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM hr.Employees
            WHERE EmployeeID = @ApprovedByEmployeeID
              AND EmployeeStatus='Active'
              AND IsActive=1
        )
        BEGIN
            THROW 50002,'Invalid approving employee.',1;
        END

        --------------------------------------------------------
        -- Loan Validation
        --------------------------------------------------------

        SELECT
            @CustomerID = CustomerID,
            @AccountID = AccountID,
            @OutstandingAmount = OutstandingAmount,
            @LoanStatus = LoanStatus
        FROM lending.Loans WITH (UPDLOCK)
        WHERE LoanID=@LoanID
          AND IsActive=1;

        IF @CustomerID IS NULL
        BEGIN
            THROW 50003,'Loan not found.',1;
        END

        --------------------------------------------------------
        -- Status Validation
        --------------------------------------------------------

        IF @LoanStatus <> 'Pending'
        BEGIN
            THROW 50004,'Only Pending loans can be approved.',1;
        END

        --------------------------------------------------------
        -- Update Loan
        --------------------------------------------------------

        UPDATE lending.Loans
        SET

            LoanStatus='Approved',
            ApprovedByEmployeeID=@ApprovedByEmployeeID,
            ApprovalDate=CAST(GETDATE() AS DATE),
            DisbursementDate=CAST(GETDATE() AS DATE),
            ModifiedDate=SYSDATETIME()

        WHERE LoanID=@LoanID;

        --------------------------------------------------------
        -- Credit Customer Account
        --------------------------------------------------------

        UPDATE core.Accounts
        SET

            Balance = Balance + @OutstandingAmount,
            AvailableBalance = AvailableBalance + @OutstandingAmount,
            ModifiedDate = SYSDATETIME()

        WHERE AccountID=@AccountID;

        --------------------------------------------------------
        -- Current Balance
        --------------------------------------------------------

        SELECT
            @Balance = Balance
        FROM core.Accounts
        WHERE AccountID=@AccountID;

        --------------------------------------------------------
        -- Generate Transaction Number
        --------------------------------------------------------

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

        --------------------------------------------------------
        -- Transaction Entry
        --------------------------------------------------------

        INSERT INTO transactions.Transactions
        (
            TransactionNumber,
            AccountID,
            LoanID,
            ProcessedByEmployeeID,
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
            @ApprovedByEmployeeID,
            'Deposit',
            'Loan Disbursement',
            @OutstandingAmount,
            @Balance,
            'Success',
            SYSDATETIME(),
            'Loan Approved & Amount Credited'
        );

        --------------------------------------------------------
        -- Commit
        --------------------------------------------------------

        COMMIT TRANSACTION;

        --------------------------------------------------------
        -- Result
        --------------------------------------------------------

        SELECT

            LoanID=@LoanID,
            TransactionNumber=@TransactionNumber,
            CreditedAmount=@OutstandingAmount,
            CurrentBalance=@Balance,
            Message='Loan approved and amount credited successfully.';

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT>0
            ROLLBACK;

        THROW;

    END CATCH

END
GO