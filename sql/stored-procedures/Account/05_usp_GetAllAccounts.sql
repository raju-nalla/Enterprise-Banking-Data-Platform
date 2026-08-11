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
Object Name  : dbo.usp_GetAllAccounts

Author        : Raju Nalla
Created On    : 11-Aug-2026
Version       : 1.0

Description:
Returns all accounts with pagination and optional Active/Inactive filtering.

Business Rules

1. Supports pagination.
2. Supports Active/Inactive filtering.
3. Returns total records and total pages.
4. Read-only operation.
5. Returns two result sets.

Return Codes

0       Success
2004    No accounts found
2005    Invalid Page Number
2006    Invalid Page Size
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetAllAccounts
(
      @PageNumber INT = 1
    , @PageSize   INT = 20
    , @IsActive   BIT = 1
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE
          @StatusCode INT = -1
        , @StatusMessage VARCHAR(200) = '';

    ----------------------------------------------------------
    -- Validate Page Number
    ----------------------------------------------------------

    IF @PageNumber < 1
    BEGIN

        SET @StatusCode = 2005;
        SET @StatusMessage = 'Invalid page number.';

        SELECT
              @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ----------------------------------------------------------
    -- Validate Page Size
    ----------------------------------------------------------

    IF @PageSize < 1
    BEGIN

        SET @StatusCode = 2006;
        SET @StatusMessage = 'Invalid page size.';

        SELECT
              @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

        RETURN;

    END;

    BEGIN TRY

        ----------------------------------------------------------
        -- Total Records
        ----------------------------------------------------------

        DECLARE @TotalRecords INT;

        SELECT
            @TotalRecords = COUNT(*)
        FROM core.Accounts
        WHERE
        (
            @IsActive IS NULL
            OR IsActive = @IsActive
        );

        ----------------------------------------------------------
        -- No Records
        ----------------------------------------------------------

        IF @TotalRecords = 0
        BEGIN

            SET @StatusCode = 2004;
            SET @StatusMessage = 'No accounts found.';

            SELECT
                  @StatusCode AS StatusCode
                , @StatusMessage AS StatusMessage;

            RETURN;

        END;

        ----------------------------------------------------------
        -- Result Set 1 : Account Details
        ----------------------------------------------------------

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

        FROM core.Accounts

        WHERE
        (
            @IsActive IS NULL
            OR IsActive = @IsActive
        )

        ORDER BY AccountID

        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;

        ----------------------------------------------------------
        -- Result Set 2 : Pagination
        ----------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Accounts retrieved successfully.';

        SELECT

              @TotalRecords AS TotalRecords
            , @PageNumber AS PageNumber
            , @PageSize AS PageSize
            , CEILING(CAST(@TotalRecords AS DECIMAL(18,2)) / @PageSize) AS TotalPages
            , @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

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
              @StatusCode AS StatusCode
            , @StatusMessage AS StatusMessage;

    END CATCH

END;
GO