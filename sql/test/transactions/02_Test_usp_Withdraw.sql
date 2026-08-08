EXEC dbo.usp_Withdraw
     @AccountID = 2,
     @Amount = 3000,
     @TransactionMode = 'ATM',
     @Remarks = 'ATM Cash Withdrawal';

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


EXEC dbo.usp_Withdraw
     @AccountID = 2,
     @Amount = 500000,
     @TransactionMode = 'ATM';