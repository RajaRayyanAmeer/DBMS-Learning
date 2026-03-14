CREATE TABLE students (
  student_id INT PRIMARY KEY,
  name VARCHAR(50),
  dob DATE,
  email VARCHAR(50) UNIQUE,
  program VARCHAR(50),
  gpa DECIMAL(3,2),
  dept_id INT
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  title VARCHAR(50),
  credit_hours int
);

CREATE TABLE faculty (
  faculty_id INT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  dept_id INT
);

CREATE TABLE enrollments (
  student_id INT,
  course_id INT,
  instructor_id INT,
  semester VARCHAR(15),
  grade CHAR(2),
  PRIMARY KEY (student_id, course_id, instructor_id)
);

CREATE TABLE library_accounts (
  account_id INT,
  student_id INT,
  issue_date DATE,
  expiry_date DATE,
  PRIMARY KEY (account_id, student_id)
);

CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(255)
);

ALTER TABLE students
ADD FOREIGN KEY (dept_id)
REFERENCES departments (dept_id);

ALTER TABLE faculty
ADD FOREIGN KEY (dept_id)
REFERENCES departments (dept_id);

ALTER TABLE enrollments
ADD FOREIGN KEY (student_id)
REFERENCES students (student_id);

ALTER TABLE enrollments
ADD FOREIGN KEY (course_id)
REFERENCES courses (course_id);

ALTER TABLE enrollments
ADD FOREIGN KEY (instructor_id)
REFERENCES faculty (faculty_id);

ALTER TABLE library_accounts
ADD FOREIGN KEY (student_id)
REFERENCES students (student_id);