--CTRL+A F5 :)
use Chess; 

/*_______________Bonus point______________
	This query displays the data of a player searching by his name and club name.
Among the details shown there are the average of his results and the date of the first time he attended the chess championships.
Along with the average of the results of the other members of that club, with and without this player.
*/

DECLARE @name varchar(6) = 'Narita';
DECLARE @clubname varchar(7) = 'Glasgow';

SELECT  TOP (1)PERCENT
								Players.first_name+ '   '+ Players.last_name [Complete name],
								Chess_Club.clubname [Club name],
								Player_Rating.description [Ranking],
								Tournaments.t_name [Tournament name],
								CONVERT(CHAR(2),Tournaments.t_start_date) AS [Starting date],
								(  SELECT  AVG(R.score) [Average score of the player] 
                                   FROM Rankings R
								   WHERE R.player_id =( SELECT player_id
											            FROM Players
											            WHERE last_name = @name)) 
										AS [Average score of the player],
								(  SELECT  AVG(R.score) [Score average] 
                                   FROM Rankings R
								   WHERE R.player_id IN ( SELECT player_id
											              FROM Players
											              WHERE club_id =( SELECT club_id
																		   FROM Chess_Club
															               WHERE clubname = @clubname)) AND R.player_id != ( SELECT player_id
																										                 	  FROM Players
																											                  WHERE last_name = @name)) 
										AS [Average club score without the player],
								(  SELECT  AVG(R.score) [Score average] 
                                   FROM Rankings R
								   WHERE R.player_id IN ( SELECT player_id
											              FROM Players
											              WHERE club_id =( SELECT club_id
															       		   FROM Chess_Club
																		   WHERE clubname = @clubname))) 
										AS [Average club score with the player]
									
FROM  Chess_Club INNER JOIN
                         Players ON Chess_Club.club_id = Players.club_id INNER JOIN
                         Player_Rating ON Players.rating_id = Player_Rating.rating_id INNER JOIN
                         Rankings ON Players.player_id = Rankings.player_id INNER JOIN
                         Tournaments ON Rankings.tournament_id = Tournaments.tournament_id

WHERE Players.player_id = (SELECT player_id
						   FROM Players
						   WHERE last_name = @name) AND Players.club_id = (SELECT club_id
																		   FROM Chess_Club		
																		   WHERE clubname = @clubname)

ORDER BY [Starting date], [Complete name]