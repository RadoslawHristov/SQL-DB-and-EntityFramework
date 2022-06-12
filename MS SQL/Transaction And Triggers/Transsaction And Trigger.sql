--======================= Triggers and Transactions ===========================


--===================== 01. Create Table Logs  ==========================


CREATE TABLE Logs
(
  LogID INT NOT NULL IDENTITY,
  AccountID INT FOREIGN KEY REFERENCES Accounts(Id),
  OldSum MONEY,
  NewSum MONEY,
)

CREATE TRIGGER tr_ChangeBalance ON Accounts
AFTER UPDATE
AS	
BEGIN
INSERT INTO Logs(AccountID,OldSum,NewSum)
SELECT i.Id, d.Balance, i.Balance 
FROM inserted AS i
INNER JOIN deleted AS d
ON i.Id = d.Id
END

SELECT * FROM Accounts

UPDATE Accounts
	SET Balance = 0
	WHERE Id = 1

SELECT * FROM Logs


--============================ 15. Create Table Emails ===========================


CREATE TABLE NotificationEmails
(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	Recipient INT 
	FOREIGN KEY REFERENCES Accounts(id),
	[Subject] VARCHAR(50) NOT NULL,
	Body  TEXT
)



CREATE TRIGGER tr_NotificationEmails ON 
Logs AFTER INSERT 
AS
BEGIN

INSERT INTO NotificationEmails(Recipient,Subject,Body)
	SELECT  
		i.AccountID,
		CONCAT('Balance change for account:',i.AccountID),
		CONCAT('On ',GETDATE(),' your balance was changed from ',i.OldSum,' to ',i.NewSum)
		
	 FROM inserted AS i

END

SELECT * FROM NotificationEmails


--==================== 16. Deposit Money ===========================


CREATE PROCEDURE usp_DepositMoney(@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN TRANSACTION

UPDATE Accounts
SET Balance += @MoneyAmount
WHERE Id = @AccountId

COMMIT


--===================== 17. Withdraw Money Procedure ================================


CREATE PROCEDURE usp_WithdrawMoney (@AccountId INT  , @MoneyAmount MONEY)
AS 
BEGIN TRANSACTION

UPDATE Accounts

	SET Balance -= @MoneyAmount
	WHERE id = @AccountId 

	DECLARE @Sum MONEY = (SELECT Balance FROM Accounts WHERE ID=@AccountId)
	IF (@Sum < 0)
	BEGIN 

	ROLLBACK
	END

COMMIT
SELECT * FROM Accounts
EXEC dbo.usp_WithdrawMoney @Accountid = 2 , @MoneyAmount = 354.23



--=================== 18. Money Transfer ======================================


CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT , @Amount MONEY)
AS
BEGIN TRANSACTION

	EXEC usp_DepositMoney @ReceiverId, @Amount
	EXEC usp_WithdrawMoney @SenderId, @Amount

COMMIT





--========================== 20. *Massive Shopping ===============================


DECLARE @UserName VARCHAR(50) = 'Stamat'
DECLARE @GameName VARCHAR(50) = 'Safflower'
DECLARE @UserID int = (SELECT Id FROM Users WHERE Username = @UserName)
DECLARE @GameID int = (SELECT Id FROM Games WHERE Name = @GameName)
DECLARE @UserMoney money = (SELECT Cash FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)
DECLARE @ItemsTotalPrice money
DECLARE @UserGameID int = (SELECT Id FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)

BEGIN TRANSACTION
	SET @ItemsTotalPrice = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 11 AND 12)

	IF(@UserMoney - @ItemsTotalPrice >= 0)
	BEGIN
		INSERT INTO UserGameItems
		SELECT i.Id, @UserGameID FROM Items AS i
		WHERE i.Id IN (SELECT Id FROM Items WHERE MinLevel BETWEEN 11 AND 12)

		UPDATE UsersGames
		SET Cash -= @ItemsTotalPrice
		WHERE GameId = @GameID AND UserId = @UserID
		COMMIT
	END
	ELSE
	BEGIN
		ROLLBACK
	END

SET @UserMoney = (SELECT Cash FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)
BEGIN TRANSACTION
	SET @ItemsTotalPrice = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)

	IF(@UserMoney - @ItemsTotalPrice >= 0)
	BEGIN
		INSERT INTO UserGameItems
		SELECT i.Id, @UserGameID FROM Items AS i
		WHERE i.Id IN (SELECT Id FROM Items WHERE MinLevel BETWEEN 19 AND 21)

		UPDATE UsersGames
		SET Cash -= @ItemsTotalPrice
		WHERE GameId = @GameID AND UserId = @UserID
		COMMIT
	END
	ELSE
	BEGIN
		ROLLBACK
	END

SELECT Name AS [Item Name]
FROM Items
WHERE Id IN (SELECT ItemId FROM UserGameItems WHERE UserGameId = @userGameID)
ORDER BY [Item Name]


--======================= 21. Employees with Three Projects ===============================



CREATE PROC usp_AssignProject(@EmloyeeId INT , @ProjectID INT)
AS
BEGIN TRANSACTION
DECLARE @ProjectsCount INT;
SET @ProjectsCount = (SELECT COUNT(ProjectID) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId)
IF(@ProjectsCount >= 3)
BEGIN 
 ROLLBACK
 RAISERROR('The employee has too many projects!', 16, 1)
 RETURN
END
INSERT INTO EmployeesProjects
     VALUES
(@EmloyeeId, @ProjectID)
 
 COMMIT


 --========================= 22. Delete Employees =============================


 CREATE TABLE  Deleted_Employees
 (
	EmployeeId INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	MiddleName VARCHAR (50),
	JobTitle VARCHAR(50),
	DepartmentId INT ,
	Salary DECIMAL(18,2)
 )

 CREATE TRIGGER tr_DelitedEmploees ON 
 Deleted_Employees AFTER DELETE
 AS
	INSERT INTO	Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
		SELECT 
			d.EmployeeId,
			d.FirstName,
			d.LastName,
			d.MiddleName,
			d.JobTitle,
			d.DepartmentId,
			d.Salary
	 FROM deleted AS d



 
 SELECT * FROM Deleted_Employees
DELETE FROM Employees
WHERE EmployeeID = 1
 DELETE Employees
 WHERE EmployeeID = 1