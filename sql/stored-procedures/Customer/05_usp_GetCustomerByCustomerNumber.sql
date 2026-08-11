USE [EnterpriseBankingDB]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCustomerByCustomerNumber]    Script Date: 11-08-2026 11:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Customer Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_GetCustomerByCustomerNumber

Author        : Raju Nalla
Created On    : 08-Aug-2026
Version       : 1.0

Description:
Returns customer details using Customer Number.

Business Rules
--------------
1. Customer Number must exist.
2. Customer must be active.
3. Returns complete customer information.

Return Codes
------------
0       Success
1001    Customer Number not found
1008    Customer inactive
9999    Unexpected SQL Error
************************************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerByCustomerNumber
      @CustomerNumber VARCHAR(20)

AS
BEGIN

SET NOCOUNT ON;

DECLARE @StatusCode INT = -1;
DECLARE @StatusMessage VARCHAR(200) = '';

SET @CustomerNumber = NULLIF(LTRIM(RTRIM(@CustomerNumber)), '');

BEGIN TRY

    ----------------------------------------------------------
    -- Validate Customer Number
    ----------------------------------------------------------

    IF @CustomerNumber IS NULL
    BEGIN

        SET @StatusCode = 1001;
        SET @StatusMessage = 'Customer Number is required.';

        SELECT
            NULL AS CustomerID,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;
    ----------------------------------------------------------
    -- Customer Exists
    ----------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerNumber = @CustomerNumber
    )
    BEGIN

        SET @StatusCode = 1001;
        SET @StatusMessage = 'Customer Number not found.';

        SELECT
            NULL AS CustomerID,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ----------------------------------------------------------
    -- Customer Active
    ----------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerNumber = @CustomerNumber
          AND IsActive = 0
    )
    BEGIN

        SET @StatusCode = 1008;
        SET @StatusMessage = 'Customer is inactive.';

        SELECT
            NULL AS CustomerID,
            @StatusCode AS StatusCode,
            @StatusMessage AS StatusMessage;

        RETURN;

    END;

    ----------------------------------------------------------
    -- Return Customer
    ----------------------------------------------------------

    SET @StatusCode = 0;
    SET @StatusMessage = 'Customer retrieved successfully.';

    SELECT

        CustomerID,
        CustomerNumber,
        FirstName,
        LastName,
        DateOfBirth,
        Gender,
        Email,
        PhoneNumber,
        AddressLine1,
        AddressLine2,
        City,
        State,
        Country,
        PostalCode,
        KYCStatus,
        CustomerStatus,
        IsActive,
        CreatedDate,
        ModifiedDate,
        0 AS StatusCode,
        'Customer retrieved successfully.' AS StatusMessage
    FROM core.Customers
    WHERE CustomerNumber = @CustomerNumber
      AND IsActive = 1;

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
        CAST(NULL AS BIGINT) AS CustomerID,
        @StatusCode          AS StatusCode,
        @StatusMessage       AS StatusMessage;

    RETURN;

END CATCH

END;
