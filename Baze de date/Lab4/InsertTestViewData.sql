USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create or ALTER PROCEDURE [dbo].[insertTestViewData]
	@cod_rulare_test int,
	@cod_view int,
	@data_inceput datetime
AS
BEGIN
	DECLARE @index int
	exec getLastIndex 'TestRuns', 'TestRunID', @index OUTPUT 
	insert into TestRunViews values(@index, @cod_view, @data_inceput, @data_inceput)
END
