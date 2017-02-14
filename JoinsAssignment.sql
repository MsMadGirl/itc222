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
SELECT EmployeeLastName, EmployeeFirstName, EmployeeEmail, PositionName, EmployeeHourlyPayRate
FROM Employee e
INNER JOIN EmployeePosition ep
ON e.EmployeeKey = e.EmployeeKey
INNER JOIN Position p
ON p.PositionKey = ep.PositionKey;

--List the bus driver’s last name  the shift times, the bus number (key)  and the bus type
SELECT EmployeeLastName, BusDriverShiftStartTime, BusDriverShiftStopTime, b.BusKey, BusTypekey
FROM Employee e
INNER JOIN BusScheduleAssignment bsa
ON bsa.EmployeeKey = e.EmployeeKey
INNER JOIN BusDriverShift bds
ON bsa.BusDriverShiftKey = bds.BusDriverShiftKey
INNER JOIN Bus b
ON bsa.BusKey = b.BusKey
INNER JOIN EmployeePosition ep
ON e.EmployeeKey = ep.EmployeeKey
WHERE ep.PositionKey = 1;

--for each bus on route 43
SELECT EmployeeLastName, BusDriverShiftStartTime, BusDriverShiftStopTime, b.BusKey, BusTypekey, bsa.BusRouteKey
FROM Employee e
INNER JOIN BusScheduleAssignment bsa
ON bsa.EmployeeKey = e.EmployeeKey
INNER JOIN BusDriverShift bds
ON bsa.BusDriverShiftKey = bds.BusDriverShiftKey
INNER JOIN Bus b
ON bsa.BusKey = b.BusKey
INNER JOIN EmployeePosition ep
ON e.EmployeeKey = ep.EmployeeKey
WHERE ep.PositionKey = 1 
AND bsa.BusRouteKey = 43;

--Return all the positions that no employee holds.
SELECT PositionName, ep.PositionKey
FROM Position p
LEFT OUTER JOIN EmployeePosition ep
ON p.PositionKey = ep.PositionKey
WHERE ep.PositionKey IS NULL;

--Get the employee key, first name, last name, position key for every driver (position key=1) who has never been assigned to a shift. 
SELECT e.EmployeeKey, EmployeeFirstName, EmployeeLastName, ep.PositionKey
FROM Employee e
INNER JOIN EmployeePosition ep
ON e.EmployeeKey = ep.EmployeeKey
LEFT OUTER JOIN BusScheduleAssignment bsa
ON e.EmployeeKey = bsa.EmployeeKey
WHERE ep.PositionKey = 1
AND bsa.EmployeeKey IS NULL;

