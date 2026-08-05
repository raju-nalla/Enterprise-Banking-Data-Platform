# Solution Design Document (SDD)

## Project Name

Enterprise Banking Data Platform using Azure Synapse & Azure Databricks

---

# Version

1.0

---

# Project Overview

The Enterprise Banking Data Platform is designed to modernize banking analytics by integrating data from multiple operational systems into a centralized cloud-based platform using Microsoft Azure.

The platform will ingest structured and semi-structured data, apply enterprise-grade transformations, implement a Medallion Architecture, and provide trusted datasets for reporting and analytics.

---

# Business Problem

The bank currently relies on multiple disconnected operational systems that generate inconsistent reports, duplicated data, and slow analytics.

Business users require a scalable, secure, and reliable data platform capable of processing enterprise-scale banking data.

---

# Business Objectives

* Modernize legacy reporting.
* Centralize enterprise data.
* Improve reporting performance.
* Enable scalable analytics.
* Improve data quality.
* Support future real-time analytics.
* Implement enterprise security.
* Reduce operational complexity.

---

# Project Scope

## In Scope

* Azure SQL Database
* Azure Synapse Analytics
* Azure Databricks
* ADLS Gen2
* Azure Key Vault
* Azure Monitor
* Power BI
* Python Banking Data Simulator

## Out of Scope

* Mobile Banking Application
* Internet Banking UI
* Customer Authentication
* Payment Gateway Development
* Machine Learning Models (Future Enhancement)

---

# Technology Stack

| Layer         | Technology                                           |
| ------------- | ---------------------------------------------------- |
| Source        | Azure SQL Database, REST APIs, CSV, Excel, JSON, XML |
| Storage       | ADLS Gen2                                            |
| Processing    | Azure Databricks                                     |
| Orchestration | Azure Synapse Pipelines                              |
| Serving       | Synapse SQL, Power BI                                |
| Security      | Key Vault, Managed Identity, RBAC                    |
| Monitoring    | Azure Monitor, Log Analytics                         |

---

# Current Status

Sprint 0 – Project Foundation

Status: In Progress
