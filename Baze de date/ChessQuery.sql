Create DATABASE Chess;

use Chess;

Create TABLE Player_Rating(
rating_id int,
description varchar(12),
PRIMARY KEY(rating_id)
);

Create TABLE Chess_Club(
club_id int,
clubname varchar(12),
PRIMARY KEY(club_id)
);

Create Table Tournaments(
tournament_id int,
organizer_id int,
t_start_date time,
t_end_date time,
t_name varchar(12),
Primary key(tournament_id)
);

Create TABLE Tournament_Organizer(
organizer_id int,
tournament_id int,
organizer_name varchar(12),
PRIMARY KEY(organizer_id),
Foreign KEY(tournament_id) references Tournaments(tournament_id)
);

Create TAble Sponsors(
sponsor_id int,
sponsor_name varchar(12),
Primary key(sponsor_id)
);

Create table Actual_Tournament_Sponsors(
tournament_id int,
sponsor_id int,
Primary key(sponsor_id,tournament_id),
Foreign KEY(tournament_id) references Tournaments(tournament_id),
Foreign KEY(sponsor_id) references Sponsors(sponsor_id)
);

Create table Players(
player_id int,
club_id int,
rating_id int,
first_name varchar(12),
last_name varchar(12),
email varchar(12),
Foreign KEY(rating_id) references Player_Rating(rating_id),
Foreign KEY(club_id) references Chess_Club(club_id),
Primary key(player_id)
);

Create Table Rounds(
round_id int,
date_s date,
Primary key(round_id)
);

Create Table Tabless(
table_id int,
round_id int,
player_id_white int,
player_id_black int,
result varchar(12),
Foreign KEY(round_id) references Rounds(round_id),
Primary key(table_id , player_id_white, player_id_black)
);

Create table Players_Rounds(
round_id int,
player_id int,
Primary key(round_id,player_id),
Foreign KEY(round_id) references Rounds(round_id),
Foreign KEY(player_id) references Players(player_id)
);

Create table Rankings(
tournament_id int,
player_id int,
score int,
date_s date,
time_s time,
time_e time,
Primary key(tournament_id,player_id),
Foreign KEY(tournament_id) references Tournaments(tournament_id),
Foreign KEY(player_id) references Players(player_id)
);
