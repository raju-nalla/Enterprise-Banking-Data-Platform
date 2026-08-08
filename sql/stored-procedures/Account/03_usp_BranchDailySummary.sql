CREATE OR ALTER PROCEDURE dbo.usp_BranchDailySummary
(
    @BranchID INT,
    @BusinessDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------
    -- Validation
    --------------------------------------------

    IF @BusinessDate IS NULL
        THROW 50001,'Business Date cannot be NULL.',1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Branches
        WHERE BranchID=@BranchID
        AND IsActive=1
    )
        THROW 50002,'Branch not found.',1;

    --------------------------------------------
    -- Branch Summary
    --------------------------------------------

    SELECT

        b.BranchID,
        b.BranchCode,
        b.BranchName,

        @BusinessDate AS BusinessDate,

        ----------------------------------------

        (
            SELECT COUNT(*)
            FROM core.Customers c
            WHERE CAST(c.CreatedDate AS DATE)=@BusinessDate
        ) AS CustomersCreated,

        ----------------------------------------

        (
            SELECT COUNT(*)
            FROM core.Accounts a
            WHERE a.BranchID=@BranchID
            AND CAST(a.CreatedDate AS DATE)=@BusinessDate
        ) AS AccountsOpened,

        ----------------------------------------

        (
            SELECT ISNULL(SUM(t.Amount),0)
            FROM transactions.Transactions t
            INNER JOIN core.Accounts a
                    ON t.AccountID=a.AccountID
            WHERE a.BranchID=@BranchID
            AND t.TransactionType='Deposit'
            AND CAST(t.TransactionDate AS DATE)=@BusinessDate
        ) AS TotalDeposits,

        ----------------------------------------

        (
            SELECT ISNULL(SUM(t.Amount),0)
            FROM transactions.Transactions t
            INNER JOIN core.Accounts a
                    ON t.AccountID=a.AccountID
            WHERE a.BranchID=@BranchID
            AND t.TransactionType='Withdrawal'
            AND CAST(t.TransactionDate AS DATE)=@BusinessDate
        ) AS TotalWithdrawals,

        ----------------------------------------

        (
            SELECT ISNULL(SUM(t.Amount),0)
            FROM transactions.Transactions t
            INNER JOIN core.Accounts a
                    ON t.AccountID=a.AccountID
            WHERE a.BranchID=@BranchID
            AND t.TransactionType='Transfer'
            AND CAST(t.TransactionDate AS DATE)=@BusinessDate
        ) AS TotalTransfers,

        ----------------------------------------

        (
            SELECT COUNT(*)
            FROM lending.Loans l
            WHERE CAST(l.ApplicationDate AS DATE)=@BusinessDate
            AND EXISTS
            (
                SELECT 1
                FROM core.Accounts a
                WHERE a.AccountID=l.AccountID
                AND a.BranchID=@BranchID
            )
        ) AS LoanApplications,

        ----------------------------------------

        (
            SELECT COUNT(*)
            FROM lending.Loans l
            WHERE CAST(l.ApprovalDate AS DATE)=@BusinessDate
            AND LoanStatus IN ('Approved','Closed')
            AND EXISTS
            (
                SELECT 1
                FROM core.Accounts a
                WHERE a.AccountID=l.AccountID
                AND a.BranchID=@BranchID
            )
        ) AS LoansApproved,

        ----------------------------------------

        (
            SELECT COUNT(*)
            FROM lending.Loans l
            WHERE LoanStatus='Rejected'
            AND CAST(l.ModifiedDate AS DATE)=@BusinessDate
            AND EXISTS
            (
                SELECT 1
                FROM core.Accounts a
                WHERE a.AccountID=l.AccountID
                AND a.BranchID=@BranchID
            )
        ) AS LoansRejected,

        ----------------------------------------

        (
            SELECT ISNULL(SUM(Amount),0)
            FROM transactions.Transactions t
            INNER JOIN core.Accounts a
                    ON t.AccountID=a.AccountID
            WHERE a.BranchID=@BranchID
            AND t.TransactionType='EMI'
            AND CAST(t.TransactionDate AS DATE)=@BusinessDate
        ) AS EMICollected,

        ----------------------------------------

        (
            SELECT ISNULL(SUM(Amount),0)
            FROM transactions.Transactions t
            INNER JOIN core.Accounts a
                    ON t.AccountID=a.AccountID
            WHERE a.BranchID=@BranchID
            AND t.TransactionMode='Cash'
            AND t.TransactionType='Deposit'
            AND CAST(t.TransactionDate AS DATE)=@BusinessDate
        ) AS CashDeposited,

        ----------------------------------------

        (
            SELECT ISNULL(SUM(Amount),0)
            FROM transactions.Transactions t
            INNER JOIN core.Accounts a
                    ON t.AccountID=a.AccountID
            WHERE a.BranchID=@BranchID
            AND t.TransactionMode='Cash'
            AND t.TransactionType='Withdrawal'
            AND CAST(t.TransactionDate AS DATE)=@BusinessDate
        ) AS CashWithdrawn,

        ----------------------------------------

        (
            (
                SELECT ISNULL(SUM(Amount),0)
                FROM transactions.Transactions t
                INNER JOIN core.Accounts a
                        ON t.AccountID=a.AccountID
                WHERE a.BranchID=@BranchID
                AND t.TransactionType='Deposit'
                AND CAST(t.TransactionDate AS DATE)=@BusinessDate
            )
            -
            (
                SELECT ISNULL(SUM(Amount),0)
                FROM transactions.Transactions t
                INNER JOIN core.Accounts a
                        ON t.AccountID=a.AccountID
                WHERE a.BranchID=@BranchID
                AND t.TransactionType='Withdrawal'
                AND CAST(t.TransactionDate AS DATE)=@BusinessDate
            )
        ) AS NetCashFlow

    FROM core.Branches b
    WHERE b.BranchID=@BranchID;

    -------------------------------------------------------
    -- Transaction Details
    -------------------------------------------------------

    SELECT

        t.TransactionNumber,
        c.CustomerNumber,
        CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,
        a.AccountNumber,
        t.TransactionType,
        t.TransactionMode,
        t.Amount,
        t.TransactionStatus,
        t.TransactionDate,
        t.Remarks

    FROM transactions.Transactions t

    INNER JOIN core.Accounts a
        ON t.AccountID=a.AccountID

    INNER JOIN core.Customers c
        ON a.CustomerID=c.CustomerID

    WHERE a.BranchID=@BranchID
      AND CAST(t.TransactionDate AS DATE)=@BusinessDate

    ORDER BY t.TransactionDate;
END;
GO