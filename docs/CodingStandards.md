# Enterprise Banking Data Platform
## SQL Coding Standards

Version: 1.0
Author: Raju Nalla
Project: Enterprise Banking Data Platform

---

# Purpose

This document defines the SQL coding standards followed throughout the Enterprise Banking Data Platform project.

These standards ensure:

- Consistency
- Readability
- Maintainability
- Enterprise-level development practices

All SQL scripts (Tables, Views, Functions, Procedures, Triggers) must follow these standards.

---

# 1. Naming Conventions

## Schemas

| Schema | Purpose |
|---------|----------|
| core | Transactional Tables |
| reporting | Reporting Views |
| audit | Audit Objects |
| dbo | Utility Objects |

Always reference objects using schema names.

Correct

core.Customers

Incorrect

Customers

---

# 2. Object Naming

| Object | Prefix | Example |
|----------|------------|---------------------------|
| Table | None | Customers |
| View | vw_ | vw_CustomerSummary |
| Function | fn_ | fn_CalculateAge |
| Stored Procedure | usp_ | usp_CreateCustomer |
| Trigger | trg_ | trg_Customers_Audit |

---

# 3. Constraint Naming

Primary Key

PK_TableName

Example

PK_Customers

Unique Key

UQ_Table_Column

Example

UQ_Customers_Email

Foreign Key

FK_ChildTable_ParentTable

Example

FK_Accounts_Customers

Check Constraint

CHK_Table_Column

Default Constraint

DF_Table_Column

---

# 4. SQL Formatting

Keywords should be uppercase.

Correct

SELECT
FROM
WHERE
JOIN

Object names should use PascalCase.

Example

CustomerNumber

Indentation

4 spaces.

Each column on a new line.

Example

SELECT
    CustomerID,
    CustomerNumber,
    FirstName
FROM core.Customers;

---

# 5. Stored Procedures

Always use

CREATE OR ALTER PROCEDURE

Always include

SET NOCOUNT ON;

Always use

TRY...CATCH

Use explicit transactions for INSERT/UPDATE/DELETE.

BEGIN TRANSACTION

COMMIT

ROLLBACK

---

# 6. Input Validation

Always validate

Mandatory fields

Duplicate values

Business Rules

Date validations

Never insert invalid data.

---

# 7. String Handling

Trim all string inputs before saving.

Use

LTRIM(RTRIM())

Avoid storing leading or trailing spaces.

---

# 8. Error Handling

Never use PRINT.

Use Output Parameters.

Example

StatusCode

StatusMessage

Use standardized status codes.

0 = Success

1001 = Duplicate Customer

1002 = Duplicate Email

9999 = Unexpected Error

---

# 9. Transactions

Every business procedure must follow

BEGIN TRY

BEGIN TRANSACTION

Business Logic

COMMIT

END TRY

BEGIN CATCH

ROLLBACK

END CATCH

---

# 10. Comments

Every script must contain

Header Block

Business Description

Author

Version

Created Date

Modification History

Logical sections must contain comments.

Example

--------------------------------------------------
-- Validate Customer Number
--------------------------------------------------

---

# 11. Database Objects

Never use

SELECT *

Always specify required columns.

Correct

SELECT
    CustomerID,
    FirstName,
    LastName

Incorrect

SELECT *

---

# 12. Default Values

Business defaults

Should be explicitly assigned by Stored Procedures.

System defaults

Should be handled by SQL Server.

Examples

CreatedDate

ModifiedDate

Identity Columns

---

# 13. Audit Logging

Every INSERT

UPDATE

DELETE

Business Transaction

must be written to

audit.AuditLogs

using

audit.usp_WriteAuditLog

(No duplicate audit code.)

---

# 14. Performance

Avoid unnecessary cursors.

Prefer set-based operations.

Use EXISTS instead of COUNT() for existence checks.

Create indexes where required.

Avoid unnecessary DISTINCT.

Avoid functions inside WHERE clauses.

---

# 15. Security

Never concatenate SQL strings.

Use parameters.

Avoid dynamic SQL unless absolutely required.

Grant minimum permissions.

---

# 16. Testing

Every Stored Procedure

must have

Positive Test Cases

Negative Test Cases

Boundary Test Cases

Error Test Cases

---

# 17. Documentation

Every completed feature must include

SQL Script

Test Script

README Update

Release Notes

Git Commit

---

# 18. Git Standards

One feature per commit.

Meaningful commit messages.

Example

Added usp_CreateCustomer with enterprise validation.

---

# 19. Enterprise Principles

Keep procedures modular.

Avoid duplicate code.

Follow DRY (Don't Repeat Yourself).

Keep business logic inside procedures.

Centralize reusable logic.

Always think about scalability.

---

End of Document