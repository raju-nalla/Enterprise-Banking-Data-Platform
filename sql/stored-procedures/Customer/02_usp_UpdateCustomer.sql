USE EnterpriseBankingDB;
GO

/******************************************************************************
Procedure Name : dbo.usp_UpdateCustomer

Purpose:
    Updates an existing customer's profile information.

Business Rules:
    • Customer must exist.
    • Customer must be Active.
    • First Name and Last Name are mandatory.
    • Date Of Birth cannot be a future date.
    • Gender must be M, F or O.
    • Email must be unique across customers.
    • Customer Number cannot be changed.
    • KYC Status cannot be changed.
    • Customer Status cannot be changed.

Return Codes:

0       = Success
1002    = Email already exists.
1003    = Invalid Date Of Birth.
1004    = Mandatory fields missing.
1005    = Invalid Gender.
1006    = Customer not found.
1007    = Customer is inactive.
9999    = Unexpected error.

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_UpdateCustomer

      @CustomerID        INT,

      @FirstName         VARCHAR(50),
      @LastName          VARCHAR(50),
      @DateOfBirth       DATE = NULL,
      @Gender            CHAR(1) = NULL,

      @Email             VARCHAR(100) = NULL,
      @PhoneNumber       VARCHAR(20) = NULL,

      @AddressLine1      VARCHAR(200) = NULL,
      @AddressLine2      VARCHAR(200) = NULL,
      @City              VARCHAR(50) = NULL,
      @State             VARCHAR(50) = NULL,
      @Country           VARCHAR(50) = NULL,
      @PostalCode        VARCHAR(15) = NULL,

      @StatusCode        INT OUTPUT,
      @StatusMessage     VARCHAR(200) OUTPUT

AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    --------------------------------------------------------------------------
    -- Initialize Output Parameters
    --------------------------------------------------------------------------

    SET @StatusCode = -1;
    SET @StatusMessage = '';

    --------------------------------------------------------------------------
    -- Normalize Input Parameters
    --------------------------------------------------------------------------

    SET @FirstName    = LTRIM(RTRIM(@FirstName));
    SET @LastName     = LTRIM(RTRIM(@LastName));

    SET @Email        = NULLIF(LTRIM(RTRIM(@Email)), '');
    SET @PhoneNumber  = NULLIF(LTRIM(RTRIM(@PhoneNumber)), '');

    SET @AddressLine1 = NULLIF(LTRIM(RTRIM(@AddressLine1)), '');
    SET @AddressLine2 = NULLIF(LTRIM(RTRIM(@AddressLine2)), '');

    SET @City         = NULLIF(LTRIM(RTRIM(@City)), '');
    SET @State        = NULLIF(LTRIM(RTRIM(@State)), '');
    SET @Country      = NULLIF(LTRIM(RTRIM(@Country)), '');
    SET @PostalCode   = NULLIF(LTRIM(RTRIM(@PostalCode)), '');

    --------------------------------------------------------------------------
    -- Mandatory Validation
    --------------------------------------------------------------------------

    IF @FirstName IS NULL
       OR @LastName IS NULL
    BEGIN

        SET @StatusCode = 1004;
        SET @StatusMessage = 'First Name and Last Name are mandatory.';

        RETURN;

    END

    --------------------------------------------------------------------------
    -- Customer Exists
    --------------------------------------------------------------------------

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

    END

    --------------------------------------------------------------------------
    -- Customer Active Validation
    --------------------------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID = @CustomerID
          AND IsActive = 0
    )
    BEGIN

        SET @StatusCode = 1007;
        SET @StatusMessage = 'Cannot update an inactive customer.';

        RETURN;

    END

    --------------------------------------------------------------------------
    -- Gender Validation
    --------------------------------------------------------------------------

    IF @Gender IS NOT NULL
       AND @Gender NOT IN ('M','F','O')
    BEGIN

        SET @StatusCode = 1005;
        SET @StatusMessage = 'Invalid Gender. Allowed values are M, F or O.';

        RETURN;

    END

    --------------------------------------------------------------------------
    -- Date Of Birth Validation
    --------------------------------------------------------------------------

    IF @DateOfBirth IS NOT NULL
       AND @DateOfBirth > CAST(GETDATE() AS DATE)
    BEGIN

        SET @StatusCode = 1003;
        SET @StatusMessage = 'Date of Birth cannot be a future date.';

        RETURN;

    END

    --------------------------------------------------------------------------
    -- Duplicate Email Validation
    --------------------------------------------------------------------------

    IF @Email IS NOT NULL
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM core.Customers
            WHERE Email = @Email
              AND CustomerID <> @CustomerID
        )
        BEGIN

            SET @StatusCode = 1002;
            SET @StatusMessage = 'Email already exists.';

            RETURN;

        END

    END

    --------------------------------------------------------------------------
    -- Begin Transaction
    --------------------------------------------------------------------------

    BEGIN TRY

        BEGIN TRANSACTION;

        ----------------------------------------------------------------------
        -- Update Customer
        ----------------------------------------------------------------------

        UPDATE core.Customers
        SET

            FirstName      = @FirstName,
            LastName       = @LastName,
            DateOfBirth    = @DateOfBirth,
            Gender         = @Gender,

            Email          = @Email,
            PhoneNumber    = @PhoneNumber,

            AddressLine1   = @AddressLine1,
            AddressLine2   = @AddressLine2,
            City           = @City,
            State          = @State,
            Country        = @Country,
            PostalCode     = @PostalCode,

            ModifiedDate   = GETDATE()

        WHERE CustomerID = @CustomerID;

        ----------------------------------------------------------------------
        -- Success Response
        ----------------------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Customer updated successfully.';

        COMMIT TRANSACTION;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @StatusCode = 9999;
        SET @StatusMessage = ERROR_MESSAGE();

    END CATCH

END;
GO