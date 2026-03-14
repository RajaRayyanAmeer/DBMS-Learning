CREATE DATABASE lab4;
USE lab4;

CREATE TABLE product (
	product_id INT PRIMARY KEY,
    name VARCHAR (30),
    quantity INT,
    price DECIMAL (10,2) CHECK (price > 0)
);

CREATE TABLE supplier (
	supplier_id INT PRIMARY KEY,
    name VARCHAR (30),
    contact VARCHAR (20)
);

ALTER TABLE product
ADD supplier_id INT,
ADD FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id);

CREATE TABLE employee (
	emp_id INT PRIMARY KEY,
    name VARCHAR (30) NOT NULL,
    role VARCHAR (30) CHECK (role IN ('Cashier','Manager','Stocker')),
    hire_date DATE CHECK (hire_date <= CURRENT_DATE)
);

CREATE TABLE customer (
	customer_id INT PRIMARY KEY,
    name VARCHAR(30),
    email VARCHAR(30) UNIQUE,
    phone_number VARCHAR(20) UNIQUE,
    address VARCHAR(200)
);

CREATE TABLE `order` (
	order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

CREATE TABLE order_product (
	order_id INT,
    product_id INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES `order` (order_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id)
);

ALTER TABLE product MODIFY quantity INT CHECK (quantity > 0);  

ALTER TABLE `Order` 
ADD status VARCHAR(20) DEFAULT 'Pending';

ALTER TABLE `Order` RENAME COLUMN status TO order_status;

SHOW TABLES;