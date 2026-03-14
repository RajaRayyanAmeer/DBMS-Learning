-- Using Previous Lab Database
USE Lab7;

-- Task 1
EXPLAIN
SELECT o.order_id, o.order_date, c.name AS customer, p.category, p.product_name, op.quantity, op.unit_price
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
JOIN Products p ON p.product_id = op.product_id
WHERE p.category = 'Accessories'
  AND o.order_date BETWEEN '2025-09-01' AND '2025-10-31'
ORDER BY o.order_date DESC;

-- Task 2
CREATE OR REPLACE VIEW v_customer_orders AS
SELECT o.order_id, o.order_date, o.customer_id, c.name AS customer, o.total_amount
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id;

SELECT * FROM v_customer_orders ORDER BY order_date DESC;

-- Task 3
CREATE OR REPLACE VIEW v_customer_spend AS
SELECT c.customer_id, c.name,
       SUM(op.quantity * op.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
GROUP BY c.customer_id, c.name;

SELECT * FROM v_customer_spend ORDER BY total_spent DESC;

-- Task 4
CREATE OR REPLACE VIEW v_products_basic AS
SELECT product_id, product_name, category, price
FROM Products
WHERE price >= 0
WITH CHECK OPTION;

-- Valid update (works fine)
UPDATE v_products_basic
SET price = price + 100
WHERE product_id = 101;

-- Invalid update (will fail intentionally)
UPDATE v_products_basic
SET price = -1
WHERE product_id = 102;

-- Task 5
CREATE INDEX idx_orders_order_date ON Orders(order_date);

EXPLAIN
SELECT o.order_id, o.order_date, c.name, p.product_name
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
JOIN Products p ON p.product_id = op.product_id
WHERE o.order_date BETWEEN '2025-09-01' AND '2025-10-31'
ORDER BY o.order_date DESC;

-- Task 6
CREATE INDEX idx_orderproducts_order_product
ON OrderProducts(order_id, product_id);

EXPLAIN
SELECT o.order_id, p.product_name, SUM(op.quantity) AS units
FROM Orders o
JOIN OrderProducts op ON op.order_id = o.order_id
JOIN Products p ON p.product_id = op.product_id
GROUP BY o.order_id, p.product_name
ORDER BY o.order_id;

-- Task 7
CREATE INDEX idx_products_category_name_price
ON Products(category, product_name, price);

EXPLAIN
SELECT product_name, price
FROM Products
WHERE category = 'Accessories'
ORDER BY product_name;

-- Task 8
EXPLAIN
SELECT p.product_id, p.product_name
FROM Products p
WHERE p.product_id IN (
  SELECT op.product_id
  FROM OrderProducts op
);

EXPLAIN
SELECT p.product_id, p.product_name
FROM Products p
WHERE EXISTS (
  SELECT 1
  FROM OrderProducts op
  WHERE op.product_id = p.product_id
);

-- Task 9
EXPLAIN ANALYZE
SELECT c.customer_id, c.name,
       SUM(op.quantity * op.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- Task 10
ANALYZE TABLE Orders, OrderProducts, Products;

DROP INDEX idx_orders_order_date ON Orders;

EXPLAIN
SELECT o.order_id, o.order_date
FROM Orders o
WHERE o.order_date BETWEEN '2025-09-01' AND '2025-10-31'
ORDER BY o.order_date DESC;

-- Challenge 1
CREATE OR REPLACE VIEW v_recent_orders AS
SELECT o.order_id, o.order_date, o.customer_id, c.name AS customer, o.total_amount
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

SELECT * FROM v_recent_orders ORDER BY o.order_date DESC;

-- Challenge 2
CREATE INDEX idx_orders_customer_date
ON Orders(customer_id, order_date DESC);

SELECT order_id, order_date, total_amount
FROM Orders
WHERE customer_id = 5
  AND order_date BETWEEN '2025-09-01' AND '2025-10-31'
ORDER BY order_date DESC;

-- Challenge 3
SELECT * FROM Orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31';

EXPLAIN SELECT * FROM Orders WHERE YEAR(order_date) = 2025;
EXPLAIN SELECT * FROM Orders WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31';

-- Challenge 4
CREATE INDEX idx_products_camera_cover
ON Products(category, product_name, price);

EXPLAIN SELECT product_name, price
FROM Products
WHERE category = 'Cameras'  
ORDER BY product_name;

-- Challenge 5
CREATE OR REPLACE VIEW v_high_value_customers AS
SELECT c.customer_id, c.name,
       SUM(op.quantity * op.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
GROUP BY c.customer_id, c.name
HAVING total_spent > 20000;

SELECT * FROM v_high_value_customers ORDER BY total_spent DESC;

SHOW TABLES;