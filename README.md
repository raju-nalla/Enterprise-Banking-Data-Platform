# 🏦 Enterprise Banking Data Platform

> An end-to-end Azure Data Engineering project that simulates a production-grade banking platform using SQL Server, Azure Data Factory, Azure Databricks, Azure Synapse Analytics, ADLS Gen2, Delta Lake, and Power BI.

---

# 📌 Project Overview

This project demonstrates how a modern enterprise banking data platform is designed, built, and deployed using Microsoft Azure services and industry best practices.

The solution covers the complete data engineering lifecycle:

- Database Design
- Data Generation
- Data Ingestion
- Data Transformation
- Medallion Architecture
- Data Warehousing
- Analytics
- Monitoring
- CI/CD

---

# 🏗️ Solution Architecture

![Architecture](docs/architecture/Enterprise%20Banking%20Data%20Platform%20Architecture.png)

---

# 🚀 Technology Stack

| Category | Technologies |
|-----------|--------------|
| Database | SQL Server, Azure SQL Database |
| Data Integration | Azure Data Factory / Azure Synapse Pipelines |
| Data Lake | Azure Data Lake Storage Gen2 |
| Processing | Azure Databricks, PySpark |
| Storage Format | Delta Lake |
| Analytics | Azure Synapse Analytics |
| Reporting | Power BI |
| Programming | SQL, Python, PySpark |
| DevOps | Git, GitHub, Azure DevOps |
| Security | Azure Key Vault, Managed Identity, RBAC |

---

# 📂 Project Structure

```text
Enterprise-Banking-Data-Platform/
│
├── docs/
│   ├── architecture/
│   ├── design/
│   └── screenshots/
│
├── sql/
│   ├── schema/
│   ├── procedures/
│   ├── functions/
│   ├── views/
│   ├── scripts/
│   └── sample-data/
│
├── data/
│   ├── raw/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── databricks/
│
├── synapse/
│
├── adf/
│
├── powerbi/
│
├── infrastructure/
│
├── terraform/
│
└── README.md
```

---

# 📊 Banking Database Design

### Schemas

- core
- hr
- lending
- transactions
- audit

---

## Tables

| Schema | Table | Status |
|----------|---------|--------|
| core | Branches | ✅ |
| core | Customers | ✅ |
| core | Accounts | ✅ |
| hr | Employees | ✅ |
| lending | Loans | ✅ |
| transactions | Transactions | ✅ |
| audit | AuditLogs | ✅ |

---

# 🔗 Database Relationships

```text
                             Branches
                            /        \
                           /          \
                          ▼            ▼
                  Customers      Employees
                       │              ▲
                       ▼              │
                   Accounts           │
                       │              │
                       └──────┬───────┘
                              ▼
                            Loans
                              │
                              ▼
                        Transactions

AuditLogs
   │
   └── Tracks all business events
```

---

# ✅ Features Implemented

## Database

- Enterprise Database Design
- Normalized Relational Model
- Multiple Schemas
- Business Keys
- Surrogate Keys
- Self-Referencing Foreign Keys

---

## Constraints

- Primary Keys
- Foreign Keys
- Unique Constraints
- Check Constraints
- Default Constraints

---

## Enterprise Features

- Audit Columns
- Soft Delete Pattern
- Enterprise Naming Standards
- Business Validation Rules
- Referential Integrity
- Performance Indexing

---

# 🚧 Current Progress

| Sprint | Status |
|----------|--------|
| Sprint 0 – Project Foundation | ✅ Completed |
| Sprint 1 – Banking Database Design | ✅ Completed |
| Sprint 2 – Stored Procedures & Business Logic | 🔄 In Progress |
| Sprint 3 – Sample Data Generation | ⏳ Pending |
| Sprint 4 – Azure SQL & ADLS | ⏳ Pending |
| Sprint 5 – Synapse Pipelines | ⏳ Pending |
| Sprint 6 – Bronze Layer | ⏳ Pending |
| Sprint 7 – Silver Layer | ⏳ Pending |
| Sprint 8 – Gold Layer | ⏳ Pending |
| Sprint 9 – Power BI | ⏳ Pending |
| Sprint 10 – CI/CD | ⏳ Pending |

---

# 📋 Next Milestones

- Stored Procedures
- Views
- Functions
- Sample Data Generator (Python + Faker)
- Azure SQL Database
- Azure Data Factory
- Azure Databricks
- Azure Synapse Analytics
- Delta Lake
- Power BI Dashboards

---

# 🎯 Learning Objectives

This project demonstrates:

- SQL Server Database Design
- Enterprise Data Modeling
- Azure Data Engineering
- Data Warehousing
- ETL / ELT Design
- Medallion Architecture
- Delta Lake
- PySpark
- Azure Synapse
- Performance Optimization
- CI/CD
- Production Best Practices

---

# 📜 License

This project is created for learning, portfolio, and interview preparation purposes.