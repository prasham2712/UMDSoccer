USE BUDT702_Project_0501_13

-- Game results view with stadium name and game result
DROP VIEW IF EXISTS GameResultsView;
GO
CREATE VIEW GameResultsView AS 
SELECT
   g.gameScore AS 'Game Score', 
    CASE
        WHEN CAST(SUBSTRING(g.gameScore, 1, CHARINDEX('-', g.gameScore) - 1) AS INT) >
             CAST(SUBSTRING(g.gameScore, CHARINDEX('-', g.gameScore) + 1, LEN(g.gameScore)) AS INT)
        THEN 'Win'
        WHEN CAST(SUBSTRING(g.gameScore, 1, CHARINDEX('-', g.gameScore) - 1) AS INT) <
             CAST(SUBSTRING(g.gameScore, CHARINDEX('-', g.gameScore) + 1, LEN(g.gameScore)) AS INT)
        THEN 'Loss'
        ELSE 'Tie'
    END AS 'Game Result',
	CASE
        WHEN g.stadiumId = '10001' 
		THEN 'Home'
        ELSE 'Away'
    END AS 'Location',
	g.opponentTeamName AS 'Opponent',
	g.gameDate AS 'Game Date',
	g.gameAssists AS 'Assists',
	g.gameShotsOnGoal AS 'Shots On Goal',
	g.gameCorners AS 'Corners',
	g.gameYellowCards AS 'Yellow Cards',
	g.gameRedCards AS 'Red Cards',
	s.stadiumName As 'Stadium Name'
FROM Game g JOIN Stadium s
ON g.stadiumId = s.stadiumId



