CREATE DATABASE NationalTouristSitesOfBulgaria

USE NationalTouristSitesOfBulgaria


--========================== DDL ===============================

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50) NULL,
	Province VARCHAR(50) NULL
)


CREATE TABLE Sites
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	LocationId INT
	FOREIGN KEY REFERENCES Locations(Id) NOT NULL,
	CategoryId INT
	FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Establishment VARCHAR(15) NULL
)


CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Age INT CHECK(Age >= 0 AND Age <= 120) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Reward VARCHAR(20) NULL
)


CREATE TABLE SitesTourists
(
	TouristId INT 
	FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,

	SiteId INT
	FOREIGN KEY REFERENCES Sites(Id) NOT NULL

	PRIMARY KEY(TouristId,SiteId)
)


CREATE TABLE BonusPrizes
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)


CREATE TABLE TouristsBonusPrizes
(
	TouristId INT
	FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,

	BonusPrizeId INT
	FOREIGN KEY REFERENCES BonusPrizes(Id) NOT NULL

	PRIMARY KEY (TouristId,BonusPrizeId)
)



--========================= Problem 2 =================================


INSERT INTO Tourists
VALUES
('Borislava Kazakova',52,'+359896354244','Bulgaria',NULL),
('Peter Bosh',48,'+447911844141','UK',NULL),
('Martin Smith',29,'+353863818592','Ireland','Bronze badge'),
('Svilen Dobrev',49,'359986584786','Bulgaria','Silver badge'),
('Kremena Popova',38,'+359893298604','Bulgaria',NULL)


INSERT INTO Sites
VALUES
('Ustra fortress',90,7,'X'),
('Karlanovo Pyramids',65,7,NULL),
('The Tomb of Tsar Sevt',63,8,'V BC'),
('Sinite Kamani Natural Park',17,1,'NULL'),
('St. Petka of Bulgaria – Rupite',92,6,'1994')



--========================== problem 3-update ================================


UPDATE Sites
	SET Establishment = '(not defined)'
	WHERE Establishment IS NULL




--======================== Problem 4 - delete ================================

DELETE FROM TouristsBonusPrizes
	WHERE BonusPrizeId = 5

DELETE FROM BonusPrizes
	WHERE [Name] ='Sleeping bag'




--======================= Problem 5 ==================================

SELECT
	t.Name,
	t.Age,
	t.PhoneNumber,
	t.Nationality
	FROM Tourists AS t
	ORDER BY T.Nationality,T.Age DESC,T.Name ASC



--============================ Problem 6 ===============================

SELECT
	s.Name,
	l.Name,
	s.Establishment,
	c.Name
	FROM Sites AS s
	JOIN Locations AS l ON S.LocationId =L.Id
	JOIN Categories AS c ON s.CategoryId = c.Id
	ORDER BY c.Name DESC,l.Name ASC,s.Name ASC


--=================== Problem 7 ==================================

SELECT 
     l.Province,
	 l.Municipality,
	 l.Name,
	 COUNT(st.TouristId) AS CountOfSites
  FROM Locations AS l
  JOIN Sites AS s ON s.LocationId = l.Id
  JOIN SitesTourists AS st ON st.SiteId = S.Id
  WHERE Province = 'Sofia'
  GROUP BY L.Province,L.Municipality 
  ORDER BY  COUNT(L.Id) DESC


--============================== Problem 8 ====================================


SELECT 
	s.Name,
	l.Name,
	l.Municipality,
	l.Province,
	s.Establishment
	FROM Sites AS s
	JOIN Locations AS l ON S.LocationId = l.Id
	WHERE s.Name NOT LIKE 'B%' AND s.Name NOT LIKE 'M%' AND s.Name NOT LIKE 'D%'
	AND (s.Establishment IS NOT NULL) AND (s.Establishment  LIKE '%BC')
	ORDER BY S.Name






--============================= Problem 9 ======================================


SELECT 
	T.Name,
	T.Age,
	t.PhoneNumber,
	T.Nationality,
	CASE
	WHEN BP.Name IS NULL THEN '(no bonus prize)'
	ELSE bp.Name
	END AS Reward
	FROM Tourists AS t
	LEFT JOIN TouristsBonusPrizes AS tb ON t.Id = tb.TouristId
	LEFT JOIN BonusPrizes AS bp ON tb.BonusPrizeId = bp.Id
	ORDER BY t.Name












--========================== Problem 10======================================


SELECT DISTINCT
	SUBSTRING(t.Name,CHARINDEX(' ',t.Name),LEN(t.Name)) AS LastName,
	t.Nationality,
	t.Age,
	t.PhoneNumber
	FROM Tourists AS t
	JOIN SitesTourists AS st ON t.Id = st.TouristId
	JOIN Sites AS s ON st.SiteId = s.Id
	JOIN Categories AS c ON S.CategoryId = C.Id
	WHERE C.Name ='History and archaeology'
	ORDER BY LastName



--=========================== Problem 11 ==================================
GO

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
AS
BEGIN

	DECLARE @Count INT

	SELECT @Count = COUNT(s.Id) FROM Sites AS s
	JOIN SitesTourists AS st ON S.Id = ST.SiteId
	WHERE S.Name = @Site


	RETURN @Count
END


SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')




--================================= Problem 12 ====================================


SELECT COUNT(*) FROM Tourists AS t
JOIN SitesTourists AS st ON t.Id = st.TouristId 
WHERE t.Name = 'Zac Walsh'


GO

CREATE  PROCEDURE  usp_AnnualRewardLottery(@TouristName VARCHAR(100))
AS
BEGIN

		DECLARE @Point INT =(SELECT COUNT(*) FROM Tourists AS t
								JOIN SitesTourists AS st ON t.Id = st.TouristId 
								WHERE t.Name = @TouristName)

		IF(@Point >= 100)
		BEGIN
			UPDATE Tourists
				SET Reward ='Gold badge'
				WHERE Tourists.Name = @TouristName
		END

		ELSE IF(@Point >= 50)
		BEGIN
			UPDATE Tourists
				SET Reward ='Silver badge'
				WHERE Tourists.Name = @TouristName
		END

		ELSE IF(@Point >= 25)
			BEGIN
			UPDATE Tourists
			   SET Reward = 'Bronze badge'
			   WHERE Tourists.Name = @TouristName
			END


		ELSE 
			BEGIN
			UPDATE Tourists
			   SET Reward = NULL
			   WHERE Tourists.Name = @TouristName

			END

			SELECT Name,Reward FROM Tourists
			WHERE Tourists.Name = @TouristName

END


EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'
EXEC usp_AnnualRewardLottery 'Brus Brown'

SELECT * FROM Tourists
WHERE Tourists.Name = 'Gerhild Lutgard'
