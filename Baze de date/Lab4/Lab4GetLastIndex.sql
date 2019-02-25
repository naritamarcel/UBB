USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or alter PROCEDURE [dbo].[getLastIndex]
	@nume_tabela varchar(50),
	@nume_coloana varchar(50),
	@index int OUTPUT
AS
BEGIN
	
	declare @sqlstatement nvarchar(4000)

	set @sqlstatement = 'DECLARE index_cursor CURSOR FOR SELECT ' + @nume_coloana +' FROM ' + @nume_tabela

	exec sp_executesql @sqlstatement


	OPEN index_cursor

	FETCH NEXT FROM index_cursor INTO @index

		WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH NEXT FROM index_cursor INTO @index
		END
	CLOSE index_cursor
	DEALLOCATE index_cursor
END