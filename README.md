# Enterprise Banking Data Platform

A production-style Enterprise Banking Data Platform built using SQL Server, Python, and Microsoft Azure Data Engineering concepts.

The project demonstrates how a modern banking organization manages customers, accounts, loans, and financial transactions while following enterprise database design, transactional integrity, auditing, reporting, and simulator-driven testing.

---

# Project Overview

This project simulates a real enterprise banking system consisting of multiple business domains.

It demonstrates:

- Enterprise Database Design
- Banking Transaction Processing
- Stored Procedure Development
- Trigger-based Auditing
- Reporting Views
- Python Banking Simulator
- Azure Data Engineering Integration (Next Phase)

---

# Project Architecture

```
                +----------------------+
                | Banking Simulator    |
                |      (Python)        |
                +----------+-----------+
                           |
                           |
                           v
                +----------------------+
                | SQL Server Database  |
                | EnterpriseBankingDB  |
                +----------+-----------+
                           |
        ---------------------------------------------
        |          |           |          |          |
        v          v           v          v          v

      Core      Lending   Transactions   HR      Reporting
```

---

# Technology Stack

| Technology | Purpose |
|------------|----------|
| SQL Server | Enterprise Database |
| T-SQL | Stored Procedures |
| Python | Banking Simulator |
| pyodbc | SQL Connectivity |
| VS Code | Development |
| SSMS | Database Development |
| Git | Version Control |
| Azure (Upcoming) | Data Engineering |

---

# Database Structure

```
EnterpriseBankingDB

│
├── core
│      Customers
│      Accounts
│      Branches
│
├── hr
│      Employees
│
├── lending
│      Loans
│
├── transactions
│      Transactions
│
├── reporting
│      Views
│
└── audit
       AuditLogs
```

---

# Features

## Customer Management

- Customer Registration
- KYC Details
- Contact Information
- Customer Status

---

## Account Management

- Savings Accounts
- Current Accounts
- Balance Tracking
- Available Balance
- Active/Inactive Accounts

---

## Loan Management

- Home Loan
- Personal Loan
- Vehicle Loan
- EMI Tracking
- Loan Status

---

## Banking Transactions

Supported Transaction Types

- Deposit
- Withdrawal
- Transfer
- EMI
- Interest
- Fee
- Refund

Supported Modes

- Cash
- ATM
- Card
- UPI
- IMPS
- NEFT
- RTGS
- Branch
- Internal
- Loan Disbursement

---

# Stored Procedures

| Procedure | Description |
|------------|-------------|
| usp_Deposit | Deposit Amount |
| usp_Withdraw | Withdraw Amount |
| usp_TransferFunds | Transfer Between Accounts |
| usp_GetAccountStatement | Generate Account Statement |

Each stored procedure includes

- Input Validation
- Transaction Handling
- TRY/CATCH Error Handling
- Business Rules
- Status Codes
- Standardized Result Sets

---

# Triggers

## Audit Triggers

| Trigger | Description |
|----------|-------------|
| trg_Accounts_Audit | Audits Account Changes |
| trg_Customers_Audit | Audits Customer Changes |
| trg_Loans_Audit | Audits Loan Changes |

---

## Protection Triggers

| Trigger | Description |
|----------|-------------|
| trg_Transactions_PreventUpdate | Prevent Updates |
| trg_Transactions_PreventDelete | Prevent Deletes |

---

# Reporting Views

| View | Purpose |
|------|----------|
| vw_CustomerAccounts | Customer Account Summary |
| vw_TransactionHistory | Banking Transactions |
| vw_LoanPortfolio | Loan Analytics |
| vw_BranchSummary | Branch Analytics |
| vw_EmployeeHierarchy | Employee Reporting |

---

# Audit Logging

The project maintains a centralized audit table.

Tracked Operations

- INSERT
- UPDATE
- DELETE

Captured Information

- Table Name
- Record ID
- Operation Type
- User Name
- Timestamp
- Previous Values
- New Values

---

# Python Banking Simulator

The simulator generates realistic banking activity.

Supported Operations

- Deposit
- Withdrawal
- Fund Transfer

Features

- Random Account Selection
- Random Transaction Amounts
- Multiple Transaction Modes
- Transaction Logging
- Execution Statistics
- Audit Logging

---

# Simulation Summary

Example Output

```
Enterprise Banking Simulator

Deposit
Withdrawal
Transfer

Simulation Summary

Total Transactions : 20

Deposits           : 7

Withdrawals        : 6

Transfers          : 7

Successful         : 20

Failed             : 0

Execution Time     : 0:00:01.124
```

---

# Project Folder Structure

```
Enterprise-Banking-Data-Platform/

│
├── sql/
│   ├── schema/
│   ├── tables/
│   ├── constraints/
│   ├── indexes/
│   ├── triggers/
│   ├── views/
│   ├── procedures/
│   ├── sequences/
│   └── sample_data/
│
├── simulator/
│   ├── generators/
│   ├── services/
│   ├── utils/
│   ├── logs/
│   ├── output/
│   └── simulator.py
│
├── architecture/
│
├── documentation/
│
└── README.md
```

---

# Current Project Status

| Module | Status |
|---------|--------|
| Database Design | ✅ Completed |
| Tables | ✅ Completed |
| Constraints | ✅ Completed |
| Indexes | ✅ Completed |
| Sequences | ✅ Completed |
| Sample Data | ✅ Completed |
| Stored Procedures | ✅ Completed |
| Triggers | ✅ Completed |
| Reporting Views | ✅ Completed |
| Python Simulator | ✅ Completed |
| Statistics | ✅ Completed |
| Logging | ✅ Completed |
| Audit Logging | ✅ Completed |

---

# Upcoming Azure Implementation

The next phase extends this project into a complete Azure Data Engineering solution.

Components

- Azure SQL Database
- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks
- Delta Lake
- Medallion Architecture
- Azure Synapse Analytics
- Azure Key Vault
- Azure Monitor
- Azure DevOps CI/CD

---

# Planned Data Flow

```
Multiple Source Systems
        │
        ▼
Azure Data Factory
        │
        ▼
ADLS Gen2 (Landing)
        │
        ▼
Azure Databricks

Bronze
   │

Silver
   │

Gold
        │
        ▼
Azure Synapse Analytics
        │
        ▼
Power BI
```

---

# Future Enhancements

- CDC Pipelines
- Incremental Loading
- Delta Lake MERGE
- Medallion Architecture
- Databricks Workflows
- ADF Triggers
- Azure DevOps CI/CD
- Power BI Dashboards
- Monitoring & Alerts

---

# Author

**Raju Nalla**

Azure Data Engineer

Enterprise Banking Data Platform

2026