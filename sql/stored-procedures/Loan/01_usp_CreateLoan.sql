CREATE OR ALTER PROCEDURE dbo.usp_CreateLoan
(
      @CustomerID        INT
    , @AccountID         INT
    , @LoanType          VARCHAR(20)
    , @PrincipalAmount   DECIMAL(18,2)
    , @InterestRate      DECIMAL(5,2)
    , @TenureMonths      INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        -------------------------------------------------------
        -- Variable Declaration
        -------------------------------------------------------
        DECLARE
              @LoanID             INT
            , @LoanNumber         VARCHAR(20)
            , @BranchCode         VARCHAR(10)
            , @LoanSequence       BIGINT
            , @MonthlyRate        DECIMAL(18,10)
            , @EMIAmount          DECIMAL(18,2)
            , @OutstandingAmount  DECIMAL(18,2);

        -------------------------------------------------------
        -- Customer Validation
        -------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM core.Customers
            WHERE CustomerID = @CustomerID
              AND IsActive = 1
        )
        BEGIN
            THROW 50001,'Customer does not exist.',1;
        END

        -------------------------------------------------------
        -- Account Validation
        -------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM core.Accounts
            WHERE AccountID = @AccountID
              AND CustomerID = @CustomerID
              AND IsActive = 1
        )
        BEGIN
            THROW 50002,'Account does not belong to the customer.',1;
        END

        -------------------------------------------------------
        -- Loan Type Validation
        -------------------------------------------------------
        IF @LoanType NOT IN
        (
            'Home',
            'Personal',
            'Vehicle',
            'Education',
            'Business'
        )
        BEGIN
            THROW 50003,'Invalid Loan Type.',1;
        END

        -------------------------------------------------------
        -- Principal Validation
        -------------------------------------------------------
        IF @PrincipalAmount <= 0
        BEGIN
            THROW 50004,'Principal Amount must be greater than zero.',1;
        END

        -------------------------------------------------------
        -- Interest Validation
        -------------------------------------------------------
        IF @InterestRate <= 0
        BEGIN
            THROW 50005,'Interest Rate must be greater than zero.',1;
        END

        -------------------------------------------------------
        -- Tenure Validation
        -------------------------------------------------------
        IF @TenureMonths <= 0
        BEGIN
            THROW 50006,'Tenure must be greater than zero.',1;
        END

        -------------------------------------------------------
        -- Branch Code
        -------------------------------------------------------
        SELECT
            @BranchCode = B.BranchCode
        FROM core.Accounts A
        INNER JOIN core.Branches B
            ON A.BranchID = B.BranchID
        WHERE A.AccountID = @AccountID;

        -------------------------------------------------------
        -- Loan Number
        -------------------------------------------------------
        SET @LoanSequence =
            NEXT VALUE FOR lending.seq_LoanNumber;

        SET @LoanNumber =
            'LN-'
            + @BranchCode
            + '-'
            + CAST(YEAR(GETDATE()) AS VARCHAR(4))
            + '-'
            + RIGHT('000000'+CAST(@LoanSequence AS VARCHAR(6)),6);

        -------------------------------------------------------
        -- EMI Calculation
        -------------------------------------------------------
        SET @MonthlyRate =
            (@InterestRate/12.0)/100.0;

        SET @EMIAmount =
        (
            @PrincipalAmount
            * @MonthlyRate
            * POWER((1+@MonthlyRate),@TenureMonths)
        )
        /
        (
            POWER((1+@MonthlyRate),@TenureMonths)-1
        );

        SET @EMIAmount =
            ROUND(@EMIAmount,2);

        SET @OutstandingAmount =
            @PrincipalAmount;

        -------------------------------------------------------
        -- Insert Loan
        -------------------------------------------------------
        BEGIN TRANSACTION;

        INSERT INTO lending.Loans
        (
              LoanNumber
            , CustomerID
            , AccountID
            , LoanType
            , PrincipalAmount
            , InterestRate
            , TenureMonths
            , EMIAmount
            , OutstandingAmount
            , LoanStatus
        )
        VALUES
        (
              @LoanNumber
            , @CustomerID
            , @AccountID
            , @LoanType
            , @PrincipalAmount
            , @InterestRate
            , @TenureMonths
            , @EMIAmount
            , @OutstandingAmount
            , 'Pending'
        );

        SET @LoanID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        -------------------------------------------------------
        -- Success Result
        -------------------------------------------------------
        SELECT
              @LoanID AS LoanID
            , @LoanNumber AS LoanNumber
            , @EMIAmount AS EMIAmount
            , @OutstandingAmount AS OutstandingAmount
            , 'Loan application created successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO