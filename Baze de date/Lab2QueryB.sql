use Chess;
/* INSERT */
DElete from Player_Rating;
Insert into Player_Rating(rating_id,description)
Values(1,'Grandmaster');
Insert into Player_Rating(rating_id,description)
Values(2,'Internat');
Insert into Player_Rating(rating_id,description)
Values(3,'FIDE ');
Insert into Player_Rating(rating_id,description)
Values(4,'Candidate ');
Insert into Player_Rating(rating_id,description) 
Values(5,'Class A');
Insert into Player_Rating(rating_id,description)
Values(6,'WCC'); 

Delete from Chess_Club;
Insert into Chess_Club
values(1,'Glasgow');
Insert into Chess_Club
values(2,'Hammersmith ');
Insert into Chess_Club
values(3,'Battersea');
Insert into Chess_Club
values (4,'ForestOD');  
Insert into Chess_Club
values (5,'BlueP');
Insert into Chess_Club
values (6,'ScothClub');
Insert into Chess_Club
values (7,'Arsenal');
Insert into Chess_Club
values (8,'Dirlosss');

Delete from Tournament_Organizer;
insert into Tournament_Organizer
values(1,1,'Fortech');
insert into Tournament_Organizer
values(2,5,'PrimariaD');
insert into Tournament_Organizer
values(3,7,'UBB');
insert into Tournament_Organizer
values(4,5,'Endava');
insert into Tournament_Organizer
values(5,4,'P3R');
insert into Tournament_Organizer
values(1,4,'P3R');

/*Delete from Tournaments;
Insert into Tournaments
values(1,1,'09:00','18:00','Elisabeta');
Insert into Tournaments
values(2,3,'10:00','14:00','SNG');
Insert into Tournaments
values(3,2,'11:00','19:00','Polihroniade');
Insert into Tournaments
values(4,5,'11:00','20:00','WWC');
Insert into Tournaments
values(5,2,'12:00','20:00','Word Cup');
Insert into Tournaments
values(6,1,'13:00','19:00','Tudor P');
Insert into Tournaments
values(7,3,'08:00','11:00','WWD');
Insert into Tournaments
values(8,4,'09:00','16:00','Damian CH');
Insert into Tournaments
values(9,4,'10:00','16:00','Fiesta');

Delete from Sponsors;
insert into Sponsors
values(1,'SoftVision');
insert into Sponsors
values(2,'Aerobs');
insert into Sponsors
values(3,'Pde');
insert into Sponsors
values(4,'Microsoft');
insert into Sponsors
values(5,'Telenav');
insert into Sponsors
values(6,'CLD');
insert into Sponsors
values(7,'Yardi');
insert into Sponsors
values(8,'Soft');*/

Delete from Actual_Tournament_Sponsors;
insert into Actual_Tournament_Sponsors
values(4,3);
insert into Actual_Tournament_Sponsors
values(3,4);
insert into Actual_Tournament_Sponsors
values(2,5);
insert into Actual_Tournament_Sponsors
values(1,6);
/*-------------------------------------------------------------------------------*/
/* Update */
/*-------------------------------------------------------------------------------*/
Update Tournament_Organizer
Set organizer_name = 'P3'
Where organizer_id = 5 and tournament_id = 4;

Update Chess_Club
Set clubname = 'Dirloss'
Where club_id IN (8,12,13);

Update Chess_Club
Set clubname = 'Dirlos'
Where club_id Between 8 and 9;

Update Player_Rating
set description='CandidateC'
where rating_id=4;

Update Player_Rating
set description='CandidateD'
where description LIKE 'Can%';
/*-------------------------------------------------------------------------------*/
/* Delete */
/*-------------------------------------------------------------------------------*/
Delete from Sponsors
Where sponsor_id>7;

Delete from Player_Rating
where description LIKE 'Can%';

/*-------------------------------------------------------------------------------*/
/* Select */
/*-------------------------------------------------------------------------------*/
 
/*__________A. 2 queries with the union operation; use UNION [ALL] and OR;____________*/

--Uneste descrierea cu numele cluburilor de sah
Select description from Player_Rating
Union ALL
Select clubname from Chess_Club
Order by description;

--Afiseaza numele organizatorilor si doar primi doi sponsori
Select organizer_name from Tournament_Organizer
Union ALL
Select sponsor_name from Sponsors where sponsor_id=1 OR sponsor_id=2;


/*___________B. 2 queries with the intersection operation; use INTERSECT and IN;_______________*/

--Afiseara numele si prenumele jucatorului care a fost pe pozitia 2
Select P.first_name, P.last_name
From Players P
where P.player_id in ( Select R.player_id
					   From Rankings R
					   where score = 2)

--Intersecteaza campionatele care incep de la orele 9, 10, 11 dar una dintre ele are numele 'SNG'
Select T.t_start_date,T.t_end_date,T.t_name
From Tournaments T
where T.t_start_date in ('09:00:00','10:00:00','11:00:00')
Intersect
Select TT.t_start_date,TT.t_end_date,TT.t_name
From Tournaments TT
where TT.t_start_date<> (Select C.t_start_date
						From Tournaments C
						where t_name ='SNG')

/*________C. 2 queries with the difference operation; use EXCEPT and NOT IN;________*/

--Afiseara jucatorii care nu am avut loc in top10
Select P.player_id as 'Player Id:',P.first_name as 'Name:'
From Players P
Where P.player_id NOT IN (Select player_id 
							from Rankings
							where score<10)

--Afiseara campionatele care incep de la orele 10 sau 11 cu exceptia carora au literele PO in denumire
Select T.t_start_date AS 'Start time:',T.t_name AS 'Nume:'
From Tournaments T
where T.t_start_date='10:00:00' OR T.t_start_date='11:00:00'
Except
Select TT.t_start_date AS 'Start time:',TT.t_name
From Tournaments TT
where TT.t_start_date<> (Select C.t_start_date
						From Tournaments C
						where t_name like 'Po%')

/*___________d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN; 
---one query will join at least 3 tables, 
---while another one will join at least two many-to-many relationships;_______________*/

/* INNER JOIN -- jucatorii care se gasesc care au fost in top*/
Select P.player_id as 'Player Id:',P.first_name as 'Name:'
From Players P
INNer JOIN Rankings R ON (r.player_id = p.player_id);

/* LEFT JOIN -- jucatorii care au jucat cu piese negre */
Select P.player_id as 'Player Id:',P.last_name as 'Name:', R.result as 'Result', R.player_id_white as 'Adversar'
From Players P
Left JOIN Tabless R ON ( r.player_id_black=p.player_id )
Where r.result='b'

/* RIGHT JOIN --afiseaza numele campionatului alaturi de numele sponsorului unde ora inceperii este dupa 9 */
Select T.t_name as 'Tournament name:',S.sponsor_name as 'Sponsor'
From Tournaments T
Right join Actual_Tournament_Sponsors TS ON (TS.tournament_id = T.tournament_id)
Right join Sponsors S ON (Ts.sponsor_id=S.sponsor_id)

/* FULL JOIN   --toti jucatorii care au fost in top10 */
Select distinct P.player_id as 'Player Id:',P.first_name as 'Name:'
From Players P
Full JOIN Rankings R ON (r.player_id = p.player_id)
Where score<10


/*__________E. 2 queries using the IN operator to introduce a subquery in the WHERE clause;
 in at least one query, the subquery should include a subquery in its own WHERE clause;________________*/

 --jucatorii care au fost in  top10
Select P.player_id as 'Id',P.first_name as 'Name', P.last_name as '   -'
From Players P
Where P.player_id  IN (Select player_id 
							from Rankings 
							where tournament_id <10)


--jucatorii care au fost in top50 dar jucand cu piese negre si castigand
Select TOP 3 P.player_id , P.first_name , P.last_name
From Players P
Where P.player_id  IN (Select  T.player_id_black 
							from Tabless T 
							where T.player_id_white IN (Select player_id 
														from Rankings 
														where score<50  ))

/*__________F. 2 queries using the EXISTS operator to introduce a subquery in the WHERE clause;______________*/

--afiseaza cluburile care au jucatorii inregistrati in tabelul de jucatori
select C.clubname AS 'Club name'
from Chess_Club C
where exists(
	select *
	from Players P
	where P.club_id=C.club_id);


--afiseaza descrierea gradului unui jucator al carui nume incepe cu P
select C.description AS 'Description'
from Player_Rating C
where exists(
	select *
	from Players P
	where P.club_id=C.rating_id) and
	exists( select *
			from Players
			where last_name like 'P%');

/*____________G. 2 queries with a subquery in the FROM clause;______________*/
--afiseara la cate runde a fost un jucator la un campionat
select Distinct *
from (Select P.player_id as 'Player Id:',P.first_name as 'Name:'
		From Players P
		Right Join Players_Rounds PR on(pr.player_id=p.player_id)) rez
order by rez.[Name:];

--Afiseaza toate campionatele care au avut sponsori 
select *
from ( Select T.t_name as 'Tournament name:'
	   From Tournaments T
       Inner join Actual_Tournament_Sponsors TS ON (TS.tournament_id = T.tournament_id))rez
order by rez.[Tournament name:]

/*__________h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
2 of the latter will also have a subquery in the HAVING clause;
 use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;________________*/

/* COUNT */ -- afiseaza jucatorii care se gasesc in lista de top-uri, daca sunt cel putin 1
select P.player_id, P.first_name
from Players P inner join Rankings PC on PC.player_id = P.player_id
group by P.player_id, P.first_name
having count(*)>1

/* SUM */ --numarul  jucatorilor care sunt in lista de top-uri iar prenumele lor contine 'TU'
Select SUM(score) as 'Suma'
From Rankings
Where player_id = (Select player_id
					From Players
					Where first_name LIKE 'Tu%');

/* AVG  */ --Media rankurilor jucatorului care are prenumele 'Na..'
Select AVG(score) as 'Average position for M'
From Rankings
Where player_id = (Select player_id
					From Players
					Where last_name like 'Na%');

/* MIN  */ --Jucatorul care a obtinut cel mai bun scor
Select MIN(score) as 'Best score in Tournament!'
From Rankings

/*__________i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause; 
--2 of them should be rewritten with aggregation operators, 
--while the other 2 should also be expressed with [NOT] IN.________________*/

--afiseaza numele jucatorului care a intrat primul in top3
Select TOP 1 P.first_name as ' First name '
From Players P
where P.player_id = ANY (select player_id 
					   From Rankings
					   where score<4)

--afiseaza numele si prenumele jucatorului care are un rank mai mare decat media rankurilor unde jucatorii sunt in primii 10
Select P.first_name as ' First name ',P.last_name as 'Last name'
From Players P
where P.player_id > ALL (Select player_id
						From Rankings
						where score > (Select AVG(score)
									   From Rankings
									   Where player_id <10))


--afiseaza numele complet jucatorilor care au obtinut un loc sunt sub media rankurilor cautat dupa prenumele acestuia
Select CONCAT(P.first_name, ' ',P.last_name) AS 'Complete name'
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
Group by p.first_name, p.last_name

--afiseara numele complet al jucatorului daca a castigat macar o data!
Select CONCAT(P.first_name, ' ',P.last_name) AS 'Name'
from Players P
where P.player_id = ANY ( Select player_id_white
						  FRom Tabless
						  Where result='w');




--##########################################################################################################################

-------------------------------------BONUS-------------------------------------

--afiseaza numele complet jucatorilor care au obtinut un loc sub media rankurilor cautat dupa prenumele acestui


SELECT DISTINCT       dbo.Players.player_id as 'Player id', dbo.Players.first_name + '  '+ dbo.Players.last_name as 'Complete name', dbo.Rankings.score as 'Position'
FROM            dbo.Chess_Club INNER JOIN
                         dbo.Players ON dbo.Chess_Club.club_id = dbo.Players.club_id INNER JOIN
                         dbo.Player_Rating ON dbo.Players.rating_id = dbo.Player_Rating.rating_id INNER JOIN
                         dbo.Players_Rounds ON dbo.Players.player_id = dbo.Players_Rounds.player_id INNER JOIN
                         dbo.Rankings ON dbo.Players.player_id = dbo.Rankings.player_id INNER JOIN
                         dbo.Rounds ON dbo.Players_Rounds.round_id = dbo.Rounds.round_id INNER JOIN
                         dbo.Tabless ON dbo.Rounds.round_id = dbo.Tabless.round_id INNER JOIN
                         dbo.Tournament_Organizer ON dbo.Rankings.tournament_id = dbo.Tournament_Organizer.tournament_id INNER JOIN
                         dbo.Tournaments ON dbo.Rankings.tournament_id = dbo.Tournaments.tournament_id AND dbo.Tournament_Organizer.tournament_id = dbo.Tournaments.tournament_id CROSS JOIN
                         dbo.Sponsors
where dbo.Players.player_id IN (Select player_id
						From Rankings R
						where score > 
							          (Select AVG(score) as 'Average position'
									   From Rankings
									   Where player_id =
														  (Select player_id
											              From Players
											              Where last_name like 'Nari%'))) 






SELECT  Distinct      dbo.Players.player_id, dbo.Players.first_name, dbo.Players.last_name, dbo.Rankings.score, dbo.Chess_Club.clubname, dbo.Tournaments.t_name
FROM            dbo.Chess_Club INNER JOIN
                         dbo.Players ON dbo.Chess_Club.club_id = dbo.Players.club_id INNER JOIN
                         dbo.Player_Rating ON dbo.Players.rating_id = dbo.Player_Rating.rating_id INNER JOIN
                         dbo.Players_Rounds ON dbo.Players.player_id = dbo.Players_Rounds.player_id INNER JOIN
                         dbo.Rankings ON dbo.Players.player_id = dbo.Rankings.player_id INNER JOIN
                         dbo.Rounds ON dbo.Players_Rounds.round_id = dbo.Rounds.round_id INNER JOIN
                         dbo.Tabless ON dbo.Rounds.round_id = dbo.Tabless.round_id INNER JOIN
                         dbo.Tournament_Organizer ON dbo.Rankings.tournament_id = dbo.Tournament_Organizer.tournament_id INNER JOIN
                         dbo.Tournaments ON dbo.Rankings.tournament_id = dbo.Tournaments.tournament_id AND dbo.Tournament_Organizer.tournament_id = dbo.Tournaments.tournament_id CROSS JOIN
                         dbo.Sponsors




						 
CREATE VIEW [Average PositionG] AS
SELECT  AVG(R.score) [Average] 
FROM Rankings R
--
SELECT    DISTINCT    TOP (100) PERCENT Players.first_name+ '   '+ Players.last_name [Complet name],
									    Chess_Club.clubname [Club],
										Player_Rating.description [Position in word],
									    Tournaments.t_name [Tournament name],
										CONVERT(CHAR(5),Tournaments.t_start_date) AS [Start Time],
									
									
									
							
									
										Rankings.score [Score],
										(  Select * 
										   From [Average PositionG]) 
										   AS [Average position]
FROM  Chess_Club INNER JOIN
                         Players ON Chess_Club.club_id = Players.club_id INNER JOIN
                         Player_Rating ON Players.rating_id = Player_Rating.rating_id INNER JOIN
                         Rankings ON Players.player_id = Rankings.player_id INNER JOIN
                         Tournaments ON Rankings.tournament_id = Tournaments.tournament_id
WHERE Players.player_id IN (SELECT player_id
		       				FROM Rankings R
						    WHERE score > 
							          (SELECT AVG(score) AS 'Average position'
									   FROM Rankings
									   WHERE player_id IN
														  ( SELECT player_id
											                FROM Players
											                WHERE last_name LIKE 'N%'))) 
ORDER BY [Start Time], [Complet name]














Select CONCAT(P.first_name, ' ',P.last_name) AS 'Complete name',
	  /*(Select MAX(rr.score)
	       From Rankings rr
		   Where rr.player_id=P.player_id) as 'Worst result',*/
	   AVG(G.score) as 'Average position'
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
Group by p.first_name, p.last_name




Union
	Select MAX(rr.score) as 'Worst result'
	       From Rankings rr
		   Where rr.player_id = P.player_id  

