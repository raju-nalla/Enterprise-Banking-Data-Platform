/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Database Programming
Object Type  : Scalar Function
Object Name  : dbo.fn_CalculateEMI
File Name    : 02_fn_CalculateEMI.sql

Author       : Raju Nalla
Created On   : 2026-08-07
Version      : 1.0

Description  :
Calculates the Equated Monthly Installment (EMI) for a loan
based on principal amount, annual interest rate, and tenure.

Business Use :
Used during loan application, loan approval,
financial reporting, and customer EMI estimation.

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

CREATE OR ALTER FUNCTION dbo.fn_CalculateEMI
(
    @PrincipalAmount DECIMAL(18,2),
    @AnnualInterestRate DECIMAL(5,2),
    @TenureMonths INT
)

RETURNS DECIMAL(18,2)

AS
BEGIN

    --------------------------------------------------------------------------
    -- Variable Declaration
    --------------------------------------------------------------------------

    DECLARE @MonthlyRate FLOAT;
    DECLARE @EMI DECIMAL(18,2);

    --------------------------------------------------------------------------
    -- Input Validation
    --------------------------------------------------------------------------

    IF @PrincipalAmount <= 0
        RETURN NULL;

    IF @TenureMonths <= 0
        RETURN NULL;

    --------------------------------------------------------------------------
    -- Handle Zero Interest Loan
    --------------------------------------------------------------------------

    IF @AnnualInterestRate = 0
    BEGIN
        SET @EMI = @PrincipalAmount / @TenureMonths;
        RETURN @EMI;
    END

    --------------------------------------------------------------------------
    -- Monthly Interest Rate
    --------------------------------------------------------------------------

    SET @MonthlyRate = (@AnnualInterestRate / 12.0) / 100.0;

    --------------------------------------------------------------------------
    -- EMI Formula
    --------------------------------------------------------------------------

    SET @EMI =
    @PrincipalAmount *
    @MonthlyRate *
    POWER((1 + @MonthlyRate), @TenureMonths)
    /
    (
        POWER((1 + @MonthlyRate), @TenureMonths)
        - 1
    );

    --------------------------------------------------------------------------
    -- Return EMI
    --------------------------------------------------------------------------

    RETURN ROUND(@EMI,2);

END;

GO