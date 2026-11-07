CREATE TABLE employee ( 
    employee_id INT PRIMARY KEY, 
    employee_name VARCHAR(100), 
    department VARCHAR(100), 
    salary DECIMAL(10, 2) 
); 


INSERT INTO employee (employee_id, employee_name, 
department, salary)  
VALUES  
(1, 'Alice', 'HR', 50000.00), 
(2, 'Bob', 'Finance', 60000.00), 
(3, 'Charlie', 'Finance', 55000.00), 
(4, 'David', 'HR', 45000.00), 
(5, 'Eve', 'IT', 70000.00), 
(6, 'Frank', 'IT', 65000.00), 
(7, 'Grace', 'HR', 50000.00), 
(8, 'Heidi', 'Finance', 75000.00), 
(9, 'Ivan', 'IT', 72000.00), 
(10, 'Judy', 'HR', 51000.00); 

select * from employee

select 
    employee_id,
    employee_name,
    department,
    salary,
    row_number()over (partition by department order by salary desc )as rownumber 
from employee;


