use Chess;
GO
SET ANSI_NULLS ON -- (1)
GO
SET QUOTED_IDENTIFIER ON -- (2)
GO
--use (1) && (2) for error:[Batch Start Line 0] 'CREATE/ALTER PROCEDURE' must be the first statement in a query batch.
CREATE or alter PROCEDURE [dbo].[deleteData]
    @id_start int,
	@nr_randuri int,
	@nume_tabela varchar(100)
AS 
BEGIN
   While @nr_randuri > 0
   BEGIN
		SET @nr_randuri = @nr_randuri-1
		
		if(@nume_tabela= 'Players' or @nume_tabela= 'Rankings')
			Begin 
			--from Players or Rankings
			DECLARE @query nvarchar(2000)
			set @query = 'delete from ' + @nume_tabela + ' Where player_id= '+ CAST(@id_start AS varchar(10))  
			EXECUTE sp_executesql @query
			End
		Else
			Begin
			--from Player_Rating
			DECLARE @queryy nvarchar(2000)
			set @queryy = 'delete from ' + @nume_tabela + ' Where rating_id= '+ CAST(@id_start AS varchar(10))  
			EXECUTE sp_executesql @queryy
			End
		set @id_start= @id_start+1
   END
END


