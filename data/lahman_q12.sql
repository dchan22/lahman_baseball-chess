--Q12 In this question, you will explore the connection between number of wins and attendance.
-- Does there appear to be any correlation between attendance at home games and number of wins? 
-- Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? 
-- Making the playoffs means either being a division winner or a wild card winner.

SELECT *
FROM homegames;

SELECT *
FROM teams


--homegames table
SELECT year AS home_years, team, attendance
FROM homegames
ORDER BY attendance DESC;

--teams table
SELECT yearid AS team_years, w, divwin, wswin, name
FROM teams
WHERE divwin = 'Y'
AND wswin = 'Y'
ORDER BY w DESC; 

--CTEs
WITH attendance_results AS (SELECT year AS home_years, team, attendance
						 FROM homegames
						 ORDER BY attendance DESC)
SELECT yearid AS team_years, w, divwin, wswin, name, attendance
FROM teams
WHERE divwin = 'Y'
AND wswin = 'Y'

ORDER BY w DESC, attendance DESC;


WITH attendance_results AS (SELECT year, team, attendance
						 FROM homegames
						 ORDER BY attendance DESC)
SELECT yearid AS team_years, w, divwin, wswin, name, year, attendance
FROM teams 
WHERE divwin = 'Y'
AND wswin = 'Y'
ORDER BY w DESC;

