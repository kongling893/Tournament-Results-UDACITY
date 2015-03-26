-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


DROP VIEW IF EXISTS standings;
DROP VIEW IF EXISTS players_wins;
DROP VIEW IF EXISTS players_loses;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS players;

create table players(
	name text,
	ID serial,
	primary key (ID)
);

create table games(
	ID_winner serial references players (ID),
	ID_loser serial references players (ID),
	match_ID serial,
	primary key (match_ID)
);

create view players_loses as
select players.id as ID, COALESCE(count(ID_loser),0) as times
from players LEFT JOIN games
ON players.id = games.ID_loser
group by players.id
order by times DESC;

create view players_wins as
select players.id as ID, COALESCE(count(ID_winner),0) as times
from players LEFT JOIN games
ON players.id = games.ID_winner
group by players.id
order by times DESC;


create view standings as
select players_wins.ID as ID, name, players_wins.times as wins,  players_loses.times+ players_wins.times as matches 
from players, players_loses,  players_wins
where players.ID = players_wins.ID and players_loses.ID = players_wins.ID 
order by wins DESC;

