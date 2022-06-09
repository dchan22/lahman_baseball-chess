-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, 
-- keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

SELECT t.name AS team_name, 
	   t.yearid AS year, 
	   t.w AS number_of_wins, 
	   SUM(s.salary) AS team_salary
FROM teams AS t
	LEFT JOIN salaries AS s ON s.teamid = t.teamid AND s.yearid = t.yearid
WHERE t.yearid >= '2000'
GROUP BY t.name, t.yearid, t.w
ORDER BY t.yearid, team_salary DESC;