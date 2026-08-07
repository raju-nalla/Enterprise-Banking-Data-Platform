USE EnterpriseBankingDB;
GO

CREATE OR ALTER VIEW reporting.vw_CustomerAccounts
AS

SELECT

    -- Customer Information
    c.CustomerID,
    c.CustomerNumber,
    c.FirstName,
    c.LastName,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    c.Email,
    c.PhoneNumber,
    c.City AS CustomerCity,
    c.State AS CustomerState,
    c.KYCStatus,
    c.CustomerStatus,

    -- Account Information
    a.AccountID,
    a.AccountNumber,
    a.AccountType,
    a.CurrencyCode,
    a.Balance,
    a.AvailableBalance,
    a.AccountStatus,
    a.OpenDate,

    -- Branch Information
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.City AS BranchCity,
    b.State AS BranchState

FROM core.Customers c

INNER JOIN core.Accounts a
    ON c.CustomerID = a.CustomerID

INNER JOIN core.Branches b
    ON a.BranchID = b.BranchID;
GO