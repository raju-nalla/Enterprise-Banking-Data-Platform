
EXEC dbo.usp_RejectLoan
    @LoanID = 2,
    @RejectedByEmployeeID = 1,
    @Remarks = 'Credit score below bank policy.';

SELECT
    LoanID,
    LoanStatus,
    Remarks
FROM lending.Loans
WHERE LoanID = 2;

EXEC dbo.usp_RejectLoan
    @LoanID = 1,
    @RejectedByEmployeeID = 1,
    @Remarks = 'Testing';