use Chess;

Create view OneTable
AS
Select * From Players P
Where P.last_name LIKE 'P'


Create view TwoTables
AS
/*--toti jucatorii care au fost in top10 */
Select distinct P.player_id as 'Player Id:',P.first_name as 'Name:'
From Players P
Full JOIN Rankings R ON (r.player_id = p.player_id)
Where score<10


Create view GroupByView
AS
Select CONCAT(P.first_name,'  ',P.last_name) AS 'Complete name', P.email, P.rating_id
From Players P, Rankings G
where P.player_id IN (Select player_id
						From Rankings R
						where score > 
							          (Select AVG(score) as 'Average position'
									   From Rankings
									   Where player_id =
														  (Select player_id
											              From Players
											              Where last_name like 'Nari%'))) 
Group by p.first_name, p.last_name,P.email,P.rating_id
