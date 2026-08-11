CREATE OR ALTER PROCEDURE dbo.usp_DashboardSummary
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------
    -- Dashboard KPI Summary
    -----------------------------------------------------

    SELECT

    -----------------------------------------------------
    -- Customer KPIs
    -----------------------------------------------------

    (SELECT COUNT(*) FROM core.Customers) AS TotalCustomers,

    (SELECT COUNT(*)
     FROM core.Customers
     WHERE CustomerStatus='Active') AS ActiveCustomers,

    (SELECT COUNT(*)
     FROM core.Customers
     WHERE CustomerStatus='Inactive') AS InactiveCustomers,

    -----------------------------------------------------
    -- Account KPIs
    -----------------------------------------------------

    (SELECT COUNT(*)
     FROM core.Accounts) AS TotalAccounts,

    (SELECT COUNT(*)
     FROM core.Accounts
     WHERE AccountStatus='Active') AS ActiveAccounts,

    (SELECT ISNULL(SUM(Balance),0)
     FROM core.Accounts) AS TotalAccountBalance,

    -----------------------------------------------------
    -- Transaction KPIs
    -----------------------------------------------------

    (SELECT COUNT(*)
     FROM transactions.Transactions) AS TotalTransactions,

    (SELECT ISNULL(SUM(Amount),0)
     FROM transactions.Transactions
     WHERE TransactionType='Deposit') AS TotalDeposits,

    (SELECT ISNULL(SUM(Amount),0)
     FROM transactions.Transactions
     WHERE TransactionType='Withdrawal') AS TotalWithdrawals,

    (SELECT ISNULL(SUM(Amount),0)
     FROM transactions.Transactions
     WHERE TransactionType='Transfer') AS TotalTransfers,

    (SELECT ISNULL(SUM(Amount),0)
     FROM transactions.Transactions
     WHERE TransactionType='EMI') AS TotalEMICollected,

    (SELECT ISNULL(SUM(Amount),0)
     FROM transactions.Transactions) AS TotalTransactionAmount,

    -----------------------------------------------------
    -- Loan KPIs
    -----------------------------------------------------

    (SELECT COUNT(*)
     FROM lending.Loans) AS TotalLoans,

    (SELECT COUNT(*)
     FROM lending.Loans
     WHERE LoanStatus='Pending') AS PendingLoans,

    (SELECT COUNT(*)
     FROM lending.Loans
     WHERE LoanStatus='Approved') AS ApprovedLoans,

    (SELECT COUNT(*)
     FROM lending.Loans
     WHERE LoanStatus='Rejected') AS RejectedLoans,

    (SELECT COUNT(*)
     FROM lending.Loans
     WHERE LoanStatus='Closed') AS ClosedLoans,

    (SELECT ISNULL(SUM(OutstandingAmount),0)
     FROM lending.Loans) AS TotalOutstandingAmount,

    (SELECT ISNULL(SUM(PrincipalAmount),0)
     FROM lending.Loans) AS TotalPrincipalAmount,

    -----------------------------------------------------
    -- Branch KPIs
    -----------------------------------------------------

    (SELECT COUNT(*)
     FROM core.Branches) AS TotalBranches,

    (SELECT COUNT(*)
     FROM core.Branches
     WHERE IsActive=1) AS ActiveBranches,

    -----------------------------------------------------
    -- Today's Activity
    -----------------------------------------------------

    (SELECT COUNT(*)
     FROM transactions.Transactions
     WHERE CAST(TransactionDate AS DATE)=CAST(GETDATE() AS DATE))
        AS TodayTransactions,

    (SELECT COUNT(*)
     FROM lending.Loans
     WHERE CAST(ApplicationDate AS DATE)=CAST(GETDATE() AS DATE))
        AS TodayLoanApplications,

    (SELECT COUNT(*)
     FROM core.Accounts
     WHERE CAST(CreatedDate AS DATE)=CAST(GETDATE() AS DATE))
        AS TodayAccountsOpened;
        
    -----------------------------------------------------
    -- Top Performing Branch
    -----------------------------------------------------

    SELECT TOP (1)

        b.BranchCode,
        b.BranchName,

        COUNT(t.TransactionID) AS TotalTransactions,

        SUM(CASE
                WHEN t.TransactionType='Deposit'
                THEN t.Amount
                ELSE 0
            END) AS TotalDeposits,

        SUM(CASE
                WHEN t.TransactionType='Withdrawal'
                THEN t.Amount
                ELSE 0
            END) AS TotalWithdrawals,

        SUM(t.Amount) AS TotalBusinessVolume

    FROM core.Branches b

    INNER JOIN core.Accounts a
        ON b.BranchID=a.BranchID

    INNER JOIN transactions.Transactions t
        ON a.AccountID=t.AccountID

    GROUP BY

        b.BranchCode,
        b.BranchName

    ORDER BY

        TotalBusinessVolume DESC;

END;
GO