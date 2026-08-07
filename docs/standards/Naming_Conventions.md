# Naming Conventions

## Database

EnterpriseBankingDB

---

# Schemas

- core
- hr
- lending
- transactions
- audit
- reporting

---

# Tables

| Schema | Table |
|----------|---------|
| core | Branches |
| core | Customers |
| core | Accounts |
| hr | Employees |
| lending | Loans |
| transactions | Transactions |
| audit | AuditLogs |

---

# Views

- reporting.vw_CustomerAccounts
- reporting.vw_LoanPortfolio
- reporting.vw_BranchSummary
- reporting.vw_EmployeeHierarchy
- reporting.vw_TransactionHistory

---

# Stored Procedures

Examples:

- usp_CreateCustomer
- usp_CreateAccount
- usp_TransferFunds
- usp_ApplyLoan
- usp_ApproveLoan

---

# Functions

Examples:

- fn_CalculateEMI
- fn_CalculateInterest
- fn_GetCustomerAge

---

# File Naming

Examples:

01_Create_Database.sql

02_Create_Schemas.sql

03_Create_Branches.sql

04_Create_Customers.sql

...

Views

01_Create_vw_CustomerAccounts.sql

02_Create_vw_LoanPortfolio.sql

---

# Git Commit Convention

Examples

feat: Add customer reporting views

feat: Create loan approval stored procedures

docs: Update project documentation

fix: Correct foreign key relationship

refactor: Improve reporting views