USE EnterpriseBankingDB;
GO

CREATE TABLE core.Branches
(
    BranchID INT IDENTITY(1,1),

    BranchCode VARCHAR(10) NOT NULL,

    BranchName VARCHAR(100) NOT NULL,

    AddressLine1 VARCHAR(200) NULL,

    City VARCHAR(50) NULL,

    State VARCHAR(50) NULL,

    Country VARCHAR(50) NULL,

    PostalCode VARCHAR(15) NULL,

    IFSCCode VARCHAR(20) NOT NULL,

    PhoneNumber VARCHAR(20) NULL,

    ManagerName VARCHAR(100) NULL,

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Branches_CreatedDate DEFAULT SYSDATETIME(),

    ModifiedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Branches_ModifiedDate DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Branches_IsActive DEFAULT (1),

    CONSTRAINT PK_Branches
        PRIMARY KEY (BranchID),

    CONSTRAINT UQ_Branches_BranchCode
        UNIQUE (BranchCode),

    CONSTRAINT UQ_Branches_IFSCCode
        UNIQUE (IFSCCode)
);
GO