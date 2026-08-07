/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Database Programming
Object Type  : Scalar Function
Object Name  : dbo.fn_GetCustomerFullName
File Name    : 03_fn_GetCustomerFullName.sql

Author       : Raju Nalla
Created On   : 2026-08-08
Version      : 1.0

Description  :
Returns the customer's full name based on CustomerID.

Business Use :
Used in reports, stored procedures, audit logs,
notifications, and dashboards.

Dependencies :
- core.Customers

******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetCustomerFullName
(
    @CustomerID INT
)

RETURNS VARCHAR(101)

AS
BEGIN

    DECLARE @FullName VARCHAR(101);

    SELECT
        @FullName =
            CONCAT(
                FirstName,
                ' ',
                LastName
            )
    FROM core.Customers
    WHERE CustomerID = @CustomerID;

    RETURN @FullName;

END;
GO