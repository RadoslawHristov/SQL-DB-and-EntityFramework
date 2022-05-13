CREATE DATABASE  Minions

USE Minions

CREATE TABLE Minions
(
   ID INT PRIMARY KEY ,
   [NAME] VARCHAR(50) NULL,
   AGE INT NULL
)

CREATE TABLE Towns
(
   ID INT PRIMARY KEY,
   [NAME] VARCHAR(50) NOT NULL
)

ALTER TABLE Minions
ADD TOWNID INT FOREIGN KEY (TOWNID) REFERENCES Towns(id) 

INSERT INTO Towns(ID,NAME)
VALUES

	(1,'Sofia'),
	(2,'Plovdiv'),
	(3,'Varna')

INSERT INTO Minions (ID,NAME,AGE,TOWNID)
VALUES

(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',null,2)


delete Minions

SELECT * FROM Minions
SELECT * FROM Towns

DROP TABLE Minions
DROP TABLE Towns

