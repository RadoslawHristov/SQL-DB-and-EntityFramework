--=====================Indices and Data Aggregation ====================

USE Gringotts

--===================01. Records’ Count=======================

SELECT COUNT(*) FROM WizzardDeposits


--==================Longest Magic Wand ==============

SELECT MAX(MagicWandSize) AS [LongestMagicWand]
  FROM WizzardDeposits


--===================03. Longest Magic Wand per Deposit Groups===================


SELECT DepositGroup AS [DepositGroup], MAX(MagicWandSize) AS [LongestMagicWand]
  FROM WizzardDeposits
 GROUP BY DepositGroup
 ORDER BY LongestMagicWand DESC



 --=======================04. Smallest Deposit Group per Magic Wand Size==================

SELECT TOP(2) DepositGroup 
  FROM WizzardDeposits
 GROUP BY DepositGroup
 ORDER BY AVG(MagicWandSize)




 --====================05. Deposits Sum====================


 SELECT DepositGroup, SUM(DepositAmount) AS TotalSum 
 FROM WizzardDeposits

 GROUP BY DepositGroup


 --================06. Deposits Sum for Ollivander Family==================

 SELECT 
 DepositGroup,
 SUM(DepositAmount) AS TotalSum
 FROM WizzardDeposits
 WHERE MagicWandCreator='Ollivander family'
 GROUP BY DepositGroup



 --====================07. Deposits Filter=====================


 SELECT 
    DepositGroup, SUM(DepositAmount) AS TotalSum
FROM
    WizzardDeposits AS wd
WHERE    wd.MagicWandCreator = 'Ollivander family' 
GROUP BY wd.DepositGroup
HAVING  SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC



--================08. Deposit Charge=====================


SELECT DepositGroup,MagicWandCreator,
(
	MIN(DepositCharge) 
) AS MinDepositCharge
FROM WizzardDeposits

GROUP BY DepositGroup,MagicWandCreator



--======================09. Age Groups=====================


SELECT  
	AgeGroup,
	COUNT(*) AS WizardCount 
FROM 
	(
		SELECT 
		
		CASE 
	
		    WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		    WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		    WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
			WHEN Age >= 61 THEN '[61+]'
	
			END
			AS AgeGroup
	  FROM WizzardDeposits
	) AS AgesGroups
	
GROUP BY AgeGroup



--=================10. First Letter=============================


SELECT DISTINCT LEFT(FirstName,1) AS FirstLetter FROM WizzardDeposits
WHERE DepositGroup='Troll Chest'
GROUP BY LEFT(FirstName,1)
ORDER BY FirstLetter



--=======================11. Average Interest===========================


SELECT DepositGroup,
       IsDepositExpired,
       AVG(1.0 * DepositInterest)
FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup,
         IsDepositExpired
ORDER BY DepositGroup DESC,
         IsDepositExpired; 


--=================12. Rich Wizard, Poor Wizard ========================


SELECT SUM(ws.Difference)
FROM
(
    SELECT DepositAmount -
    (
        SELECT DepositAmount
        FROM WizzardDeposits AS wsd
        WHERE wsd.Id = wd.Id + 1
    ) AS Difference
    FROM WizzardDeposits AS wd
) AS ws; 


--=================13. Departments Total Salaries========================

USE SoftUni


SELECT DepartmentID ,SUM(Salary) AS TotalSum

FROM Employees
	
GROUP BY DepartmentID



--=================14. Employees Minimum Salaries==================


SELECT DepartmentID,MIN(Salary) AS MinimumSalary FROM Employees
WHERE DepartmentID IN (2,5,7)
GROUP BY DepartmentID




--======================15. Employees Average Salaries=============


SELECT * FROM Employees


--CREATE TABLE EMP AS(
--	SELECT * FROM Employees
	--WHERE Salary > 30000
--)

SELECT *
INTO EMP 
FROM Employees
WHERE Salary > 30000;

DELETE EMP
WHERE ManagerID= 42

UPDATE EMP
	SET Salary += 5000
WHERE DepartmentID = 1


SELECT DepartmentID,AVG(Salary) AS AverageSalary  FROM EMP

GROUP BY DepartmentID


--==============16. Employees Maximum Salaries===============


SELECT  
	DepartmentID,
	MAX(Salary)
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000




--====================17. Employees Count Salaries====================


SELECT COUNT(Salary) AS [Count]  FROM Employees

WHERE ManagerID IS NULL




--==================18. 3rd Highest Salary====================


SELECT s.DepartmentID, MAX(s.Salary)
FROM (
SELECT DepartmentID, Salary, DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS salaryrank
FROM Employees) s

WHERE s.salaryrank=3
GROUP BY DepartmentID


SELECT s.DepartmentID,MAX(s.Salary)
FROM (
SELECT DepartmentID,Salary, DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS Ranking FROM Employees) AS s

WHERE s.Ranking=3
GROUP BY DepartmentID


--========================19. Salary Challenge========================

SELECT DepartmentID,AVG(Salary) AS Average 
FROM Employees

GROUP BY DepartmentID


SELECT TOP(10) FirstName,LastName,DepartmentID 
FROM Employees
AS e
WHERE Salary > (

					SELECT AVG(Salary) AS Average 
					FROM Employees
					AS esub
					WHERE esub.DepartmentID = e.DepartmentID
					GROUP BY DepartmentID
		     	)

