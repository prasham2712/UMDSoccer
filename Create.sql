USE BUDT702_Project_0501_13

DROP TABLE IF EXISTS Play
DROP TABLE IF EXISTS Game
DROP TABLE IF EXISTS UmdPlayer
DROP TABLE IF EXISTS UmdTeam
DROP TABLE IF EXISTS Stadium
DROP TABLE IF EXISTS OpponentTeam

CREATE TABLE OpponentTeam (
opponentTeamId CHAR(5) NOT NULL,
opponentTeamName VARCHAR(20) NOT NULL,
CONSTRAINT pk_Team_teamId PRIMARY KEY (opponentTeamId),
)

CREATE TABLE Stadium (
stadiumId CHAR(5) NOT NULL,
stadiumName VARCHAR(30),
stadiumCity VARCHAR(20) NOT NULL,
stadiumState VARCHAR(20) NOT NULL,
CONSTRAINT pk_Stadium_stadiumId PRIMARY KEY (stadiumId)
)

CREATE TABLE UmdTeam (
umdTeamId CHAR(4) NOT NULL,
CONSTRAINT pk_UmdTeam_umdTeamId PRIMARY KEY (umdTeamId)
)

CREATE TABLE UmdPlayer (
umdPlayerId CHAR(6) NOT NULL,
umdPlayerName VARCHAR(50),
umdTeamId CHAR(4) NOT NULL,
CONSTRAINT pk_UmdPlayer_playerId PRIMARY KEY (umdPlayerId),
CONSTRAINT fk_UmdPlayer_umdTeam FOREIGN KEY (umdTeamId)
REFERENCES UmdTeam (umdTeamId)
ON DELETE CASCADE ON UPDATE CASCADE
)


CREATE TABLE Game(
gameId CHAR(6) NOT NULL,
gameScore VARCHAR(10) NOT NULL,
opponentTeamName VARCHAR(20) NOT NULL,
gameDate DATE,
gameAssists VARCHAR(5),
gameShotsOnGoal VARCHAR(5),
gameCorners VARCHAR(5),
gameYellowCards VARCHAR(5),
gameRedCards VARCHAR(5),
stadiumId CHAR(5) NOT NULL,
umdTeamId CHAR(4) NOT NULL,
opponentTeamId CHAR(5) NOT NULL,
CONSTRAINT pk_Game_gameId PRIMARY KEY (gameId),
CONSTRAINT fk_Game_stadiumId FOREIGN KEY (stadiumId)
REFERENCES Stadium (stadiumId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Game_umdTeamId FOREIGN KEY (umdTeamId)
REFERENCES UmdTeam (umdTeamId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_Game_opponentTeamId FOREIGN KEY (opponentTeamId)
REFERENCES OpponentTeam (opponentTeamId)
ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Play(
gameId CHAR(6) NOT NULL,
umdTeamId CHAR(4) NOT NULL,
opponentTeamId CHAR(5) NOT NULL,
CONSTRAINT pk_Play_gameId PRIMARY KEY (gameId),
CONSTRAINT fk_Play_gameId FOREIGN KEY (gameId)
REFERENCES Game (gameId)
ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT fk_Play_umdTeamId FOREIGN KEY (umdTeamId)
REFERENCES umdTeam (umdTeamId)
ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT fk_Play_opponentTeamId FOREIGN KEY (opponentTeamId)
REFERENCES OpponentTeam (opponentTeamId)
ON DELETE NO ACTION ON UPDATE NO ACTION
)
