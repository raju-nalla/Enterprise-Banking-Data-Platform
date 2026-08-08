CREATE OR ALTER TRIGGER trg_Accounts_Audit
ON core.Accounts
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
        'Accounts',
        d.AccountID,
        'UPDATE',
        SYSDATETIME(),

        CONCAT(
            'Balance=',d.Balance,
            '; AvailableBalance=',d.AvailableBalance,
            '; Status=',d.AccountStatus,
            '; Type=',d.AccountType
        ),

        CONCAT(
            'Balance=',i.Balance,
            '; AvailableBalance=',i.AvailableBalance,
            '; Status=',i.AccountStatus,
            '; Type=',i.AccountType
        ),

        'Account information updated.'
    FROM inserted i
    INNER JOIN deleted d
        ON i.AccountID=d.AccountID
    WHERE
        ISNULL(i.Balance,0)<>ISNULL(d.Balance,0)
        OR ISNULL(i.AvailableBalance,0)<>ISNULL(d.AvailableBalance,0)
        OR ISNULL(i.AccountStatus,'')<>ISNULL(d.AccountStatus,'')
        OR ISNULL(i.AccountType,'')<>ISNULL(d.AccountType,'');
END;
GO