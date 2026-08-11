USE [EnterpriseBankingDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Account Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_GetAccountByAccountNumber

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 1.0

Description:
Returns complete account details using Account Number.

Business Rules

1. Account Number is mandatory.
2. Account must exist.
3. Returns complete account information.
4. Read-only operation.

Return Codes

0       Success
2000    Account Number is required
2001    Account not found
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetAccountByAccountNumber
(
      @AccountNumber VARCHAR(20)
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Local Variables
    ------------------------------------------------------------

    DECLARE
          @StatusCode INT = -1
        , @StatusMessage VARCHAR(200) = '';

    ------------------------------------------------------------
    -- Normalize Input
    ------------------------------------------------------------

    SET @AccountNumber = NULLIF(LTRIM(RTRIM(@AccountNumber)), '');

    BEGIN TRY

        ------------------------------------------------------------
        -- Validate Account Number
        ------------------------------------------------------------

        IF @AccountNumber IS NULL
        BEGIN

            SET @StatusCode = 2000;
            SET @StatusMessage = 'Account Number is required.';

            SELECT
                NULL AS AccountNumber,
                @StatusCode AS StatusCode,
                @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ------------------------------------------------------------
        -- Validate Account Exists
        ------------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM core.Accounts
            WHERE AccountNumber = @AccountNumber
        )
        BEGIN

            SET @StatusCode = 2001;
            SET @StatusMessage = 'Account not found.';

            SELECT
                @AccountNumber AS AccountNumber,
                @StatusCode AS StatusCode,
                @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ------------------------------------------------------------
        -- Success
        ------------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Account retrieved successfully.';

        SELECT

              A.AccountID
            , A.AccountNumber
            , A.CustomerID
            , C.CustomerNumber
            , CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName
            , A.BranchID
            , B.BranchCode
            , B.BranchName
            , A.AccountType
            , A.Balance
            , A.AvailableBalance
            , A.CurrencyCode
            , A.AccountStatus
            , A.OpenDate
            , A.CloseDate
            , A.IsActive
            , A.CreatedDate
            , A.ModifiedDate

            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage

        FROM core.Accounts A

        INNER JOIN core.Customers C
            ON A.CustomerID = C.CustomerID

        INNER JOIN core.Branches B
            ON A.BranchID = B.BranchID

        WHERE A.AccountNumber = @AccountNumber;

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
            @AccountNumber AS AccountNumber,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

    END CATCH

END;
GO