UPDATE lending.Loans
SET InterestRate = 12.50
WHERE LoanID = 2;

SELECT
    LoanID,
    InterestRate
FROM lending.Loans
WHERE LoanID = 2;

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
WHERE TableName='Loans'
ORDER BY AuditID DESC;