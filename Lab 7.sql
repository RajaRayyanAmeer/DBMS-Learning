CREATE DATABASE Lab7;
USE Lab7;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(80)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(80),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE OrderProducts (
    op_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES
(1, 'Ali Khan', 'Lahore'),
(2, 'Sara Ahmed', 'Karachi'),
(3, 'John Lee', 'Islamabad'),
(4, 'Noor Fatima', 'Lahore');

INSERT INTO Products VALUES
(101, 'USB-C Cable', 'Accessories', 800.00),
(102, 'Wireless Mouse', 'Accessories', 2200.00),
(103, '27-Inch Monitor', 'Displays', 48000.00),
(104, 'Mechanical Keyboard', 'Accessories', 9500.00),
(105, 'Webcam HD', 'Cameras', 5200.00);

INSERT INTO Orders VALUES
(5001, 1, '2025-10-01', 13300.00),  
(5002, 2, '2025-10-03', 48000.00),  
(5003, 3, '2025-10-05', 5200.00),   
(5004, 4, '2025-10-07', 9200.00);   

INSERT INTO OrderProducts VALUES
(1, 5001, 101, 2, 800.00),
(2, 5001, 102, 1, 2200.00),
(3, 5001, 104, 1, 9500.00),
(4, 5002, 103, 1, 48000.00),
(5, 5003, 105, 1, 5200.00),
(6, 5004, 102, 2, 2200.00),
(7, 5004, 103, 1, 48000.00);

-- Task 1
SELECT c.customer_id, c.name, o.order_id, o.order_date, o.total_amount
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_date;

-- Task 2
SELECT c.customer_id, c.name, o.order_id, o.order_date
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_date;

-- Task 3
SELECT o.order_id, o.order_date, c.name AS customer, p.product_name,
       op.quantity, op.unit_price, (op.quantity * op.unit_price) AS line_total
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
JOIN Products p ON p.product_id = op.product_id
ORDER BY o.order_id, p.product_name;

-- Task 4
SELECT c.customer_id, c.name, SUM(op.quantity * op.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- Task 5
SELECT c.customer_id, c.name, SUM(op.quantity * op.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
GROUP BY c.customer_id, c.name
HAVING SUM(op.quantity * op.unit_price) > 20000
ORDER BY total_spent DESC;

-- Task 6
SELECT p.product_id, p.product_name, SUM(op.quantity) AS units_sold
FROM Products p
JOIN OrderProducts op ON op.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, p.product_name;

-- Task 7
SELECT DISTINCT p.product_id, p.product_name, p.category
FROM Products p
WHERE p.product_id IN (
    SELECT op.product_id
    FROM OrderProducts op
    JOIN Orders o ON o.order_id = op.order_id
    JOIN Customers c ON c.customer_id = o.customer_id
    WHERE c.name = 'Ali Khan'
)
ORDER BY p.product_name;

-- Task 8
SELECT o.order_id, c.name, o.total_amount
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
WHERE o.total_amount > (
    SELECT AVG(o2.total_amount)
    FROM Orders o2
    WHERE o2.customer_id = o.customer_id
)
ORDER BY c.name, o.total_amount DESC;

-- Task 9
SELECT c.customer_id, c.name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    JOIN OrderProducts op ON op.order_id = o.order_id
    JOIN Products p ON p.product_id = op.product_id
    WHERE o.customer_id = c.customer_id
      AND p.category = 'Accessories'
)
ORDER BY c.customer_id;

-- Task 10
SELECT p.product_id, p.product_name, p.category
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderProducts op
    WHERE op.product_id = p.product_id
)
ORDER BY p.product_name;

-- Challenge 1
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       p.category,
       SUM(op.quantity * op.unit_price) AS monthly_revenue
FROM Orders o
JOIN OrderProducts op ON o.order_id = op.order_id
JOIN Products p ON p.product_id = op.product_id
GROUP BY month, p.category
HAVING SUM(op.quantity * op.unit_price) > 50000
ORDER BY month, monthly_revenue DESC;

-- Challenge 2
SELECT c.customer_id, c.name
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) = 1;

-- Challenge 3
SELECT p.category, p.product_name, p.price
FROM Products p
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM Products p2
    WHERE p2.category = p.category
);

-- Challenge 4
SELECT c.customer_id, c.name, SUM(op.quantity * op.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;

-- Challenge 5
SELECT o.order_id, c.name, COUNT(DISTINCT p.category) AS category_count
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
JOIN OrderProducts op ON op.order_id = o.order_id
JOIN Products p ON p.product_id = op.product_id
GROUP BY o.order_id, c.name
HAVING COUNT(DISTINCT p.category) = 1;

SHOW TABLES;
SELECT * FROM Orders;