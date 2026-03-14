CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(20),
    year INT,
    vehicle_type VARCHAR(20),   
    number_of_doors INT,        
    load_capacity INT,          
    engine_capacity VARCHAR(20) 
);

INSERT INTO Vehicle (vehicle_id, brand, model, year, vehicle_type, number_of_doors)
VALUES (1, 'Toyota', 'Corolla', 2022, 'Car', 4);

INSERT INTO Vehicle (vehicle_id, brand, model, year, vehicle_type, load_capacity)
VALUES (2, 'Volvo', 'FH16', 2021, 'Truck', 20000);

INSERT INTO Vehicle (vehicle_id, brand, model, year, vehicle_type, engine_capacity)
VALUES (3, 'Honda', 'CBR500R', 2023, 'Motorbike', '500cc');

SELECT * FROM Vehicle;

SELECT vehicle_id, brand, model, year, number_of_doors
FROM Vehicle
WHERE vehicle_type = 'Car';

SELECT vehicle_id, brand, model, year, load_capacity
FROM Vehicle
WHERE vehicle_type = 'Truck';

SELECT vehicle_id, brand, model, year, engine_capacity
FROM Vehicle
WHERE vehicle_type = 'Motorbike';

CREATE TABLE Employee (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50),
  join_date DATE
);

CREATE Table TeachingStaff (
  emp_id INT PRIMARY KEY,
  FOREIGN KEY(emp_id)
  REFERENCES Employee(emp_id),
  subject_specialization VARCHAR(50)
);

CREATE TABLE NonTeachingStaff (
  emp_id INT PRIMARY KEY,
  FOREIGN KEY (emp_id)
  REFERENCES Employee(emp_id),
  department VARCHAR(50)
);

CREATE TABLE ContractStaff (
  emp_id INT PRIMARY KEY,
  FOREIGN KEY (emp_id)
  REFERENCES Employee(emp_id),
  contract_duration VARCHAR(20)
);

SELECT e.emp_id, e.name, e.join_date
FROM Employee e
WHERE e.emp_id NOT IN(
	SELECT emp_id
    FROM TeachingStaff
    UNION
    
    SELECT emp_id
    FROM NonTeachingStaff
    UNION
    
    SELECT emp_id
    FROM ContractStaff
);