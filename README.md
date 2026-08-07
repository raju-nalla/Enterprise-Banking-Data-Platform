# 🏦 Enterprise Banking Data Platform

> An end-to-end Enterprise Banking Data Engineering Project built using SQL Server, Python, Azure Data Factory, Azure SQL Database, Azure Data Lake Storage Gen2, Azure Databricks, Azure Synapse Analytics, and Power BI.

---

# 📖 Project Overview

The Enterprise Banking Data Platform simulates a real-world banking ecosystem by implementing transactional database design, enterprise SQL programming, data engineering pipelines, analytics, and reporting.

This project follows enterprise software development standards and is built incrementally through versioned releases.

---

# 🎯 Project Objectives

- Design a normalized banking database
- Implement enterprise SQL programming
- Simulate real banking transactions
- Build reporting and analytics
- Generate realistic banking data
- Build Azure Data Engineering pipelines
- Implement Medallion Architecture
- Develop Power BI dashboards

---

# 🏗️ Technology Stack

| Category | Technology |
|-----------|------------|
| Database | SQL Server |
| Language | T-SQL |
| Version Control | Git & GitHub |
| Data Generation | Python |
| Cloud Database | Azure SQL Database |
| Data Integration | Azure Data Factory |
| Data Lake | Azure Data Lake Storage Gen2 |
| Processing | Azure Databricks (PySpark) |
| Analytics | Azure Synapse Analytics |
| Visualization | Power BI |

---

# 📂 Project Structure

```text
Enterprise-Banking-Data-Platform
│
├── README.md
├── LICENSE
│
├── docs
│   ├── CodingStandards.md
│   ├── Architecture.md
│   ├── DataDictionary.md
│   ├── TestingGuide.md
│   ├── InterviewGuide.md
│   └── releases
│       ├── v1.0.md
│       ├── v2.0.md
│       ├── v3.0.md
│       └── v4.0.md
│
├── sql
│   ├── schemas
│   ├── tables
│   ├── views
│   ├── functions
│   ├── procedures
│   ├── triggers
│   └── test
│
├── python
│
├── azure
│
├── databricks
│
└── powerbi
```

---

# 🗄️ Database Schemas

| Schema | Purpose |
|----------|----------|
| core | Core transactional tables |
| reporting | Reporting views |
| audit | Audit logging and tracking |
| dbo | Utility functions and procedures |

---

# 🏦 Core Banking Tables

| Table | Status |
|---------|--------|
| Branches | ✅ Completed |
| Customers | ✅ Completed |
| Accounts | ✅ Completed |
| Employees | ✅ Completed |
| Loans | ✅ Completed |
| Transactions | ✅ Completed |
| AuditLogs | ✅ Completed |

---

# 📊 Reporting Views

| View | Status |
|------|--------|
| vw_CustomerAccountSummary | ✅ |
| vw_BranchPerformance | ✅ |
| vw_TransactionSummary | ✅ |
| vw_EmployeePerformance | ✅ |
| vw_LoanPortfolio | ✅ |

---

# ⚙️ SQL Functions

| Function | Purpose | Status |
|-----------|----------|--------|
| fn_CalculateAge | Calculate customer age | ✅ |
| fn_GetFullName | Return customer full name | ✅ |
| fn_GetAccountBalance | Return account balance | ✅ |
| fn_CalculateEMI | Calculate monthly EMI | ✅ |
| fn_GetLoanOutstanding | Outstanding loan amount | ✅ |

---

# 🚀 Stored Procedures

| Procedure | Status |
|------------|--------|
| usp_CreateCustomer | 🚧 In Progress |
| usp_OpenAccount | ⏳ Planned |
| usp_DepositMoney | ⏳ Planned |
| usp_WithdrawMoney | ⏳ Planned |
| usp_TransferFunds | ⏳ Planned |
| usp_ApplyLoan | ⏳ Planned |
| usp_ApproveLoan | ⏳ Planned |

---

# 📈 Project Roadmap

## ✅ Version 1.0
- Database Foundation
- Schemas
- Core Tables
- Constraints
- Relationships

---

## ✅ Version 2.0
- Reporting Views
- Business Reporting Layer

---

## ✅ Version 3.0
- Scalar Functions
- Enterprise SQL Programming
- Unit Test Scripts

---

## 🚧 Version 4.0 (Current Sprint)
- Stored Procedures
- Enterprise Transactions
- TRY...CATCH
- Output Parameters
- Business Validation

---

## 🔜 Version 4.1
- Centralized Audit Logging
- audit.usp_WriteAuditLog
- Audit Reports

---

## 🔜 Version 5.0
- Database Triggers

---

## 🔜 Version 6.0
- Python Banking Data Simulator

---

## 🔜 Version 7.0
- Azure SQL Database
- Azure Data Factory

---

## 🔜 Version 8.0
- ADLS Gen2
- Azure Databricks
- Bronze → Silver → Gold

---

## 🔜 Version 9.0
- Azure Synapse Analytics

---

## 🔜 Version 10.0
- Power BI Dashboard

---

# 📚 Documentation

| Document | Description |
|----------|-------------|
| README.md | Project overview |
| CodingStandards.md | Enterprise SQL coding standards |
| Architecture.md | Solution architecture |
| DataDictionary.md | Database object documentation |
| TestingGuide.md | Testing strategy |
| InterviewGuide.md | Frequently asked interview questions |
| Release Notes | Version history |

---

# 🧪 Testing Strategy

Every database object is validated with:

- Positive Test Cases
- Negative Test Cases
- Boundary Value Testing
- Error Handling Validation

---

# 🛡️ Enterprise Development Standards

This project follows enterprise software engineering principles:

- Schema-qualified object names
- Standardized naming conventions
- Primary, Foreign, Unique and Check Constraints
- TRY...CATCH error handling
- Explicit Transactions
- Output Parameters
- Business Rule Validation
- Modular Design
- DRY (Don't Repeat Yourself)
- Git Versioning
- Comprehensive Documentation

---

# 👨‍💻 Author

**Raju Nalla**

Azure Data Engineer

---

# ⭐ Future Enhancements

- CI/CD with Azure DevOps
- Azure Key Vault Integration
- Azure Monitor & Log Analytics
- Delta Lake Optimization
- Slowly Changing Dimensions (SCD)
- Incremental Data Loading
- Power BI Executive Dashboard

---

# 📄 License

This project is intended for educational, portfolio, and demonstration purposes.

---

⭐ If you found this project useful, consider starring the repository and following the development journey.