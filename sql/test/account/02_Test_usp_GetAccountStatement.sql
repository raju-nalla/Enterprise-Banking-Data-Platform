EXEC dbo.usp_GetAccountStatement
    @AccountID = 2,
    @FromDate = '2026-08-01',
    @ToDate = '2026-08-31';

EXEC dbo.usp_GetAccountStatement
    @AccountID = 999,
    @FromDate = '2026-08-01',
    @ToDate = '2026-08-31';

EXEC dbo.usp_GetAccountStatement
    @AccountID = 2,
    @FromDate = '2026-08-31',
    @ToDate = '2026-08-01';