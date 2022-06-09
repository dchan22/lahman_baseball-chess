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