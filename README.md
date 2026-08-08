# 🏦 Enterprise Banking Data Platform

A production-style Enterprise Banking Data Platform built using SQL Server, with the next phase focused on Azure Data Engineering services including Azure Data Factory, Azure Databricks, ADLS Gen2, Azure Synapse Analytics, Azure SQL Database, Azure Key Vault, and CI/CD.

---

# 📌 Project Overview

This project simulates a real-world banking system by implementing:

- Customer Management
- Account Management
- Loan Processing
- EMI Payments
- Money Transfers
- Transaction Management
- Reporting & Analytics
- Audit Logging
- Business Triggers

The Azure implementation will extend this operational database into a modern cloud data platform using the Medallion Architecture (Bronze → Silver → Gold).

---

# 🏗️ Technology Stack

## Database

- SQL Server 2022
- T-SQL
- Stored Procedures
- Views
- Triggers
- Sequences
- Transactions
- Error Handling

## Azure (Next Phase)

- Azure SQL Database
- Azure Data Factory
- Azure Databricks
- Azure Synapse Analytics
- Azure Data Lake Storage Gen2
- Azure Key Vault
- Delta Lake
- PySpark
- GitHub
- Azure DevOps

---

# 📂 Project Structure

```
Enterprise-Banking-Data-Platform

│
├── Database
│
├── 01_Schemas
├── 02_Tables
├── 03_Constraints
├── 04_Sequences
├── 05_Sample_Data
├── 06_Stored_Procedures
├── 07_Views
├── 08_Triggers
├── 09_Testing
│
├── Azure
│
├── ADF
├── Databricks
├── Synapse
├── ADLS
├── KeyVault
├── CI_CD
│
└── README.md
```

---

# 🗄 Database Schemas

| Schema | Purpose |
|----------|-----------------------------|
| core | Customers, Accounts, Employees, Branches |
| lending | Loans |
| transactions | Banking Transactions |
| reporting | Reporting Views |
| audit | Audit Logs |

---

# 📊 Database Objects

## Tables

### Core

- Customers
- Accounts
- Employees
- Branches

### Lending

- Loans

### Transactions

- Transactions

### Audit

- AuditLogs

---

# 🔢 Sequences

Implemented enterprise numbering using SQL Server Sequences.

Examples:

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
- ✅ usp_DeactivateCustomer
- ✅ usp_SearchCustomers

---

## Account Module

- ✅ usp_OpenAccount
- ✅ usp_DepositMoney
- ✅ usp_WithdrawMoney
- ✅ usp_TransferMoney

---

## Loan Module

- ✅ usp_ApplyLoan
- ✅ usp_ApproveLoan
- ✅ usp_RejectLoan
- ✅ usp_PayEMI
- ✅ usp_CloseLoan
- ✅ usp_GetLoanStatement

---

## Reporting Module

- ✅ usp_GetCustomerLoanSummary
- ✅ usp_GetAccountStatement
- ✅ usp_BranchDailySummary
- ✅ usp_DashboardSummary

---

# 📈 Reporting Views

- ✅ vw_CustomerAccounts
- ✅ vw_TransactionHistory
- ✅ vw_LoanPortfolio
- ✅ vw_BranchSummary
- ✅ vw_EmployeeHierarchy

---

# 🔄 Triggers

## Audit Triggers

- ✅ trg_Customers_Audit
- ✅ trg_Accounts_Audit
- ✅ trg_Loans_Audit

Automatically captures:

- Old Values
- New Values
- Updated By
- Date & Time
- Remarks

---

## Business Triggers

### Prevent Transaction Delete

```
trg_Transactions_PreventDelete
```

Prevents deletion of completed financial transactions.

---

### Prevent Transaction Update

```
trg_Transactions_PreventUpdate
```

Prevents modification of completed transactions.

---

### Audit Defaults

```
trg_AuditLogs_Defaults
```

Automatically populates:

- ActionDate
- CreatedDate
- IsActive

---

# 📝 Audit Framework

All business-critical changes are recorded inside:

```
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

---

# 🔒 Business Rules Implemented

✔ Customer validation

✔ Account validation

✔ Loan eligibility

✔ Loan approval

✔ Loan rejection

✔ Loan disbursement

✔ EMI payment validation

✔ Loan closure validation

✔ Insufficient balance validation

✔ Prevent duplicate operations

✔ Audit Logging

✔ Transaction Protection

---

# 🧪 Testing

All stored procedures and triggers were tested with:

- Successful scenarios
- Invalid inputs
- Business validation failures
- Transaction rollback
- Error handling
- Audit verification

---

# 📊 Current Project Status

| Module | Status |
|----------|--------|
| Database Design | ✅ Completed |
| Schemas | ✅ Completed |
| Tables | ✅ Completed |
| Constraints | ✅ Completed |
| Sequences | ✅ Completed |
| Sample Data | ✅ Completed |
| Stored Procedures | ✅ Completed |
| Views | ✅ Completed |
| Triggers | ✅ Completed |
| Testing | ✅ Completed |
| Documentation | ✅ Completed |
| Azure SQL | ⏳ Planned |
| Azure Data Factory | ⏳ Planned |
| Azure Databricks | ⏳ Planned |
| ADLS Gen2 | ⏳ Planned |
| Azure Synapse | ⏳ Planned |
| Azure Key Vault | ⏳ Planned |
| CI/CD | ⏳ Planned |

---

# 🚀 Next Phase

The SQL Server operational database will be integrated with Azure services:

```
Azure SQL Database
        │
        ▼
Azure Data Factory
        │
        ▼
ADLS Gen2 (Bronze)
        │
        ▼
Azure Databricks
        │
        ▼
Silver Layer
        │
        ▼
Gold Layer
        │
        ▼
Azure Synapse Analytics
        │
        ▼
Power BI Dashboard
```

---

# 👨‍💻 Author

**Raju Nalla**

Azure Data Engineer

GitHub:
https://github.com/raju-nalla

LinkedIn:
https://www.linkedin.com/in/raju-nalla

---

# ⭐ Project Status

**Version:** v1.0

**Current Phase:** SQL Server Database Completed ✅

**Next Phase:** Azure Data Engineering Pipeline 🚀