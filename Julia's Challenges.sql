-- HACKERRANK
SELECT name FROM employee order by name

SELECT name FROM employee
where salary  > 2000 and months < 10
ORDER BY employee_id

/* Julia asked her students to create some coding challenges. 
Write a query to print the hacker_id, name, and the total number of challenges created by each student. 
Sort your results by the total number of challenges in descending order. 
If more than one student created the same number of challenges, then sort the result by hacker_id. 
If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, 
then exclude those students from the result. */

-- 
-- Author: Pavith Bambaravanage
-- URL: https://github.com/Pavith19
-- 


WITH HackerChallengeCounts AS (
    SELECT
        c.hacker_id,
        h.name,
        COUNT(c.challenge_id) AS total_challenges_created,
        COUNT(*) OVER (PARTITION BY COUNT(c.challenge_id)) AS num_hackers_with_this_count, -- Counts how many hackers have this specific total_challenges_created
        MAX(COUNT(c.challenge_id)) OVER () AS overall_max_challenges -- Gets the single highest challenge count across all hackers
    FROM
        Challenges c
    JOIN
        Hackers h ON c.hacker_id = h.hacker_id
    GROUP BY
        c.hacker_id, h.name
)
SELECT
    hcc.hacker_id,
    hcc.name,
    hcc.total_challenges_created
FROM
    HackerChallengeCounts hcc
WHERE
    hcc.num_hackers_with_this_count = 1 -- Keep only counts that are unique to one hacker
    OR hcc.total_challenges_created = hcc.overall_max_challenges -- OR if the count is the overall maximum (even if shared)
ORDER BY
    hcc.total_challenges_created DESC, hcc.hacker_id ASC;





-- otra solucion
SELECT 
	c.hacker_id,
	h.name,
	COUNT(c.challenge_id) AS cnt 
FROM Hackers AS h 
	JOIN Challenges AS c 
	ON h.hacker_id = c.hacker_id
GROUP BY c.hacker_id, h.name 
HAVING
	cnt = (SELECT 
				COUNT(c1.challenge_id) 
				FROM Challenges AS c1 
				GROUP BY c1.hacker_id 
				ORDER BY COUNT(*) DESC LIMIT 1)
				 OR
	cnt NOT IN (SELECT 
		        COUNT(c2.challenge_id) 
		        FROM Challenges AS c2 
		        GROUP BY c2.hacker_id 
		        HAVING c2.hacker_id <> c.hacker_id)
ORDER BY cnt DESC, c.hacker_id;