CREATE OR ALTER PROCEDURE dbo.usp_GetLoanStatement
(
    @LoanID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    -----------------------------------------------------
    -- Validate Loan
    -----------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM lending.Loans
        WHERE LoanID=@LoanID
    )
    BEGIN
        THROW 50001,'Loan not found.',1;
    END;

    -----------------------------------------------------
    -- Loan Summary
    -----------------------------------------------------

    SELECT

        L.LoanID,
        L.LoanNumber,

        C.CustomerNumber,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        C.PhoneNumber,
        C.Email,

        A.AccountNumber,
        A.AccountType,
        A.Balance,

        L.LoanType,
        L.PrincipalAmount,
        L.InterestRate,
        L.TenureMonths,
        L.EMIAmount,
        L.OutstandingAmount,
        L.LoanStatus,

        L.ApplicationDate,
        L.ApprovalDate,
        L.DisbursementDate,
        L.ClosedDate,

        E.EmployeeNumber,
        CONCAT(E.FirstName,' ',E.LastName) AS ApprovedBy

    FROM lending.Loans L

        INNER JOIN core.Customers C
            ON L.CustomerID=C.CustomerID

        INNER JOIN core.Accounts A
            ON L.AccountID=A.AccountID

        LEFT JOIN hr.Employees E
            ON L.ApprovedByEmployeeID=E.EmployeeID

    WHERE L.LoanID=@LoanID;

    -----------------------------------------------------
    -- Transaction History
    -----------------------------------------------------

    SELECT

        TransactionNumber,
        TransactionType,
        TransactionMode,
        Amount,
        BalanceAfterTransaction,
        TransactionStatus,
        TransactionDate,
        Remarks

    FROM transactions.Transactions

    WHERE LoanID=@LoanID

    ORDER BY TransactionDate;

END
GO