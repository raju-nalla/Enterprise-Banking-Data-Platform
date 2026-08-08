DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByID

     @CustomerID = 1,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;
-----------------------------------------------
DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByID

     @CustomerID = 9999,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

--------------------------------

DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByID

     @CustomerID = 2,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;