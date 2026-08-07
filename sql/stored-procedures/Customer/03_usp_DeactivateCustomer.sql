USE EnterpriseBankingDB;
GO

/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Customer Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_DeactivateCustomer

Author        : Raju Nalla
Created On    : 08-Aug-2026
Version       : 4.0

Description
-----------
Soft deactivates an existing customer.

Business Rules
--------------
1. Customer must exist.
2. Customer must be active.
3. Customer must not have active accounts.
4. Customer is never physically deleted.
5. CustomerStatus is updated to 'Inactive'.
6. IsActive is updated to 0.

Return Codes
------------
0       Success
1006    Customer not found
1008    Customer already inactive
1009    Customer has active accounts
9999    Unexpected SQL Error

******************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_DeactivateCustomer

      @CustomerID        BIGINT,

      @StatusCode        INT OUTPUT,
      @StatusMessage     VARCHAR(200) OUTPUT

AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    ------------------------------------------------------------
    -- Initialize Output Parameters
    ------------------------------------------------------------

    SET @StatusCode = -1;
    SET @StatusMessage = '';

    ------------------------------------------------------------
    -- Validate Customer Exists
    ------------------------------------------------------------

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

    ------------------------------------------------------------
    -- Validate Customer Is Active
    ------------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID = @CustomerID
          AND IsActive = 0
    )
    BEGIN

        SET @StatusCode = 1008;
        SET @StatusMessage = 'Customer is already inactive.';

        RETURN;

    END;

    ------------------------------------------------------------
    -- Check Active Accounts
    ------------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM core.Accounts
        WHERE CustomerID = @CustomerID
          AND AccountStatus = 'Active'
          AND IsActive = 1
    )
    BEGIN

        SET @StatusCode = 1009;
        SET @StatusMessage = 'Customer has active accounts.';

        RETURN;

    END;

    ------------------------------------------------------------
    -- Begin Transaction
    ------------------------------------------------------------

    BEGIN TRY

        BEGIN TRANSACTION;

        --------------------------------------------------------
        -- Deactivate Customer
        --------------------------------------------------------

        UPDATE core.Customers
        SET
            CustomerStatus = 'Inactive',
            IsActive = 0,
            ModifiedDate = SYSDATETIME()
        WHERE CustomerID = @CustomerID;

        --------------------------------------------------------
        -- Success Response
        --------------------------------------------------------

        SET @StatusCode = 0;
        SET @StatusMessage = 'Customer deactivated successfully.';

        COMMIT TRANSACTION;

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

    END CATCH

END;
GO