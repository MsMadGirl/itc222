USE MetroAlt


--Create a cross join between employees and bus routes to show all possible combinations of routes and drivers 
--(better use position to distinguish only drivers this involves a cross join and an inner join. I will accept either)
SELECT EmployeeLastName, BusRouteKey
FROM Employee
CROSS JOIN BusRoute
CROSS JOIN EmployeePosition
WHERE EmployeePosition.PositionKey = 1;

--List all the bus type details for each bus assigned to bus barn 3
SELECT * 
FROM Bustype
CROSS JOIN Bus
WHERE BusBarnKey = 3;

--What is the total cost of all the busses at bus barn 3
SELECT SUM(BusTypePurchasePrice) as TOTAL
FROM Bustype
CROSS JOIN Bus
WHERE BusBarnKey = 3;

--What is the total cost per type of bus at bus barn 3
SELECT SUM(BusTypePurchasePrice) as TOTAL
FROM Bustype
CROSS JOIN Bus
WHERE BusBarnKey = 3
GROUP BY Bustype.BustypeKey;

--List the last name, first name, email, position name and hourly pay for each employee
SELECT EmployeeLastName, EmployeeFirstName, EmployeeEmail
FROM 

--List the bus driver’s last name  the shift times, the bus number (key)  and the bus type


--for each bus on route 43


--Return all the positions that no employee holds.


--Get the employee key, first name, last name, position key for every driver (position key=1) who has never been assigned to a shift. 