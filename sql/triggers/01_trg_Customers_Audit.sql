CREATE OR ALTER TRIGGER trg_Customers_Audit
ON core.Customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO audit.AuditLogs
    (
        TableName,
        RecordID,
        ActionType,
        PerformedByEmployeeID,
        ActionDate,
        OldValue,
        NewValue,
        Remarks
    )
    SELECT
        'Customers',
        d.CustomerID,
        'UPDATE',
        NULL,                           -- Updated by application/SP if available
        SYSDATETIME(),

        CONCAT(
            'Name=', d.FirstName, ' ', d.LastName,
            '; Email=', ISNULL(d.Email,''),
            '; Phone=', ISNULL(d.PhoneNumber,''),
            '; Status=', d.CustomerStatus
        ),

        CONCAT(
            'Name=', i.FirstName, ' ', i.LastName,
            '; Email=', ISNULL(i.Email,''),
            '; Phone=', ISNULL(i.PhoneNumber,''),
            '; Status=', i.CustomerStatus
        ),

        'Customer record updated.'

    FROM inserted i
    INNER JOIN deleted d
        ON i.CustomerID = d.CustomerID;
END;
GO