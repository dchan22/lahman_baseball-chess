-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as 
-- well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. 
-- Which Vanderbilt player earned the most money in the majors? David Price, David Taylor

SELECT DISTINCT (sa.playerid), s.schoolname, p.namefirst, p.namelast, p.namegiven,
	   SUM(sa.salary) OVER(PARTITION BY sa.playerid) AS total_salary
FROM schools AS s
	LEFT JOIN collegeplaying AS cp ON cp.schoolid = s.schoolid
	LEFT JOIN people AS p ON p.playerid = cp.playerid
	LEFT JOIN salaries AS sa ON sa.playerid = p.playerid
WHERE schoolname = 'Vanderbilt University'
ORDER BY total_salary DESC;



