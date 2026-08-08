UPDATE core.Customers
SET
    PhoneNumber='9999999999'
WHERE CustomerID=1;

SELECT
    CustomerID,
    PhoneNumber
FROM core.Customers
WHERE CustomerID=1;

SELECT TOP (1)
    AuditID,
    TableName,
    RecordID,
    ActionType,
    ActionDate,
    OldValue,
    NewValue,
    Remarks
FROM audit.AuditLogs
ORDER BY AuditID DESC;