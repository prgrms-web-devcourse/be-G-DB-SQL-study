SELECT 
    CASE
        WHEN p IS NULL THEN CONCAT(n, ' Root')
        WHEN n IN (SELECT DISTINCT p FROM BST) THEN CONCAT(n, ' Inner')
        ELSE CONCAT(n, ' Leaf')
    END
FROM BST
    ORDER BY n;
