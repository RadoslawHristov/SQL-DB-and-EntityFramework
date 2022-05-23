USE SoftUni

--===============Find All the Information About Departments==============
SELECT * FROM Departments

--==========Find all Department Names=======

SELECT [NAME] FROM Departments

--=========Find Salary of Each Employee============

SELECT [FirstName],[LastName],[Salary] FROM Employees


--=========Find Full Name of Each Employee==========

SELECT  FirstName, MiddleName,LastName FROM Employees

--=========Find Email Address of Each Employee========


SELECT 
   CONCAT(FirstName,'.',LastName+'@softuni.bg')
   AS [Full Email Address]FROM Employees


--==========Find All Different Employees’ Salaries=========


SELECT  
	DISTINCT Salary 
	FROM Employees
    

--==========Find All Information About Employees===========

SELECT * FROM Employees
	WHERE JobTitle='Sales Representative'


--=========Find Names of All Employees by Salary in Range========


SELECT FirstName,LastName,JobTitle FROM Employees
	WHERE Salary BETWEEN 20000 AND 30000


--========Find Names of All Employees=========


SELECT FirstName+' '+MiddleName+' '+LastName
	FROM Employees
	WHERE Salary IN (25000, 14000, 12500, 23600)


--=========Find All Employees Without Manager========


SELECT FirstName,LastName FROM Employees
	WHERE ManagerID IS NULL


---=========Find All Employees with Salary More Than========


SELECT FirstName,LastName,Salary FROM Employees
	WHERE Salary > 50000
	ORDER BY Salary DESC


--=========Find 5 Best Paid Employees=========


SELECT TOP(5) FirstName,LastName FROM Employees
	ORDER BY Salary DESC


--========Find All Employees Except Marketing========


SELECT FirstName,LastName FROM Employees
	WHERE DepartmentID !=4


--=========Sort Employees Table==========


SELECT * FROM Employees
	ORDER BY Salary DESC ,FirstName,LastName DESC,MiddleName


--========= Create View Employees with Salaries===========

GO
CREATE VIEW V_EmployeesSalaries 
	AS
	SELECT FirstName,Lastname,Salary 
	FROM Employees

GO

--========Create View Employees with Job Titles=========

GO

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle 
FROM Employees
GO

SELECT * FROM V_EmployeeNameJobTitle


--===========Find First 10 Started Projects=======


SELECT TOP(10) *
	FROM Projects
	ORDER BY Projects.StartDate,[Name]


--=========Last 7 Hired Employees=========


SELECT TOP(7) FirstName,LastName,HireDate 
	FROM Employees
	ORDER BY HireDate DESC 


--===========Increase Salaries===========


 UPDATE Employees
SET Salary =Salary * 1.12
WHERE DepartmentID IN (1,2,4,11)

SELECT Salary FROM Employees



--============All Mountain Peaks===========

USE [Geography]


SELECT PeakName  FROM Peaks
	ORDER BY Peaks.PeakName



--==========Biggest Countries by Population========


SELECT TOP(30) CountryName,[Population]  
	FROM Countries
	WHERE ContinentCode ='EU'
	ORDER BY  [Population] DESC ,CountryName 
	


--==========Countries and Currency (Euro / Not Euro)===========


SELECT CountryName, CountryCode,
	CASE
    WHEN CurrencyCode ='EUR' THEN 'Euro'
    ELSE 'Not Euro'
	END AS CurrenciesText
FROM Countries

ORDER BY CountryName


--============ All Diablo Characters============

USE Diablo

SELECT [NAME] 
	FROM Characters
	ORDER BY Name


