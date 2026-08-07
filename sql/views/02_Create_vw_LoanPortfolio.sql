USE EnterpriseBankingDB;
GO

CREATE OR ALTER VIEW reporting.vw_LoanPortfolio
AS

SELECT

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

    -------------------------------------------------------------------------
    -- Loan Information
    -------------------------------------------------------------------------
    l.LoanID,
    l.LoanNumber,
    l.LoanType,
    l.PrincipalAmount,
    l.InterestRate,
    l.TenureMonths,
    l.EMIAmount,
    l.OutstandingAmount,
    l.LoanStatus,
    l.ApplicationDate,
    l.ApprovalDate,
    l.DisbursementDate,

    -------------------------------------------------------------------------
    -- Approved By
    -------------------------------------------------------------------------
    e.EmployeeID,
    e.EmployeeNumber,
    CONCAT(e.FirstName, ' ', e.LastName) AS ApprovedBy,

    -------------------------------------------------------------------------
    -- Audit
    -------------------------------------------------------------------------
    l.CreatedDate,
    l.ModifiedDate

FROM lending.Loans l

INNER JOIN core.Customers c
    ON l.CustomerID = c.CustomerID

LEFT JOIN core.Accounts a
    ON l.AccountID = a.AccountID

LEFT JOIN hr.Employees e
    ON l.ApprovedByEmployeeID = e.EmployeeID;
GO