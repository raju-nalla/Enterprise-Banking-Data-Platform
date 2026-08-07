USE EnterpriseBankingDB;
GO

SELECT dbo.fn_CalculateAge('1995-08-15') AS Age;
GO

SELECT dbo.fn_CalculateAge('2000-12-20') AS Age;
GO

SELECT dbo.fn_CalculateAge('1988-01-01') AS Age;
GO