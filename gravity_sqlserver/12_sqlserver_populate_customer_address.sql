/*
BURADA SIRALAMASI RASTGELE OLARAK CUSTOMER VE ADDRESS
ID'LER SEÇÝLÝR. YANÝ ROW NUMBER(rn)'I AYNI OLAN ADDRESS
VE CUSTOMER ID'LER BÝRBÝRLERÝNE EÞLEÞTÝRÝLEREK CUSTOMER'LARA
RASTGELE BÝR ADRES ATANIR.
*/
WITH customer_rows AS (
    SELECT c.customer_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.customer c),
address_rows AS (
    SELECT address_id,
    ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM dbo.address
    )
SELECT
c.customer_id,
a.address_id
FROM customer_rows c
INNER JOIN address_rows a
ON a.rn = c.rn;

/*
1000 TANE ADDRESS ID OLDUÐUNDAN 1000 TANE CUSTOMER'IN
ADRESÝ GÜNCELLENÝYOR.
*/
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
SELECT
c.customer_id,
a.address_id,
1 /*status id otomatik olarak 1'e eþitleniyor burada eklenen customer'lar için*/
FROM customer_rows c
INNER JOIN address_rows a
ON a.rn = c.rn;

/*Insert next 1000 customers*/
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
SELECT
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