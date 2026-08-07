USE EnterpriseBankingDB;
GO

SELECT dbo.fn_GetCustomerFullName(1) AS CustomerName;
GO

SELECT dbo.fn_GetCustomerFullName(2) AS CustomerName;
GO

SELECT dbo.fn_GetCustomerFullName(9999) AS CustomerName;
GO