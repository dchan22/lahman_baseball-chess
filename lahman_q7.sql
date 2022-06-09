/* 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win 
the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
What percentage of the time? */


SELECT COUNT(*)
FROM (SELECT MAX (w) AS max_w, yearid
		FROM teams
		WHERE yearid >= 1970
		GROUP BY teams.yearid
		ORDER BY yearid DESC) AS max_wins
INNER JOIN teams ON teams.yearid = max_wins.yearid AND max_wins.max_w = teams.w
WHERE teams.yearid >= 1970
AND wswin = 'Y';




