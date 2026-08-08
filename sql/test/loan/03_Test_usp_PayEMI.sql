EXEC dbo.usp_PayEMI
    @LoanID = 1,
    @AccountID = 2,
    @Amount = 10746.95,
    @TransactionMode = 'UPI';

SELECT LoanStatus,
       OutstandingAmount
FROM lending.Loans
WHERE LoanID = 1;

SELECT TOP (1)
       TransactionType,
       TransactionMode,
       Amount,
       Remarks
FROM transactions.Transactions
ORDER BY TransactionID DESC;