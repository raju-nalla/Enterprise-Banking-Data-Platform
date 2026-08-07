/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Customer Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_CreateCustomer

Author       : Raju Nalla
Created On   : 08-Aug-2026
Version      : 4.0

Description
-----------
Creates a new customer after validating business rules.

Business Rules
--------------
1. Customer Number must be unique.
2. Email must be unique (if provided).
3. Date of Birth cannot be a future date.
4. Customer is created with:
   - KYCStatus = 'Pending'
   - CustomerStatus = 'Active'
   - IsActive = 1

Dependencies
------------
core.Customers

Returns
-------
@CustomerID
@StatusCode
@StatusMessage
******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_CreateCustomer

    @CustomerNumber      VARCHAR(20),
    @FirstName           VARCHAR(50),
    @LastName            VARCHAR(50),
    @DateOfBirth         DATE = NULL,
    @Gender              CHAR(1) = NULL,
    @Email               VARCHAR(100) = NULL,
    @PhoneNumber         VARCHAR(20) = NULL,
    @AddressLine1        VARCHAR(200) = NULL,
    @AddressLine2        VARCHAR(200) = NULL,
    @City                VARCHAR(50) = NULL,
    @State               VARCHAR(50) = NULL,
    @Country             VARCHAR(50) = NULL,
    @PostalCode          VARCHAR(15) = NULL,

    @CustomerID          BIGINT OUTPUT,
    @StatusCode          INT OUTPUT,
    @StatusMessage       VARCHAR(200) OUTPUT

AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Initialize Output Parameters
    ------------------------------------------------------------

    SET @CustomerID = NULL;
    SET @StatusCode = -1;
    SET @StatusMessage = '';

    ------------------------------------------------------------
    -- Normalize Input Parameters
    ------------------------------------------------------------

    SET @CustomerNumber = LTRIM(RTRIM(@CustomerNumber));
    SET @FirstName      = LTRIM(RTRIM(@FirstName));
    SET @LastName       = LTRIM(RTRIM(@LastName));

    SET @Email          = NULLIF(LTRIM(RTRIM(@Email)), '');
    SET @PhoneNumber    = NULLIF(LTRIM(RTRIM(@PhoneNumber)), '');
    SET @AddressLine1   = NULLIF(LTRIM(RTRIM(@AddressLine1)), '');
    SET @AddressLine2   = NULLIF(LTRIM(RTRIM(@AddressLine2)), '');
    SET @City           = NULLIF(LTRIM(RTRIM(@City)), '');
    SET @State          = NULLIF(LTRIM(RTRIM(@State)), '');
    SET @Country        = NULLIF(LTRIM(RTRIM(@Country)), '');
    SET @PostalCode     = NULLIF(LTRIM(RTRIM(@PostalCode)), '');

    ------------------------------------------------------------
    -- Validate Mandatory Fields
    ------------------------------------------------------------

    IF NULLIF(@CustomerNumber, '') IS NULL
       OR NULLIF(@FirstName, '') IS NULL
       OR NULLIF(@LastName, '') IS NULL
    BEGIN

        SET @StatusCode = 1004;
        SET @StatusMessage = 'Customer Number, First Name and Last Name are mandatory.';

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Gender
    ------------------------------------------------------------

    IF @Gender IS NOT NULL
       AND @Gender NOT IN ('M', 'F', 'O')
    BEGIN

        SET @StatusCode = 1005;
        SET @StatusMessage = 'Invalid Gender. Allowed values are M, F or O.';

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Date Of Birth
    ------------------------------------------------------------

    IF @DateOfBirth IS NOT NULL
       AND @DateOfBirth > CAST(SYSDATETIME() AS DATE)
    BEGIN

        SET @StatusCode = 1003;
        SET @StatusMessage = 'Date of Birth cannot be a future date.';

        RETURN;

    END;

    ------------------------------------------------------------
    -- Check Duplicate Customer Number
    ------------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerNumber = @CustomerNumber
    )
    BEGIN

        SET @StatusCode = 1001;
        SET @StatusMessage = 'Customer Number already exists.';

        RETURN;

    END;

    ------------------------------------------------------------
    -- Check Duplicate Email
    ------------------------------------------------------------

    IF @Email IS NOT NULL
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM core.Customers
            WHERE Email = @Email
        )
        BEGIN

            SET @StatusCode = 1002;
            SET @StatusMessage = 'Email already exists.';

            RETURN;

        END;

    END;

    ------------------------------------------------------------
    -- Begin Transaction
    ------------------------------------------------------------

    BEGIN TRY

        BEGIN TRANSACTION;

        ------------------------------------------------------------
        -- Create Customer
        ------------------------------------------------------------

        INSERT INTO core.Customers
        (
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
            IsActive
        )
        VALUES
        (
            @CustomerNumber,
            @FirstName,
            @LastName,
            @DateOfBirth,
            @Gender,
            @Email,
            @PhoneNumber,
            @AddressLine1,
            @AddressLine2,
            @City,
            @State,
            @Country,
            @PostalCode,
            'Pending',
            'Active',
            1
        );

        ------------------------------------------------------------
        -- Capture Generated Customer ID
        ------------------------------------------------------------

        SET @CustomerID = CAST(SCOPE_IDENTITY() AS BIGINT);

        ------------------------------------------------------------
        -- Success Response
        ------------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Customer created successfully.';

        ------------------------------------------------------------
        -- Commit Transaction
        ------------------------------------------------------------

        COMMIT TRANSACTION;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @CustomerID = NULL;
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