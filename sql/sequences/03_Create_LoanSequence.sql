IF NOT EXISTS (
    SELECT 1
    FROM sys.sequences
    WHERE name = 'seq_LoanNumber'
      AND SCHEMA_NAME(schema_id) = 'lending'
)
BEGIN
    CREATE SEQUENCE lending.seq_LoanNumber
        AS BIGINT
        START WITH 1
        INCREMENT BY 1
        NO CACHE;
END;
GO

SELECT NEXT VALUE FOR lending.seq_LoanNumber;