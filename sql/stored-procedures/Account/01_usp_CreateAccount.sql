/*
===============================================================================
Object Name : dbo.usp_CreateAccount
Description : Creates a new customer account in the Core Banking System.
Author      : Raju Nalla
Project     : Enterprise Banking Data Platform
Sprint      : Sprint 1 - Banking Database Design
Module      : Account Management
===============================================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_CreateAccount
(
      @CustomerID       INT
    , @BranchID         INT
    , @AccountType      VARCHAR(20)
    , @OpeningBalance   DECIMAL(18,2)
    , @CurrencyCode     CHAR(3) = 'INR'
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
          @SequenceValue BIGINT
        , @BranchCode    VARCHAR(10)
        , @AccountNumber VARCHAR(20)
        , @AccountID     INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        ------------------------------------------------------------
        -- Input Validation
        ------------------------------------------------------------

        IF @OpeningBalance < 0
            THROW 50001, 'Opening balance cannot be negative.', 1;

        IF @AccountType NOT IN ('SB','CA')
            THROW 50002, 'Invalid Account Type. Allowed values are SB or CA.', 1;

        ------------------------------------------------------------
        -- Validate Customer
        ------------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM core.Customers
            WHERE CustomerID = @CustomerID
              AND IsActive = 1
        )
        BEGIN
            THROW 50003, 'Customer does not exist or is inactive.', 1;
        END

        ------------------------------------------------------------
        -- Validate Branch
        ------------------------------------------------------------

        SELECT
            @BranchCode = BranchCode
        FROM core.Branches
        WHERE BranchID = @BranchID
          AND IsActive = 1;

        IF @BranchCode IS NULL
        BEGIN
            THROW 50004, 'Invalid or inactive Branch.', 1;
        END

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
        -- Insert Account
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
        -- Return Result
        ------------------------------------------------------------

        SELECT
              @AccountID      AS AccountID
            , @AccountNumber  AS AccountNumber
            , 'Account created successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END
GO