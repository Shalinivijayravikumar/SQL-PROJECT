CREATE DATABASE BikeStore;
GO
USE BikeStore;
GO
select * from dbo.brands;

-- Combined view of PKs and FKs for all tables
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    CASE 
        WHEN i.is_primary_key = 1 THEN 'Primary Key'
        ELSE NULL
    END AS KeyType,
    fk.name AS ForeignKeyName,
    rt.name AS ReferencedTable,
    rc.name AS ReferencedColumn
FROM 
    sys.tables t
LEFT JOIN 
    sys.columns c ON t.object_id = c.object_id
LEFT JOIN 
    sys.index_columns ic ON t.object_id = ic.object_id AND c.column_id = ic.column_id
LEFT JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id AND i.is_primary_key = 1
LEFT JOIN 
    sys.foreign_key_columns fkc ON t.object_id = fkc.parent_object_id AND c.column_id = fkc.parent_column_id
LEFT JOIN 
    sys.foreign_keys fk ON fkc.constraint_object_id = fk.object_id
LEFT JOIN 
    sys.tables rt ON fkc.referenced_object_id = rt.object_id
LEFT JOIN 
    sys.columns rc ON fkc.referenced_object_id = rc.object_id AND fkc.referenced_column_id = rc.column_id
ORDER BY 
    TableName, ColumnName;


    SELECT * FROM INFORMATION_SCHEMA.TABLES -- lists all tables--

    SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('brands','categories','customer','order_items','orders',
'products','staffs','stocks','stores'); -- lists columns


----This query is used to check if a table named brands is present in the database and 
---- to see its basic details.----

    SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'brands';


DROP TABLE dbo.sysdiagrams;

-- checking composite keys to make sure i created CK correctly --

SELECT 
    tc.TABLE_NAME,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY tc.TABLE_NAME, kcu.ORDINAL_POSITION;


--- using below query i am creating composite key for order_items table for columns(order_id, item_id)--

ALTER TABLE order_items
DROP CONSTRAINT IF EXISTS PK_order_items;

ALTER TABLE order_items
ADD CONSTRAINT PK_order_items PRIMARY KEY (order_id, item_id);


--checking that i created all keys(PK,CK,FK) correctly--

-- Primary keys (single or composite)
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    k.name AS ConstraintName,
    ic.key_ordinal AS KeyOrder,
    'PRIMARY KEY' AS KeyType
FROM 
    sys.tables t
JOIN 
    sys.key_constraints k ON t.object_id = k.parent_object_id
JOIN 
    sys.index_columns ic ON k.parent_object_id = ic.object_id AND k.unique_index_id = ic.index_id
JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE 
    k.type = 'PK'
ORDER BY 
    t.name, ic.key_ordinal;

-- Foreign keys
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM 
    sys.foreign_keys fk
JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN 
    sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN 
    sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN 
    sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN 
    sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
ORDER BY 
    tp.name, cp.column_id;

    select* from customers

    select * from dbo.brands

    SELECT * FROM stores


    -- Update city names in customers table
UPDATE customers
SET city = UPPER(LTRIM(RTRIM(city)));

-- Update city names in stores table
UPDATE stores
SET city = UPPER(LTRIM(RTRIM(city)));

SELECT DISTINCT city
FROM customers;


    -- checking duplicates--

    -- brands table

SELECT 
    brand_id,
    brand_name,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM brands
GROUP BY brand_id, brand_name
ORDER BY brand_id;

--CHECKING DUPLICATES--

--- brand table---
SELECT 
    brand_id,
    brand_name,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM brands
GROUP BY brand_id, brand_name
ORDER BY brand_id,brand_name;


--- categories table---

select * from dbo.categories

SELECT 
    category_id,category_name,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM categories
GROUP BY category_id,category_name
ORDER BY category_id,category_name;

--- customers table---

select * from dbo.customers

SELECT 
    customer_id,first_name,last_name,phone,email,street,city,state,zip_code,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM customers
GROUP BY  customer_id,first_name,last_name,phone,email,street,city,state,zip_code
ORDER BY  customer_id,first_name,last_name,phone,email,street,city,state,zip_code;

--- order_items table---

select * from dbo.order_items

SELECT 
    order_id,item_id,product_id,quantity,list_price,discount,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM order_items
GROUP BY  order_id,item_id,product_id,quantity,list_price,discount
ORDER BY  order_id,item_id,product_id,quantity,list_price,discount;

--- orders table---
select * from dbo.orders


SELECT 
    order_id,customer_id,order_status,order_date,required_date,shipped_date,store_id,staff_id,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM orders
GROUP BY   order_id,customer_id,order_status,order_date,required_date,shipped_date,store_id,staff_id
ORDER BY   order_id,customer_id,order_status,order_date,required_date,shipped_date,store_id,staff_id;

--- products table---

select * from dbo.products

SELECT 
    product_id,product_name,brand_id,category_id,model_year,list_price,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM products
GROUP BY   product_id,product_name,brand_id,category_id,model_year,list_price
ORDER BY   product_id,product_name,brand_id,category_id,model_year,list_price;

--- staffs table---

select * from dbo.staffs

SELECT 
    staff_id,first_name,last_name,email,phone,active,store_id,manager_id,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM staffs
GROUP BY   staff_id,first_name,last_name,email,phone,active,store_id,manager_id
ORDER BY   staff_id,first_name,last_name,email,phone,active,store_id,manager_id;

--- stocks table---

select * from dbo.stocks

SELECT 
    store_id,product_id,quantity,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM stocks
GROUP BY   store_id,product_id,quantity
ORDER BY   store_id,product_id,quantity;

--- stores table---

select * from dbo.stores

SELECT 
    store_id,store_name,phone,email,street,city,state,zip_code,
    CASE 
        WHEN COUNT(*) > 1 THEN 1
        ELSE 0
    END AS DuplicateCount
FROM stores
GROUP BY   store_id,store_name,phone,email,street,city,state,zip_code
ORDER BY   store_id,store_name,phone,email,street,city,state,zip_code;









--- CHECKING MISSING VALUES--

--brand table--

SELECT 'brand_id' as brandcolumn,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM brands
WHERE brand_id IS NULL

UNION ALL

SELECT 'brand_name' as brandcolumn ,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM brands
WHERE brand_name IS NULL;


--Categories table--


SELECT 'category_id' as category_column,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM categories
WHERE category_id IS NULL

UNION ALL

SELECT 'category_name' as category_column ,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM categories
WHERE category_name IS NULL;


--Customers table--


SELECT 'first_name' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE first_name IS NULL

UNION ALL

SELECT 'last_name' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE last_name IS NULL

UNION ALL

SELECT 'phone' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE phone IS NULL

UNION ALL

SELECT 'email' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE email IS NULL

UNION ALL

SELECT 'street' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE street IS NULL

UNION ALL

SELECT 'city' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE city IS NULL

UNION ALL

SELECT 'state' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE state IS NULL

UNION ALL

SELECT 'zip_code' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM customers
WHERE zip_code IS NULL;

--order_items table--


SELECT 'order_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM order_items
WHERE order_id IS NULL

UNION ALL

SELECT 'item_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM order_items
WHERE item_id IS NULL

UNION ALL

SELECT 'product_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM order_items
WHERE product_id IS NULL

UNION ALL

SELECT 'quantity' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM order_items
WHERE quantity IS NULL

UNION ALL

SELECT 'list_price' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM order_items
WHERE list_price IS NULL

UNION ALL

SELECT 'discount' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM order_items
WHERE discount IS NULL;


--orders table--


SELECT 'order_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE order_id IS NULL

UNION ALL

SELECT 'customer_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE customer_id IS NULL

UNION ALL

SELECT 'order_status' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE order_status IS NULL

UNION ALL

SELECT 'order_date' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE order_date IS NULL

UNION ALL

SELECT 'required_date' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE required_date IS NULL

UNION ALL

SELECT 'shipped_date' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE shipped_date IS NULL

UNION ALL

SELECT 'store_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE store_id IS NULL

UNION ALL

SELECT 'staff_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM orders
WHERE staff_id IS NULL;

---Handling NULL values for "orders table"----

----this query shows "Not shipped" instead of NULL in the shipped_date column when  view the data---

SELECT 
    order_id,
    customer_id,
    order_status,
    order_date,
    required_date,
    COALESCE(CONVERT(varchar, shipped_date, 23), 'Not shipped') AS shipped_date,
    store_id,
    staff_id
FROM orders;

---- below query adds a separate column showing the shipped status while keeping the real shipped_date intact--


SELECT 
    order_id,
    customer_id,
    order_status,
    order_date,
    required_date,
    shipped_date,
    store_id,
    staff_id,
    CASE 
        WHEN shipped_date IS NULL THEN 'Not shipped'
        ELSE 'Shipped'
    END AS shipping_status
FROM orders;

--products table--

SELECT 'product_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM products
WHERE product_id IS NULL

UNION ALL

SELECT 'product_name' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM products
WHERE product_name IS NULL

UNION ALL

SELECT 'brand_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM products
WHERE brand_id IS NULL

UNION ALL

SELECT 'category_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM products
WHERE category_id IS NULL

UNION ALL

SELECT 'model_year' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM products
WHERE model_year IS NULL

UNION ALL

SELECT 'list_price' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM products
WHERE list_price IS NULL;




--products table--


SELECT 'staff_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE staff_id IS NULL

UNION ALL

SELECT 'first_name' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE first_name IS NULL

UNION ALL

SELECT 'last_name' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE last_name IS NULL

UNION ALL

SELECT 'email' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE email IS NULL

UNION ALL

SELECT 'phone' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE phone IS NULL

UNION ALL

SELECT 'active' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE active IS NULL

UNION ALL

SELECT 'store_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE store_id IS NULL

UNION ALL

SELECT 'manager_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM staffs
WHERE manager_id IS NULL;

---- Below replacing "NULL" as 'No Manager'----


SELECT 
    staff_id,
    first_name,
    last_name,
    COALESCE(CONVERT(varchar, manager_id), 'No Manager') AS manager_status
FROM staffs;



--stocks table--

SELECT 'store_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stocks
WHERE store_id IS NULL

UNION ALL

SELECT 'product_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stocks
WHERE product_id IS NULL

UNION ALL

SELECT 'quantity' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stocks
WHERE quantity IS NULL;


--stores table--

SELECT 'store_id' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE store_id IS NULL

UNION ALL

SELECT 'store_name' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE store_name IS NULL

UNION ALL

SELECT 'phone' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE phone IS NULL

UNION ALL

SELECT 'email' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE email IS NULL

UNION ALL

SELECT 'street' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE street IS NULL

UNION ALL

SELECT 'city' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE city IS NULL

UNION ALL

SELECT 'state' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE state IS NULL

UNION ALL

SELECT 'zip_code' AS column_name,
       CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS Has_Missing_Values
FROM stores
WHERE zip_code IS NULL;

---here i am checking to Make sure numbers are positive or within expected ranges.

-- Check negative quantities
SELECT COUNT(*) AS Negative_Quantities FROM order_items WHERE quantity < 0;

-- Check invalid prices
SELECT COUNT(*) AS Invalid_Prices FROM products WHERE list_price <= 0;

-- Check invalid discounts
SELECT COUNT(*) AS Invalid_Discounts FROM order_items WHERE discount < 0 OR discount > 1;


----below am checking that Inconsistent_Orders for date values---

SELECT * FROM orders
WHERE shipped_date < order_date
   OR required_date < order_date
   OR order_date > GETDATE();  -- current date

   SELECT COUNT(*) AS Inconsistent_Orders
FROM orders
WHERE shipped_date < order_date
   OR required_date < order_date
   OR order_date > GETDATE();

   ----Check Data Types and Constraints----

   SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('brands','categories','customers','orders','order_items','products','staffs','stocks','stores');

--Check Orphaned Foreign Keys---

-- orders table: customer_id must exist in customers
SELECT o.customer_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- order_items table: product_id must exist in products
SELECT oi.product_id
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


---Basic Business Insights (Analysis)----

-- Top 5 best-selling products by quantity
SELECT TOP 5 p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id ----JOIN by itself is the same as INNER JOIN----
GROUP BY p.product_name
ORDER BY total_sold DESC;


  ---- it Only returns the product(s) that have the highest or lowest price---

  SELECT product_name, list_price
FROM products
WHERE list_price = (SELECT MAX(list_price) FROM products)
   OR list_price = (SELECT MIN(list_price) FROM products);




-- Which city has the highest number of customers
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Which store sold the most items
SELECT s.store_name, SUM(oi.quantity) AS total_items_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_items_sold DESC;

----Count total rows in each table----
SELECT 'brands' AS TableName, COUNT(*) AS TotalRows FROM brands
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'staffs', COUNT(*) FROM staffs
UNION ALL
SELECT 'stocks', COUNT(*) FROM stocks
UNION ALL
SELECT 'stores', COUNT(*) FROM stores;


--checking min,avg,max price---

SELECT AVG(list_price) AS AvgPrice, MIN(list_price) AS MinPrice, MAX(list_price) AS MaxPrice
FROM products
group by product_name;


SELECT 
    p.product_name,
    AVG(oi.list_price) AS AvgPrice,
    MIN(oi.list_price) AS MinPrice,
    MAX(oi.list_price) AS MaxPrice
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY AvgPrice DESC;


select * from products
order by list_price desc;



SELECT product_name,
       AVG(list_price) AS AvgPrice,
       MIN(list_price) AS MinPrice,
       MAX(list_price) AS MaxPrice
FROM products
GROUP BY product_name
ORDER BY product_name;


SELECT p.product_name,
       AVG(oi.list_price) AS AvgPrice,
       MIN(oi.list_price) AS MinPrice,
       MAX(oi.list_price) AS MaxPrice
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY AvgPrice DESC;


SELECT product_name, ROUND(list_price, 2) AS price
FROM products;


---Top customers by purchase quantity/value--


SELECT c.customer_id, c.first_name, c.last_name, SUM(oi.quantity * oi.list_price) AS TotalSpent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY TotalSpent DESC

----Products with highest discount used---


SELECT p.product_id, p.product_name, max(oi.discount) AS maxDiscount
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
order by maxDiscount desc;

SELECT p.product_id, p.product_name, min(oi.discount) AS minDiscount
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
order by minDiscount asc;



SELECT 
    p.product_id,
    p.product_name,
    oi.discount
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY p.product_id, oi.discount ASC;


---Displays the minimum discount without duplicates---

SELECT DISTINCT
    p.product_id,
    p.product_name,
    oi.discount
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY p.product_id, oi.discount ASC;



-----Monthly sales trends----


SELECT YEAR(order_date) AS Year, MONTH(order_date) AS Month, SUM(oi.quantity) AS TotalSold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY Year, Month




--Stock availability check---

SELECT p.product_name, s.store_id, s.quantity
FROM stocks s
JOIN products p ON s.product_id = p.product_id
WHERE s.quantity < 5 -- threshold
ORDER BY s.quantity ASC

----using left join checking stock availability---


SELECT p.product_name, s.store_id, s.quantity
FROM stocks s
left JOIN products p ON s.product_id = p.product_id
WHERE s.quantity < 5 -- threshold
ORDER BY s.quantity ASC



----Checking which customer is buying the most bikes from each brand----

SELECT 
    c.first_name,
    c.last_name,
    b.brand_name,
    SUM(oi.quantity) AS total_bikes_bought
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY 
    c.first_name,
    c.last_name,
    b.brand_name
ORDER BY 
    total_bikes_bought DESC; ---'ELECTRA' is the most purchased brand by Tameka Fisher--



  update brands
  set brand_name= upper(brand_name);

  SELECT first_name + ' ' + last_name AS full_name
FROM customers;


select * from brands


--- Customers are buying very few bikes from this brand---
SELECT b.brand_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_sold ASC;  -- ascending to see least sold brands first



---cx never bought this brands---

SELECT b.brand_name
FROM brands b
LEFT JOIN products p ON b.brand_id = p.brand_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;   ----cx is not buying Electra,Trek,Surly brands---

    select *from customers

    ---The customer bought a bike under the Strider brand at a list price of $89.99---

    select b.brand_name,min(p.list_price) as list_price
    from brands b
    inner join products p
    on b.brand_id=p.brand_id
    group by b.brand_name,list_price


    SELECT TOP 1 b.brand_name, MIN(p.list_price) AS min_price
FROM brands b
INNER JOIN products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY min_price ASC;

 ---The customer bought a bike under the Trek at a maximum price at a 11999.99---

   SELECT TOP 1 b.brand_name, Max(p.list_price) AS max_price
FROM brands b
INNER JOIN products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY max_price desc;


SELECT 
    TOP 1 p.product_name,p.model_year,
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name,p.model_year
ORDER BY total_sold DESC;


select p.model_year ,b.brand_name
from products p
inner join brands b
on p.brand_id=b.brand_id


select * from customers;


------1. Sales Performance-----

----a) Products that sell the most----

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;  ---This gives a list of products with the total quantity sold.
---The highest-selling product appears first. Business can identify bestsellers vs. slow-moving products.---



--------b) Brands that sell the most-----


SELECT b.brand_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_sold DESC;  ----Shows each brand and the total number of units sold. 
---Helps the company see which brands are most popular with customers.--

-----c) Categories that sell the most---

SELECT c.category_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sold DESC;  ----Displays product categories (like mountain bikes, road bikes, accessories) and their sales volume.
---Helps identify which categories drive most sales.---


------d) Monthly sales trend-----

SELECT YEAR(o.order_date) AS year, MONTH(o.order_date) AS month,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY year, month;

---Summarizes sales revenue month by month. Useful for seasonal trend analysis (e.g., more bike sales in summer).---


------2. Customer Insights----


----a) Top customers by spending----

SELECT c.customer_id, c.first_name, c.last_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY customer_id,total_spent DESC;  -----Lists customers with the total amount they spent, highest first.
--Helps find loyal and high-value customers.---

----b) Revenue by city/state---

SELECT c.state, c.city,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state, c.city
ORDER BY revenue DESC; --Shows how much revenue is generated from each city and state. Helps identify geographical 
--markets with the most sales.---



-----c) Customer buying frequency----

SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC; --Lists customers with how many orders they placed. Helps distinguish repeat 
--customers from one-time buyers.---

----3. Store Performance----

----a) Store with highest sales---


SELECT s.store_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY revenue DESC; --Shows each store with its total revenue. Helps find top-performing stores vs. underperforming ones.---


-----b) Store-wise staff contribution---

SELECT s.store_name, st.first_name, st.last_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM staffs st
JOIN orders o ON st.staff_id = o.staff_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores s ON st.store_id = s.store_id
GROUP BY s.store_name, st.first_name, st.last_name
ORDER BY revenue DESC; --Lists staff members in each store with the revenue they handled. Helps measure individual staff performance.---



----4. Inventory Management---

-----a) Products running low in stock---

SELECT s.store_id, st.store_name, p.product_name, s.quantity
FROM stocks s
JOIN products p ON s.product_id = p.product_id
JOIN stores st ON s.store_id = st.store_id
WHERE s.quantity < 5
ORDER BY s.quantity ,store_id ASC; ---Lists staff members in each store with the revenue they handled. Helps measure 
---individual staff performance.----



----b) Overstocked products--


SELECT st.store_name, p.product_name, s.quantity
FROM stocks s
JOIN products p ON s.product_id = p.product_id
JOIN stores st ON s.store_id = st.store_id
WHERE s.quantity > 100
ORDER BY s.quantity DESC; --Lists products with very high stock levels. Helps avoid overstock and excess storage costs.---



--- 5. Staff Performance-----

----a) Staff handling most orders--


SELECT st.first_name, st.last_name, COUNT(o.order_id) AS total_orders
FROM staffs st
JOIN orders o ON st.staff_id = o.staff_id
GROUP BY st.first_name, st.last_name
ORDER BY total_orders DESC;
----Shows which staff processed the most orders. Good for tracking workload and efficiency.----


----b) Staff sales revenue----

SELECT st.first_name, st.last_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
FROM staffs st
JOIN orders o ON st.staff_id = o.staff_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY st.first_name, st.last_name
ORDER BY revenue DESC; ----Lists staff with total sales revenue they handled. Helps spot top sales performers.---



-----6. Discount & Pricing Analysis---

---a) Products most sold with discounts---

SELECT p.product_name,
       COUNT(*) AS times_discounted,
       AVG(oi.discount) AS avg_discount
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.discount > 0
GROUP BY p.product_name
ORDER BY times_discounted DESC;  ---Shows products that were sold most often with discounts and their average discount rate.
----Helps identify products that depend on discounts to sell.



---b) Total discount impact on sales---

SELECT SUM(oi.quantity * oi.list_price * oi.discount) AS total_discount,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_revenue
FROM order_items oi; ---Displays total money given away as discounts vs. the net revenue collected. Helps measure the 
--financial effect of discounting.---





----7. Time-based Trends----

----a) Order fulfillment time--

SELECT o.order_id, DATEDIFF(DAY, o.order_date, o.shipped_date) AS fulfillment_days
FROM orders o
WHERE o.shipped_date IS NOT NULL;---Shows how many days each order took from order date to shipment. Helps track shipping efficiency.--


----b) Late shipping analysis--

SELECT o.order_id, o.required_date, o.shipped_date,
       DATEDIFF(DAY, o.required_date, o.shipped_date) AS delay_days
FROM orders o
WHERE o.shipped_date > o.required_date; ---Lists orders that shipped late and by how many days. 
----Helps identify delivery delays and improve logistics.----

select * from customers;

select * from categories;

select * from brands;

select * from products;


select * from brands;

select * from orders;



