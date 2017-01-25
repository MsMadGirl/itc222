USE MetroAlt

SELECT * FROM Employee;

SELECT EmployeeLastName, EmployeeFirstName, EmployeeEmail
FROM Employee;

SELECT * FROM Employee
ORDER BY EmployeeLastName;

SELECT * FROM Employee
ORDER BY EmployeeHireDate desc;

SELECT * FROM Employee 
WHERE EmployeeCity = 'Seattle';

SELECT * FROM Employee 
WHERE EmployeeCity != 'Seattle';

SELECT * FROM Employee 
WHERE EmployeePhone IS NULL;

SELECT * FROM Employee 
WHERE EmployeePhone IS NOT NULL;

SELECT * FROM Employee 
WHERE EmployeeLastName like 'C%';

SELECT EmployeeKey, EmployeeHourlyPayRate 
FROM EmployeePosition
ORDER BY EmployeeHourlyPayRate desc;

SELECT EmployeeKey, EmployeeHourlyPayRate 
FROM EmployeePosition
WHERE PositionKey = 2;

SELECT TOP 10 EmployeeKey, EmployeeHourlyPayRate 
FROM EmployeePosition
WHERE PositionKey = 2;

SELECT EmployeeKey, EmployeeHourlyPayRate 
FROM EmployeePosition
WHERE PositionKey = 2
ORDER BY EmployeeKey
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;

SELECT DISTINCT EmployeeKey, BusRouteKey 
FROM BusScheduleAssignment;