-- https://www.hackerrank.com/challenges/the-report/problem
-- The Report

SELECT CASE
            WHEN MAX >= MID + MIN THEN "Not A Triangle"
            WHEN MAX = MID AND MID = MIN THEN "Equilateral"
            WHEN MAX = MID OR MID = MIN THEN "Isosceles"
            WHEN MAX <> MID AND MID <> MIN THEN "Scalene"
        END AS TYPE
FROM (
    SELECT GREATEST(A, B, C) AS "MAX",
            ((A + B + C) - GREATEST(A, B, C) - LEAST(A, B, C)) AS "MID",
            LEAST(A, B, C) AS "MIN"
    FROM TRIANGLES
) T;