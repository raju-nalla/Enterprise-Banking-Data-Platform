EXEC dbo.usp_ApproveLoan
     @LoanID = 1,
     @ApprovedByEmployeeID = 1;

SELECT
    LoanID,
    LoanStatus,
    ApprovalDate,
    DisbursementDate,
    ApprovedByEmployeeID
FROM lending.Loans
WHERE LoanID = 1;


SELECT
    AccountID,
    Balance,
    AvailableBalance
FROM core.Accounts
WHERE AccountID = 2;

SELECT TOP 1
    TransactionNumber,
    TransactionType,
    TransactionMode,
    Amount,
    Remarks
FROM transactions.Transactions
ORDER BY TransactionID DESC;