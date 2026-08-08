DECLARE

    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByCustomerNumber

     @CustomerNumber = 'CUST100001',

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;
    ----------------------------------------


DECLARE

    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByCustomerNumber

     @CustomerNumber = 'CUST999999',

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

-----------------------------------------

DECLARE

    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByCustomerNumber

     @CustomerNumber = 'CUST100007',

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

    -----------------------------------------

    DECLARE

    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetCustomerByCustomerNumber

     @CustomerNumber = '',

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;