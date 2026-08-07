USE EnterpriseBankingDB;
GO

CREATE TABLE core.Customers
(
    CustomerID INT IDENTITY(1,1),

    CustomerNumber VARCHAR(20) NOT NULL,

    FirstName VARCHAR(50) NOT NULL,

    LastName VARCHAR(50) NOT NULL,

    DateOfBirth DATE NULL,

    Gender CHAR(1) NULL
        CONSTRAINT CHK_Customers_Gender
        CHECK (Gender IN ('M', 'F', 'O')),

    Email VARCHAR(100) NULL,

    PhoneNumber VARCHAR(20) NULL,

    AddressLine1 VARCHAR(200) NULL,

    AddressLine2 VARCHAR(200) NULL,

    City VARCHAR(50) NULL,

    State VARCHAR(50) NULL,

    Country VARCHAR(50) NULL,

    PostalCode VARCHAR(15) NULL,

    KYCStatus VARCHAR(20) NOT NULL
        CONSTRAINT DF_Customers_KYCStatus DEFAULT ('Pending')
        CONSTRAINT CHK_Customers_KYCStatus
        CHECK (KYCStatus IN ('Pending', 'Verified', 'Rejected')),

    CustomerStatus VARCHAR(20) NOT NULL
        CONSTRAINT DF_Customers_Status DEFAULT ('Active')
        CONSTRAINT CHK_Customers_Status
        CHECK (CustomerStatus IN ('Active', 'Inactive', 'Blocked')),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Customers_CreatedDate DEFAULT SYSDATETIME(),

    ModifiedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Customers_ModifiedDate DEFAULT SYSDATETIME(),

    IsActive BIT NOT NULL
        CONSTRAINT DF_Customers_IsActive DEFAULT (1),

    CONSTRAINT PK_Customers
        PRIMARY KEY (CustomerID),

    CONSTRAINT UQ_Customers_CustomerNumber
        UNIQUE (CustomerNumber),

    CONSTRAINT UQ_Customers_Email
        UNIQUE (Email)
);
GO


CREATE INDEX IX_Customers_LastName
ON core.Customers(LastName);

CREATE INDEX IX_Customers_PhoneNumber
ON core.Customers(PhoneNumber);

CREATE INDEX IX_Customers_City
ON core.Customers(City);

CREATE INDEX IX_Customers_CustomerStatus
ON core.Customers(CustomerStatus);
GO