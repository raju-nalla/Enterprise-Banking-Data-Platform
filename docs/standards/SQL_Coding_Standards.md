# SQL Coding Standards

## Purpose

This document defines the SQL coding standards followed throughout the Enterprise Banking Data Platform project.

---

# General Guidelines

- Use uppercase SQL keywords.
- Use meaningful object names.
- Always specify schema names.
- Use consistent indentation.
- Group related columns together.
- Name all constraints explicitly.

---

# Naming Standards

| Object | Convention | Example |
|---------|------------|---------|
| Table | PascalCase | Customers |
| View | vw_ObjectName | vw_CustomerAccounts |
| Stored Procedure | usp_ActionObject | usp_CreateCustomer |
| Function | fn_Action | fn_CalculateEMI |
| Trigger | trg_Table_Action | trg_Accounts_Insert |

---

# SQL Formatting

## Keywords

```sql
SELECT
FROM
INNER JOIN
LEFT JOIN
WHERE
GROUP BY
ORDER BY
```

---

## Aliases

| Table | Alias |
|---------|-------|
| Customers | c |
| Accounts | a |
| Branches | b |
| Employees | e |
| Loans | l |
| Transactions | t |

---

# Constraint Naming

| Constraint | Convention |
|------------|------------|
| Primary Key | PK_Table |
| Foreign Key | FK_Table_Reference |
| Unique | UQ_Table_Column |
| Check | CHK_Table_Column |
| Default | DF_Table_Column |

---

# Audit Columns

Every table should include:

- CreatedDate
- ModifiedDate
- IsActive

---

# Enterprise Principles

- No SELECT *
- Always specify schemas
- Use CREATE OR ALTER for programmable objects
- Prefer DATETIME2 over DATETIME
- Keep SQL readable and maintainable