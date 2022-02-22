WITH employee_rows AS (
    SELECT e.employee_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.employee e),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
    )
SELECT
e.employee_id,
a.address_id
FROM employee_rows e
INNER JOIN address_rows a
ON a.rn = e.rn;

/*Insert 1000 employees*/
WITH employee_rows AS (
    SELECT e.employee_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.employee e),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
    )
INSERT INTO dbo.employee_address (employee_id, address_id, status_id)
SELECT
e.employee_id,
a.address_id,
1
FROM employee_rows e
INNER JOIN address_rows a
ON a.rn = e.rn;

/*
/*Insert next 1000 employees*/
WITH employee_rows AS (
    SELECT e.employee_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.employee e),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
     )
INSERT INTO dbo.employee_address (employee_id, address_id, status_id)
SELECT
e.employee_id,
a.address_id,
1
FROM employee_rows e
INNER JOIN address_rows a
ON a.rn = e.rn
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.employee_address ea
    WHERE ea.employee_id = e.employee_id
    AND ea.address_id = a.address_id
    );
*/
/*
/*Add a second active address for 750 of those customers*/
WITH customer_rows AS (
    SELECT c.customer_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.customer c),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
     )
INSERT INTO dbo.customer_address (customer_id, address_id, status_id)
SELECT TOP 750
c.customer_id,
a.address_id,
1
FROM customer_rows c
INNER JOIN address_rows a
ON a.rn = c.rn
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.customer_address ca
    WHERE ca.customer_id = c.customer_id
    AND ca.address_id = a.address_id
    );


/*Add an inactive address for customers.*/

WITH customer_rows AS (
    SELECT c.customer_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.customer c),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
     )
INSERT INTO dbo.customer_address (customer_id, address_id, status_id)
SELECT TOP 400
c.customer_id,
a.address_id,
2
FROM customer_rows c
INNER JOIN address_rows a
ON a.rn = c.rn
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.customer_address ca
    WHERE ca.customer_id = c.customer_id
    AND ca.address_id = a.address_id
);

/*Add an active address for 200 customers.*/
WITH customer_rows AS (
    SELECT c.customer_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.customer c),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
     )
INSERT INTO dbo.customer_address (customer_id, address_id, status_id)
SELECT TOP 200
c.customer_id,
a.address_id,
1
FROM customer_rows c
INNER JOIN address_rows a
ON a.rn = c.rn
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.customer_address ca
    WHERE ca.customer_id = c.customer_id
    AND ca.address_id = a.address_id
);
*/