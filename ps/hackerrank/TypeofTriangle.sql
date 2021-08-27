-- https://www.hackerrank.com/challenges/what-type-of-triangle/problem
-- Type of Triangle

SELECT IF(GRADE >= 8, NAME, NULL) NAME, GRADE, MARKS
FROM (
    SELECT NAME, GRADE, MARKS
    FROM STUDENTS S
    LEFT JOIN GRADES G ON MAX_MARK >= MARKS AND MARKS >= MIN_MARK
) R
ORDER BY GRADE DESC,
        (CASE
            WHEN GRADE >= 8 THEN NAME
            ELSE MARKS
        END)
;