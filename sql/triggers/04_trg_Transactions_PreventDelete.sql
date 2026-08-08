CREATE OR ALTER TRIGGER trg_Transactions_PreventDelete
ON transactions.Transactions
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    THROW 51001,
    'Transactions cannot be deleted. Contact the database administrator.',
    1;
END;
GO