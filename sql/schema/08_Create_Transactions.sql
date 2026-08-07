USE EnterpriseBankingDB;
GO

CREATE TABLE transactions.Transactions
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    TransactionID INT IDENTITY(1,1) NOT NULL,

    -------------------------------------------------------------------------
    -- Business Key
    -------------------------------------------------------------------------
    TransactionNumber VARCHAR(30) NOT NULL,

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    AccountID INT NOT NULL,

    LoanID INT NULL,

    ProcessedByEmployeeID INT NULL,

    -------------------------------------------------------------------------
    -- Transaction Details
    -------------------------------------------------------------------------
    TransactionType VARCHAR(20) NOT NULL,

    TransactionMode VARCHAR(20) NOT NULL,

    Amount DECIMAL(18,2) NOT NULL,

    BalanceAfterTransaction DECIMAL(18,2) NOT NULL,

    TransactionStatus VARCHAR(20) NOT NULL
        CONSTRAINT DF_Transactions_Status DEFAULT ('Pending'),

    TransactionDate DATETIME2 NOT NULL
        CONSTRAINT DF_Transactions_Date DEFAULT SYSDATETIME(),

    Remarks VARCHAR(255) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Transactions_CreatedDate
        DEFAULT SYSDATETIME(),

    ModifiedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Transactions_ModifiedDate
        DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Transactions_IsActive
        DEFAULT (1),

    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CONSTRAINT PK_Transactions
        PRIMARY KEY (TransactionID),

    -------------------------------------------------------------------------
    -- Unique Constraint
    -------------------------------------------------------------------------
    CONSTRAINT UQ_Transactions_TransactionNumber
        UNIQUE (TransactionNumber),

    -------------------------------------------------------------------------
    -- Foreign Keys
    -------------------------------------------------------------------------
    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID)
        REFERENCES core.Accounts(AccountID),

    CONSTRAINT FK_Transactions_Loans
        FOREIGN KEY (LoanID)
        REFERENCES lending.Loans(LoanID),

    CONSTRAINT FK_Transactions_Employees
        FOREIGN KEY (ProcessedByEmployeeID)
        REFERENCES hr.Employees(EmployeeID),

    -------------------------------------------------------------------------
    -- Check Constraints
    -------------------------------------------------------------------------
    CONSTRAINT CHK_Transactions_Amount
        CHECK (Amount > 0),

    CONSTRAINT CHK_Transactions_Balance
        CHECK (BalanceAfterTransaction >= 0),

    CONSTRAINT CHK_Transactions_Type
        CHECK
        (
            TransactionType IN
            (
                'Deposit',
                'Withdrawal',
                'Transfer',
                'EMI',
                'Interest',
                'Fee',
                'Refund'
            )
        ),

    CONSTRAINT CHK_Transactions_Mode
        CHECK
        (
            TransactionMode IN
            (
                'Cash',
                'UPI',
                'NEFT',
                'RTGS',
                'IMPS',
                'ATM',
                'Card'
            )
        ),

    CONSTRAINT CHK_Transactions_Status
        CHECK
        (
            TransactionStatus IN
            (
                'Pending',
                'Success',
                'Failed',
                'Reversed'
            )
        )
);
GO

CREATE INDEX IX_Transactions_AccountID
ON transactions.Transactions(AccountID);
GO

CREATE INDEX IX_Transactions_LoanID
ON transactions.Transactions(LoanID);
GO

CREATE INDEX IX_Transactions_EmployeeID
ON transactions.Transactions(ProcessedByEmployeeID);
GO

CREATE INDEX IX_Transactions_Date
ON transactions.Transactions(TransactionDate);
GO

CREATE INDEX IX_Transactions_Status
ON transactions.Transactions(TransactionStatus);
GO

CREATE INDEX IX_Transactions_Type
ON transactions.Transactions(TransactionType);
GO