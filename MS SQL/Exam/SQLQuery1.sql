CREATE DATABASE Zoo

USE Zoo


CREATE TABLE Owners 
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	Address VARCHAR(50) NULL
)

CREATE TABLE AnimalTypes
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	AnimalType VARCHAR(30) NOT NULL	
)


CREATE TABLE Cages
(
	Id	INT PRIMARY KEY IDENTITY NOT NULL,
	AnimalTypeId INT
	FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT
	FOREIGN KEY REFERENCES Owners (Id) NULL,
	AnimalTypeId INT
	FOREIGN KEY REFERENCES AnimalTypes (Id) NOT NULL
)

CREATE TABLE AnimalsCages
(
	CageId INT
	FOREIGN KEY REFERENCES Cages (Id),

	AnimalId INT
	FOREIGN KEY REFERENCES Animals(Id)

	PRIMARY KEY (CageId,AnimalId)
)

CREATE TABLE VolunteersDepartments
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DepartmentName VARCHAR(30) NOT NULL
)


CREATE TABLE Volunteers
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	Address VARCHAR(50) NULL,
	AnimalId INT
	FOREIGN KEY REFERENCES Animals (Id) NULL,
	DepartmentId INT
	FOREIGN KEY REFERENCES  VolunteersDepartments (Id) NOT NULL
)

INSERT INTO [Volunteers] ([Name],[PhoneNumber],[Address],[AnimalId],[DepartmentId])
VALUES 
('Anita Kostova','0896365412','Sofia 5 Rosa str.',15,1),
('Dimitur Stoev','0877564223',NULL,42,4),
('Kalina Evtimova','0896321112','Silistra, 21 Breza str.',9,7),
('Stoyan Tomov','0898564100','Montana, 1 Bor str.',18,8),
('Boryana Mileva','0888112233',NULL,31,5)

INSERT INTO [Animals] ([Name],[BirthDate],[OwnerId],[AnimalTypeId])
VALUES
('Giraffe','2018-09-21',21,1),
('Harpy Eagle','2015-04-17',15,3),
('Hamadryas Baboon','2017-11-02',NULL,1),
('Tuatara','2021-06-30',2,4)


SELECT COUNT(*) FROM Volunteers
SELECT COUNT(*) FROM Animals

--========== UpdateDatabase ===========================

SELECT O.Id FROM Owners AS O
WHERE O.Name ='Kaloqn Stoqnov'

UPDATE Animals
	SET OwnerId = 4
	WHERE OwnerId IS NULL


--====================== Delete =============================
SELECT a.Id FROM VolunteersDepartments AS a
WHERE a.DepartmentName ='Education program assistant' 


DELETE Volunteers
 WHERE DepartmentId = 2


DELETE VolunteersDepartments
WHERE DepartmentName ='Education program assistant' 


SELECT COUNT(*) FROM Volunteers
SELECT COUNT(*) FROM VolunteersDepartments

--================================ problem 5 ==============================


SELECT
		v.Name,
		v.PhoneNumber,
		v.Address,
		v.AnimalId,
		v.DepartmentId
	FROM Volunteers AS v
	ORDER BY V.Name ASC,V.AnimalId ASC,V.DepartmentId ASC



--============================== PROBLE 6 ============================

SELECT
	a.Name,
	ay.AnimalType,
	FORMAT(a.BirthDate,'dd.MM.yyyy')
	FROM Animals AS a
	JOIN AnimalTypes AS ay ON a.AnimalTypeId = ay.Id
	ORDER BY A.Name





--========================== Problem 7 ==================================



SELECT TOP(5)
	o.Name,
	COUNT(a.OwnerId) AS CountOfAnimals
	FROM Owners AS o
	JOIN Animals AS a ON o.Id = a.OwnerId
	GROUP BY (o.Name)
	ORDER BY CountOfAnimals DESC,O.Name ASC


--============================ Problem 8 ====================================

SELECT * FROM AnimalsCages AS a
JOIN Owners AS o ON o.Id = a.AnimalId
JOIN Animals AS ad ON ad.OwnerId =o.Id
WHERE ad.AnimalTypeId = 1

SELECT 
	CONCAT(o.Name,'-',A.Name) AS OwnersAnimals,
	o.PhoneNumber,
	ac.CageId AS CageId
	FROM Owners AS o
	JOIN Animals AS a ON o.Id = a.OwnerId
	JOIN AnimalsCages AS ac ON a.Id = ac.AnimalId
	WHERE a.AnimalTypeId = 1
	ORDER BY  o.Name ASC, A.Name DESC


--============================= Problem 9 ======================


SELECT
	v.Name,
	v.PhoneNumber,
	SUBSTRING(v.Address,CHARINDEX(',',Address)+1,LEN(Address)) AS [Address]
	FROM Volunteers AS v
WHERE DepartmentId = 2 AND v.Address LIKE '%Sof%'
ORDER BY V.Name



--============================ Problem 10 =============================


SELECT * FROM Animals
SELECT * FROM Volunteers
SELECT * FROM VolunteersDepartments


SELECT
	A.Name,
	YEAR(a.BirthDate) AS BirthYear,
	ta.AnimalType
	FROM Animals AS a
	JOIN AnimalTypes AS ta ON A.AnimalTypeId = ta.Id
	WHERE a.OwnerId IS NULL  AND ta.Id !=3 AND YEAR(a.BirthDate) <= 2022 AND YEAR(a.BirthDate) > 2017
	ORDER BY a.Name



--=============================== Problem 11 ================================

CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(50))
RETURNS INT
AS
BEGIN
		DECLARE @Count INT

	   SELECT @Count = COUNT(v.DepartmentId) FROM Volunteers AS v
		JOIN VolunteersDepartments AS vd ON V.DepartmentId = vd.Id
		WHERE VD.DepartmentName = @VolunteersDepartment

		RETURN @Count
END

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')


GO
--====================================== Problem 12 ===================================



CREATE OR ALTER PROC  usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
AS
BEGIN
	DECLARE @ownerId INT = (SELECT OwnerId FROM Animals WHERE [Name] = @AnimalName)

	IF(@ownerId IS NULL)
		BEGIN
			SELECT 
			[Name],
			'For adoption' AS OwnersName
			FROM Animals
				WHERE [Name] = @AnimalName
		END
	ELSE
		BEGIN
		SELECT 
			a.[Name],
			o.[Name] AS OwnersName
			FROM Animals AS a 
			JOIN Owners AS o ON a.OwnerId = o.Id
			WHERE a.[Name] = @AnimalName
		END
END



