USE [EnterpriseBankingDB]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCustomers]    Script Date: 11-08-2026 11:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

CREATE OR ALTER PROCEDURE [dbo].[usp_GetAllCustomers]

    @PageNumber INT = 1,
    @PageSize   INT = 20,
    @IsActive   BIT = 1

AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @StatusCode INT = -1;
    DECLARE @StatusMessage VARCHAR(200) = '';

    ------------------------------------------------------------
    -- Validate Page Number
    ------------------------------------------------------------

    IF @PageNumber < 1
    BEGIN

        SET @StatusCode = 1002;
        SET @StatusMessage = 'Invalid page number.';

        SELECT
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;
    ------------------------------------------------------------
    -- Validate Page Size
    ------------------------------------------------------------

    IF @PageSize < 1
    BEGIN
        SET @StatusCode = 1003;
        SET @StatusMessage = 'Invalid page size.';
        SELECT
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

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
        SELECT

            0 AS TotalRecords,
            @PageNumber AS PageNumber,
            @PageSize AS PageSize,
            0 AS TotalPages,

            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

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

        SET @StatusCode = 0;
        SET @StatusMessage = 'Customers retrieved successfully.';

        SELECT

            0 AS TotalRecords,
            @PageNumber AS PageNumber,
            @PageSize AS PageSize,
            0 AS TotalPages,

            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;
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
        @StatusCode AS StatusCode,
        @StatusMessage AS StatusMessage;

    RETURN;

    END CATCH

END;
