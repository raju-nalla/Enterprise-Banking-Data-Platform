CREATE OR ALTER TRIGGER trg_Transactions_PreventUpdate
ON transactions.Transactions
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    THROW 51002,
    'Completed transactions cannot be modified.',
    1;
END;
GO