UPDATE core.Accounts
SET Balance = Balance + 500
WHERE AccountID = 2;

SELECT
    AccountID,
    Balance
FROM core.Accounts
WHERE AccountID = 2;

SELECT TOP (1)
    AuditID,
    TableName,
    RecordID,
    ActionType,
    OldValue,
    NewValue,
    Remarks,
    ActionDate
FROM audit.AuditLogs
WHERE TableName='Accounts'
ORDER BY AuditID DESC;