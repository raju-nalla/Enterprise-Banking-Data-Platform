# 🏦 Enterprise Banking Data Platform

A production-grade **Enterprise Banking Database** built using **Microsoft SQL Server** following enterprise database development standards.

This project demonstrates real-world banking operations including customer management, account management, transactions, loan processing, reporting, and audit logging using production-quality T-SQL.

---

# 📌 Project Overview

This project simulates the backend database of a banking system where customers can:

- Register customers
- Open bank accounts
- Deposit cash
- Withdraw cash
- Transfer funds
- Apply for loans
- Approve/Reject loans
- Pay Loan EMI
- Close loans
- Generate reports
- Maintain audit history

The database is designed using enterprise best practices including:

- ACID Transactions
- TRY...CATCH Error Handling
- Business Rule Validation
- Audit Logging
- Sequences
- Constraints
- Foreign Keys
- Indexes
- Production Ready Stored Procedures

---

# 🛠 Tech Stack

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- Git
- GitHub

Future Integration:

- Azure SQL Database
- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks
- Azure Synapse Analytics
- Power BI
- Azure DevOps

---

# 📂 Project Structure

```text
Enterprise-Banking-Data-Platform
│
├── Database
│   ├── 01_Database.sql
│   ├── 02_Schemas.sql
│   ├── 03_Tables.sql
│   ├── 04_Constraints.sql
│   ├── 05_Indexes.sql
│   ├── 06_Sequences.sql
│   ├── 07_StoredProcedures.sql
│   ├── 08_ReportingProcedures.sql
│   ├── 09_Triggers.sql
│   ├── 10_TestCases.sql
│   └── 11_SampleData.sql
│
├── Architecture
│
├── Images
│
├── README.md
│
└── LICENSE
```

---

# 🗂 Database Schemas

| Schema | Purpose |
|---------|---------|
| core | Customers, Accounts, Branches, Employees |
| lending | Loan Management |
| transactions | Banking Transactions |
| audit | Audit Logs |
| security | Roles & Permissions |
| reference | Lookup Tables |

---

# 🗃 Database Objects

| Object | Status |
|---------|--------|
| Database | ✅ |
| Schemas | ✅ |
| Tables | ✅ |
| Constraints | ✅ |
| Foreign Keys | ✅ |
| Indexes | ✅ |
| Sequences | ✅ |
| Stored Procedures | ✅ |
| Reporting Procedures | ✅ |
| Audit Logging | ✅ |
| Views | ⏳ |
| Triggers | ⏳ |

---

# 👥 Customer Module

### ✅ usp_CreateCustomer

- Create Customer
- Duplicate Validation
- Email Validation
- DOB Validation
- Gender Validation

---

### ✅ usp_UpdateCustomer

- Update Customer Details
- Optional Parameters
- Duplicate Email Validation

---

### ✅ usp_DeactivateCustomer

- Soft Delete
- Active Account Validation
- Loan Validation

---

# 🏦 Account Module

### ✅ usp_OpenAccount

- Open Savings / Current Account
- Initial Deposit
- Account Validation

---

### ✅ usp_Deposit

- Cash Deposit
- Balance Update
- Transaction Logging

---

### ✅ usp_Withdraw

- Cash Withdrawal
- Available Balance Validation
- Transaction History

---

### ✅ usp_FundTransfer

- Sender Validation
- Receiver Validation
- Double Entry Transaction
- Atomic Transaction Handling

---

# 💰 Loan Module

### ✅ usp_ApplyLoan

- Loan Application
- EMI Calculation
- Loan Number Generation

---

### ✅ usp_ApproveLoan

- Loan Approval
- Loan Disbursement
- Deposit to Customer Account
- Transaction Creation

---

### ✅ usp_RejectLoan

- Reject Pending Loan
- Store Rejection Reason
- Audit Logging

---

### ✅ usp_PayEMI

- EMI Validation
- Balance Validation
- Outstanding Amount Update
- Transaction Logging
- Auto Loan Closure Support

---

### ✅ usp_CloseLoan

- Close Fully Paid Loan
- Closed Date Update
- Audit Log Entry

---

### ✅ usp_GetLoanStatement

Returns

- Customer Details
- Account Details
- Loan Information
- Transaction History

---

# 📊 Reporting Stored Procedures

## ✅ usp_GetCustomerLoanSummary

Returns

- Total Loans
- Active Loans
- Closed Loans
- Rejected Loans
- Principal Amount
- Outstanding Amount
- Loan Completion %
- Loan Details

---

## ✅ usp_GetAccountStatement

Returns

- Opening Balance
- Closing Balance
- Deposits
- Withdrawals
- Transfers
- EMI Paid
- Transaction History

---

## ✅ usp_BranchDailySummary

Returns

- Customers Created
- Accounts Opened
- Deposits
- Withdrawals
- Transfers
- Loan Applications
- Loans Approved
- Loans Rejected
- EMI Collection
- Net Cash Flow

---

## ✅ usp_DashboardSummary

Enterprise Dashboard including

- Customers
- Accounts
- Transactions
- Deposits
- Withdrawals
- Transfers
- EMI Collection
- Loans
- Outstanding Amount
- Branch Statistics
- Today's Business Summary

---

# 🔐 Enterprise Features

- ACID Transactions
- TRY...CATCH
- Transaction Rollback
- Business Rule Validation
- Audit Logging
- Soft Delete
- Identity Columns
- Sequences
- Foreign Keys
- Check Constraints
- Default Constraints
- Composite Indexes
- Production Error Handling

---

# 🧪 Testing

Each stored procedure has been tested for:

✅ Valid Input

✅ Invalid Input

✅ Duplicate Records

✅ Missing Records

✅ Business Rule Violations

✅ Rollback Scenarios

✅ Exception Handling

---

# 📈 Project Progress

| Module | Status |
|---------|--------|
| Database Design | ✅ Completed |
| Customer Module | ✅ Completed |
| Branch Module | ✅ Completed |
| Employee Module | ✅ Completed |
| Account Module | ✅ Completed |
| Transaction Module | ✅ Completed |
| Loan Module | ✅ Completed |
| Reporting Module | ✅ Completed |
| Audit Logging | ✅ Completed |
| Sample Data | ✅ Completed |
| Test Cases | ✅ Completed |
| Views | ⏳ Next |
| Triggers | ⏳ Next |
| Performance Tuning | ⏳ Next |
| Azure Integration | ⏳ Planned |

---

# 🚀 Future Enhancements

- SQL Views
- Database Triggers
- User Defined Functions
- Performance Optimization
- Azure SQL Database Deployment
- Azure Data Factory Pipelines
- Azure Data Lake Storage Gen2
- Azure Databricks
- Azure Synapse Analytics
- Power BI Dashboard
- CI/CD using Azure DevOps

---

# 📸 Screenshots

The repository includes screenshots demonstrating:

- Customer Registration
- Account Creation
- Cash Deposit
- Cash Withdrawal
- Fund Transfer
- Loan Approval
- Loan Rejection
- EMI Payment
- Loan Closure
- Loan Statement
- Reporting Procedures
- Dashboard Summary

---

# 👨‍💻 Author

**Raju Nalla**

Azure Data Engineer

GitHub: https://github.com/raju-nalla

LinkedIn: https://linkedin.com/in/raju-nalla

---

# ⭐ Project Status

**Version:** 1.0

**Status:** Production Ready (SQL Module)

Next Phase: Azure Data Engineering Implementation