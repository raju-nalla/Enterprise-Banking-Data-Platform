EXEC dbo.usp_CreateLoan
      @CustomerID = 1
    , @AccountID = 2
    , @LoanType = 'Personal'
    , @PrincipalAmount = 500000
    , @InterestRate = 10.5
    , @TenureMonths = 60;

SELECT
    LoanID,
    LoanNumber,
    CustomerID,
    AccountID,
    LoanType,
    PrincipalAmount,
    InterestRate,
    TenureMonths,
    EMIAmount,
    OutstandingAmount,
    LoanStatus
FROM lending.Loans;