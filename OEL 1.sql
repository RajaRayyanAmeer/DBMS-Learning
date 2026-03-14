CREATE DATABASE OEL_Lab9;
USE OEL_Lab9;

CREATE TABLE clients (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    membership_level VARCHAR(50),
    joined_date DATE
);

CREATE TABLE barbers (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    experience_years INT,
    salary INT
);

CREATE TABLE barber_services (
    id INT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    duration_minutes INT,
    service_level VARCHAR(50)
);

CREATE TABLE bookings (
    id INT PRIMARY KEY,
    client_id INT NOT NULL,
    barber_id INT NOT NULL,
    service_id INT NOT NULL,
    booking_date DATETIME,
    status VARCHAR(50),

    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (barber_id) REFERENCES barbers(id),
    FOREIGN KEY (service_id) REFERENCES barber_services(id)
);

CREATE TABLE transactions (
    id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount INT,
    payment_method VARCHAR(50),
    payment_date DATETIME,

    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

INSERT INTO clients (id, name, phone, membership_level, joined_date)
VALUES (1, 'Ali Khan', '03001234567', 'Regular', '2025-01-01');

INSERT INTO barbers (id, name, specialty, experience_years, salary)
VALUES (1, 'Kamran', 'Fade Haircut', 5, 35000);

INSERT INTO barber_services (id, service_name, price, duration_minutes, service_level)
VALUES (1, 'Classic Haircut', 800, 30, 'Basic');

INSERT INTO bookings (id, client_id, barber_id, service_id, booking_date, status)
VALUES (1, 1, 1, 1, '2025-01-05 15:00:00', 'Booked');

INSERT INTO transactions (id, booking_id, amount, payment_method, payment_date)
VALUES (1, 1, 800, 'Cash', '2025-01-05 15:30:00');

SELECT * FROM clients;

SELECT b.id, c.name AS client_name, s.service_name, b.booking_date, b.status
FROM bookings b
JOIN clients c ON b.client_id = c.id
JOIN barber_services s ON b.service_id = s.id;

SELECT SUM(amount) AS total_earnings
FROM transactions;

CREATE INDEX idx_bookings_client ON bookings(client_id);
CREATE INDEX idx_bookings_barber ON bookings(barber_id);
CREATE INDEX idx_bookings_service ON bookings(service_id);
CREATE INDEX idx_clients_phone ON clients(phone);
CREATE INDEX idx_barbers_specialty ON barbers(specialty);

EXPLAIN
SELECT b.id, c.name AS client_name, s.service_name, b.booking_date, b.status
FROM bookings b
JOIN clients c ON b.client_id = c.id
JOIN barber_services s ON b.service_id = s.id;

CREATE VIEW view_booking_details AS
SELECT b.id, c.name, s.service_name, b.booking_date, b.status
FROM bookings b
JOIN clients c ON b.client_id = c.id
JOIN barber_services s ON b.service_id = s.id;

CREATE VIEW view_client_info AS
SELECT name, phone, membership_level
FROM clients;