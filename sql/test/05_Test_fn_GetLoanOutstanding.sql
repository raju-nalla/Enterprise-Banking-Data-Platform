USE EnterpriseBankingDB;
GO

SELECT dbo.fn_GetLoanOutstanding(1) AS OutstandingAmount;
GO

SELECT dbo.fn_GetLoanOutstanding(2) AS OutstandingAmount;
GO

SELECT dbo.fn_GetLoanOutstanding(99999) AS OutstandingAmount;
GO