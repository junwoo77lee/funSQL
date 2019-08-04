-- Create tables and Load each csv file to the proper table
CREATE TABLE Departments (
    dept_no VARCHAR(30)  NOT NULL PRIMARY KEY,
    dept_name VARCHAR(30)   NOT NULL
);

CREATE TABLE Dept_emp (
    emp_no int   NOT NULL,
    dept_no VARCHAR(30) NOT NULL REFERENCES Departments (dept_no),
    from_date date   NOT NULL,
    to_date date   NOT NULL,
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE Dept_manager (
    dept_no VARCHAR(30)   NOT NULL REFERENCES Departments (dept_no),
    emp_no int   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL,
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE Salaries (
    emp_no int   NOT NULL PRIMARY KEY,
    salary int   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL
);


CREATE TABLE Employees (
    emp_no int   NOT NULL PRIMARY KEY,
    birth_date date   NOT NULL,
    first_name VARCHAR(30)   NOT NULL,
    last_name VARCHAR(30)   NOT NULL,
    gender VARCHAR(10)   NOT NULL,
    hire_date date   NOT NULL
);

CREATE TABLE Titles (
    emp_no int   NOT NULL,
    title VARCHAR(30)   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL,
	PRIMARY KEY (emp_no, title, from_date)
);

-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT e.emp_no,
	   e.last_name,
	   e.first_name,
	   e.gender,
	   s.salary
FROM employees e
LEFT JOIN salaries s ON e.emp_no = s.emp_no
LIMIT 5;

-- 2. List employees who were hired in 1986.
SELECT e.emp_no,
	   e.last_name,
	   e.first_name,
	   e.gender,
	   EXTRACT (year from hire_date) AS hire_year
FROM employees e
WHERE EXTRACT (year from hire_date) = 1986;

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT d.dept_no,
	   d.dept_name,
	   dm.emp_no,
	   e.last_name,
	   e.first_name,
	   de.from_date AS Employment_start_date,
	   de.to_date AS Employment_end_date
FROM dept_manager dm
LEFT JOIN departments d ON dm.dept_no = d.dept_no
LEFT JOIN employees e ON dm.emp_no = e.emp_no
LEFT JOIN dept_emp de ON dm.emp_no = de.emp_no AND dm.dept_no = de.dept_no;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT de.emp_no,
	   e.last_name,
	   e.first_name,
	   d.dept_name
FROM dept_emp de
LEFT JOIN employees e ON de.emp_no = e.emp_no
LEFT JOIN departments d ON de.dept_no = d.dept_no

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
SELECT *
FROM employees e
WHERE e.first_name = 'Hercules' AND
      e.last_name LIKE 'B%'

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT de.emp_no,
	   e.last_name,
	   e.first_name,
	   d.dept_name
FROM dept_emp de
LEFT JOIN employees e ON de.emp_no = e.emp_no
LEFT JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT de.emp_no,
	   e.last_name,
	   e.first_name,
	   d.dept_name
FROM dept_emp de
LEFT JOIN employees e ON de.emp_no = e.emp_no
LEFT JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR
	  d.dept_name = 'Development'

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT e.last_name, COUNT(1) AS frequency_of_last_name
FROM employees e
GROUP BY 1
ORDER BY 2 DESC
