EXEC dbo.usp_Deposit
     @AccountID = 2,
     @Amount = 5000,
     @TransactionMode = 'Cash',
     @Remarks = 'Cash Deposit';

     
SELECT
    AccountID,
    Balance,
    AvailableBalance
FROM core.Accounts
WHERE AccountID = 2;

SELECT TOP (1) *
FROM transactions.Transactions
WHERE AccountID = 2
ORDER BY TransactionID DESC;