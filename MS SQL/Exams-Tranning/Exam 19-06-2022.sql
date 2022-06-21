--====================================MS SQL Exam – 19.06.2022 =================================

CREATE DATABASE Zoo

USE Zoo


--==================== DDL ==========================


CREATE TABLE Owners
(
	id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber NVARCHAR(15) NOT NULL,
	Address VARCHAR(50) NULL
)

CREATE TABLE AnimalTypes
(
	id INT PRIMARY KEY IDENTITY,
	AnimalType VARCHAR(30) NOT NULL
)


CREATE TABLE Cages
(
	id INT PRIMARY KEY IDENTITY,
	AnimalTypeId INT NOT NULL REFERENCES AnimalTypes(id)
)

CREATE TABLE Animals
(
	id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT REFERENCES Owners (id),
	AnimalTypeId INT NOT NULL REFERENCES AnimalTypes (id)
)

CREATE TABLE AnimalsCages
(
	CageId INT NOT NULL REFERENCES Cages (id),
	AnimalId INT NOT NULL REFERENCES Animals(id)
	PRIMARY KEY (CageId,AnimalId)
)


CREATE TABLE VolunteersDepartments
(
	id INT PRIMARY KEY IDENTITY,
	DepartmentName VARCHAR(30) NOT NULL
)


CREATE TABLE Volunteers
(
	id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	Address VARCHAR(50),
	AnimalId INT REFERENCES Animals(id),
	DepartmentId INT NOT NULL REFERENCES VolunteersDepartments (id)
)


--======================================== Insert ====================================


INSERT INTO Volunteers (Name,PhoneNumber,Address,AnimalId,DepartmentId)
	VALUES
	('Anita Kostova','0896365412','Sofia, 5 Rosa str.',15,1),
	('Dimitur Stoev','0877564223',NULL,42,4),
	('Kalina Evtimova','0896321112','Silistra, 21 Breza str.',9,7),
	('Stoyan Tomov','0898564100','Montana, 1 Bor str.',18,8),
	('Boryana Mileva','0888112233',NULL,31,5)


INSERT INTO Animals(Name,BirthDate,OwnerId,AnimalTypeId)
VALUES

('Giraffe','2018-09-21',21,1),
('Harpy Eagle','2015-04-17',15,3),
('Hamadryas Baboon','2017-11-02',NULL,1),
('Tuatara','2021-06-30',2,4)




--========================== Update Data ====================================

SELECT * FROM Owners
WHERE Name = 'Kaloqn Stoqnov'

SELECT * FROM Animals


UPDATE Animals
	SET OwnerId = 4
	WHERE OwnerId IS NULL



--======================= Delete Data ===================================

SELECT * FROM VolunteersDepartments
WHERE DepartmentName= 'Education program assistant'
SELECT * FROM Volunteers
WHERE DepartmentId = 2





ALTER TABLE VolunteersDepartments
UPDATE VolunteersDepartments
 SET id = NULL
WHERE Id= 2

DELETE FROM VolunteersDepartments
WHERE Id= 2



DELETE FROM Volunteers
WHERE DepartmentId= 2

SELECT COUNT(*) FROM Volunteers
SELECT * FROM VolunteersDepartments

--=========================== 5 Problem ================================


SELECT 
	v.Name,
	v.PhoneNumber,
	v.Address,
	v.AnimalId,
	v.DepartmentId
 FROM Volunteers AS v
 ORDER BY Name,V.AnimalId,V.DepartmentId


 --======================== PROBLEM 6 ===================================


 SELECT 
	a.Name,
	aty.AnimalType,
	FORMAT(a.BirthDate,'dd.MM.yyyy') as BirthDate
  FROM Animals AS a
  JOIN AnimalTypes AS aty ON a.AnimalTypeId = aty.id
  ORDER BY Name



--============================ PROBLEM 7 ==========================



SELECT TOP(5)
	o.Name,
	COUNT(A.OwnerId) AS CountOfAnimals
 FROM Owners AS o
 JOIN Animals AS a ON a.OwnerId = O.id
 GROUP BY O.Name
 ORDER BY CountOfAnimals DESC,O.Name


 --================================= PROBLEM 8 =================================


 SELECT 
	CONCAT(o.Name,'-',a.Name) AS OwnersAnimals,
	O.PhoneNumber,
	ac.CageId AS CageId
  FROM Owners AS o
  LEFT JOIN Animals AS a ON O.id = A.OwnerId
  JOIN AnimalTypes AS atyp ON a.AnimalTypeId = atyp.id
  JOIN AnimalsCages AS ac  ON a.id = ac.AnimalId
  JOIN Cages AS c ON ac.AnimalId = c.id
 ORDER BY o.Name ASC,a.Name DESC
 


 SELECT *FROM AnimalTypes

 --============================== problem 9 ==============================


 SELECT * FROM Volunteers AS v
 JOIN VolunteersDepartments AS vd ON v.DepartmentId =vd.id
 WHERE  V.Address =  'Sofia'


 SELECT * FROM VolunteersDepartments


CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(50))
RETURNS INT
BEGIN
   
  DECLARE @result INT;
   SET @result= (SELECT 
	COUNT(*)
	FROM Volunteers AS v
	JOIN VolunteersDepartments AS vd ON V.DepartmentId = VD.id
	WHERE VD.DepartmentName = @VolunteersDepartment)
	
	RETURN @result
END





CREATE PROCEDURE usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(50))
AS
BEGIN


	SELECT 
		A.Name,
		CASE 

		WHEN  A.OwnerId IS NULL THEN 'For adoption' 
		ELSE o.Name 
		END 	AS OwnersName
	 FROM Animals AS a
	JOIN Owners AS o ON a.OwnerId = o.id
	WHERE A.Name =@AnimalName AND A.OwnerId = O.id
	

END

EXEC usp_AnimalsWithOwnersOrNot 'Brown bear'




--================================10  ==================================



SELECT 
	A.Name,
	A.BirthDate,
	DATEPART(Year , ANT.AnimalType) as BirthYear
 FROM Animals AS a
JOIN AnimalTypes AS ant ON A.AnimalTypeId = ant.id
WHERE a.OwnerId IS NULL AND A.BirthDate <'01/01/2022' AND ant.AnimalType !='Birds'
ORDER BY A.Name
