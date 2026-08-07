/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Customer Management
Object Type  : Unit Test Script
Object Name  : 01_Test_usp_CreateCustomer.sql

Author       : Raju Nalla
Version      : 4.0

Description
-----------
Unit Test Script for dbo.usp_CreateCustomer

******************************************************************************/

USE EnterpriseBankingDB;
GO
------------------------------------------------------------
-- Test Case 1
-- Valid Customer
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber = 'CUST100001',
     @FirstName = 'Raju',
     @LastName = 'Nalla',
     @DateOfBirth = '1995-01-15',
     @Gender = 'M',
     @Email = 'raju.nalla@test.com',
     @PhoneNumber = '9876543210',
     @AddressLine1 = 'Madhapur',
     @AddressLine2 = NULL,
     @City = 'Hyderabad',
     @State = 'Telangana',
     @Country = 'India',
     @PostalCode = '500081',

     @CustomerID = @CustomerID OUTPUT,
     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @CustomerID AS CustomerID,
    @StatusCode AS StatusCode,
    @StatusMessage AS StatusMessage;


    ------------------------------------------------------------
-- Test Case 2
-- Duplicate Customer Number
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100001',
     @FirstName='John',
     @LastName='Smith',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

    ------------------------------------------------------------
-- Test Case 3
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100002',
     @FirstName='David',
     @LastName='Warner',
     @Email='raju.nalla@test.com',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;


    ------------------------------------------------------------
-- Test Case 4
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber=NULL,
     @FirstName='Raju',
     @LastName='Nalla',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;


    ------------------------------------------------------------
-- Test Case 5
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100003',
     @FirstName=NULL,
     @LastName='Nalla',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

    ------------------------------------------------------------
-- Test Case 6
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100004',
     @FirstName='Raju',
     @LastName=NULL,

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

    ------------------------------------------------------------
-- Test Case 7
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100005',
     @FirstName='Raju',
     @LastName='Nalla',
     @Gender='X',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;


    ------------------------------------------------------------
-- Test Case 8
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100006',
     @FirstName='Raju',
     @LastName='Nalla',
     @DateOfBirth='2099-01-01',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

    ------------------------------------------------------------
-- Test Case 9
------------------------------------------------------------

DECLARE
    @CustomerID BIGINT,
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_CreateCustomer

     @CustomerNumber='CUST100007',
     @FirstName='Raju',
     @LastName='Nalla',
     @Email='',

     @CustomerID=@CustomerID OUTPUT,
     @StatusCode=@StatusCode OUTPUT,
     @StatusMessage=@StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

    ------------------------------------------------------------
-- Verify Inserted Customers
------------------------------------------------------------

SELECT
    CustomerID,
    CustomerNumber,
    FirstName,
    LastName,
    Email,
    KYCStatus,
    CustomerStatus,
    CreatedDate
FROM core.Customers
ORDER BY CustomerID DESC;