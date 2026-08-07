/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Database Programming
Object Type  : Scalar Function
Object Name  : dbo.fn_GetLoanOutstanding
File Name    : 05_fn_GetLoanOutstanding.sql

Author       : Raju Nalla
Created On   : 2026-08-08
Version      : 1.0

Description  :
Returns the current outstanding amount for a loan.

Business Use :
Used in EMI processing, loan closure,
customer loan enquiry, reporting,
and dashboards.

Dependencies :
- lending.Loans

******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetLoanOutstanding
(
    @LoanID BIGINT
)

RETURNS DECIMAL(18,2)

AS
BEGIN

    DECLARE @OutstandingAmount DECIMAL(18,2);

    SELECT
        @OutstandingAmount = OutstandingAmount
    FROM lending.Loans
    WHERE LoanID = @LoanID;

    RETURN @OutstandingAmount;

END;
GO