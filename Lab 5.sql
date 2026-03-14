CREATE DATABASE Lab5;
USE Lab5;

-- Task1
CREATE TABLE Customer (
	customer_id INT PRIMARY KEY,
    name VARCHAR (100) NOT NULL,
    email VARCHAR (100) NOT NULL UNIQUE,
    phone VARCHAR (20)
);

-- Task 2
CREATE TABLE Product (
	product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    stock INT DEFAULT 0
);

-- Task 3
CREATE TABLE Orders (
	order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (ustomer_id) REFERENCES Customer (customer_id)
);

-- Task 4
ALTER TABLE Orders
DROP FOREIGN KEY Orders_ibfk_1;

ALTER TABLE Orders 
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Task 5
CREATE TABLE OrderProduct (
	order_id INT,
    product_id INT,
    quantity INT CHECK (quantity >= 1),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders (order_id),
    FOREIGN KEY (product_id) REFERENCES Product (product_id)
);

-- Task 6
CREATE TABLE Employee (
	emp_id INT PRIMARY KEY,
    name VARCHAR (100) NOT NULL,
    role ENUM ('Manager', 'Cashier', 'Stocker'),
    hire_date DATE CHECK (hire_date <= CURRENT_DATE)
);

-- Task 7
ALTER TABLE Orders
ADD STATUS VARCHAR (20) DEFAULT 'Pending';

-- Task 8
SHOW TABLES;
DESCRIBE Orders;
SHOW CREATE TABLE OrderProduct;

-- Task 9
INSERT INTO Customer VALUES (1, 'Alice', 'alice@example.com', '12345');
INSERT INTO Customer VALUES (2, 'Bob', 'alice@example.com', '67890');

-- Task 10
ALTER TABLE Orders
MODIFY status VARCHAR (20) NOT NULL DEFAULT 'Pending';

ALTER TABLE Orders
CHANGE status order_status VARCHAR (20) NOT NULL;

-- Lab Challenge 1
CREATE TABLE Supplier (
	supplier_id INT PRIMARY KEY,
    name VARCHAR (100) NOT NULL
);

ALTER TABLE Product
ADD supplier_id INT,
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES Supplier (supplier_id)
ON DELETE SET NULL;

-- Lab Challenge 2
ALTER TABLE Product
ADD CONSTRAINT chk_stock_non_negative
CHECK (stock >= 0);

-- Lab Challenge 3
ALTER TABLE OrderProduct
ADD CONSTRAINT chk_quantity CHECK (quantity <= stock);

-- Lab Challenge 4
ALTER TABLE Employee
CHANGE hire_date date_hired DATE;

-- Lab Challenge 5
ALTER TABLE OrderProduct
DROP FOREIGN KEY Orders_ibfk_1;

ALTER TABLE OrderProduct
ADD CONSTRAINT fk_orderproduct
FOREIGN KEY (Order_id) REFERENCES Orders (Order_id)
ON DELETE CASCADE;