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
Object Name  : dbo.usp_GetAccountByID

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 1.0

Description:
Returns account details using Account ID.

Business Rules

1. Account ID is mandatory.
2. Account must exist.
3. Returns complete account information.

Return Codes

0       Success
2001    Account not found
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetAccountByID
(
      @AccountID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE
          @StatusCode INT = -1
        , @StatusMessage VARCHAR(200) = '';

    BEGIN TRY

        ----------------------------------------------------------
        -- Validate Account ID
        ----------------------------------------------------------

        IF @AccountID IS NULL
           OR @AccountID <= 0
        BEGIN

            SET @StatusCode = 2001;
            SET @StatusMessage = 'Account ID is required.';

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
            WHERE AccountID = @AccountID
        )
        BEGIN

            SET @StatusCode = 2001;
            SET @StatusMessage = 'Account not found.';

            SELECT
                  @AccountID AS AccountID
                , @StatusCode AS StatusCode
                , @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ----------------------------------------------------------
        -- Success
        ----------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Account retrieved successfully.';

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
        WHERE AccountID = @AccountID;

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