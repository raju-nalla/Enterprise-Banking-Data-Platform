INSERT INTO audit.AuditLogs
(
    TableName,
    RecordID,
    ActionType,
    Remarks
)
VALUES
(
    'Customers',
    100,
    'INSERT',
    'Testing Trigger'
);


SELECT TOP 1 *
FROM audit.AuditLogs
ORDER BY AuditID DESC;