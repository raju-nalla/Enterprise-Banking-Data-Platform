CREATE OR ALTER TRIGGER audit.trg_AuditLogs_Defaults
ON audit.AuditLogs
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE A
    SET
        ActionDate = ISNULL(A.ActionDate, SYSDATETIME()),
        CreatedDate = ISNULL(A.CreatedDate, SYSDATETIME()),
        IsActive = ISNULL(A.IsActive,1)
    FROM audit.AuditLogs A
    INNER JOIN inserted I
        ON A.AuditID = I.AuditID;
END;
GO