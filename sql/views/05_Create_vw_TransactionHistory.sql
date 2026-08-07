/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Reporting Layer
Object Type  : View
Object Name  : reporting.vw_TransactionHistory
File Name    : 05_Create_vw_TransactionHistory.sql

Author       : Raju Nalla
Created On   : 2026-08-07
Version      : 1.0

Description  :
Returns complete transaction history including customer,
account, branch, employee, and loan information.

Business Use :
Used by Operations, Finance, Audit, Power BI dashboards,
Azure Synapse reporting, and Azure Data Factory pipelines.

Dependencies :
- transactions.Transactions
- core.Accounts
- core.Customers
- core.Branches
- hr.Employees
- lending.Loans

Change History
--------------------------------------------------------------------------------
Version | Date       | Author      | Description
--------------------------------------------------------------------------------
1.0     | 2026-08-07 | Raju Nalla  | Initial Creation
******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER VIEW reporting.vw_TransactionHistory
AS

SELECT

    -------------------------------------------------------------------------
    -- Transaction Information
    -------------------------------------------------------------------------
    t.TransactionID,
    t.TransactionNumber,
    t.TransactionDate,
    t.TransactionType,
    t.TransactionMode,
    t.Amount,
    t.BalanceAfterTransaction,
    t.TransactionStatus,
    t.Remarks,

    -------------------------------------------------------------------------
    -- Customer Information
    -------------------------------------------------------------------------
    c.CustomerID,
    c.CustomerNumber,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,

    -------------------------------------------------------------------------
    -- Account Information
    -------------------------------------------------------------------------
    a.AccountID,
    a.AccountNumber,
    a.AccountType,
    a.CurrencyCode,

    -------------------------------------------------------------------------
    -- Branch Information
    -------------------------------------------------------------------------
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.City,
    b.State,

    -------------------------------------------------------------------------
    -- Employee Information
    -------------------------------------------------------------------------
    e.EmployeeID,
    e.EmployeeNumber,
    CONCAT(e.FirstName, ' ', e.LastName) AS ProcessedBy,

    -------------------------------------------------------------------------
    -- Loan Information
    -------------------------------------------------------------------------
    l.LoanID,
    l.LoanNumber,
    l.LoanType,

    -------------------------------------------------------------------------
    -- Audit
    -------------------------------------------------------------------------
    t.CreatedDate,
    t.ModifiedDate

FROM transactions.Transactions t

INNER JOIN core.Accounts a
    ON t.AccountID = a.AccountID

INNER JOIN core.Customers c
    ON a.CustomerID = c.CustomerID

INNER JOIN core.Branches b
    ON a.BranchID = b.BranchID

LEFT JOIN hr.Employees e
    ON t.ProcessedByEmployeeID = e.EmployeeID

LEFT JOIN lending.Loans l
    ON t.LoanID = l.LoanID;

GO