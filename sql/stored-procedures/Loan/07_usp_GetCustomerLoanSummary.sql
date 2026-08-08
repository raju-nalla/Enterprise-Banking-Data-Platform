CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerLoanSummary
(
    @CustomerID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    ----------------------------------------------------------
    -- Validate Customer
    ----------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID = @CustomerID
    )
    BEGIN
        THROW 50001, 'Customer not found.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID = @CustomerID
          AND CustomerStatus <> 'Active'
    )
    BEGIN
        THROW 50002, 'Customer is inactive.', 1;
    END;

    ----------------------------------------------------------
    -- Result Set 1 : Customer Loan Summary
    ----------------------------------------------------------

    SELECT

        C.CustomerID,
        C.CustomerNumber,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        C.PhoneNumber,
        C.Email,

        COUNT(L.LoanID) AS TotalLoans,

        SUM(CASE WHEN L.LoanStatus='Pending' THEN 1 ELSE 0 END) AS PendingLoans,

        SUM(CASE WHEN L.LoanStatus='Approved' THEN 1 ELSE 0 END) AS ApprovedLoans,

        SUM(CASE WHEN L.LoanStatus='Rejected' THEN 1 ELSE 0 END) AS RejectedLoans,

        SUM(CASE WHEN L.LoanStatus='Closed' THEN 1 ELSE 0 END) AS ClosedLoans,

        SUM(CASE
                WHEN L.LoanStatus='Approved'
                THEN 1
                ELSE 0
            END) AS ActiveLoans,

        ISNULL(SUM(L.PrincipalAmount),0) AS TotalPrincipalAmount,

        ISNULL(SUM(L.OutstandingAmount),0) AS TotalOutstandingAmount,

        ISNULL(SUM(L.EMIAmount),0) AS TotalEMIAmount,

        ISNULL(MAX(L.PrincipalAmount),0) AS HighestLoanAmount,

        ISNULL(MIN(L.PrincipalAmount),0) AS LowestLoanAmount,

        CASE
            WHEN ISNULL(SUM(L.PrincipalAmount),0)=0
            THEN 0
            ELSE
                CAST
                (
                    ROUND
                    (
                        (
                            (
                                SUM(L.PrincipalAmount)
                                - SUM(L.OutstandingAmount)
                            ) * 100.0
                        )
                        / SUM(L.PrincipalAmount),
                        2
                    )
                AS DECIMAL(5,2))
        END AS LoanCompletionPercentage

    FROM core.Customers C

        LEFT JOIN lending.Loans L
            ON C.CustomerID=L.CustomerID

    WHERE C.CustomerID=@CustomerID

    GROUP BY

        C.CustomerID,
        C.CustomerNumber,
        C.FirstName,
        C.LastName,
        C.PhoneNumber,
        C.Email;

    ----------------------------------------------------------
    -- Result Set 2 : Loan Details
    ----------------------------------------------------------

    SELECT

        LoanID,
        LoanNumber,
        LoanType,

        PrincipalAmount,
        InterestRate,
        TenureMonths,

        EMIAmount,

        OutstandingAmount,

        LoanStatus,

        ApplicationDate,
        ApprovalDate,
        DisbursementDate,
        ClosedDate

    FROM lending.Loans

    WHERE CustomerID=@CustomerID

    ORDER BY

        ApplicationDate DESC,
        LoanID DESC;

END;
GO
