USE MetroAlt;


    --Create a derived table that returns the position name as position and count of employees at that position. 
	--(I know that this can be done as a simple join, but do it in the format of a derived table. There still will 
	--be a join in the subquery portion).


    --Create a derived table that returns a column HireYear and the count of employees who were hired that year. 
	--(Same comment as above).


    --Redo problem 1 as a Common Table Expression (CTE).


    --Redo problem 2 as a CTE.


    --Create a CTE that takes a variable argument called @BusBarn and returns the count of busses grouped by the 
	--description of that bus type at a particular Bus barn. Set @BusBarn to 3.


    --Create a View of Employees for Human Resources it should contain all the information in the Employee table 
	--plus their position and hourly pay rate


    --Alter the view in 6 to bind the schema


    --Create a view of the Bus Schedule assignment that returns the Shift times, The Employee first and last name, 
	--the bus route (key) and the Bus (key). Use the view to list the shifts for Neil Pangle in October of 2014


    --Create a table valued function that takes a parameter of city and returns all the employees who live in that city


    --Use the cross apply operator to return the last 3 routes driven by each driver
