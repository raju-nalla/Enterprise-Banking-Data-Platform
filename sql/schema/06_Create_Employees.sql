USE EnterpriseBankingDB;
GO

CREATE TABLE hr.Employees
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    EmployeeID INT IDENTITY(1,1) NOT NULL,

    -------------------------------------------------------------------------
    -- Business Key
    -------------------------------------------------------------------------
    EmployeeNumber VARCHAR(20) NOT NULL,

    -------------------------------------------------------------------------
    -- Foreign Key
    -------------------------------------------------------------------------
    BranchID INT NOT NULL,

    -------------------------------------------------------------------------
    -- Personal Information
    -------------------------------------------------------------------------
    FirstName VARCHAR(50) NOT NULL,

    LastName VARCHAR(50) NOT NULL,

    Email VARCHAR(100) NULL,

    PhoneNumber VARCHAR(20) NULL,

    -------------------------------------------------------------------------
    -- Employment Information
    -------------------------------------------------------------------------
    JobTitle VARCHAR(50) NOT NULL,

    Department VARCHAR(50) NOT NULL,

    HireDate DATE NOT NULL
        CONSTRAINT DF_Employees_HireDate
        DEFAULT (CAST(SYSDATETIME() AS DATE)),

    Salary DECIMAL(18,2) NOT NULL,

    ManagerID INT NULL,

    EmployeeStatus VARCHAR(20) NOT NULL
        CONSTRAINT DF_Employees_Status DEFAULT ('Active'),

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Employees_CreatedDate
        DEFAULT SYSDATETIME(),

    ModifiedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Employees_ModifiedDate
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Employees_IsActive
        DEFAULT (1),

    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CONSTRAINT PK_Employees
        PRIMARY KEY (EmployeeID),

    -------------------------------------------------------------------------
    -- Unique Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_Employees_EmployeeNumber
        UNIQUE (EmployeeNumber),

    CONSTRAINT UQ_Employees_Email
        UNIQUE (Email),

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    CONSTRAINT FK_Employees_Branches
        FOREIGN KEY (BranchID)
        REFERENCES core.Branches(BranchID),

    CONSTRAINT FK_Employees_Manager
        FOREIGN KEY (ManagerID)
        REFERENCES hr.Employees(EmployeeID),

    -------------------------------------------------------------------------
    -- Check Constraints
    -------------------------------------------------------------------------
    CONSTRAINT CHK_Employees_Department
        CHECK
        (
            Department IN
            (
                'Operations',
                'Retail Banking',
                'Loans',
                'Customer Service',
                'Finance',
                'IT',
                'HR',
                'Compliance'
            )
        ),

    CONSTRAINT CHK_Employees_JobTitle
        CHECK
        (
            JobTitle IN
            (
                'Branch Manager',
                'Loan Officer',
                'Teller',
                'Customer Service Executive',
                'Relationship Manager',
                'Operations Executive'
            )
        ),

    CONSTRAINT CHK_Employees_Status
        CHECK
        (
            EmployeeStatus IN
            (
                'Active',
                'On Leave',
                'Suspended',
                'Resigned',
                'Terminated'
            )
        ),

    CONSTRAINT CHK_Employees_Salary
        CHECK (Salary >= 0)
);
GO


CREATE INDEX IX_Employees_BranchID
ON hr.Employees(BranchID);
GO

CREATE INDEX IX_Employees_ManagerID
ON hr.Employees(ManagerID);
GO

CREATE INDEX IX_Employees_Department
ON hr.Employees(Department);
GO

CREATE INDEX IX_Employees_Status
ON hr.Employees(EmployeeStatus);
GO