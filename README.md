# Enterprise Banking Data Platform

A production-grade Banking Data Platform built using Microsoft SQL Server following enterprise database development standards.

---

# Project Status

## Completed Modules

### Database Foundation
- [x] Database Creation
- [x] Schemas
- [x] Master Tables
- [x] Core Tables
- [x] Constraints
- [x] Primary Keys
- [x] Foreign Keys
- [x] Default Constraints
- [x] Check Constraints
- [x] Indexes

---

## Stored Procedures

### Customer Module

### 01. usp_CreateCustomer
Status : ✅ Completed

Features

- Customer creation
- Duplicate Customer Number validation
- Duplicate Email validation
- Mandatory field validation
- Gender validation
- DOB validation
- Transaction handling
- TRY...CATCH
- Output parameters
- Enterprise error codes

Testing

- Valid Customer
- Duplicate Customer Number
- Duplicate Email
- Missing Mandatory Fields
- Invalid Gender
- Future DOB
- NULL Email
- Successful Inserts

Status

Production Ready

---

### 02. usp_UpdateCustomer
Status : ✅ Completed

Features

- Update customer details
- Partial updates supported
- Optional parameters
- Duplicate Email validation
- Gender validation
- DOB validation
- Customer existence validation
- Transaction handling
- TRY...CATCH
- Audit columns update
- Output parameters

Testing

- Successful update
- Customer not found
- Duplicate email
- Invalid DOB
- Invalid gender
- No changes supplied
- NULL optional values

Status

Production Ready

---

### 03. usp_DeactivateCustomer
Status : ✅ Completed

Features

- Soft delete implementation
- Customer existence validation
- Already inactive validation
- Active account validation
- Transaction handling
- TRY...CATCH
- Output parameters
- Audit update

Notes

Loan validation section prepared.
Will be enabled after Loan module implementation.

Testing

- Successful Deactivation
- Customer Not Found
- Already Inactive Customer
- Customer With Active Accounts
- Customer Without Accounts

Status

Production Ready

---

## Folder Structure

```
EnterpriseBankingPlatform
│
├── Database
│
├── Tables
│
├── StoredProcedures
│   ├── 01_usp_CreateCustomer.sql
│   ├── 02_usp_UpdateCustomer.sql
│   ├── 03_usp_DeactivateCustomer.sql
│   ├── 04_usp_GetCustomerByID.sql   (Next)
│   ├── 05_usp_GetAllCustomers.sql
│   ├── 06_usp_SearchCustomers.sql
│   └── ...
│
├── TestCases
│
└── README.md
```

---

# Coding Standards

- Production Ready SQL
- Naming Standards
- TRY...CATCH
- Transactions
- Output Parameters
- Business Error Codes
- Defensive Programming
- Enterprise Comments
- Soft Delete Pattern

---

# Business Rules Implemented

✔ Customer Number must be unique

✔ Email must be unique

✔ Mandatory fields validated

✔ DOB cannot be future date

✔ Gender validation

✔ Partial updates supported

✔ Soft Delete implemented

✔ Customer cannot be deactivated twice

✔ Customer cannot be deactivated with Active Accounts

---

# Error Codes

| Code | Description |
|------|-------------|
|0|Success|
|1001|Duplicate Customer Number|
|1002|Duplicate Email|
|1003|Invalid Date Of Birth|
|1004|Mandatory Fields Missing|
|1005|Invalid Gender|
|1006|Customer Not Found|
|1007|Nothing To Update|
|1008|Customer Already Inactive|
|1009|Customer Has Active Accounts|
|1010|Customer Has Active Loans (Future)|
|9999|Unexpected SQL Error|

---

# Current Progress

Completed

- Database Design
- Core Tables
- Customer Module
- Create Customer SP
- Update Customer SP
- Deactivate Customer SP

Next

- usp_GetCustomerByID
- usp_GetAllCustomers
- Search Customer
- Branch Module
- Account Module
- Loan Module
- Transaction Module
- Views
- Functions
- Triggers
- Performance Tuning

---

Last Updated

08-Aug-2026