EXEC dbo.usp_TransferFunds
    @FromAccountID = 2,
    @ToAccountID = 3,
    @Amount = 2000,
    @TransactionMode = 'IMPS',
    @Remarks = 'Transfer from SB to CA';

SELECT
    AccountID,
    AccountNumber,
    Balance,
    AvailableBalance
FROM core.Accounts
WHERE AccountID = 2;

SELECT
    AccountID,
    AccountNumber,
    Balance,
    AvailableBalance
FROM core.Accounts
WHERE AccountID = 3;

SELECT TOP (2)
    TransactionNumber,
    AccountID,
    TransactionType,
    TransactionMode,
    Amount,
    BalanceAfterTransaction,
    TransactionStatus
FROM transactions.Transactions
ORDER BY TransactionID DESC;