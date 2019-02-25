USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or ALTER PROCEDURE [dbo].[executaView]
	@nume_view varchar(50)
AS
BEGIN 
	declare @sqlstatement nvarchar(4000)
	set @sqlstatement = 'select * from ' + @nume_view
	exec sp_executesql @sqlstatement
END