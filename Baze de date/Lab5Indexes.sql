Create Database Indexes;
use Indexes;

drop table Tc
drop table Tb
drop table Ta

CREATE TABLE Ta(
	aid int Primary key,
	a2 int UNIQUE,
	randomString varchar(30)
);

CREATE TABLE Tb(
	bid int Primary key,
	b2 int
);

CREATE TABLE  Tc(
	cid int Primary key,
	aid int Foreign key references Ta(aid),
	bid int Foreign key references Tb(bid)
);

Insert into Ta values(1,1,'asda');
Insert into Ta values(3,3,'asda');
Insert into Ta values(4,4,'asda');
Insert into Ta values(5,5,'asda');
Insert into Ta values(6,6,'asda');

Insert into Tb values(1,1);
Insert into Tb values(2,2);
Insert into Tb values(3,3);
Insert into Tb values(4,4);
Insert into Tb values(5,5);
Insert into Tb values(6,6);

Insert into Tc values(1,1,1);
Insert into Tc values(2,2,2);
Insert into Tc values(3,1,2);
Insert into Tc values(4,2,1);
Insert into Tc values(5,3,2);
Insert into Tc values(6,4,2);
Insert into Tc values(7,5,1);
Insert into Tc values(8,4,2);
Insert into Tc values(9,2,2);
--a. Write queries on Ta such that their corresponding execution plans contain the following operators:
--clustered index scan;
select * from Ta

--clustered index seek;
select * from Ta where aid=2

--nonclustered index scan;
create nonclustered index [myIndex] on Ta(a2)
select a2 from Ta

--nonclustered index seek;
select a2 from Ta with (index=myIndex) where a2>2

--key lookup.
select * from Ta  where a2=3
drop index myIndex on Ta
-- b Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
-- Create a nonclustered index that can speed up the query. 
-- Recheck the query’s execution plan (operators, SELECT’s estimated subtree cost)
	
		-- clustered 0.0032886
		select b2 from Tb
		where b2 >=3

	-- nonclustered 0.0032831
		create nonclustered index myIndex on Tb(b2)
		select b2 from Tb
		where b2 >=3

		drop index myIndex on Tb

-- c Create a view that joins at least 2 tables. Check whether existing indexes are helpful; 
-- if not, reassess existing indexes / examine the cardinality of the tables

GO
	create view MyView
	as

	SELECT        dbo.Ta.a2
	FROM          dbo.Ta INNER JOIN
                  dbo.Tc ON dbo.Ta.aid = dbo.Tc.aid and Ta.a2=3

GO
	-- clustered 0.0111683

create nonclustered index [myIndex] on Ta(a2)
select * from MyView
drop index myIndex on Ta
select * from MyView





