EXEC dbo.usp_BranchDailySummary
    @BranchID = 1,
    @BusinessDate = '2026-08-08';

EXEC dbo.usp_BranchDailySummary
    @BranchID = 999,
    @BusinessDate = '2026-08-08';