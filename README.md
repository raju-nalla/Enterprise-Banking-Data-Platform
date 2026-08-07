# 🏦 Enterprise Banking Data Platform

> An end-to-end Enterprise Banking Data Engineering project built using SQL Server, Azure Data Factory, Azure Databricks, Azure Synapse Analytics, ADLS Gen2, Azure SQL Database, Power BI, and Azure DevOps.

![Project Status](https://img.shields.io/badge/Status-In%20Progress-orange)
![Version](https://img.shields.io/badge/Version-v3.0.0-blue)
![Database](https://img.shields.io/badge/SQL%20Server-2022-red)
![Cloud](https://img.shields.io/badge/Azure-Data%20Engineering-0078D4)

---

# 📌 Project Overview

The Enterprise Banking Data Platform is a production-style Azure Data Engineering project that simulates a real-world banking ecosystem.

The project demonstrates the complete lifecycle of banking data:

- Banking Operations (SQL Server)
- Data Ingestion (Azure Data Factory)
- Data Lake (ADLS Gen2)
- Data Processing (Azure Databricks)
- Data Warehouse (Azure Synapse Analytics)
- Business Intelligence (Power BI)
- CI/CD (GitHub & Azure DevOps)

The objective is to build an enterprise-grade portfolio project while following software engineering and data engineering best practices.

---

# 🏗️ High-Level Architecture

```
Business Applications
        │
        ▼
Azure SQL Database (OLTP)
        │
        ▼
Azure Data Factory
        │
        ▼
ADLS Gen2
(Bronze → Silver → Gold)
        │
        ▼
Azure Databricks
(PySpark + Delta Lake)
        │
        ▼
Azure Synapse Analytics
        │
        ▼
Power BI
```

---

# 🛠️ Technology Stack

| Category | Technology |
|-----------|------------|
| Database | SQL Server 2022 |
| Cloud | Microsoft Azure |
| ETL | Azure Data Factory |
| Storage | ADLS Gen2 |
| Processing | Azure Databricks |
| Language | SQL, Python, PySpark |
| Analytics | Azure Synapse Analytics |
| Visualization | Power BI |
| Version Control | Git & GitHub |
| CI/CD | Azure DevOps |
| Secrets Management | Azure Key Vault |

---

# 📂 Repository Structure

```
Enterprise-Banking-Data-Platform
│
├── docs/
│   ├── architecture/
│   ├── releases/
│   └── design/
│
├── sql/
│   ├── schema/
│   ├── tables/
│   ├── views/
│   ├── functions/
│   ├── procedures/
│   ├── triggers/
│   ├── sample-data/
│   └── test/
│
├── python/
│
├── azure/
│   ├── azure-sql/
│   ├── adf/
│   ├── adls/
│   ├── databricks/
│   ├── synapse/
│   └── key-vault/
│
├── powerbi/
│
└── README.md
```

---

# 🚀 Current Progress

## ✅ Version 1.0 – Database Foundation

- Database Creation
- Schemas
- Core Tables
- Constraints
- Relationships

---

## ✅ Version 2.0 – Reporting Layer

Reporting Views

- vw_CustomerAccounts
- vw_LoanPortfolio
- vw_BranchSummary
- vw_EmployeeHierarchy
- vw_TransactionHistory

---

## ✅ Version 3.0 – Database Programming (Functions)

Implemented Enterprise Scalar Functions

| Function | Description |
|----------|-------------|
| fn_CalculateAge | Calculates customer age |
| fn_CalculateEMI | Calculates loan EMI |
| fn_GetCustomerFullName | Returns customer full name |
| fn_GetAccountBalance | Returns account balance |
| fn_GetLoanOutstanding | Returns outstanding loan amount |

### Features

- Enterprise SQL coding standards
- Header documentation
- Reusable business logic
- Financial calculations
- Unit test scripts

---

# 📅 Upcoming Releases

| Version | Module | Status |
|----------|---------|--------|
| v4.0 | Stored Procedures | 🔄 Next |
| v5.0 | Triggers | ⏳ Planned |
| v6.0 | Python Banking Data Simulator | ⏳ Planned |
| v7.0 | Azure SQL & Data Factory | ⏳ Planned |
| v8.0 | ADLS Gen2 & Databricks | ⏳ Planned |
| v9.0 | Azure Synapse Analytics | ⏳ Planned |
| v10.0 | Power BI Dashboard | ⏳ Planned |

---

# 📊 Database Modules

### Core Tables

- Branches
- Customers
- Accounts
- Employees
- Loans
- Transactions
- AuditLogs

### Reporting Views

- Customer Accounts
- Loan Portfolio
- Branch Summary
- Employee Hierarchy
- Transaction History

### User Defined Functions

- Calculate Age
- Calculate EMI
- Get Customer Full Name
- Get Account Balance
- Get Loan Outstanding

---

# 🎯 Future Enhancements

- Enterprise Stored Procedures
- Database Triggers
- Banking Data Simulator
- Incremental Data Pipelines
- Medallion Architecture
- Delta Lake
- Performance Tuning
- Monitoring & Logging
- CI/CD Pipeline
- Infrastructure as Code (Bicep/Terraform)

---

# 📚 Learning Objectives

This project demonstrates:

- Database Design
- SQL Programming
- Azure Data Engineering
- Data Warehousing
- ETL Development
- Delta Lake
- Cloud Architecture
- Performance Optimization
- Enterprise Coding Standards
- DevOps Practices

---

# 📖 Documentation

Project documentation includes:

- Architecture Diagrams
- Solution Design Document
- Release Notes
- SQL Scripts
- Test Scripts
- Interview Guide

---

# 🤝 Contributing

Suggestions and improvements are welcome.

Feel free to fork the repository, create a feature branch, and submit a pull request.

---

# 📄 License

This project is licensed under the MIT License.

---

## ⭐ Project Status

**Current Version:** **v3.0.0**

**Current Sprint:** Sprint 3 – Database Programming

**Next Milestone:** Enterprise Stored Procedures