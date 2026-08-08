UPDATE transactions.Transactions
SET Amount = 1
WHERE TransactionID = 1;

SELECT
    TransactionID,
    Amount
FROM transactions.Transactions
WHERE TransactionID = 1;