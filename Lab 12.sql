CREATE DATABASE Lab13;
USE Lab13;

CREATE TABLE Patients (
	PatientID INT PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	DOB DATE,
	Phone VARCHAR(20)
);

CREATE TABLE Doctors (
	DoctorID INT PRIMARY KEY,
	FullName VARCHAR(100),
	Specialization VARCHAR(100)
);

CREATE TABLE Appointments (
	ApptID INT PRIMARY KEY,
	PatientID INT,
	DoctorID INT,
	ApptDate DATE,
	Status VARCHAR(20),
	FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
	FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Treatments (
	TreatmentID INT PRIMARY KEY,
	ApptID INT,
	Description VARCHAR(200),
	Cost DECIMAL(10,2),
	FOREIGN KEY (ApptID) REFERENCES Appointments(ApptID)
);

CREATE TABLE Billing (
	BillID INT PRIMARY KEY,
	ApptID INT,
	TotalAmount DECIMAL(10,2),
	PaymentStatus VARCHAR(20),
	FOREIGN KEY (ApptID) REFERENCES Appointments(ApptID)
);

CREATE TABLE AuditLogs (
	log_id BIGINT PRIMARY KEY AUTO_INCREMENT,
	action_type VARCHAR(50),
	table_name VARCHAR(50),
	record_id BIGINT,
	old_value VARCHAR(255),
	new_value VARCHAR(255),
	change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Notifications (
	notification_id BIGINT PRIMARY KEY,
	appointment_id BIGINT,
	message VARCHAR(255),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DoctorAvailability (
	doctor_id BIGINT,
	available_date DATE,
	is_available TINYINT(1) DEFAULT 1,
	PRIMARY KEY (doctor_id, available_date)
 );

CREATE TABLE PatientsArchive (
	patient_id BIGINT PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	dob DATE,
	phone VARCHAR(20),
	archived_on DATETIME
);

INSERT INTO Patients VALUES
(1,'Ali','Khan','1998-04-12','0300123456'),
(2,'Sara','Malik','2000-10-05','0300654321');

INSERT INTO Doctors VALUES
(10,'Dr. Hamid Ali','Cardiology'),
(20,'Dr. Ayesha Siddiq','Dermatology');

INSERT INTO DoctorAvailability (doctor_id, available_date, is_available) VALUES
(1, '2025-03-20', 1),
(1, '2025-03-21', 1),
(1, '2025-03-22', 0), 
(2, '2025-03-20', 1),
(2, '2025-03-21', 0), 
(3, '2025-03-20', 1),
(3, '2025-03-21', 1);

INSERT INTO Patients (patient_id, first_name, last_name, dob, phone) VALUES
(999, 'Old', 'Patient', '1980-01-01', '0300-0000000');

INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(9991, 999, 1, '2021-01-10', 'Completed');

-- Task 1
DELIMITER $$
	CREATE TRIGGER ValidateTreatmentCost
	BEFORE INSERT ON Treatments
	FOR EACH ROW
		BEGIN
		IF NEW.cost < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Treatment cost cannot be negative.';
		END IF;
	END $$
DELIMITER;

-- Task 2
DELIMITER $$
	CREATE TRIGGER LogAppointmentInsert
	AFTER INSERT ON Appointments
	FOR EACH ROW
		BEGIN
		INSERT INTO AuditLogs(action_type, table_name, record_id, new_value)
		VALUES ('INSERT', 'Appointments', NEW.appointment_id, NEW.status);
	END $$
DELIMITER ;

-- Task 3
DELIMITER $$
	CREATE TRIGGER PreventCompletedUpdate
	BEFORE UPDATE ON Appointments
	FOR EACH ROW
		BEGIN
		IF OLD.status = 'Completed' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cannot modify a completed appointment.';
		END IF;
END $$
DELIMITER ;

-- Task 4
DELIMITER $$
	CREATE TRIGGER LogStatusUpdate
	AFTER UPDATE ON Appointments
		FOR EACH ROW
		BEGIN
		IF OLD.status <> NEW.status THEN
		INSERT INTO AuditLogs(action_type, table_name, record_id, old_value, new_value)
		VALUES ('UPDATE', 'Appointments', NEW.appointment_id, OLD.status, NEW.status);
		END IF;
	END $$
DELIMITER ;

-- Task 5
DELIMITER $$
	CREATE TRIGGER BlockDoctorDelete
	BEFORE DELETE ON Doctors
		FOR EACH ROW
		BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Doctors cannot be deleted due to dependency.';
	END $$
DELIMITER ;

-- Task 6
DELIMITER $$
	CREATE TRIGGER LogTreatmentDelete
	AFTER DELETE ON Treatments
		FOR EACH ROW
		BEGIN
		INSERT INTO AuditLogs(action_type, table_name, record_id, old_value)
		VALUES ('DELETE', 'Treatments', OLD.treatment_id, OLD.description);
	END $$
DELIMITER ;

-- Task 7
DELIMITER $$
	CREATE TRIGGER SetDefaultStatus
	BEFORE INSERT ON Appointments
		FOR EACH ROW
		BEGIN
		IF NEW.status IS NULL THEN
		SET NEW.status = 'Pending';
		END IF;
	END $$
DELIMITER ;

-- Task 8
CREATE EVENT IF NOT EXISTS CleanCancelledAppointments
ON SCHEDULE EVERY 1 DAY
DO
	DELETE FROM Appointments
	WHERE status = 'Cancelled'
	AND appointment_date < CURDATE() - INTERVAL 30 DAY;

-- Task 9
CREATE TABLE IF NOT EXISTS DailyRevenue (
	report_date DATE PRIMARY KEY,
	total_revenue DECIMAL(10,2)
);

CREATE EVENT IF NOT EXISTS DailyRevenueReport
ON SCHEDULE EVERY 1 DAY
DO
	INSERT INTO DailyRevenue(report_date, total_revenue)
	SELECT CURDATE(), SUM(cost) FROM Treatments;

-- Task 10
SET GLOBAL event_scheduler = OFF;
SET GLOBAL event_scheduler = ON;

-- Challenge 1


-- Challenge 2


-- Challenge 3


-- Challenge 4


-- Challenge 5