CREATE DATABASE college;
USE college;

CREATE TABLE students (
	student_id INT PRIMARY KEY,
    name VARCHAR(100),
    dob DATE,
    program VARCHAR(50)
);

CREATE TABLE courses (
	course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100),
    credit_hours int
);

CREATE TABLE enrollments (
	student_id INT,
    course_id VARCHAR(10),
    semester VARCHAR(10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students VALUES (1, 'Ali Khan', '2000-05-12', 'Computer Engineering');
INSERT INTO students VALUES (2, 'Sara Ahmed', '2001-09-23', 'Software Engineering');

INSERT INTO courses VALUES ('CS101', 'Databases', 3);
INSERT INTO courses VALUES ('CS102', 'Programming', 4);

INSERT INTO enrollments VALUES (1, 'CS101', 'Fall2023');
INSERT INTO enrollments VALUES (2, 'CS102', 'Fall2023');

SELECT *
FROM students;

SELECT s.name, c.title, e.semester
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

DESCRIBE students;

ALTER TABLE students
ADD email VARCHAR(100);

ALTER TABLE students
DROP COLUMN email;

ALTER TABLE students
ADD email VARCHAR(100) UNIQUE;

CREATE TABLE departments(
	dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);
ALTER TABLE students
ADD dept_id INT,
ADD CONSTRAINT fk_dept
FOREIGN KEY (dept_id) REFERENCES students(students_id)

DROP FROM courses WHERE course_id = 'CS101';

UPDATE students
SET program = 'Data Science'
WHERE student_id = 1;
SELECT * FROM students WHERE student_id = 1;
 
SELECT program, COUNT(*) AS total_students
FROM students
GROUP BY program;