# 🏦 Enterprise Banking Data Platform

A production-style Enterprise Banking Data Platform built using SQL Server and Python, designed to simulate a real-world core banking system. The next phase extends this platform into a modern Azure Data Engineering solution using Azure Data Factory, Azure Databricks, ADLS Gen2, Azure Synapse Analytics, Azure SQL Database, Azure Key Vault, and Power BI.

---

# 📌 Project Overview

This project demonstrates the complete lifecycle of an enterprise banking system by implementing:

- Customer Management
- Account Management
- Loan Processing
- Transaction Management
- EMI Payments
- Money Transfers
- Reporting & Analytics
- Audit Logging
- Business Triggers
- Python Integration Simulator

The long-term objective is to build an end-to-end Azure Data Engineering project that ingests operational banking data into a Medallion Architecture (Bronze → Silver → Gold) for enterprise reporting and analytics.

---

# 🏗 Technology Stack

## Database

- SQL Server 2022
- T-SQL
- Stored Procedures
- Views
- Functions
- Triggers
- Sequences
- Transactions
- Error Handling

## Python

- Python 3.x
- pyodbc
- Faker
- Object-Oriented Programming
- Service Layer Architecture

## Azure (Upcoming Phase)

- Azure SQL Database
- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks
- Azure Synapse Analytics
- Azure Key Vault
- Delta Lake
- PySpark
- Azure DevOps
- GitHub

---

# 📂 Project Structure

```text
Enterprise-Banking-Data-Platform
│
├── docs
│
├── infrastructure
│
├── monitoring
│
├── powerbi
│
├── simulator
│   ├── config
│   ├── generators
│   ├── services
│   ├── tests
│   ├── utils
│   └── logs
│
├── sql
│   ├── schema
│   ├── sequences
│   ├── stored-procedures
│   │   ├── Customer
│   │   ├── Account
│   │   ├── Loan
│   │   ├── Transactions
│   │   └── Reporting
│   ├── functions
│   ├── views
│   ├── triggers
│   └── test
│
└── README.md
```

---

# 🗄 Database Schemas

| Schema | Purpose |
|----------|-------------------------------|
| core | Customers, Accounts, Branches, Employees |
| lending | Loan Management |
| transactions | Banking Transactions |
| reporting | Reporting Views |
| audit | Audit Framework |

---

# 📊 Database Objects

## Tables

### Core

- Customers
- Accounts
- Branches
- Employees

### Lending

- Loans

### Transactions

- Transactions

### Audit

- AuditLogs

---

# 🔢 Sequences

Enterprise numbering is implemented using SQL Server Sequences.

- CustomerNumber
- AccountNumber
- LoanNumber
- TransactionNumber
- EmployeeNumber

---

# ⚙ Stored Procedures

## Customer Module

- ✅ usp_CreateCustomer
- ✅ usp_UpdateCustomer
- ✅ usp_GetCustomerByID
- ✅ usp_GetCustomerByCustomerNumber
- ✅ usp_GetAllCustomers
- ✅ usp_DeactivateCustomer

---

## Account Module

- ✅ usp_CreateAccount
- ✅ usp_UpdateAccountStatus
- ✅ usp_GetAccountByAccountNumber
- ✅ usp_GetAccountByID
- ✅ usp_GetAllAccounts
- ✅ usp_CloseAccount

---

## Loan Module

- ✅ usp_CreateLoan
- ✅ usp_ApproveLoan
- ✅ usp_RejectLoan
- ✅ usp_PayEMI
- ✅ usp_CloseLoan
- ✅ usp_GetLoanStatement

---

## Transaction Module

- ✅ usp_Deposit
- ✅ usp_Withdraw
- ✅ usp_TransferFunds
- ✅ usp_GetAccountStatement

---

## Reporting Module

- ✅ usp_DashboardSummary
- ✅ usp_BranchDailySummary
- ✅ usp_GetCustomerLoanSummary

---

# 📈 Reporting Views

- ✅ vw_CustomerAccounts
- ✅ vw_TransactionHistory
- ✅ vw_LoanPortfolio
- ✅ vw_BranchSummary
- ✅ vw_EmployeeHierarchy

---

# 🧮 Scalar Functions

- ✅ fn_GetCustomerFullName
- ✅ fn_GetAccountBalance
- ✅ fn_GetLoanOutstanding
- ✅ fn_CalculateAge
- ✅ fn_CalculateEMI

---

# 🔄 Triggers

## Audit Triggers

- ✅ trg_Customers_Audit
- ✅ trg_Accounts_Audit
- ✅ trg_Loans_Audit

Automatically captures:

- Old Values
- New Values
- Employee ID
- Action Type
- Remarks
- Timestamp

---

## Business Triggers

### Transaction Protection

- ✅ trg_Transactions_PreventUpdate
- ✅ trg_Transactions_PreventDelete

### Audit Defaults

- ✅ trg_AuditLogs_Defaults

---

# 📝 Audit Framework

All business-critical changes are stored in:

```text
audit.AuditLogs
```

Captured Information:

- Table Name
- Record ID
- Action Type
- Employee ID
- Old Values
- New Values
- Remarks
- Action Date
- Created Date

---

# 🐍 Python Banking Simulator

A lightweight simulator is included to validate SQL Server stored procedures through Python.

The simulator follows a Service Layer architecture.

## Customer Module

### Generator

- ✅ customer_generator.py

### Service

- ✅ customer_service.py

### Integration Test

- ✅ test_customer_service.py

---

## Account Module

### Generator

- ✅ account_generator.py

### Service

- ✅ account_service.py

### Integration Test

- ✅ test_account_service.py

---

## Loan Module

⏳ Planned

---

## Transaction Module

⏳ Planned

---

## Reporting Module

⏳ Planned

---

# 🔒 Business Rules Implemented

✔ Customer Validation

✔ Account Validation

✔ Branch Validation

✔ Loan Eligibility

✔ Loan Approval

✔ Loan Rejection

✔ EMI Validation

✔ Loan Closure

✔ Deposit Validation

✔ Withdrawal Validation

✔ Fund Transfer Validation

✔ Insufficient Balance Validation

✔ Duplicate Prevention

✔ Audit Logging

✔ Transaction Protection

✔ Error Handling

---

# 🧪 Testing

The following components have been tested successfully:

- Customer CRUD
- Account Creation
- Account Lookup
- Account Status Update
- Stored Procedure Validation
- Transaction Rollback
- Error Handling
- Business Rules
- Trigger Validation
- Audit Logging
- Python Integration

---

# 📊 Current Project Status

| Component | Status |
|------------|---------|
| Database Design | ✅ Completed |
| Database Schemas | ✅ Completed |
| Tables | ✅ Completed |
| Constraints | ✅ Completed |
| Sample Data | ✅ Completed |
| Sequences | ✅ Completed |
| Views | ✅ Completed |
| Functions | ✅ Completed |
| Triggers | ✅ Completed |
| Customer Stored Procedures | ✅ Completed |
| Account Stored Procedures | ✅ Completed |
| Loan Stored Procedures | ✅ Completed |
| Transaction Stored Procedures | ✅ Completed |
| Reporting Stored Procedures | ✅ Completed |
| Customer Python Simulator | ✅ Completed |
| Account Python Simulator | ✅ Completed |
| Loan Python Simulator | ⏳ Planned |
| Transaction Python Simulator | ⏳ Planned |
| Reporting Python Simulator | ⏳ Planned |
| Azure SQL | ⏳ Planned |
| Azure Data Factory | ⏳ Planned |
| ADLS Gen2 | ⏳ Planned |
| Azure Databricks | ⏳ Planned |
| Azure Synapse Analytics | ⏳ Planned |
| Power BI | ⏳ Planned |

---

# 🚀 Azure Data Engineering Roadmap

```text
                SQL Server
                     │
                     ▼
          Azure Data Factory
                     │
                     ▼
           ADLS Gen2 (Bronze)
                     │
                     ▼
          Azure Databricks
          Bronze → Silver → Gold
                     │
                     ▼
      Azure Synapse Analytics
                     │
                     ▼
             Power BI Dashboard
```

---

# 🎯 Upcoming Work

- Loan Python Simulator
- Transaction Python Simulator
- Reporting Python Simulator
- Azure SQL Migration
- Azure Data Factory Pipelines
- ADLS Gen2 Integration
- Azure Databricks ETL
- Delta Lake Implementation
- Synapse Analytics
- Power BI Dashboards
- CI/CD using Azure DevOps

---

# 👨‍💻 Author

**Raju Nalla**

Azure Data Engineer

GitHub

https://github.com/raju-nalla

LinkedIn

https://www.linkedin.com/in/raju-nalla

---

# ⭐ Project Status

**Version:** v1.5

**Current Phase**

✅ Enterprise SQL Banking Platform with Python Integration Simulator

**Next Phase**

🚀 Azure Data Engineering Platform (ADF → ADLS → Databricks → Synapse → Power BI)