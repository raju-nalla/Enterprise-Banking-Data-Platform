USE EnterpriseBankingDB;
GO

SELECT dbo.fn_GetAccountBalance(1) AS Balance;
GO

SELECT dbo.fn_GetAccountBalance(2) AS Balance;
GO

SELECT dbo.fn_GetAccountBalance(99999) AS Balance;
GO