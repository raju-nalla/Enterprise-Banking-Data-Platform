USE EnterpriseBankingDB;
GO

CREATE TABLE lending.Loans
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    LoanID INT IDENTITY(1,1) NOT NULL,

    -------------------------------------------------------------------------
    -- Business Key
    -------------------------------------------------------------------------
    LoanNumber VARCHAR(20) NOT NULL,

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    CustomerID INT NOT NULL,

    AccountID INT NULL,

    ApprovedByEmployeeID INT NULL,

    -------------------------------------------------------------------------
    -- Loan Details
    -------------------------------------------------------------------------
    LoanType VARCHAR(20) NOT NULL,

    PrincipalAmount DECIMAL(18,2) NOT NULL,

    InterestRate DECIMAL(5,2) NOT NULL,

    TenureMonths INT NOT NULL,

    EMIAmount DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Loans_EMIAmount DEFAULT (0.00),

    OutstandingAmount DECIMAL(18,2) NOT NULL,

    LoanStatus VARCHAR(20) NOT NULL
        CONSTRAINT DF_Loans_Status DEFAULT ('Pending'),

    -------------------------------------------------------------------------
    -- Dates
    -------------------------------------------------------------------------
    ApplicationDate DATE NOT NULL
        CONSTRAINT DF_Loans_ApplicationDate
        DEFAULT (CAST(SYSDATETIME() AS DATE)),

    ApprovalDate DATE NULL,

    DisbursementDate DATE NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Loans_CreatedDate
        DEFAULT SYSDATETIME(),

    ModifiedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Loans_ModifiedDate
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Loans_IsActive
        DEFAULT (1),

    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CONSTRAINT PK_Loans
        PRIMARY KEY (LoanID),

    -------------------------------------------------------------------------
    -- Unique Constraint
    -------------------------------------------------------------------------
    CONSTRAINT UQ_Loans_LoanNumber
        UNIQUE (LoanNumber),

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    CONSTRAINT FK_Loans_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES core.Customers(CustomerID),

    CONSTRAINT FK_Loans_Accounts
        FOREIGN KEY (AccountID)
        REFERENCES core.Accounts(AccountID),

    CONSTRAINT FK_Loans_Employees
        FOREIGN KEY (ApprovedByEmployeeID)
        REFERENCES hr.Employees(EmployeeID),

    -------------------------------------------------------------------------
    -- Check Constraints
    -------------------------------------------------------------------------
    CONSTRAINT CHK_Loans_LoanType
        CHECK
        (
            LoanType IN
            (
                'Home',
                'Personal',
                'Vehicle',
                'Education',
                'Business'
            )
        ),

    CONSTRAINT CHK_Loans_Status
        CHECK
        (
            LoanStatus IN
            (
                'Pending',
                'Approved',
                'Rejected',
                'Disbursed',
                'Closed'
            )
        ),

    CONSTRAINT CHK_Loans_Principal
        CHECK (PrincipalAmount > 0),

    CONSTRAINT CHK_Loans_InterestRate
        CHECK (InterestRate > 0),

    CONSTRAINT CHK_Loans_Tenure
        CHECK (TenureMonths > 0),

    CONSTRAINT CHK_Loans_Outstanding
        CHECK
        (
            OutstandingAmount >= 0
            AND OutstandingAmount <= PrincipalAmount
        )
);
GO


CREATE INDEX IX_Loans_CustomerID
ON lending.Loans(CustomerID);
GO

CREATE INDEX IX_Loans_AccountID
ON lending.Loans(AccountID);
GO

CREATE INDEX IX_Loans_ApprovedByEmployeeID
ON lending.Loans(ApprovedByEmployeeID);
GO

CREATE INDEX IX_Loans_LoanStatus
ON lending.Loans(LoanStatus);
GO

CREATE INDEX IX_Loans_ApplicationDate
ON lending.Loans(ApplicationDate);
GO