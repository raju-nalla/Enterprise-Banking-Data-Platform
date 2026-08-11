USE EnterpriseBankingDB;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Account Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_CloseAccount

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 1.0

Description:
Soft closes an existing bank account.

Business Rules

1. Account Number is mandatory.
2. Account must exist.
3. Account cannot already be closed.
4. Account balance must be zero.
5. Account status is updated to 'Closed'.
6. IsActive is updated to 0.
7. CloseDate is set to today's date.
8. ModifiedDate is updated automatically.

Return Codes

0       Success
2001    Account not found
2003    Account already closed
2007    Account balance must be zero
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_CloseAccount
(
      @AccountNumber VARCHAR(20)
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
          @StatusCode INT = -1
        , @StatusMessage VARCHAR(200) = '';

    BEGIN TRY

        ----------------------------------------------------------
        -- Validate Account Number
        ----------------------------------------------------------

        SET @AccountNumber = NULLIF(LTRIM(RTRIM(@AccountNumber)), '');

        IF @AccountNumber IS NULL
        BEGIN

            SET @StatusCode = 2001;
            SET @StatusMessage = 'Account Number is required.';

            SELECT
                  NULL AS AccountID
                , @StatusCode AS StatusCode
                , @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ----------------------------------------------------------
        -- Validate Account Exists
        ----------------------------------------------------------

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
                  NULL AS AccountID
                , @StatusCode AS StatusCode
                , @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ----------------------------------------------------------
        -- Already Closed
        ----------------------------------------------------------

        IF EXISTS
        (
            SELECT 1
            FROM core.Accounts
            WHERE AccountNumber = @AccountNumber
              AND AccountStatus = 'Closed'
        )
        BEGIN

            SET @StatusCode = 2003;
            SET @StatusMessage = 'Account is already closed.';

            SELECT
                  NULL AS AccountID
                , @StatusCode AS StatusCode
                , @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ----------------------------------------------------------
        -- Validate Zero Balance
        ----------------------------------------------------------

        IF EXISTS
        (
            SELECT 1
            FROM core.Accounts
            WHERE AccountNumber = @AccountNumber
              AND Balance <> 0
        )
        BEGIN

            SET @StatusCode = 2007;
            SET @StatusMessage = 'Account balance must be zero before closing.';

            SELECT
                  NULL AS AccountID
                , @StatusCode AS StatusCode
                , @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ----------------------------------------------------------
        -- Close Account
        ----------------------------------------------------------

        UPDATE core.Accounts
        SET
              AccountStatus = 'Closed'
            , IsActive = 0
            , CloseDate = CAST(GETDATE() AS DATE)
            , ModifiedDate = SYSDATETIME()
        WHERE AccountNumber = @AccountNumber;

        ----------------------------------------------------------
        -- Success
        ----------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Account closed successfully.';

        SELECT

              AccountID
            , AccountNumber
            , CustomerID
            , BranchID
            , AccountType
            , Balance
            , AvailableBalance
            , CurrencyCode
            , AccountStatus
            , OpenDate
            , CloseDate
            , IsActive
            , CreatedDate
            , ModifiedDate

            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage

        FROM core.Accounts
        WHERE AccountNumber = @AccountNumber;

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
              @AccountNumber AS AccountNumber
            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

    END CATCH

END;
GO