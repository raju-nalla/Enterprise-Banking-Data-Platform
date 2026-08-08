DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetAllCustomers

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;


------------------------------------------

DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetAllCustomers

     @IsActive = 0,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

------------------------------------------

DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetAllCustomers

     @IsActive = NULL,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

------------------------------------------

DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetAllCustomers

     @PageNumber = 0,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;

------------------------------------------

DECLARE
    @StatusCode INT,
    @StatusMessage VARCHAR(200);

EXEC dbo.usp_GetAllCustomers

     @PageSize = 0,

     @StatusCode = @StatusCode OUTPUT,
     @StatusMessage = @StatusMessage OUTPUT;

SELECT
    @StatusCode,
    @StatusMessage;