--Q10 Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the
--league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

SELECT *
FROM batting;


--CTEs from 1 table
WITH career_hr AS (SELECT playerid, 
				   COUNT(*) AS years_in_lg,
				   MAX(hr) AS high_hr
				   FROM batting
				   --WHERE yearid = '2016'
				   --AND hr >= 1
                   --AND years_in_lg >= 10
				   GROUP BY playerid)
SELECT CONCAT(namefirst, '  ' ,namelast), high_hr
FROM batting  INNER JOIN career_hr ON batting.playerid = career_hr.playerid
				INNER JOIN people as p ON batting.playerid = p.playerid
WHERE yearid = 2016
AND hr >= 1
AND years_in_lg >= 10
ORDER BY high_hr DESC;



-- CTEs from multiple tables And joins 
WITH career_hr AS (SELECT batting.playerid, 
				   namefirst, namelast,
				   COUNT(*) AS years_in_lg,
				   MAX(hr) AS high_hr
				   FROM batting INNER JOIN people as p ON batting.playerid = p.playerid
				   GROUP BY batting.playerid, namefirst, namelast)
SELECT CONCAT(namefirst, '  ' ,namelast), high_hr
FROM career_hr  INNER JOIN batting ON career_hr.playerid = batting.playerid
WHERE yearid = '2016'
AND hr >= 1
AND years_in_lg >= 10
ORDER BY high_hr DESC








