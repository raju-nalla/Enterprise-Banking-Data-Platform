USE [EnterpriseBankingDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Account Management
Object Type  : Stored Procedure
Object Name  : dbo.usp_CreateAccount

Author       : Raju Nalla
Created On   : 11-Aug-2026
Version      : 1.0

Description:
Creates a new customer account.

Business Rules

1. Customer must exist and be active.
2. Branch must exist and be active.
3. Opening balance cannot be negative.
4. Account Type must be SB, CA, FD or RD.
5. Currency must be INR or USD.
6. Account Number is generated automatically.

Return Codes

0       Success
2001    Invalid Customer
2002    Invalid Branch
2003    Invalid Account Type
2004    Invalid Opening Balance
2005    Invalid Currency
9999    Unexpected SQL Error

****************************************************************************************************/

CREATE OR ALTER PROCEDURE dbo.usp_CreateAccount

      @CustomerID       BIGINT
    , @BranchID         INT
    , @AccountType      VARCHAR(20)
    , @OpeningBalance   DECIMAL(18,2)
    , @CurrencyCode     CHAR(3) = 'INR'

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE

      @SequenceValue BIGINT
    , @BranchCode VARCHAR(10)
    , @AccountNumber VARCHAR(30)
    , @AccountID INT

BEGIN TRY

    BEGIN TRANSACTION;

    ------------------------------------------------------------
    -- Validate Opening Balance
    ------------------------------------------------------------

    IF @OpeningBalance < 0
    BEGIN

        SELECT
            NULL AS AccountID,
            NULL AS AccountNumber,
            2004 AS StatusCode,
            'Opening balance cannot be negative.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Account Type
    ------------------------------------------------------------

    IF @AccountType NOT IN ('SB','CA','FD','RD')
    BEGIN

        SELECT
            NULL AS AccountID,
            NULL AS AccountNumber,
            2003 AS StatusCode,
            'Invalid Account Type.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Currency
    ------------------------------------------------------------

    IF @CurrencyCode NOT IN ('INR','USD')
    BEGIN

        SELECT
            NULL AS AccountID,
            NULL AS AccountNumber,
            2005 AS StatusCode,
            'Invalid Currency Code.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Customer
    ------------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM core.Customers
        WHERE CustomerID=@CustomerID
          AND IsActive=1
    )
    BEGIN

        SELECT
            NULL AS AccountID,
            NULL AS AccountNumber,
            2001 AS StatusCode,
            'Customer does not exist or is inactive.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Validate Branch
    ------------------------------------------------------------

    SELECT
        @BranchCode = BranchCode
    FROM core.Branches
    WHERE BranchID=@BranchID
      AND IsActive=1;

    IF @BranchCode IS NULL
    BEGIN

        SELECT
            NULL AS AccountID,
            NULL AS AccountNumber,
            2002 AS StatusCode,
            'Invalid or inactive Branch.' AS StatusMessage;

        RETURN;

    END;

    ------------------------------------------------------------
    -- Generate Account Number
    ------------------------------------------------------------

    SET @SequenceValue = NEXT VALUE FOR core.seq_AccountNumber;

    SET @AccountNumber =
            @AccountType
        + '-'
        + @BranchCode
        + '-'
        + CAST(YEAR(GETDATE()) AS VARCHAR(4))
        + '-'
        + RIGHT('000000' + CAST(@SequenceValue AS VARCHAR(6)),6);

    ------------------------------------------------------------
    -- Create Account
    ------------------------------------------------------------

    INSERT INTO core.Accounts
    (
          AccountNumber
        , CustomerID
        , BranchID
        , AccountType
        , Balance
        , AvailableBalance
        , CurrencyCode
    )
    VALUES
    (
          @AccountNumber
        , @CustomerID
        , @BranchID
        , @AccountType
        , @OpeningBalance
        , @OpeningBalance
        , @CurrencyCode
    );

    SET @AccountID = SCOPE_IDENTITY();

    COMMIT TRANSACTION;

    ------------------------------------------------------------
    -- Success
    ------------------------------------------------------------

    SELECT

          @AccountID AS AccountID
        , @AccountNumber AS AccountNumber
        , @CustomerID AS CustomerID
        , @BranchID AS BranchID
        , @AccountType AS AccountType
        , @OpeningBalance AS OpeningBalance
        , @CurrencyCode AS CurrencyCode
        , 0 AS StatusCode
        , 'Account created successfully.' AS StatusMessage;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SELECT

        NULL AS AccountID,
        NULL AS AccountNumber,
        9999 AS StatusCode,

        CONCAT
        (
            'SQL Error ',
            ERROR_NUMBER(),
            ': ',
            ERROR_MESSAGE()
        ) AS StatusMessage;

END CATCH

END;
GO