CREATE OR ALTER TRIGGER trg_Loans_Audit
ON lending.Loans
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO audit.AuditLogs
    (
        TableName,
        RecordID,
        ActionType,
        ActionDate,
        OldValue,
        NewValue,
        Remarks
    )
    SELECT
        'Loans',
        d.LoanID,
        'UPDATE',
        SYSDATETIME(),

        CONCAT(
            'Status=',d.LoanStatus,
            '; Outstanding=',d.OutstandingAmount,
            '; Principal=',d.PrincipalAmount,
            '; Interest=',d.InterestRate
        ),

        CONCAT(
            'Status=',i.LoanStatus,
            '; Outstanding=',i.OutstandingAmount,
            '; Principal=',i.PrincipalAmount,
            '; Interest=',i.InterestRate
        ),

        CASE

            WHEN d.LoanStatus='Pending'
             AND i.LoanStatus='Approved'
                THEN 'Loan Approved'

            WHEN d.LoanStatus='Pending'
             AND i.LoanStatus='Rejected'
                THEN 'Loan Rejected'

            WHEN d.LoanStatus='Approved'
             AND i.LoanStatus='Closed'
                THEN 'Loan Closed'

            WHEN d.OutstandingAmount<>i.OutstandingAmount
                THEN 'EMI Payment Processed'

            ELSE 'Loan Details Updated'

        END

    FROM inserted i
    INNER JOIN deleted d
        ON i.LoanID=d.LoanID

    WHERE

        ISNULL(i.LoanStatus,'')<>
        ISNULL(d.LoanStatus,'')

        OR

        ISNULL(i.OutstandingAmount,0)<>
        ISNULL(d.OutstandingAmount,0)

        OR

        ISNULL(i.PrincipalAmount,0)<>
        ISNULL(d.PrincipalAmount,0)

        OR

        ISNULL(i.InterestRate,0)<>
        ISNULL(d.InterestRate,0);

END;
GO