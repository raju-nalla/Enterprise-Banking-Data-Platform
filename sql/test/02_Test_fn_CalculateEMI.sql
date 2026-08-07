USE EnterpriseBankingDB;
GO

-- Test Case 1
SELECT dbo.fn_CalculateEMI
(
    1000000,
    8.50,
    240
) AS EMI;
GO

-- Test Case 2
SELECT dbo.fn_CalculateEMI
(
    500000,
    10.25,
    60
) AS EMI;
GO

-- Test Case 3
SELECT dbo.fn_CalculateEMI
(
    100000,
    0,
    24
) AS EMI;
GO

-- Invalid Principal
SELECT dbo.fn_CalculateEMI
(
    -100000,
    8,
    60
) AS EMI;
GO

-- Invalid Tenure
SELECT dbo.fn_CalculateEMI
(
    100000,
    8,
    0
) AS EMI;
GO