CREATE OR ALTER PROCEDURE dbo.usp_CloseLoan
(
    @LoanID INT,
    @ClosedByEmployeeID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE
            @OutstandingAmount DECIMAL(18,2),
            @LoanStatus VARCHAR(20);

        ------------------------------------
        -- Validate Loan
        ------------------------------------

        SELECT
            @OutstandingAmount = OutstandingAmount,
            @LoanStatus = LoanStatus
        FROM lending.Loans WITH (UPDLOCK)
        WHERE LoanID=@LoanID;

        IF @OutstandingAmount IS NULL
            THROW 50001,'Loan not found.',1;

        IF @LoanStatus='Closed'
            THROW 50002,'Loan already closed.',1;

        IF @LoanStatus='Rejected'
            THROW 50003,'Rejected loan cannot be closed.',1;

        IF @LoanStatus='Pending'
            THROW 50004,'Loan has not been approved.',1;

        IF @LoanStatus<>'Disbursed'
            THROW 50005,'Invalid loan status.',1;

        IF @OutstandingAmount>0
            THROW 50006,'Outstanding amount is not zero.',1;

        ------------------------------------
        -- Close Loan
        ------------------------------------

        UPDATE lending.Loans
        SET
            LoanStatus='Closed',
            ClosedDate=CAST(GETDATE() AS DATE),
            ModifiedDate=SYSDATETIME()
        WHERE LoanID=@LoanID;

        ------------------------------------
        -- Audit Log
        ------------------------------------

        INSERT INTO audit.AuditLogs
        (
            TableName,
            RecordID,
            ActionType,
            PerformedByEmployeeID,
            ActionDate,
            Remarks
        )
        VALUES
        (
            'Loans',
            @LoanID,
            'UPDATE',
            @ClosedByEmployeeID,
            SYSDATETIME(),
            'Loan Closed'
        );

        COMMIT TRANSACTION;

        SELECT
            @LoanID AS LoanID,
            'Closed' AS LoanStatus,
            CAST(GETDATE() AS DATE) AS ClosedDate,
            'Loan closed successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT>0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END
GO
