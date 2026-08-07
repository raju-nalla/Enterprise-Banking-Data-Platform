USE EnterpriseBankingDB;
GO

CREATE TABLE core.Accounts
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    AccountID INT IDENTITY(1,1) NOT NULL,

    -------------------------------------------------------------------------
    -- Business Key
    -------------------------------------------------------------------------
    AccountNumber VARCHAR(20) NOT NULL,

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    CustomerID INT NOT NULL,

    BranchID INT NOT NULL,

    -------------------------------------------------------------------------
    -- Account Details
    -------------------------------------------------------------------------
    AccountType VARCHAR(20) NOT NULL,

    Balance DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Accounts_Balance DEFAULT (0.00),

    AvailableBalance DECIMAL(18,2) NOT NULL
        CONSTRAINT DF_Accounts_AvailableBalance DEFAULT (0.00),

    CurrencyCode CHAR(3) NOT NULL
        CONSTRAINT DF_Accounts_Currency DEFAULT ('INR'),

    AccountStatus VARCHAR(20) NOT NULL
        CONSTRAINT DF_Accounts_Status DEFAULT ('Active'),

    -------------------------------------------------------------------------
    -- Dates
    -------------------------------------------------------------------------
    OpenDate DATE NOT NULL
        CONSTRAINT DF_Accounts_OpenDate
        DEFAULT (CAST(SYSDATETIME() AS DATE)),

    CloseDate DATE NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Accounts_CreatedDate
        DEFAULT SYSDATETIME(),

    ModifiedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Accounts_ModifiedDate
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Accounts_IsActive
        DEFAULT (1),

    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CONSTRAINT PK_Accounts
        PRIMARY KEY (AccountID),

    -------------------------------------------------------------------------
    -- Unique Constraint
    -------------------------------------------------------------------------
    CONSTRAINT UQ_Accounts_AccountNumber
        UNIQUE (AccountNumber),

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES core.Customers(CustomerID),

    CONSTRAINT FK_Accounts_Branches
        FOREIGN KEY (BranchID)
        REFERENCES core.Branches(BranchID),

    -------------------------------------------------------------------------
    -- Check Constraints
    -------------------------------------------------------------------------
    CONSTRAINT CHK_Accounts_AccountType
        CHECK (AccountType IN
        (
            'Savings',
            'Current',
            'Salary',
            'Fixed Deposit'
        )),

    CONSTRAINT CHK_Accounts_Status
        CHECK (AccountStatus IN
        (
            'Active',
            'Inactive',
            'Frozen',
            'Dormant',
            'Closed'
        )),

    CONSTRAINT CHK_Accounts_Currency
        CHECK (CurrencyCode IN
        (
            'INR',
            'USD'
        )),

    CONSTRAINT CHK_Accounts_Balance
        CHECK (Balance >= 0),

    CONSTRAINT CHK_Accounts_AvailableBalance
        CHECK
        (
            AvailableBalance >= 0
            AND AvailableBalance <= Balance
        )
);
GO



CREATE INDEX IX_Accounts_CustomerID
ON core.Accounts(CustomerID);
GO

CREATE INDEX IX_Accounts_BranchID
ON core.Accounts(BranchID);
GO

CREATE INDEX IX_Accounts_Status
ON core.Accounts(AccountStatus);
GO

CREATE INDEX IX_Accounts_OpenDate
ON core.Accounts(OpenDate);
GO