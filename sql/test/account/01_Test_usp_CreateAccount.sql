EXEC dbo.usp_CreateAccount
     @CustomerID = 1,
     @BranchID = 1,
     @AccountType = 'SB',
     @OpeningBalance = 10000,
     @CurrencyCode = 'INR';


          SELECT
    AccountID,
    AccountNumber,
    CustomerID,
    BranchID,
    AccountType,
    Balance,
    AvailableBalance,
    CurrencyCode,
    AccountStatus,
    OpenDate
FROM core.Accounts
ORDER BY AccountID DESC;