-- https://www.hackerrank.com/challenges/binary-search-tree-1/problem
-- Binary Tree Nodes

SELECT NODES.NODE, 
        CASE
            WHEN PARENT_CNT = 0 THEN "Root"
            WHEN CHILDREN_CNT > 0 THEN "Inner"
            ELSE "Leaf" 
        END POSITION
FROM (
    SELECT ORG.N NODE, 
            COUNT(ORG.P) PARENT_CNT, 
            COUNT(REC.N) CHILDREN_CNT
    FROM BST ORG 
    LEFT JOIN BST REC ON ORG.N = REC.P
    GROUP BY ORG.N
) NODES
ORDER BY NODE;