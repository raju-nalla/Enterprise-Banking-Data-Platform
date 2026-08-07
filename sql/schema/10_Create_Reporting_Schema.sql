USE EnterpriseBankingDB;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'reporting'
)
BEGIN
    EXEC('CREATE SCHEMA reporting');
END;
GO