--subqueries
USE Community_Assist

--inner joins and subqueries do many of the same things
SELECT PersonlastName, PersonFirstName, EmployeeHireDate, PositionName
from person p
inner join Employee e
on p.PersonKey = e.PersonKey
INNER JOIN EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
INNER JOIN Position po
on po.PositionKey = ep.PositionKey;

--subquery similar to inner join looks like:
SELECT Max(DonationAmount) FROM Donation;

SELECT Donationkey, DonationDate, PersonKey, DonationAmount
FROM Donation
WHERE DonationAmount = (Select Max(DonationAmount) from Donation);

SELECT GrantTypeName FROM GrantType
WHERE GrantTypeKey not in (SELECT GrantTypeKey from GrantRequest);

--subquery
SELECT PersonlastNamte, PersonFirstName, PersonEmail
FROM Person
WHERE PersonKey in (SELECT PersonKey FROM Employee);
--inner join that does the same as subquery
SELECT PersonLastName, PersonFirstName, PersonEmail
FROM Person
INNER JOIN Employee
on Person.PersonKey = Employee.PersonKey;

SELECT PersonFirstName, PersonLastName
FROM Person
WHERE PersonKey in (SELECT PersonKey FROM Employee 
WHERE EmployeeKey in (SELECT EmployeeKey FROM GrantReview 
WHERE GrantRequestStatus = 'Denied'));

--subquery in select statement, formatting
SELECT GrantTypeName, format(Sum(GrantRequestAmount), '$ #,##0.00') as Subtotal,
format((Select Sum(GrantRequestAmount) FROM GrantRequest), '$ #,##0.00') as Total,
format(Sum(GrantRequestAmount) / (Select Sum(GrantRequestAmount) FROM GrantRequest), '#0.00%') as Percentage
From GrantRequest gr
INNER JOIN GrantType gt
on gr.GrantTypeKey=gt.GrantTypeKey
GROUP BY GrantTypeName;

--just for reference
SELECT GrantTypeKey, AVG(GrantRequestAmount)
FROM GrantRequest
GROUP BY GrantTypeKey;

--correlated subquery
--compares thing in inner query to thing in outer query
SELECT GrantTypeKey, GrantRequestAmount
FROM GrantRequest gr1
WHERE GrantRequestAmount >
(SELECT AVG(GrantRequestAmount)
FROM GrantRequest gr2
WHERE gr1.GrantTypeKey = gr2.GrantTypeKey);

