CREATE OR ALTER PROCEDURE dbo.usp_RejectLoan
(
    @LoanID INT,
    @RejectedByEmployeeID INT,
    @Remarks VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- Variables
        ----------------------------------------------------
        DECLARE
            @LoanStatus VARCHAR(20);

        ----------------------------------------------------
        -- Loan Validation
        ----------------------------------------------------
        SELECT
            @LoanStatus = LoanStatus
        FROM lending.Loans WITH (UPDLOCK, ROWLOCK)
        WHERE LoanID = @LoanID;

        IF @LoanStatus IS NULL
            THROW 50001, 'Loan not found.', 1;

        ----------------------------------------------------
        -- Employee Validation
        ----------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM hr.Employees
            WHERE EmployeeID = @RejectedByEmployeeID
              AND EmployeeStatus = 'Active'
        )
        BEGIN
            THROW 50002, 'Invalid rejecting employee.', 1;
        END;

        ----------------------------------------------------
        -- Remarks Validation
        ----------------------------------------------------
        IF NULLIF(LTRIM(RTRIM(@Remarks)), '') IS NULL
        BEGIN
            THROW 50003, 'Rejection reason is mandatory.', 1;
        END;

        ----------------------------------------------------
        -- Status Validation
        ----------------------------------------------------
        IF @LoanStatus = 'Approved'
            THROW 50004, 'Approved loans cannot be rejected.', 1;

        IF @LoanStatus = 'Rejected'
            THROW 50005, 'Loan is already rejected.', 1;

        IF @LoanStatus = 'Closed'
            THROW 50006, 'Closed loans cannot be rejected.', 1;

        IF @LoanStatus <> 'Pending'
            THROW 50007, 'Only pending loans can be rejected.', 1;

        ----------------------------------------------------
        -- Reject Loan
        ----------------------------------------------------
        UPDATE lending.Loans
        SET
            LoanStatus = 'Rejected',
            ApprovedByEmployeeID = @RejectedByEmployeeID,
            Remarks = @Remarks,
            ModifiedDate = SYSDATETIME()
        WHERE LoanID = @LoanID;

        COMMIT TRANSACTION;

        ----------------------------------------------------
        -- Result
        ----------------------------------------------------
        SELECT
            @LoanID AS LoanID,
            'Rejected' AS LoanStatus,
            @RejectedByEmployeeID AS RejectedByEmployeeID,
            @Remarks AS Remarks,
            'Loan rejected successfully.' AS Message;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;
GO