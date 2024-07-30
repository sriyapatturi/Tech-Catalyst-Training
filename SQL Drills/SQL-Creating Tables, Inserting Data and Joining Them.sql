-- Activity 4.2: All about creating tables, inserting records into them and joining them: 
CREATE or REPLACE TEMPORARY TABLE TECHCATALYST_DE.SPATTURI.CUSTOMERS(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    email VARCHAR(50)
);

CREATE or REPLACE TEMPORARY TABLE TECHCATALYST_DE.SPATTURI.ORDERS(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(20, 2),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);

CREATE or REPLACE TEMPORARY TABLE TECHCATALYST_DE.SPATTURI.PRODUCTS(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(40),
    price DECIMAL(20, 2)
    
);
-- Customers table
INSERT INTO Customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Sriya', 'Patturi', 'sriya123@gmail.com'),
(3, 'Sidney', 'White', 'sydthesquid@gmail.com'),
(4, 'Emma', 'Doe', 'emmaleedoe@gmail.com'),
(5, 'Sean', 'White', 'sean1020@gmail.com');

-- Orders table
DELETE FROM ORDERS;
SELECT * FROM ORDERS;
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2023-01-01', 100.00),
(2, 1, '2023-01-02', 200.00),
(3, 2, '2023-01-03', 50.00),
(4, 3, '2023-01-05', 1000.00),
(5, 5, '2023-01-08', 10.00);

-- Products table
INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'Laptop', 999.99),
(2, 'Tea Bags', 4.99),
(3, 'Makeup Kit', 49.99),
(4, 'Apple Pie', 8.99),
(5, 'Headphones', 29.99);

-- Creating the Order Details Table:
-- You will need to make sure that all three tables can be joined. You final query will be to show all columns from all three tables.

-- Write a query to join all three tables:

-- The Orders table has a foreign key customer_id that references the customer_id in the Customers table. This relationship implies that each order is associated with a specific customer.

-- To create a meaningful join between the Orders and Products tables, we need an intermediary table to handle the many-to-many relationship, since one order can contain multiple products, and one product can be part of multiple orders. This intermediary table is typically called OrderDetails.

-- Create the OrderDetails Table:

-- Schema:

-- OrderDetails
-- order_id (INT, Foreign Key referencing Orders)
-- product_id (INT, Foreign Key referencing Products)
-- quantity (INT)
CREATE or REPLACE TEMPORARY TABLE TECHCATALYST_DE.SPATTURI.ORDERDETAILS(
    order_id INT,
    product_id INT,
    quantity INT,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

INSERT INTO ORDERDETAILS(order_id, product_id, quantity)
VALUES(3, 3, 1);
-- ORDERDETAILS is a connector table and you would use a connector table when two tables have a many to many relationship

-- Snowflake does not enforce constraints - a lot of constraints in snowflake are logical
-- doesn't enforce integrity like an OLTP system

-- Identifying duplicate records

SELECT NAME, SALARY, OTHER_ID, count(*)
FROM fun_facts
GROUP BY NAME, SALARY, OTHER_ID
HAVING count(*) > 1;
-- Another 
with cte as
(
    SELECT *,
        ROW_NUMBER() OVER(PARITION BY name, salary, other_id order by id) as row_num
    from fun_facts

)
select * from cte where row_num = 1; 