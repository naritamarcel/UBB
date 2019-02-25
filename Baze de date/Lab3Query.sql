use Chess;

--------------------------Create table for version
CREATE TABLE Database_Version  
	(  
	   Version_ID int IDENTITY (1,1) NOT NULL,
	   current_version int,  
	   CONSTRAINT PK_Version_ID PRIMARY KEY CLUSTERED (Version_ID)  
	); 
Insert into Database_Version Values(0);

----------------------------------------a. modify the type of a column;
GO
CREATE PROCEDURE up1 AS 
BEGIN
	Alter table Tournaments
	Alter column t_end_date char(100);
END; 
GO
--reverse
GO
CREATE PROCEDURE down1 AS 
BEGIN
	Alter table Tournaments
	Alter column t_end_date time;
END; 
GO


----------------------------------------b. add / remove a column;
GO
CREATE PROCEDURE up2 AS 
BEGIN
	Alter table Players
	ADD varsta int
END; 
GO
--reverse
GO
CREATE PROCEDURE down2 AS 
BEGIN
	Alter table Players
	Drop column  varsta; 
END; 
GO


----------------------------------------c. add / remove a DEFAULT constraint;
GO
CREATE PROCEDURE up3 AS 
BEGIN
	Alter table Players
	ADD varsta1 int
	Alter table Players
		ADD Constraint varstadefault
		Default '9' for varsta1
END; 
GO
--reverse
GO
CREATE PROCEDURE down3 AS 
BEGIN
	Alter table Players
	Drop Constraint varstadefault;
	Alter table Players
	Drop column varsta1
END; 
GO

--------------------------------------d. add / remove a primary key;
GO
CREATE PROCEDURE up4 AS 
BEGIN
	CREATE TABLE TransactionH  
	(  
	   TransactionID int  NOT NULL,  
	); 
		ALTER TABLE TransactionH 
		ADD CONSTRAINT PK_Transaction_TransactionID PRIMARY KEY CLUSTERED (TransactionID);
	 
END; 
GO
--reverse.  
GO
CREATE PROCEDURE down4 AS 
BEGIN
	ALTER TABLE TransactionH 
	DROP CONSTRAINT PK_Transaction_TransactionID;  
	Drop Table  TransactionH;
END; 
GO





----------------------------------------e. add / remove a candidate key;
GO
CREATE PROCEDURE up5 AS 
BEGIN
	Create TABLE Player_Ratings(
	rating_id int,
	description varchar(12) NOT NULL,
	CONSTRAINT PK_H PRIMARY KEY (rating_id)
	);

	ALTER TABLE Player_Ratings  
	DROP CONSTRAINT PK_H;
	ALTER TABLE Player_Ratings 
	ADD CONSTRAINT PK_descr PRIMARY KEY CLUSTERED (description); 
END; 
GO

--reverse
GO
CREATE PROCEDURE down5 AS 
BEGIN
	ALTER TABLE Player_Ratings  
	DROP CONSTRAINT PK_descr;

	ALTER TABLE Player_Ratings 
	ADD CONSTRAINT PK_H PRIMARY KEY CLUSTERED (rating_id);
	Drop Table Player_Ratings
END; 
GO




----------------------------------------f. add / remove a foreign key;
GO
CREATE PROCEDURE up6 AS 
BEGIN
	Create TABLE Player_Rank(
	rank_id int,
	descr varchar(12) NOT NULL,
	ratingFK_id int,
	PRIMARY KEY (rank_id)
	);

	Create TABLE Player_Ratings_Good(
		rating_id int,
		description varchar(12) NOT NULL,
		CONSTRAINT PK_H PRIMARY KEY (rating_id)
		);

	Alter Table Player_Rank
	Add constraint PK_F foreign key(ratingFK_id) references Player_Ratings_Good(rating_id);
END; 
GO

--reverse
GO
CREATE PROCEDURE down6 AS 
BEGIN
	Alter table Player_Rank
	Drop constraint PK_f;
	Drop table Player_Ratings_Good;
	Drop table Player_Rank;
END; 
GO


---------------------------------------- g. create / remove a table.

GO
CREATE PROCEDURE up7 AS 
BEGIN
	Create TABLE Player_Ranks(
	rank_id int,
	descr varchar(12) NOT NULL,
	ratingFK_id int,
	PRIMARY KEY (rank_id)
	);
END; 
GO

--reverse
GO
CREATE PROCEDURE down7 AS 
BEGIN
	Drop table Player_Ranks;
END; 
GO