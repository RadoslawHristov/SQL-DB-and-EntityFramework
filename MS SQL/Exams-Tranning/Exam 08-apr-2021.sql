--============================= Exam – 8 April 2021 ==========================

CREATE DATABASE Service
--================= 1.DDL ========================================


CREATE TABLE Users
(
	Id INT IDENTITY PRIMARY KEY ,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50) ,
	Birthdate DATETIME  ,
	Age INT CHECK(Age BETWEEN 14 AND 110),
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
	Id INT IDENTITY PRIMARY KEY ,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Employees
(
	Id INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATETIME,
	Age INT CHECK(Age BETWEEN 18 AND 110),
	DepartmentId INT REFERENCES Departments(id)
)

CREATE TABLE Categories
(
	id INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT REFERENCES Departments(id)
)


CREATE TABLE [Status]
(
	id INT IDENTITY PRIMARY KEY,
	[Label] VARCHAR(30) NOT NULL
)


CREATE TABLE Reports
(
	id INT IDENTITY PRIMARY KEY,
	CategoryId INT NOT NULL REFERENCES Categories(id),
	StatusId INT NOT NULL REFERENCES [Status](id),
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME ,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT NOT NULL REFERENCES Users(id),
	EmployeeId INT  REFERENCES Employees(id)
)
-- judge return-22/30 mayby problem in relationships


--=============================== problem 2 - Insert =================================================


INSERT INTO Employees(FirstName,LastName,Birthdate,DepartmentId)
	VALUES
	('Mario','O''Malley','1958-9-21',1),
	('Niki','Stanaghan','1969-11-16',4),
	('Ayrton','Senna','1960-03-21',9),
	('Ronnie','Peterson','1944-02-14',9),
	('Giovanna','Amati','1959-07-20',5)



INSERT INTO Reports(CategoryId,StatusId,OpenDate,CloseDate,[Description],UserId,EmployeeId)
	VALUES
	(1,1,'2017-04-13',NULL,'Stuck Road on Str.133',6,2),
	(6,3,'2015-09-05','2015-12-06','Charity trail running',3,5),
	(14,2,'2015-09-07',NULL,'Falling bricks on Str.58',5,2),
	(4,3,'2017-07-03','2017-07-06','Cut off streetlight on Str.11',1,1)
	


--====================Update=======================================

UPDATE Reports
	SET CloseDate = GETDATE()
	WHERE CloseDate IS NULL

SELECT * FROM Reports


--=================  Delete ============================

DELETE Reports
WHERE Reports.StatusId = 4


--===================== Problem 5 ================================



SELECT 
	[Description],
	FORMAT(OpenDate,'dd-MM-yyyy') AS OpenDate
 FROM Reports
 WHERE EmployeeId IS NULL
ORDER BY Reports.OpenDate ASC,[Description] ASC



--=========================== Problem 6 ==============================

SELECT 
	r.Description,
	c.Name
 FROM Reports AS r
 JOIN Categories AS c ON r.CategoryId = c.id
 ORDER BY R.Description,c.Name


--========================= Problem 7 ================================


SELECT top (5) 
	c.[Name] AS CategoryName,
	COUNT(*) AS RaportName
	FROM Reports AS r
	JOIN Categories AS c ON C.id = R.CategoryId
	GROUP BY CategoryId, c.[Name]
	ORDER BY COUNT(*) DESC , C.[Name] ASC




--======================= Problem 8 ==============================

SELECT		
	U.Username,
	C.[Name] AS CategoryName
 FROM Reports AS r
 JOIN Users AS u ON R.UserId = u.id
 JOIN Categories AS c ON C.id = r.CategoryId
 WHERE CONCAT_WS('-',MONTH(r.OpenDate),DAY(r.OpenDate)) = CONCAT_WS('-',MONTH(u.Birthdate),DAY(u.Birthdate))
 ORDER BY u.Username , c.[Name]



 --======================== Problem 9 ==================================
 SELECT * FROM Reports
	
 SELECT 
	CONCAT(e.FirstName,' ',e.LastName) AS FullName,
	(
		SELECT DISTINCT COUNT(UserId) FROM Reports
		WHERE EmployeeId = E.id
	) AS UserCount
  FROM Employees AS e
  GROUP BY E.FirstName,E.LastName,E.id
  ORDER BY UserCount DESC, FullName



--================== PROBLEM 10 ===========================

SELECT
	CASE
	WHEN e.FirstName IS NULL OR e.LastName IS NULL THEN 'None'
	ELSE CONCAT(e.FirstName,' ',e.LastName)
	END AS Employee,
	ISNULL(d.[Name],'None') AS Department,
	ISNULL(c.[Name],'None') AS Category,
	ISNULL(r.[Description],'None') AS [Description],
	CASE 
	WHEN r.OpenDate IS NULL THEN 'None'
	ELSE FORMAT(R.OpenDate,'dd.MM.yyyy')
	END AS OpenDate,
	ISNULL(S.[Label],'None') AS [Status],
	ISNULL(u.[Name],'None') AS [User]
 FROM Reports AS r
LEFT JOIN Employees AS e ON E.id = r.EmployeeId
LEFT JOIN Departments AS d ON e.DepartmentId = D.id
LEFT JOIN Categories AS c ON c.id = r.CategoryId
LEFT JOIN [Status] AS s ON s.id = r.StatusId
LEFT JOIN Users AS u ON U.id = R.UserId

ORDER BY E.FirstName DESC,e.LastName DESC,Department,Category,[Description],R.OpenDate,S.[Label],u.[Name]


--======================== Problem 11 =========================================

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN

	IF(@StartDate IS NULL OR @EndDate IS NULL)
	BEGIN
	RETURN 0
	END
	
		RETURN DATEDIFF(HOUR,@StartDate,@EndDate)

SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
   FROM Reports


CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
BEGIN

DECLARE @result INT=(
SELECT
IIF(DATEDIFF(HOUR,@StartDate,@EndDate)IS NULL,0,DATEDIFF(HOUR,@StartDate,@EndDate))
);

RETURN @result;
END





--============================= problem 12 ==================================


CREATE PROCEDURE usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN

	DECLARE @CategorieID INT =(SELECT  
									c.DepartmentId
								FROM Reports AS r
								JOIN Categories AS c ON c.id = r.CategoryId
								WHERE r.id = @ReportId)

	DECLARE @EmploessDepartmentid INT =(SELECT d.id
											FROM Employees AS e
											JOIN Departments AS d ON d.id = e.DepartmentId
											WHERE e.id = @EmployeeId)

	IF(@CategorieID != @EmploessDepartmentid)
		THROW 51000, 'Employee doesn''t belong to the appropriate department!',1;

		ELSE 
		BEGIN
		UPDATE Reports
			SET EmployeeId = @EmploessDepartmentid
			WHERE Id =@ReportId
			END

END


