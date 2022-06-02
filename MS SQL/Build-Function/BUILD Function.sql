--=============Find Names of All Employees by First Name ==============

USE SoftUni

SELECT 
	FirstName,LastName 
FROM Employees
	WHERE FirstName LIKE 'Sa%'


--=======02. Find Names of All Employees by Last Name=========

SELECT 
	FirstName,LastName 
FROM Employees
	WHERE LastName LIKE '%ei%'



--=======03. Find First Names of All Employess==========


SELECT 
      [FirstName]
FROM Employees

WHERE DepartmentID IN (3,10) 
AND 
YEAR(HireDate)>= 1995 
AND 
YEAR(HireDate) <= 2005
ORDER BY EmployeeID;


---=======04. Find All Employees Except Engineers=========


SELECT 
	[FirstName],
	[LastName]
FROM Employees
WHERE JobTitle NOT LIKE '%Engineer%'


--=======05. Find Towns with Name Length===============


SELECT [Name] FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]




--===========06. Find Towns Starting With=========

SELECT * FROM Towns
WHERE [Name] LIKE 'M%' 
OR [Name] LIKE 'B%'
OR [Name] LIKE 'E%'
OR [Name] LIKE 'K%'

ORDER BY [Name]
	
--===========07. Find Towns Not Starting With===========


SELECT * FROM Towns
WHERE [Name]  NOT LIKE '[!rbd]%'

ORDER BY [Name]


--=========08. Create View Employees Hired After===========


CREATE VIEW [V_EmployeesHiredAfter2000] AS
 SELECT FirstName,LastName 
	FROM Employees
	WHERE YEAR(HireDate) > 2000


--========09. Length of Last Name==================


SELECT 
	FirstName,LastName 
FROM Employees
WHERE LEN(LastName)=5



--=============10. Rank Employees by Salary=============


SELECT   
EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID])
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC



--===========11. Find All Employees with Rank 2==============


SELECT *
	FROM (
	       SELECT   
		   EmployeeID,FirstName,LastName,Salary,
		   DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID])
		   AS [Rank]
		   FROM Employees
		   WHERE Salary BETWEEN 10000 AND 50000
		)
		AS [RankingSubQue]
    WHERE [Rank]=2
	ORDER BY Salary DESC


--=============12. Countries Holding 'A'==================

USE Geography

SELECT 
CountryName,IsoCode
FROM Countries  
--WHERE CountryName LIKE '%a%a%a%'
WHERE len(CountryName) - len(replace(CountryName, 'a', '')) =3
ORDER BY IsoCode 


--============13. Mix of Peak and River Names===============



SELECT p.PeakName,r.RiverName,
LOWER(CONCAT(LEFT(p.PeakName,LEN(p.PeakName)-1) ,r.RiverName))
AS Mix
FROM Rivers AS r,
Peaks AS p
WHERE RIGHT(p.PeakName,1)=LEFT(r.RiverName,1)
ORDER BY Mix


--===============14. Games From 2011 and 2012 Year=============

USE Diablo

SELECT TOP(50) 
[Name],FORMAT([Start],'yyyy-MM-dd') AS Start
		
FROM Games
WHERE  FORMAT([Start],'yyyy')= 2011
OR FORMAT([Start],'yyyy')= 2012
ORDER BY [Start],[Name]


--===========15. User Email Providers===============


SELECT Username, SUBSTRING(Email,CHARINDEX('@',Email,1)+1,LEN(Email)) 
AS 'Email Provider' 
FROM Users
ORDER BY [Email Provider], Username



--=========16. Get Users with IPAddress Like Pattern===========

SELECT Username,IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username




--===============17. Show All Games with Duration=============


SELECT
Name,
'Part of the Day'=CASE
WHEN DATEPART(HOUR,Start) BETWEEN 0 AND 11 THEN 'Morning' --Because between takes 12 inclusive
WHEN DATEPART(HOUR,Start) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(HOUR,Start) BETWEEN 18 AND 23 THEN 'Evening'
END
,
'Duration'=CASE
WHEN Duration <= 3 THEN 'Extra Short'
WHEN Duration BETWEEN 4 AND 6.00 THEN 'Short'
WHEN Duration > 6 THEN 'Long'
WHEN Duration IS NULL THEN 'Extra Long'
END
FROM Games
ORDER BY Name, Duration


---===============18. Orders Table==============


USE Orders

SELECT 
	[ProductName],
	[OrderDate],
	DATEADD(DAY,3,OrderDate) AS 'Pay Due',
    DATEADD(MONTH,1,OrderDate) AS 'Delivery Due'
FROM Orders



--================= People Table =========================

USE Orders

CREATE TABLE People
(
	ID INT IDENTITY PRIMARY KEY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Birthdate DATETIME NOT NULL
)

INSERT INTO People
VALUES
('Victor', '2000-12-07'),
('Steven', '1992-09-10'),
('Stephen', '1910-09-19'),
('John', '2010-01-06')


SELECT 
[NAME],
DATEDIFF(YEAR,Birthdate,GETDATE()) AS 'Age in Years',
DATEDIFF(MONTH,Birthdate,GETDATE()) AS 'Age in Months',
DATEDIFF(DAY,Birthdate,GETDATE()) AS 'Age in Days',
DATEDIFF(MINUTE,Birthdate,GETDATE()) AS 'Age in Minutes'
FROM People
