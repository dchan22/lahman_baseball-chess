-- 2. Find the name and height of the shortest player in the database. How many games did he play in? 
-- What is the name of the team for which he played?

SELECT DISTINCT p.namefirst, 
				p.namelast, 
				p.namegiven, 
				p.height, 
				a.playerid, 
				t.name
FROM people AS p 
		LEFT JOIN appearances AS a ON a.playerid = p.playerid
		LEFT JOIN teams AS t ON t.teamid = a.teamid
WHERE height IN(SELECT MIN(height)
				FROM people)
