/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Reporting Layer
Object Type  : View
Object Name  : reporting.vw_EmployeeHierarchy
File Name    : 04_Create_vw_EmployeeHierarchy.sql

Author       : Raju Nalla
Created On   : 2026-08-07
Version      : 1.0

Description  :
Returns employee hierarchy including manager information,
branch details, department, and employment status.

Business Use :
Used by HR, Branch Managers, Regional Managers,
Power BI dashboards, and organizational reporting.

Dependencies :
- hr.Employees
- core.Branches

Change History
--------------------------------------------------------------------------------
Version | Date       | Author      | Description
--------------------------------------------------------------------------------
1.0     | 2026-08-07 | Raju Nalla  | Initial Creation
******************************************************************************/

USE EnterpriseBankingDB;
GO

CREATE OR ALTER VIEW reporting.vw_EmployeeHierarchy
AS

SELECT

    -------------------------------------------------------------------------
    -- Employee Information
    -------------------------------------------------------------------------
    e.EmployeeID,
    e.EmployeeNumber,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,

    e.JobTitle,
    e.Department,
    e.Email,
    e.PhoneNumber,
    e.HireDate,
    e.EmployeeStatus,

    -------------------------------------------------------------------------
    -- Branch Information
    -------------------------------------------------------------------------
    b.BranchID,
    b.BranchCode,
    b.BranchName,
    b.City,
    b.State,

    -------------------------------------------------------------------------
    -- Manager Information
    -------------------------------------------------------------------------
    m.EmployeeID AS ManagerID,
    m.EmployeeNumber AS ManagerNumber,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,

    -------------------------------------------------------------------------
    -- Audit
    -------------------------------------------------------------------------
    e.CreatedDate,
    e.ModifiedDate

FROM hr.Employees e

INNER JOIN core.Branches b
    ON e.BranchID = b.BranchID

LEFT JOIN hr.Employees m
    ON e.ManagerID = m.EmployeeID;

GO