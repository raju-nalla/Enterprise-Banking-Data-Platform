CREATE OR ALTER PROCEDURE dbo.usp_GetAccountStatement
(
    @AccountID INT,
    @FromDate DATE,
    @ToDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------
    -- Validate Date Range
    ---------------------------------------------------------

    IF @FromDate > @ToDate
    BEGIN
        THROW 50001,'From Date cannot be greater than To Date.',1;
    END;

    ---------------------------------------------------------
    -- Validate Account
    ---------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID = @AccountID
    )
    BEGIN
        THROW 50002,'Account not found.',1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID=@AccountID
          AND AccountStatus<>'Active'
    )
    BEGIN
        THROW 50003,'Account is inactive.',1;
    END;

    ---------------------------------------------------------
    -- Declare Variables
    ---------------------------------------------------------

    DECLARE

        @OpeningBalance DECIMAL(18,2),
        @ClosingBalance DECIMAL(18,2),

        @TotalDeposits DECIMAL(18,2),
        @TotalWithdrawals DECIMAL(18,2),

        @TotalTransfers DECIMAL(18,2),
        @TotalEMIPaid DECIMAL(18,2),

        @TotalFees DECIMAL(18,2),

        @TransactionCount INT;

    ---------------------------------------------------------
    -- Opening Balance
    ---------------------------------------------------------

    SELECT TOP(1)

        @OpeningBalance = BalanceAfterTransaction

    FROM transactions.Transactions

    WHERE AccountID=@AccountID
      AND CAST(TransactionDate AS DATE)<@FromDate

    ORDER BY TransactionDate DESC;

    IF @OpeningBalance IS NULL
        SET @OpeningBalance=0;

    ---------------------------------------------------------
    -- Closing Balance
    ---------------------------------------------------------

    SELECT
        @ClosingBalance = Balance
    FROM core.Accounts
    WHERE AccountID=@AccountID;

    ---------------------------------------------------------
    -- Summary Values
    ---------------------------------------------------------

    SELECT

        @TotalDeposits =
            ISNULL(SUM(
                CASE
                    WHEN TransactionType='Deposit'
                    THEN Amount
                END),0),

        @TotalWithdrawals =
            ISNULL(SUM(
                CASE
                    WHEN TransactionType='Withdrawal'
                    THEN Amount
                END),0),

        @TotalTransfers =
            ISNULL(SUM(
                CASE
                    WHEN TransactionType='Transfer'
                    THEN Amount
                END),0),

        @TotalEMIPaid =
            ISNULL(SUM(
                CASE
                    WHEN TransactionType='EMI'
                    THEN Amount
                END),0),

        @TotalFees =
            ISNULL(SUM(
                CASE
                    WHEN TransactionType='Fee'
                    THEN Amount
                END),0),

        @TransactionCount=COUNT(*)

    FROM transactions.Transactions

    WHERE AccountID=@AccountID
      AND CAST(TransactionDate AS DATE)
      BETWEEN @FromDate AND @ToDate;

    ---------------------------------------------------------
    -- Result Set 1
    ---------------------------------------------------------

    SELECT

        C.CustomerNumber,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        A.AccountNumber,

        A.AccountType,

        B.BranchCode,

        B.BranchName,

        @FromDate AS StatementFrom,

        @ToDate AS StatementTo,

        @OpeningBalance AS OpeningBalance,

        @ClosingBalance AS ClosingBalance,

        @TransactionCount AS TotalTransactions,

        @TotalDeposits AS TotalDeposits,

        @TotalWithdrawals AS TotalWithdrawals,

        @TotalTransfers AS TotalTransfers,

        @TotalEMIPaid AS TotalEMIPaid,

        @TotalFees AS TotalFees,

        A.AvailableBalance

    FROM core.Accounts A

        INNER JOIN core.Customers C
            ON A.CustomerID=C.CustomerID

        INNER JOIN core.Branches B
            ON A.BranchID=B.BranchID

    WHERE A.AccountID=@AccountID;

    ---------------------------------------------------------
    -- Result Set 2
    ---------------------------------------------------------

    SELECT

        TransactionNumber,

        TransactionDate,

        TransactionType,

        TransactionMode,

        Amount,

        BalanceAfterTransaction,

        TransactionStatus,

        Remarks

    FROM transactions.Transactions

    WHERE AccountID=@AccountID

      AND CAST(TransactionDate AS DATE)

      BETWEEN @FromDate AND @ToDate

    ORDER BY

        TransactionDate,
        TransactionID;

END;
GO