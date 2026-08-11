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

    , @TotalDeposits DECIMAL(18,2)
    , @TotalWithdrawals DECIMAL(18,2)
    , @TotalTransfers DECIMAL(18,2)
    , @TotalEMIPaid DECIMAL(18,2)
    , @TotalFees DECIMAL(18,2)

    , @TransactionCount INT;

BEGIN TRY

    ----------------------------------------------------------
    -- Validate Date Range
    ----------------------------------------------------------

    IF @FromDate > @ToDate
    BEGIN

        SET @StatusCode = 3003;
        SET @StatusMessage = 'From Date cannot be greater than To Date.';

        SELECT
            NULL AS AccountID,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ----------------------------------------------------------
    -- Validate Account Exists
    ----------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID = @AccountID
    )
    BEGIN

        SET @StatusCode = 3001;
        SET @StatusMessage = 'Account not found.';

        SELECT
            NULL AS AccountID,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ----------------------------------------------------------
    -- Validate Active Account
    ----------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE AccountID = @AccountID
          AND IsActive = 0
    )
    BEGIN

        SET @StatusCode = 3002;
        SET @StatusMessage = 'Account is inactive.';

        SELECT
            NULL AS AccountID,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ----------------------------------------------------------
    -- Opening Balance
    ----------------------------------------------------------

    SELECT TOP (1)

        @OpeningBalance = BalanceAfterTransaction

    FROM transactions.Transactions

    WHERE AccountID = @AccountID
      AND CAST(TransactionDate AS DATE) < @FromDate

    ORDER BY TransactionDate DESC;

    SET @OpeningBalance = ISNULL(@OpeningBalance,0);

    ----------------------------------------------------------
    -- Closing Balance
    ----------------------------------------------------------

    SELECT
        @ClosingBalance = Balance
    FROM core.Accounts
    WHERE AccountID = @AccountID;

    ----------------------------------------------------------
    -- Summary
    ----------------------------------------------------------

    SELECT

        @TotalDeposits =
            ISNULL(SUM(CASE
                        WHEN TransactionType='Deposit'
                        THEN Amount
                       END),0),

        @TotalWithdrawals =
            ISNULL(SUM(CASE
                        WHEN TransactionType='Withdrawal'
                        THEN Amount
                       END),0),

        @TotalTransfers =
            ISNULL(SUM(CASE
                        WHEN TransactionType='Transfer'
                        THEN Amount
                       END),0),

        @TotalEMIPaid =
            ISNULL(SUM(CASE
                        WHEN TransactionType='EMI'
                        THEN Amount
                       END),0),

        @TotalFees =
            ISNULL(SUM(CASE
                        WHEN TransactionType='Fee'
                        THEN Amount
                       END),0),

        @TransactionCount = COUNT(*)

    FROM transactions.Transactions

    WHERE AccountID = @AccountID
      AND CAST(TransactionDate AS DATE)
      BETWEEN @FromDate AND @ToDate;

    ----------------------------------------------------------
    -- Success
    ----------------------------------------------------------

    SET @StatusCode = 0;
    SET @StatusMessage = 'Account statement generated successfully.';

    ----------------------------------------------------------
    -- Result Set 1 : Statement Summary
    ----------------------------------------------------------

    SELECT

          C.CustomerNumber
        , CONCAT(C.FirstName,' ',C.LastName) AS CustomerName
        , A.AccountNumber
        , A.AccountType
        , B.BranchCode
        , B.BranchName

        , @FromDate AS StatementFrom
        , @ToDate AS StatementTo

        , @OpeningBalance AS OpeningBalance
        , @ClosingBalance AS ClosingBalance

        , @TransactionCount AS TotalTransactions
        , @TotalDeposits AS TotalDeposits
        , @TotalWithdrawals AS TotalWithdrawals
        , @TotalTransfers AS TotalTransfers
        , @TotalEMIPaid AS TotalEMIPaid
        , @TotalFees AS TotalFees

        , A.AvailableBalance

        , @StatusCode AS StatusCode
        , @StatusMessage AS StatusMessage

    FROM core.Accounts A

        INNER JOIN core.Customers C
            ON A.CustomerID = C.CustomerID

        INNER JOIN core.Branches B
            ON A.BranchID = B.BranchID

    WHERE A.AccountID = @AccountID;

    ----------------------------------------------------------
    -- Result Set 2 : Transaction Details
    ----------------------------------------------------------

    SELECT

          TransactionID
        , TransactionNumber
        , TransactionDate
        , TransactionType
        , TransactionMode
        , Amount
        , BalanceAfterTransaction
        , TransactionStatus
        , Remarks

    FROM transactions.Transactions

    WHERE AccountID = @AccountID
      AND CAST(TransactionDate AS DATE)
          BETWEEN @FromDate AND @ToDate

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
GO