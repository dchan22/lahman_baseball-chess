-- LAHMAN BASEBALL PROJECT, TEAM CHESS


-- 1. What range of years for baseball games played does the provided database cover? 
-- MIN: 1871, MAX: 2016
SELECT 
	MIN(yearid),
	MAX(yearid)
FROM batting;


-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
-- A: Eddie Gaedel, played in 1 game for STL browns
SELECT DISTINCT p.namefirst, 
				p.namelast, 
				p.namegiven, 
				p.height,  
				a.g_all AS total_games_played,
				t.name			
FROM people AS p 
		LEFT JOIN appearances AS a ON a.playerid = p.playerid
		LEFT JOIN teams AS t ON t.teamid = a.teamid
WHERE height IN(SELECT MIN(height)
				FROM people);


-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they 
-- earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors? 
-- A: David Taylor Price
SELECT DISTINCT (sa.playerid), s.schoolname, p.namefirst, p.namelast, p.namegiven,
	   SUM(sa.salary::numeric::money) OVER(PARTITION BY sa.playerid) AS total_salary
FROM schools AS s
	LEFT JOIN collegeplaying AS cp ON cp.schoolid = s.schoolid
	LEFT JOIN people AS p ON p.playerid = cp.playerid
	LEFT JOIN salaries AS sa ON sa.playerid = p.playerid
WHERE schoolname = 'Vanderbilt University'
ORDER BY total_salary DESC NULLS LAST;


-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", 
-- those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
-- Determine the number of putouts made by each of these three groups in 2016.
SELECT position, 
	   COUNT(position) AS sum_of_positions_2016, 
	   COUNT(po) AS total_po_2016
FROM (SELECT yearid, pos, po,
	  		CASE WHEN pos = 'OF' THEN 'Outfield'
		 	 	WHEN pos = 'SS' THEN 'Infield'
			 	WHEN pos = '1B' THEN 'Infield'
			 	WHEN pos = '2B' THEN 'Infield'
			 	WHEN pos = '3B' THEN 'Infield'
			 	WHEN pos = 'P' THEN 'Battery'
		  	 	WHEN pos = 'C' THEN 'Battery'
		 	 	END AS position
	  FROM fielding
	  WHERE yearid = '2016') AS positions_po
GROUP BY position; 


-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places.
-- Do the same for home runs per game. Do you see any trends? INC as the years go (steriod use increased)
WITH decades AS
			(SELECT yearid, so, hr, g,
	         CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
		          WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
		          WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
		          WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
		          WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
		          WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
		          WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
		          WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
		          WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
		          ELSE '2010s' END AS decade
             FROM teams
             WHERE yearid >= 1920)
SELECT decade,
       ROUND(SUM(so::numeric)/sum(g), 2) AS avg_so_per_game,
	   ROUND(SUM(hr::numeric)/sum(g), 2) AS avg_hr_per_game
FROM decades	   
GROUP BY decade
ORDER BY decade; 


-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of
-- stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.)
-- Consider only players who attempted _at least_ 20 stolen bases.

-- SELECT *
-- FROM batting
	
-- SELECT namefirst,
--        namelast,
-- 	   CONCAT(ROUND((sb::numeric / (sb::numeric + cs::numeric)) * 100, 2), '%') AS successful_sb_percentage
-- FROM batting
-- 	   LEFT JOIN people
-- 	   USING(playerid)
-- 	   WHERE yearid = 2016
-- 	   AND (sb + cs) > 20
-- ORDER BY successful_sb_percentage DESC
-- LIMIT 1;

SELECT CONCAT(namefirst, ' ', namelast) AS player_name,
	   CONCAT(ROUND((sb::numeric / (sb::numeric + cs::numeric)) * 100, 2), '%') AS successful_sb_percentage
FROM batting
	   LEFT JOIN people
	   USING(playerid)
	   WHERE yearid = 2016
	   AND (sb + cs) > 20
ORDER BY successful_sb_percentage DESC
LIMIT 1;

-- 7a. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?
-- 7b. What is the smallest number of wins for a team that did win the world series? Doing this will probably
--     result in an unusually small number of wins for a world series champion – determine why this is the case.
-- 7c. Then redo your query, excluding the problem year.
-- 7d. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?
-- 7e. What percentage of the time?

-- 7a. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?
SELECT teamid, yearid, w, wswin
FROM teams
WHERE yearid >= 1970
      AND wswin = 'N'
ORDER BY w DESC
LIMIT 1;
-- 7a. answer: SEA 201 116 wins and no world series win


-- 7b. What is the smallest number of wins for a team that did win the world series? Doing this will probably
--    result in an unusually small number of wins for a world series champion – determine why this is the case.
SELECT teamid, yearid, w, wswin
FROM teams
WHERE yearid >= 1970
AND wswin = 'Y'
ORDER BY w ASC
LIMIT 1;
-- 7b. answer: LAN 1981 63 wins and world series win

/* In 1981 there was a strike from june 12- july-31 over free agent compensation resulting in the season being cut in half 
and several teams missing out on playoff berths 
(https://www.usatoday.com/story/sports/mlb/2020/03/15/1981-mlb-season-coronavirus-delay-baseball/5054780002/)*/

-- 7c. Then redo your query, excluding the problem year.
SELECT teamid, yearid, w, wswin
FROM teams 
WHERE yearid <> 1981
AND yearid >= 1970
AND wswin = 'Y'
ORDER BY w ASC
LIMIT 1;
-- 7c. answer: SLN 2006 83 wins and a world series win


-- 7d. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?
-- There are two queries for 7d, with and without an INNER JOIN, each arriving at the same result.
--WITHOUT inner join
WITH win_percentage AS (SELECT yearid, name, wswin, 
	                   (CASE WHEN w = MAX(w) OVER(PARTITION BY yearid)
						AND wswin = 'Y' THEN 1 ELSE 0 END) AS max_wins
			            FROM teams
			            WHERE yearid >= 1970 AND yearid <> 1981)
SELECT --Round(SUM(max_wins)::decimal / COUNT(wswin) * 100, 1) AS max_win_perc
	         SUM(max_wins) AS most_wins
FROM win_percentage
WHERE wswin = 'Y';

--WITH inner join
SELECT COUNT(*) AS most_wins
FROM (SELECT MAX (w) AS max_w, yearid
      FROM teams
	  WHERE yearid >= 1970
	  GROUP BY teams.yearid
	  ORDER BY yearid DESC) AS max_wins
INNER JOIN teams ON teams.yearid = max_wins.yearid AND max_wins.max_w = teams.w
WHERE teams.yearid >= 1970
AND wswin = 'Y';

/* 7d answer: 12 (year 1994 has no world series winner due to another strike over a salery cap 
the last pat of the regualr season and the post season was cancelled)*/

-- 7e. (How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?)
-- What percentage of the time?
WITH win_percentage AS (SELECT yearid, name, wswin, 
	                   (CASE WHEN w = MAX(w) OVER(PARTITION BY yearid)
						AND wswin = 'Y' THEN 1 ELSE 0 END) AS max_wins
			            FROM teams
			            WHERE yearid >= 1970 AND yearid <> 1981)
SELECT CONCAT(Round(SUM(max_wins)::decimal / COUNT(wswin)*100,1),'%') AS max_win_perc,
	         SUM(max_wins) AS most_wins
FROM win_percentage
WHERE wswin = 'Y';


-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 
-- (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. 
-- Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
--Top 5
SELECT team, park, attendance / games AS avg_attendance
FROM homegames
WHERE year = '2016' AND games >= '10'
GROUP BY team, park, avg_attendance
ORDER BY avg_attendance DESC
LIMIT 5;

SELECT team, park_name, year, games, attendance / games as average_attendance
FROM homegames as h
		INNER JOIN parks as p
		ON h.park = p.park
WHERE year = 2016
      and games >= 10
ORDER BY average_attendance DESC
LIMIT 5;

-- Lowest 5
SELECT team, park, attendance / games AS avg_attendance
FROM homegames
WHERE year = '2016' AND games >= '10'
GROUP BY team, park, avg_attendance
ORDER BY avg_attendance
LIMIT 5;

SELECT team, park_name, year, games, attendance / games as average_attendance
FROM homegames as h
		INNER JOIN parks as p
		ON h.park = p.park
WHERE year = 2016
      and games >= 10
ORDER BY average_attendance ASC
LIMIT 5;

-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
-- Give their full name and the teams that they were managing when they won the award.
WITH award_AL AS (SELECT DISTINCT playerid, yearid, lgid
					 FROM awardsmanagers
					 WHERE awardid = 'TSN Manager of the Year'
					 AND (awardsmanagers.lgid = 'AL')),
award_NL AS (SELECT DISTINCT playerid, yearid, lgid
					 FROM awardsmanagers
					 WHERE awardid = 'TSN Manager of the Year'
					 AND (awardsmanagers.lgid = 'NL'))	
SELECT DISTINCT CONCAT(people.namefirst, ' ' ,people.namelast) AS manager_name,  
				teams.name AS team_name,
				award_AL.yearid AS AL_yearid, 
				award_NL.yearid AS NL_yearid
	  FROM award_AL INNER JOIN award_NL ON award_NL.playerid = award_AL.playerid
	  				INNER JOIN people ON people.playerid = award_AL.playerid
					INNER JOIN managers ON managers.playerid = award_AL.playerid AND (managers.yearid = award_AL.yearid OR managers.yearid = award_NL.yearid)
					INNER JOIN teams ON teams.teamid = managers.teamid AND (teams.yearid = award_AL.yearid OR teams.yearid = award_NL.yearid);


-- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, 
-- and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.
WITH career_high AS (SELECT b.playerid,
					        namefirst,
					        namelast,
					        COUNT(*) AS seasons_played,
					        MAX(hr) AS career_high_hr
					 FROM batting AS b
				     INNER JOIN people AS p
					 ON b.playerid = p.playerid
	 			     GROUP BY b.playerid, namefirst, namelast)	 			  
SELECT CONCAT(namefirst,' ', namelast), career_high_hr--, yearid, seasons_played				 
FROM batting
INNER JOIN career_high
ON career_high.playerid = batting.playerid
WHERE yearid = 2016
AND hr >= 1
AND seasons_played >= 10
AND hr = career_high_hr
ORDER BY career_high_hr DESC;


-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, 
-- keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.
-- No correlation between number of wins and team salary, graphs on excel
SELECT t.name AS team_name, 
	   t.yearid AS year, 
	   t.w AS number_of_wins, 
	   SUM(s.salary) AS team_salary
FROM teams AS t
	LEFT JOIN salaries AS s ON s.teamid = t.teamid AND s.yearid = t.yearid
WHERE t.yearid >= '2000'
GROUP BY t.name, t.yearid, t.w
ORDER BY t.yearid, team_salary DESC;

-- 12. In this question, you will explore the connection between number of wins and attendance.
--     <ol type="a">
--       <li>Does there appear to be any correlation between attendance at home games and number of wins? </li>
--       <li>Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means 
--           either being a division winner or a wild card winner.</li>


-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this 
-- claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. 
-- Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?
SELECT COUNT(*)
FROM people
WHERE throws = 'R';
-- 14480, 80% of all pitchers

SELECT COUNT(*)
FROM people
WHERE throws = 'L';
-- 3654, 20% of all pitchers

WITH r_pitcher AS (SELECT *
				   FROM people
				   WHERE throws = 'R'),
	 cy_award AS (SELECT *
				  FROM awardsplayers
				  WHERE awardid ILIKE 'CY%')
SELECT COUNT(*)
FROM r_pitcher 
	INNER JOIN cy_award ON cy_award.playerid = r_pitcher.playerid;
-- 75 R handed pitchers won CY Young Award, 0.52% of all R handed pitchers

WITH l_pitcher AS (SELECT *
				   FROM people
				   WHERE throws = 'L'),
	 cy_award AS (SELECT *
				  FROM awardsplayers
				  WHERE awardid ILIKE 'CY%')
SELECT COUNT(*)
FROM l_pitcher 
	INNER JOIN cy_award ON cy_award.playerid = l_pitcher.playerid;
-- 37 right handed players won CY Young Award, 1.01% of all L handed pitchers