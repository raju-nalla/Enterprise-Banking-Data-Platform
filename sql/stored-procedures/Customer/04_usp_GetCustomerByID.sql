USE EnterpriseBankingDB;
GO

/************************************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Customer Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_GetCustomerByID

Author        : Raju Nalla
Created On    : 08-Aug-2026
Version       : 1.0

Description:
Returns a single active customer based on CustomerID.

Business Rules
--------------
1. Customer must exist.
2. Customer must be active.
3. Returns complete customer details.

Return Codes
------------
0       Success
1006    Customer not found
1008    Customer inactive
9999    Unexpected SQL Error
************************************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerByID

      @CustomerID BIGINT,

      @StatusCode INT OUTPUT,
      @StatusMessage VARCHAR(200) OUTPUT

AS
BEGIN

SET NOCOUNT ON;

---------------------------------------------------------
-- Initialize
---------------------------------------------------------

SET @StatusCode = -1;
SET @StatusMessage = '';

BEGIN TRY

    ---------------------------------------------------------
    -- Customer Exists
    ---------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID = @CustomerID
    )
    BEGIN

        SET @StatusCode = 1006;
        SET @StatusMessage = 'Customer not found.';

        RETURN;

    END;

    ---------------------------------------------------------
    -- Customer Active
    ---------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID=@CustomerID
          AND IsActive=0
    )
    BEGIN

        SET @StatusCode=1008;
        SET @StatusMessage='Customer is inactive.';

        RETURN;

    END;

    ---------------------------------------------------------
    -- Return Customer
    ---------------------------------------------------------

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
        CreatedDate,
        ModifiedDate

    FROM core.Customers

    WHERE CustomerID=@CustomerID;

    SET @StatusCode=0;
    SET @StatusMessage='Customer retrieved successfully.';

END TRY

BEGIN CATCH

    SET @StatusCode=9999;

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