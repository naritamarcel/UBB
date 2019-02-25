USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insertData]
	@id_start int,
	@nr_randuri int,
	@nume_tabela varchar(100)
AS
BEGIN
   While @nr_randuri > 0
   BEGIN
		SET @nr_randuri = @nr_randuri-1
		
		if(@nume_tabela= 'Players')
		Begin 
		--in Players
		Insert into Players(player_id,club_id,rating_id,first_name,last_name,email,varsta)
		Values(@id_start,1,1,'First' +Cast(@id_start as varchar(10)),'Last' +Cast(@id_start as varchar(10)),'emailp' +Cast(@id_start as varchar(10)),@id_start)   
		End

		Else
		Begin
			if(@nume_tabela= 'Player_Rating')
			Begin
			--in Player_Rating
			Insert into Player_Rating(rating_id,description)
			Values(@id_start,'Grand' + Cast(@id_start AS varchar(10)));
			End

			Else
			Begin
			--in Rankings
			Insert into Rankings(tournament_id,player_id,score,date_s,time_s)
			Values(1,@id_start,@id_start+@id_start,'2018-09-08','2018-10-08')
			End
		End
		set @id_start= @id_start+1

   END
END

