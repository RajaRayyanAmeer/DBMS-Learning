CREATE DATABASE Lab11;
USE Lab11;

CREATE TABLE Departments (
 DeptID INT PRIMARY KEY,
 DeptName VARCHAR(100) NOT NULL
);

CREATE TABLE Students (
 StudentID INT PRIMARY KEY,
 FirstName VARCHAR(50),
 LastName VARCHAR(50),
 BirthDate DATE,
 Email VARCHAR(100) UNIQUE,
 DeptID INT,
 FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Courses (
 CourseID INT PRIMARY KEY,
 CourseName VARCHAR(100),
 CreditHours INT,
 DeptID INT,
 FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Enrollments (
 EnrollmentID INT PRIMARY KEY,
 StudentID INT,
 CourseID INT,
 Semester VARCHAR(20),
 Grade VARCHAR(5),
 FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
 FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments VALUES
(1, 'Computer Engineering'),
(2, 'Electrical Engineering'),
(3, 'Mechanical Engineering');

INSERT INTO Students VALUES
(1, 'Ali', 'Khan', '2003-04-12', 'ali.khan@example.com', 1),
(2, 'Sara', 'Malik', '2002-09-20', 'sara.malik@example.com', 1),
(3, 'Hamza', 'Yousaf', '2001-01-15', 'hamza.y@example.com', 2),
(4, 'Ayesha', 'Raza', '2000-11-08', 'ayesha.raza@example.com', 3);

INSERT INTO Courses VALUES
(101, 'Database Systems', 3, 1),
(102, 'Programming Fundamentals', 3, 1),
(201, 'Circuit Analysis', 4, 2),
(301, 'Thermodynamics', 3, 3);

INSERT INTO Enrollments VALUES
(1, 1, 101, 'Fall 2024', 'A'),
(2, 1, 102, 'Fall 2024', 'B'),
(3, 2, 101, 'Fall 2024', 'A'),
(4, 3, 201, 'Fall 2024', 'C'),
(5, 4, 301, 'Fall 2024', 'B');

-- Task 1
START TRANSACTION;
UPDATE Students SET FirstName='Ali_R' WHERE StudentID=1;
SELECT * FROM Students WHERE StudentID=1;

-- Task 2
COMMIT;
SELECT * FROM Students WHERE StudentID=1;

-- Task 3
START TRANSACTION;
UPDATE Students SET LastName='RollbackTest' WHERE StudentID=2;
ROLLBACK;
SELECT * FROM Students WHERE StudentID=2;

-- Task 4
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Students SET FirstName='DirtyName' WHERE StudentID=3;
-- Session 2
SELECT FirstName FROM Students WHERE StudentID=3;

-- Task 5
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT Grade FROM Enrollments WHERE EnrollmentID=1;
-- Session 2
UPDATE Enrollments SET Grade='A+' WHERE EnrollmentID=1;
COMMIT;
-- Session 1 Again
SELECT Grade FROM Enrollments WHERE EnrollmentID=1;

-- Task 6
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM Enrollments WHERE CourseID=101;
-- Session 2
INSERT INTO Enrollments VALUES (10, 2, 101, 'Fall 2024','B');
COMMIT;
-- Session 1 Again
SELECT * FROM Enrollments WHERE CourseID=101;

-- Task 7
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Task 8
START TRANSACTION;
UPDATE Students SET Email='temp@example.com' WHERE StudentID=1;
SAVEPOINT sp1;
UPDATE Students SET Email='temp2@example.com' WHERE StudentID=1;
ROLLBACK TO sp1;
COMMIT;

-- Task 9
START TRANSACTION;
SELECT * FROM Students WHERE StudentID=1 FOR UPDATE;

-- Task 10
-- Session 1
START TRANSACTION;
UPDATE Students SET FirstName='Blocked' WHERE StudentID=4;
-- Session 2
UPDATE Students SET FirstName='Waiting' WHERE StudentID=4;

-- Challenge 1
-- Session 1
START TRANSACTION;
UPDATE Students SET FirstName='Lock1' WHERE StudentID=1;
-- Session 2
START TRANSACTION;
UPDATE Students SET LastName='Lock2' WHERE StudentID=2;
-- Session 1 Again
UPDATE Students SET LastName='Dead1' WHERE StudentID=2;
-- Session 2 Again
UPDATE Students SET FirstName='Dead2' WHERE StudentID=1;

-- Challenge 2
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

SELECT * FROM Enrollments WHERE CourseID=101;
-- Session 2
INSERT INTO Enrollments VALUES (20, 1, 101, 'Fall 2024', 'A');
COMMIT;
-- Session 1 Again
SELECT * FROM Enrollments WHERE CourseID=101;
COMMIT;

-- Challenge 3
START TRANSACTION;
UPDATE Students SET Email='stage1@example.com' WHERE StudentID=1;
SAVEPOINT sp1;

UPDATE Students SET Email='stage2@example.com' WHERE StudentID=1;
SAVEPOINT sp2;

UPDATE Students SET Email='stage3@example.com' WHERE StudentID=1;

-- Undo last update only
ROLLBACK TO sp2;

-- Keep stage2, continue work
UPDATE Students SET Email='final@example.com' WHERE StudentID=1;
COMMIT;

-- Challenge 4
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;

SELECT * FROM Enrollments WHERE CourseID=201;
-- Session 2
INSERT INTO Enrollments VALUES (30, 3, 201, 'Fall 2024', 'B');
-- Session 1 Again
COMMIT;

-- Challenge 5
-- Part A: Lost Update
-- Session 1
START TRANSACTION;
SELECT FirstName FROM Students WHERE StudentID=4;
-- Session 2
START TRANSACTION;
SELECT FirstName FROM Students WHERE StudentID=4;
-- Session 1 Again
UPDATE Students SET FirstName='Change1' WHERE StudentID=4;
COMMIT;
-- Session 2 Again
UPDATE Students SET FirstName='Change2' WHERE StudentID=4;
COMMIT;

-- Part B: Fix Lost Update
-- Session 1
START TRANSACTION;
SELECT FirstName FROM Students WHERE StudentID=4 FOR UPDATE;
-- Session 2
START TRANSACTION;
SELECT FirstName FROM Students WHERE StudentID=4 FOR UPDATE;
-- Session 1 Again
UPDATE Students SET FirstName='Safe1' WHERE StudentID=4;
COMMIT;
-- Session 2 Again
-- Now row is free
UPDATE Students SET FirstName='Safe2' WHERE StudentID=4;
COMMIT;