
USE BUDT702_Project_0501_13

--What are the total number of games played in each year?
SELECT ut.umdTeamId AS 'Game Year', COUNT(pl.gameId) AS 'Number of Games Played'
FROM Play pl
JOIN UmdTeam ut ON pl.umdTeamId = ut.umdTeamId
GROUP BY ut.umdTeamId;

--What are the total number of wins and number of losses per year for the UMD team?
SELECT
    YEAR(g.gameDate) AS 'Game Year',
    SUM(CASE
            WHEN CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) >
                 CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT)
            THEN 1 ELSE 0
        END) AS 'Total Wins',
    SUM(CASE
            WHEN CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) <
                 CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT)
            THEN 1 ELSE 0
        END) AS 'Total Loss',
	SUM(CASE
            WHEN CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) =
                 CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT)
            THEN 1 ELSE 0
        END) AS 'Total Ties'
FROM Game g
GROUP BY YEAR(g.gameDate)
ORDER BY [Game Year];

-- How many games were won,loss and tied at different stadiums?
SELECT 
	s.stadiumId,
    s.stadiumName,
    SUM(CASE 
            WHEN CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) > 
                 CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT) THEN 1
            ELSE 0
        END) AS 'Total Wins',
    SUM(CASE 
            WHEN CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) < 
                 CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT) THEN 1
            ELSE 0
        END) AS 'Total loss',
	SUM(CASE 
            WHEN CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) = 
                 CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT) THEN 1
            ELSE 0
        END) AS 'Total Ties'
FROM Game g
JOIN Stadium s ON g.stadiumId = s.stadiumId
GROUP BY s.stadiumId, stadiumName

-- Which games had a high number of yellow or red cards?
SELECT g.gameId, g.opponentTeamName, g.gameDate, g.gameYellowCards, g.gameRedCards
FROM Game g
WHERE 
    TRY_CAST(g.gameYellowCards AS INT) = 1 OR TRY_CAST(g.gameRedCards AS INT) > 0
ORDER BY g.gameDate;

-- Which opponent teams have frequently neaten UMD Team?
SELECT g.opponentTeamName AS 'Opponent Team Name', COUNT(*) AS 'Number of Losses'
FROM Game g
WHERE 
    CAST(SUBSTRING(g.gameScore, 1, CHARINDEX('-', g.gameScore) - 1) AS INT) < 
    CAST(SUBSTRING(g.gameScore, CHARINDEX('-', g.gameScore) + 1, LEN(g.gameScore)) AS INT)
GROUP BY g.opponentTeamName
ORDER BY 'Number of Losses' DESC;

-- How was the performance of UMDTeam against opponents with consistently strong defensive records?
SELECT g.opponentTeamName AS 'Opponent Team Name', COUNT(*) AS 'Number of games UMDTeam Failed To Score'
FROM Game g
WHERE 
    CAST(SUBSTRING(g.gameScore, 1, CHARINDEX('-', g.gameScore) - 1) AS INT) = 0
GROUP BY g.opponentTeamName
ORDER BY 'Number of games UMDTeam Failed To Score' DESC;


--Which were the games where the UMDTeam had high offensive output but still lost?
SELECT g.gameId AS 'Game Id', g.opponentTeamName AS 'Opponent Team Name', g.gameScore AS 'Game Score', g.gameShotsOnGoal AS 'Shots on Goal', g.gameAssists AS 'Game Assists'
FROM Game g
WHERE 
    ABS(TRY_CAST(SUBSTRING(g.gameScore, 1, CHARINDEX('-', g.gameScore) - 1) AS INT) 
        - TRY_CAST(SUBSTRING(g.gameScore, CHARINDEX('-', g.gameScore) + 1, LEN(g.gameScore)) AS INT)) = 1
    AND TRY_CAST(SUBSTRING(g.gameScore, 1, CHARINDEX('-', g.gameScore) - 1) AS INT) < 
        TRY_CAST(SUBSTRING(g.gameScore, CHARINDEX('-', g.gameScore) + 1, LEN(g.gameScore)) AS INT)
		ORDER BY g.gameId DESC;

-- Which were the matches that were extremely close in terms of score? (Focus on games where the difference in score was only 1 goal, indicating close games)
SELECT g.gameId AS 'Game Id', g.opponentTeamName AS 'Opponent Team Name', g.gameDate AS 'Game Date', g.gameScore AS 'Game Score'
FROM Game g
WHERE ABS(TRY_CAST(LEFT(g.gameScore, CHARINDEX('-', g.gameScore) - 1) AS INT) - 
          TRY_CAST(RIGHT(g.gameScore, LEN(g.gameScore) - CHARINDEX('-', g.gameScore)) AS INT)) = 1
ORDER BY g.gameDate DESC;

-- Which games had the poorest discipline i.e. many yellow or red cards?
SELECT *
FROM GameResultsView
WHERE [Yellow Cards] <> '0/0' OR [Red Cards] <> '0/0'
ORDER BY [Game Date];

