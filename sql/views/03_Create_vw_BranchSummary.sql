/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Reporting Layer
Object Type  : View
Object Name  : reporting.vw_BranchSummary
File Name    : 03_Create_vw_BranchSummary.sql

Author       : Raju Nalla
Created On   : 2026-08-07
Version      : 1.0

Description  :
Returns branch-level KPIs including customer count, account count,
employee count, active accounts, total balance, and available balance.

Business Use :
Used by Branch Managers, Regional Managers, Power BI dashboards,
Azure Synapse reporting, and Azure Data Factory pipelines.

Dependencies :
- core.Branches
- core.Accounts
- hr.Employees

Change History
--------------------------------------------------------------------------------
Version | Date       | Author      | Description
--------------------------------------------------------------------------------
1.0     | 2026-08-07 | Raju Nalla  | Initial Creation
******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER VIEW reporting.vw_BranchSummary
AS

SELECT

    -------------------------------------------------------------------------
    -- Branch Information
    -------------------------------------------------------------------------
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.City,
    b.State,
    b.Country,

    -------------------------------------------------------------------------
    -- Customer & Account Metrics
    -------------------------------------------------------------------------
    COALESCE(a.CustomerCount, 0) AS CustomerCount,

    COALESCE(a.AccountCount, 0) AS AccountCount,

    COALESCE(a.ActiveAccountCount, 0) AS ActiveAccountCount,

    COALESCE(a.TotalBalance, 0.00) AS TotalBalance,

    COALESCE(a.TotalAvailableBalance, 0.00) AS TotalAvailableBalance,

    -------------------------------------------------------------------------
    -- Employee Metrics
    -------------------------------------------------------------------------
    COALESCE(e.EmployeeCount, 0) AS EmployeeCount

FROM core.Branches b

------------------------------------------------------------------------
-- Account Summary
------------------------------------------------------------------------
LEFT JOIN
(
    SELECT

        BranchID,

        COUNT(DISTINCT CustomerID) AS CustomerCount,

        COUNT(AccountID) AS AccountCount,

        SUM(CASE
                WHEN AccountStatus = 'Active'
                THEN 1
                ELSE 0
            END) AS ActiveAccountCount,

        SUM(Balance) AS TotalBalance,

        SUM(AvailableBalance) AS TotalAvailableBalance

    FROM core.Accounts

    GROUP BY BranchID

) a
ON b.BranchID = a.BranchID

------------------------------------------------------------------------
-- Employee Summary
------------------------------------------------------------------------
LEFT JOIN
(
    SELECT

        BranchID,

        COUNT(EmployeeID) AS EmployeeCount

    FROM hr.Employees

    GROUP BY BranchID

) e
ON b.BranchID = e.BranchID;

GO