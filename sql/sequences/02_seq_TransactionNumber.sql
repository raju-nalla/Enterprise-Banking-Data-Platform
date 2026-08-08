CREATE SEQUENCE transactions.seq_TransactionNumber
AS BIGINT
START WITH 1
INCREMENT BY 1
NO CACHE;
GO

SELECT NEXT VALUE FOR transactions.seq_TransactionNumber;