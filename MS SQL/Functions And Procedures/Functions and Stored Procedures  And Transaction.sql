--=====================Functions and Stored Procedures ===============================



--===================01. Employees with Salary Above 35000=======================

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN

	SELECT 
		FirstName, 
		LastName
		FROM Employees
	WHERE Salary > 35000

END

EXEC  [dbo].[usp_GetEmployeesSalaryAbove35000]



--=====================02. Employees with Salary Above Number==========================
GO

CREATE  PROCEDURE usp_GetEmployeesSalaryAboveNumber @Salary DECIMAL(18,4)
AS
BEGIN
	SELECT 
		FirstName,
		LastName 
	FROM Employees
	WHERE Salary >= @Salary
​
END

EXEC dbo.usp_GetEmployeesSalaryAboveNumber @Salary = 48100




--===================03. Town Names Starting With==========================
GO

CREATE OR ALTER PROCEDURE usp_GetTownsStartingWith(@searchedString NVARCHAR(50))

AS

BEGIN

     DECLARE @stringCount int = LEN(@searchedString)

SELECT [Name] FROM Towns

WHERE LEFT([Name],@stringCount) = @searchedString

END

EXEC  dbo.usp_GetTownsStartingWith @searchedString ='b'



--======================04. Employees from Town=======================
GO

CREATE PROCEDURE  usp_GetEmployeesFromTown @searchTown NVARCHAR(50)
AS
BEGIN

	SELECT 
		FirstName,
		LastName 
	 FROM Employees AS e
	 JOIN Addresses AS a ON e.AddressID = a.AddressID
	 JOIN Towns AS t ON A.TownID = T.TownID
	 WHERE t.[Name] =  @searchTown


END
EXEC  dbo.usp_GetEmployeesFromTown  @searchTown= 'Sofia'


--====================05. Salary Level Function=============================

CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4)) 
RETURNS VARCHAR(10) AS 
BEGIN 
	DECLARE @SalaryLevel VARCHAR(10)
	IF(@Salary < 30000)
	BEGIN 
	 SET @SalaryLevel = 'Low'
	END
	ELSE IF(@Salary >= 30000 AND @Salary <= 50000)
	BEGIN
	 SET @SalaryLevel = 'Average'
	END
	ELSE 
	BEGIN 
	 SET @SalaryLevel = 'High'
	END
RETURN @SalaryLevel
END



--==================================06. Employees by Salary Level===========================
GO
CREATE PROCEDURE usp_EmployeesBySalaryLevel (@SalaryLevel VARCHAR(10))
AS
BEGIN

	SELECT
		FirstName,
		LastName
	 FROM Employees
	 
	 WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

END

EXEC dbo.usp_EmployeesBySalaryLevel @SalaryLevel = 'Low'
EXEC dbo.usp_EmployeesBySalaryLevel @SalaryLevel = 'Average'
EXEC dbo.usp_EmployeesBySalaryLevel @SalaryLevel = 'High'




--=========================07. Define Function=====================


CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50)) 
RETURNS BIT
AS
BEGIN
DECLARE @currentIndex int = 1;

WHILE(@currentIndex <= LEN(@word))
	BEGIN

	DECLARE @currentLetter varchar(1) = SUBSTRING(@word, @currentIndex, 1);

	IF(CHARINDEX(@currentLetter, @setOfLetters)) = 0
	BEGIN
	RETURN 0;
	END

	SET @currentIndex += 1;
	END

RETURN 1;
END


--====================08. Delete Employees and Departments========================

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS

DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

ALTER TABLE Departments
ALTER COLUMN ManagerID int NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId 

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId


--===============================09. Find Full Name==============================


CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN

	SELECT 
		CONCAT(FirstName,' ',LastName) AS FullName

	 FROM AccountHolders

END



--====================10. People with Balance Higher Than=======================

CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@balance DECIMAL(10,2)) as
SELECT FirstName, LastName FROM AccountHolders ah
JOIN Accounts as a ON a.AccountHolderId = ah.Id
GROUP BY FirstName, LastName
HAVING SUM(a.Balance) > @balance
ORDER BY FirstName, LastName

---=============================11. Future Value Function=====================


CREATE FUNCTION ufn_CalculateFutureValue(@Sum DECIMAL(15,4),
@YearlyInterestRate FLOAT,
@NumberOfYears INT )
RETURNS DECIMAL(15,4)
BEGIN
    DECLARE @FutureValue DECIMAL(15,4);

    SET @FutureValue = @Sum * POWER((1 + @YearlyInterestRate), @NumberOfYears)
    
    RETURN @FutureValue
END



--========================12. Calculating Interest=================================


CREATE PROC usp_CalculateFutureValueForAccount (@AccountId INT, @InterestRate FLOAT) AS
SELECT a.Id AS [Account Id],
	   ah.FirstName AS [First Name],
	   ah.LastName AS [Last Name],
	   a.Balance,
	   dbo.ufn_CalculateFutureValue(Balance, @InterestRate, 5) AS [Balance in 5 years]
  FROM AccountHolders AS ah
  JOIN Accounts AS a ON ah.Id = a.Id
 WHERE a.Id = @AccountId


 --=======================13. *Cash in User Games Odd Rows============================


 CREATE FUNCTION ufn_CashInUsersGames(@gameName varchar(max))
RETURNS @returnedTable TABLE
(
SumCash money
)
AS
BEGIN
	DECLARE @result money

	SET @result = 
	(SELECT SUM(ug.Cash) AS Cash
	FROM
		(SELECT Cash, GameId, ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
		FROM UsersGames
		WHERE GameId = (SELECT Id FROM Games WHERE Name = @gameName)
		) AS ug
	WHERE ug.RowNumber % 2 != 0
	)

	INSERT INTO @returnedTable SELECT @result
	RETURN
END












