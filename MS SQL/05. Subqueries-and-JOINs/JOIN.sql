USE SoftUni

---=========01. Employee Address============

SELECT TOP(5)  
[EmployeeID],
[JobTitle],
e.AddressID,
a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID


--===========02. Addresses with Towns===============


USE SoftUni

SELECT TOP(50)  
[e].[FirstName],
[e].[LastName],
t.[Name],
a.AddressText
FROM Employees as e
JOIN Addresses AS a ON e.AddressID = a.AddressID 
JOIN Towns AS t ON  a.TownID= t.TownID
ORDER BY e.FirstName,e.LastName



--=============03. Sales Employees=================


SELECT 
	[e].[EmployeeID],
	[e].FirstName,
	[e].[LastName],
	[d].[Name]
FROM Employees AS e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
	WHERE d.[Name]='Sales'
ORDER BY e.EmployeeID



--====================04. Employee Departments======================

SELECT TOP(5) 
	e.EmployeeID,
	e.FirstName,
	e.Salary,
	d.[Name]
FROM Employees AS e

 JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
 WHERE e.Salary > 15000
 ORDER BY d.DepartmentID



 --=============05. Employees Without Projects=====================



 SELECT  TOP(3)

	E.EmployeeID,
	E.FirstName

 FROM Employees AS e
 FULL JOIN EmployeesProjects AS ep ON E.EmployeeID = ep.EmployeeID
 WHERE ep.EmployeeID IS NULL
 ORDER BY E.EmployeeID


 --=================06. Employees Hired After====================


 SELECT  
	e.FirstName,
	e.LastName,
	e.HireDate,
	d.[Name]
 FROM Employees AS e
 JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
 WHERE E.HireDate > DATEPART(YEAR,1999) AND d.[Name] IN ('Finance','Sales')
 ORDER BY e.HireDate



 --=================07. Employees With Project====================


 SELECT  TOP(5)
	e.EmployeeID,
	e.FirstName,
	p.[Name]
 FROM Employees AS e
 JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
 JOIN Projects AS p ON ep.ProjectID = p.ProjectID
 WHERE P.StartDate > '2002-08-13' AND P.EndDate IS NULL
 ORDER BY e.EmployeeID



 --==============08. Employee 24==============================


 SELECT  
	e.EmployeeID,
	e.FirstName,
	(
	  CASE 
		WHEN P.StartDate >='2005-01-01' THEN NULL 
		ELSE P.StartDate
		END
	) AS ProjectName
 FROM Employees AS e
  JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
  LEFT JOIN Projects AS p ON ep.ProjectID = p.ProjectID
  WHERE e.EmployeeID=24
 
 --OR
 SELECT e.EmployeeID, e.FirstName, p.name AS project_name
FROM employees AS e
INNER JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
LEFT OUTER JOIN projects AS p
ON ep.ProjectID = p.ProjectID
AND p.StartDate < '2005-01-01'
WHERE e.EmployeeID = 24


--================09. Employee Manager==============


SELECT 
	e.EmployeeID,
	e.FirstName,
	M.EmployeeID AS MenegerID,
	m.FirstName AS FirstName
FROM Employees AS e

 JOIN Employees m ON E.ManagerID=M.EmployeeID
WHERE m.EmployeeID IN(3,7)
ORDER BY e.EmployeeID


--=====================10. Employees Summary===================


SELECT  TOP(50)
	E.EmployeeID,
	CONCAT(e.FirstName,' ',e.LastName) AS EmployeeName,
	CONCAT(m.FirstName,' ',m.LastName) AS ManagerName,
	D.[Name] AS DepartmentName
FROM Employees AS e

LEFT JOIN Employees AS m ON m.EmployeeID = e.ManagerID
 JOIN Departments AS d ON e.DepartmentID = D.DepartmentID
ORDER BY E.EmployeeID


--============11.Min Average Salary ======================


SELECT min(avg) AS [MinAverageSalary]
FROM (
       SELECT avg(Salary) AS [avg]
       FROM Employees
       GROUP BY DepartmentID
     ) AS AverageSalary



--=====================12.Highest Peaks in Bulgaria==================


USE Geography

SELECT 
	c.CountryCode,
	m.MountainRange,
	p.PeakName,
	p.Elevation
FROM Countries AS c

JOIN MountainsCountries AS mc ON c.CountryCode = MC.CountryCode
JOIN Mountains AS m ON mc.MountainId = M.Id
JOIN Peaks AS p ON m.Id = P.MountainId

WHERE c.CountryCode = 'BG' AND P.Elevation > 2835
ORDER BY P.Elevation DESC



--================13. Count Mountain Ranges========================


SELECT c.CountryCode, count(m.MountainRange)
FROM Countries AS c
  INNER JOIN MountainsCountries mc
    ON c.CountryCode = mc.CountryCode
  INNER JOIN Mountains m
    ON mc.MountainId = m.Id
WHERE c.CountryName in ('United States', 'Russia', 'Bulgaria')
GROUP BY c.CountryCode


--=====================14. Countries With or Without Rivers=======================


SELECT  TOP(5)
	c.CountryName,
	r.RiverName
FROM Countries AS c

LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = R.Id
WHERE C.ContinentCode = 'AF'
ORDER BY c.CountryName


SELECT * FROM Continents



--===================15. Continents and Currencies====================


SELECT OrderedCurrencies.ContinentCode,
	   OrderedCurrencies.CurrencyCode,
	   OrderedCurrencies.CurrencyUsage
  FROM Continents AS c
  JOIN (
	   SELECT ContinentCode AS [ContinentCode],
	   COUNT(CurrencyCode) AS [CurrencyUsage],
	   CurrencyCode as [CurrencyCode],
	   DENSE_RANK() OVER (PARTITION BY ContinentCode
	                      ORDER BY COUNT(CurrencyCode) DESC
						  ) AS [Rank]
	   FROM Countries
	   GROUP BY ContinentCode, CurrencyCode
	   HAVING COUNT(CurrencyCode) > 1
	   )
	   AS OrderedCurrencies
    ON c.ContinentCode = OrderedCurrencies.ContinentCode
 WHERE OrderedCurrencies.Rank = 1




--======================16. Countries Without any Mountains============================


SELECT count(*) as [CountryCode]
FROM (
       SELECT mc.CountryCode
       FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc
           ON c.CountryCode = mc.CountryCode
       WHERE mc.CountryCode IS NULL
     ) AS CountriesWithoutMountains



--=============17. Highest Peak and Longest River by Country==============


SELECT TOP (5)
       Sorted.CountryName,
	   MAX(Sorted.PeakElevation) AS HighestPeakElevation,
	   MAX(Sorted.RiverLength) AS LongestRiverLength
  FROM (
         SELECT c.CountryName AS CountryName,
         	   p.Elevation AS PeakElevation,
         	   r.Length AS RiverLength
           FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc
         ON c.CountryCode = mc.CountryCode
         LEFT JOIN Peaks AS p
         ON mc.MountainId = p.MountainId
         LEFT JOIN CountriesRivers AS cr
         ON c.CountryCode = cr.CountryCode
         LEFT JOIN Rivers AS r
         ON cr.RiverId = r.Id
        ) AS Sorted
 GROUP BY Sorted.CountryName
 ORDER BY MAX(Sorted.PeakElevation) DESC,
	      MAX(Sorted.RiverLength) DESC,
		  Sorted.CountryName




--====================18. Highest Peak Name and Elevation by Country==================


WITH chp AS
(SELECT
   c.CountryName,
   p.PeakName,
   p.Elevation,
   m.MountainRange,
   ROW_NUMBER()
   OVER ( PARTITION BY c.CountryName
     ORDER BY p.Elevation DESC ) AS rn
 FROM Countries AS c
   LEFT JOIN CountriesRivers AS cr
     ON c.CountryCode = cr.CountryCode
   LEFT JOIN MountainsCountries AS mc
     ON mc.CountryCode = c.CountryCode
   LEFT JOIN Mountains AS m
     ON mc.MountainId = m.Id
   LEFT JOIN Peaks p
     ON p.MountainId = m.Id)

SELECT TOP 5
  chp.CountryName                           AS [Country],
  ISNULL(chp.PeakName, '(no highest peak)') AS [Highest Peak Name],
  ISNULL(chp.Elevation, 0)                  AS [Highest Peak Elevation],
  CASE WHEN chp.PeakName IS NOT NULL
    THEN chp.MountainRange
  ELSE '(no mountain)' END                  AS [Mountain]
FROM chp
WHERE rn = 1
ORDER BY chp.CountryName ASC, chp.PeakName ASC


--=======================END=============================








