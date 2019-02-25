USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or ALTER procedure [dbo].[selectData]
	@nume_view varchar(20)
AS
BEGIN
	DECLARE @query varchar(2000)
	set @query = 'select * from ' + @nume_view
	exec @query
END