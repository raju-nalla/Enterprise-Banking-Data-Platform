/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Database Programming
Object Type  : Scalar Function
Object Name  : dbo.fn_CalculateAge
File Name    : 01_fn_CalculateAge.sql

Author       : Raju Nalla
Created On   : 2026-08-07
Version      : 1.0

Description  :
Returns the completed age in years based on the
provided date of birth.

Business Use :
Used for customer onboarding, KYC validation,
loan eligibility checks, and reporting.

Dependencies :
None

Change History
--------------------------------------------------------------------------------
Version | Date       | Author      | Description
--------------------------------------------------------------------------------
1.0     | 2026-08-07 | Raju Nalla  | Initial Creation
******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER FUNCTION dbo.fn_CalculateAge
(
    @DateOfBirth DATE
)
RETURNS INT
AS
BEGIN

    DECLARE @Age INT;

    SET @Age =
        DATEDIFF(YEAR, @DateOfBirth, GETDATE())
        -
        CASE
            WHEN DATEADD(YEAR,
                         DATEDIFF(YEAR, @DateOfBirth, GETDATE()),
                         @DateOfBirth) > GETDATE()
            THEN 1
            ELSE 0
        END;

    RETURN @Age;

END;
GO