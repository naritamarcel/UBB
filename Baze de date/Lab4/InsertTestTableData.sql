USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or ALTER PROCEDURE [dbo].[insertTestTableData]
	@cod_rulare_test int,
	@cod_tabela int,
	@data_inceput datetime
AS
BEGIN
	DECLARE @index int
	exec getLastIndex 'TestRuns', 'TestRunID', @index OUTPUT 
	insert into TestRunTables values(@index, @cod_tabela, @data_inceput, @data_inceput)
END