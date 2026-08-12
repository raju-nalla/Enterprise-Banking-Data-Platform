USE [EnterpriseBankingDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Transaction Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_GetAccountStatement

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 2.0

Description:
Returns account statement for a specified date range.

Business Rules

1. Account must exist.
2. Account must be Active.
3. From Date cannot be greater than To Date.
4. Returns two result sets.
5. Result Set 1 -> Statement Summary.
6. Result Set 2 -> Transaction Details.

Return Codes

0       Success
3001    Invalid Account
3002    Account Inactive
3003    Invalid Date Range
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetAccountStatement
(
      @AccountID INT
    , @FromDate DATE
    , @ToDate DATE
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE
      @StatusCode INT = -1
    , @StatusMessage VARCHAR(200) = ''

    , @OpeningBalance DECIMAL(18,2)
    , @ClosingBalance DECIMAL(18,2)
    , @AvailableBalance DECIMAL(18,2)

    , @TotalDeposits DECIMAL(18,2)
    , @TotalWithdrawals DECIMAL(18,2)
    , @TotalTransfers DECIMAL(18,2)
    , @TotalEMIAmount DECIMAL(18,2)
    , @TotalFees DECIMAL(18,2)

    , @TransactionCount INT;

BEGIN TRY

    ------------------------------------------------------------
    -- Validate Date Range
    ------------------------------------------------------------

    IF @FromDate > @ToDate
    BEGIN

        SET @StatusCode = 3003;
        SET @StatusMessage = 'From Date cannot be greater than To Date.';

        SELECT
              NULL AS AccountID
            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Account
    ------------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID = @AccountID
          AND AccountStatus = 'Active'
          AND IsActive = 1
    )
    BEGIN

        SET @StatusCode = 3001;
        SET @StatusMessage = 'Account not found or inactive.';

        SELECT
              NULL AS AccountID
            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Opening Balance
    ------------------------------------------------------------

    SELECT TOP (1)

        @OpeningBalance = BalanceAfterTransaction

    FROM transactions.Transactions

    WHERE AccountID = @AccountID
      AND TransactionDate < @FromDate

    ORDER BY
          TransactionDate DESC
        , TransactionID DESC;

    SET @OpeningBalance = ISNULL(@OpeningBalance,0);

    ------------------------------------------------------------
    -- Closing Balance
    ------------------------------------------------------------

    SELECT

          @ClosingBalance = Balance
        , @AvailableBalance = AvailableBalance

    FROM core.Accounts

    WHERE AccountID = @AccountID;

    ------------------------------------------------------------
    -- Statement Summary
    ------------------------------------------------------------

    SELECT

          @TotalDeposits =
            SUM(CASE
                    WHEN TransactionType='Deposit'
                    THEN Amount
                    ELSE 0
                END)

        , @TotalWithdrawals =
            SUM(CASE
                    WHEN TransactionType='Withdrawal'
                    THEN Amount
                    ELSE 0
                END)

        , @TotalTransfers =
            SUM(CASE
                    WHEN TransactionType='Transfer'
                    THEN Amount
                    ELSE 0
                END)

        , @TotalEMIAmount =
            SUM(CASE
                    WHEN TransactionType='EMI'
                    THEN Amount
                    ELSE 0
                END)

        , @TotalFees =
            SUM(CASE
                    WHEN TransactionType='Fee'
                    THEN Amount
                    ELSE 0
                END)

        , @TransactionCount = COUNT(*)

    FROM transactions.Transactions

    WHERE AccountID = @AccountID
      AND TransactionDate >= @FromDate
      AND TransactionDate < DATEADD(DAY,1,@ToDate);

    SET @TotalDeposits = ISNULL(@TotalDeposits,0);
    SET @TotalWithdrawals = ISNULL(@TotalWithdrawals,0);
    SET @TotalTransfers = ISNULL(@TotalTransfers,0);
    SET @TotalEMIAmount = ISNULL(@TotalEMIAmount,0);
    SET @TotalFees = ISNULL(@TotalFees,0);

    ------------------------------------------------------------
    -- Success
    ------------------------------------------------------------

    SET @StatusCode = 0;
    SET @StatusMessage = 'Account statement generated successfully.';

    ------------------------------------------------------------
    -- Result Set 1
    ------------------------------------------------------------

    SELECT

          @StatusCode AS StatusCode
        , @StatusMessage AS StatusMessage

        , C.CustomerNumber
        , CONCAT(C.FirstName,' ',C.LastName) AS CustomerName

        , A.AccountNumber
        , A.AccountType

        , B.BranchCode
        , B.BranchName

        , @FromDate AS StatementFrom
        , @ToDate AS StatementTo

        , @OpeningBalance AS OpeningBalance
        , @ClosingBalance AS ClosingBalance
        , @AvailableBalance AS AvailableBalance

        , @TransactionCount AS TotalTransactions
        , @TotalDeposits AS TotalDeposits
        , @TotalWithdrawals AS TotalWithdrawals
        , @TotalTransfers AS TotalTransfers
        , @TotalEMIAmount AS TotalEMIAmount
        , @TotalFees AS TotalFees

    FROM core.Accounts A

    INNER JOIN core.Customers C
        ON A.CustomerID = C.CustomerID

    INNER JOIN core.Branches B
        ON A.BranchID = B.BranchID

    WHERE A.AccountID = @AccountID;

    ------------------------------------------------------------
    -- Result Set 2
    ------------------------------------------------------------

    SELECT

          TransactionID
        , TransactionNumber
        , ProcessedByEmployeeID
        , TransactionDate
        , TransactionType
        , TransactionMode
        , Amount
        , BalanceAfterTransaction
        , TransactionStatus
        , Remarks

    FROM transactions.Transactions

    WHERE AccountID = @AccountID
      AND TransactionDate >= @FromDate
      AND TransactionDate < DATEADD(DAY,1,@ToDate)

    ORDER BY
          TransactionDate
        , TransactionID;

END TRY

BEGIN CATCH

    SET @StatusCode = 9999;

    SET @StatusMessage =
        CONCAT
        (
            'SQL Error ',
            ERROR_NUMBER(),
            ': ',
            ERROR_MESSAGE()
        );

    SELECT

          @AccountID AS AccountID
        , @StatusCode AS StatusCode
        , @StatusMessage AS StatusMessage;

END CATCH

END;