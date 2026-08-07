/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Database Programming
Object Type  : Scalar Function
Object Name  : dbo.fn_GetAccountBalance
File Name    : 04_fn_GetAccountBalance.sql

Author       : Raju Nalla
Created On   : 2026-08-08
Version      : 1.0

Description  :
Returns the current balance for a given account.

Business Use :
Used in withdrawals, deposits, transfers,
loan processing, reporting, and dashboards.

Dependencies :
- core.Accounts

******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_GetAccountBalance
(
    @AccountID BIGINT
)

RETURNS DECIMAL(18,4)

AS
BEGIN

    DECLARE @Balance DECIMAL(18,4);

    SELECT
        @Balance = Balance
    FROM core.Accounts
    WHERE AccountID = @AccountID;

    RETURN @Balance;

END;
GO