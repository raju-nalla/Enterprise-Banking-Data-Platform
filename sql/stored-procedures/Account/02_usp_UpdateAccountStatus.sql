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
Object Name  : dbo.usp_UpdateAccountStatus

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 1.1

Description:
Updates the status of an existing bank account.

Business Rules

1. Account Number is mandatory.
2. Account must exist.
3. Account cannot be updated if already Closed.
4. Allowed Status:
      Active
      Inactive
      Frozen
      Dormant
      Closed
5. CloseDate is populated only when AccountStatus = Closed.
6. IsActive is synchronized with AccountStatus.
7. ModifiedDate is updated automatically.

Return Codes

0       Success
2000    Account Number is required
2001    Account not found
2002    Invalid Account Status
2003    Account already closed
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_UpdateAccountStatus
(
      @AccountNumber    VARCHAR(20)
    , @AccountStatus    VARCHAR(20)
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
          @StatusCode INT = -1
        , @StatusMessage VARCHAR(200) = '';

    BEGIN TRY

        ------------------------------------------------------------
        -- Normalize Inputs
        ------------------------------------------------------------

        SET @AccountNumber = NULLIF(LTRIM(RTRIM(@AccountNumber)), '');

        SET @AccountStatus = UPPER(LTRIM(RTRIM(@AccountStatus)));

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
        -- Validate Status
        ------------------------------------------------------------

        IF @AccountStatus NOT IN
        (
            'ACTIVE',
            'INACTIVE',
            'FROZEN',
            'DORMANT',
            'CLOSED'
        )
        BEGIN

            SET @StatusCode = 2002;
            SET @StatusMessage = 'Invalid Account Status.';

            SELECT
                @AccountNumber AS AccountNumber,
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
        -- Prevent Updating Closed Account
        ------------------------------------------------------------

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
                @AccountNumber AS AccountNumber,
                @StatusCode AS StatusCode,
                @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ------------------------------------------------------------
        -- Begin Transaction
        ------------------------------------------------------------

        BEGIN TRANSACTION;

        ------------------------------------------------------------
        -- Update Account Status
        ------------------------------------------------------------

        UPDATE core.Accounts
        SET
              AccountStatus = @AccountStatus
            , IsActive =
                CASE
                    WHEN @AccountStatus = 'ACTIVE'
                    THEN 1
                    ELSE 0
                END
            , CloseDate =
                CASE
                    WHEN @AccountStatus = 'CLOSED'
                    THEN CAST(SYSDATETIME() AS DATE)
                    ELSE CloseDate
                END
            , ModifiedDate = SYSDATETIME()

        WHERE AccountNumber = @AccountNumber;

        ------------------------------------------------------------
        -- Commit Transaction
        ------------------------------------------------------------

        COMMIT TRANSACTION;

        ------------------------------------------------------------
        -- Success
        ------------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Account status updated successfully.';

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

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

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