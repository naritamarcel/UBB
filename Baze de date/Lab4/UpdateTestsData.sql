USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create or ALTER PROCEDURE [dbo].[updateTestData]
	@data_sfarsit datetime
AS
BEGIN
	DECLARE @index int
	exec getLastIndex 'TestRuns', 'TestRunID', @index OUTPUT 
	update TestRuns set EndAt=@data_sfarsit where TestRunID=@index
END