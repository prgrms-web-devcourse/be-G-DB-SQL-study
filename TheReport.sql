SELECT
    CASE
        WHEN grade < 8 THEN NULL
        ELSE name
    END AS name,
    grade,
    marks
FROM STUDENTS s
    INNER JOIN GRADES g ON s.marks >= g.min_mark AND s.marks <= g.max_mark
ORDER BY grade DESC, name, marks;
