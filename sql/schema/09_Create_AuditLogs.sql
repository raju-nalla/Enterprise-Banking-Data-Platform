USE EnterpriseBankingDB;
GO

CREATE TABLE audit.AuditLogs
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    AuditID INT IDENTITY(1,1) NOT NULL,

    -------------------------------------------------------------------------
    -- Audit Information
    -------------------------------------------------------------------------
    TableName VARCHAR(100) NOT NULL,

    RecordID INT NOT NULL,

    ActionType VARCHAR(20) NOT NULL,

    PerformedByEmployeeID INT NULL,

    ActionDate DATETIME2 NOT NULL
        CONSTRAINT DF_AuditLogs_ActionDate
        DEFAULT SYSDATETIME(),

    -------------------------------------------------------------------------
    -- Change Tracking
    -------------------------------------------------------------------------
    OldValue NVARCHAR(MAX) NULL,

    NewValue NVARCHAR(MAX) NULL,

    IPAddress VARCHAR(45) NULL,

    Remarks VARCHAR(500) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_AuditLogs_CreatedDate
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_AuditLogs_IsActive
        DEFAULT (1),

    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CONSTRAINT PK_AuditLogs
        PRIMARY KEY (AuditID),

    -------------------------------------------------------------------------
    -- Foreign Key
    -------------------------------------------------------------------------
    CONSTRAINT FK_AuditLogs_Employees
        FOREIGN KEY (PerformedByEmployeeID)
        REFERENCES hr.Employees(EmployeeID),

    -------------------------------------------------------------------------
    -- Check Constraints
    -------------------------------------------------------------------------
    CONSTRAINT CHK_AuditLogs_ActionType
        CHECK
        (
            ActionType IN
            (
                'INSERT',
                'UPDATE',
                'DELETE',
                'LOGIN',
                'LOGOUT',
                'APPROVE',
                'REJECT',
                'TRANSFER',
                'REVERSE'
            )
        )
);
GO


CREATE INDEX IX_AuditLogs_TableName
ON audit.AuditLogs(TableName);
GO

CREATE INDEX IX_AuditLogs_RecordID
ON audit.AuditLogs(RecordID);
GO

CREATE INDEX IX_AuditLogs_ActionDate
ON audit.AuditLogs(ActionDate);
GO

CREATE INDEX IX_AuditLogs_EmployeeID
ON audit.AuditLogs(PerformedByEmployeeID);
GO

CREATE INDEX IX_AuditLogs_ActionType
ON audit.AuditLogs(ActionType);
GO