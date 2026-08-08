USE EnterpriseBankingDB;
GO

/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Customer Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_GetAllCustomers

Author        : Raju Nalla
Created On    : 09-Aug-2026
Version       : 1.0

Description
-----------
Returns customers with pagination.

Business Rules
--------------
1. Supports pagination.
2. Supports Active/Inactive filtering.
3. Returns total records and total pages.
4. Returns two result sets.
5. Read-only operation.

Return Codes
------------
0       Success
1001    No customers found
1002    Invalid Page Number
1003    Invalid Page Size
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetAllCustomers

      @PageNumber      INT = 1,
      @PageSize        INT = 20,
      @IsActive        BIT = 1,

      @StatusCode      INT OUTPUT,
      @StatusMessage   VARCHAR(200) OUTPUT

AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Initialize
    ------------------------------------------------------------

    SET @StatusCode = -1;
    SET @StatusMessage = '';

    ------------------------------------------------------------
    -- Validate Page Number
    ------------------------------------------------------------

    IF @PageNumber < 1
    BEGIN
        SET @StatusCode = 1002;
        SET @StatusMessage = 'Invalid page number.';
        RETURN;
    END;

    ------------------------------------------------------------
    -- Validate Page Size
    ------------------------------------------------------------

    IF @PageSize < 1
    BEGIN
        SET @StatusCode = 1003;
        SET @StatusMessage = 'Invalid page size.';
        RETURN;
    END;

    BEGIN TRY

        ------------------------------------------------------------
        -- Total Records
        ------------------------------------------------------------

        DECLARE @TotalRecords INT;

        SELECT
            @TotalRecords = COUNT(*)
        FROM core.Customers
        WHERE
        (
            @IsActive IS NULL
            OR IsActive = @IsActive
        );

        ------------------------------------------------------------
        -- No Records Found
        ------------------------------------------------------------

        IF @TotalRecords = 0
        BEGIN
            SET @StatusCode = 1001;
            SET @StatusMessage = 'No customers found.';
            RETURN;
        END;

        ------------------------------------------------------------
        -- Result Set 1 : Customer Data
        ------------------------------------------------------------

        SELECT

            CustomerID,
            CustomerNumber,
            FirstName,
            LastName,
            Email,
            PhoneNumber,
            City,
            State,
            Country,
            KYCStatus,
            CustomerStatus,
            CreatedDate

        FROM core.Customers

        WHERE
        (
            @IsActive IS NULL
            OR IsActive = @IsActive
        )

        ORDER BY CustomerID

        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;

        ------------------------------------------------------------
        -- Result Set 2 : Pagination Information
        ------------------------------------------------------------

        SELECT

            @TotalRecords AS TotalRecords,
            @PageNumber AS PageNumber,
            @PageSize AS PageSize,
            CEILING(CAST(@TotalRecords AS DECIMAL(18,2)) / @PageSize) AS TotalPages;

        ------------------------------------------------------------
        -- Success
        ------------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Customers retrieved successfully.';

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

    END CATCH

END;
GO