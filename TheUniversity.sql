--CREATE DATABASE TheUniversity

USE TheUniversity

Create Table Student
(
	SID int,
	SName nvarchar(50),
	Major nvarchar(20),
	Year char(2),
	Age tinyint,
	PRIMARY KEY(SID)
)

Create Table Course
(
	CCode varchar(8),
	CTime varchar(10),
	Room varchar(10),
	NbrStd smallint,
	AvgTotal decimal(7,3),
	PRIMARY KEY(CCode)
)

Create Table Enrollment
(
	SID int,
	CCode varchar(8),
	Midterm smallint,
	Final smallint,
	Total decimal(7,3)
	PRIMARY KEY(SID, CCode),
	FOREIGN KEY (SID) REFERENCES Student(SID),
	FOREIGN KEY (CCode) REFERENCES Course(CCode)
)

Insert Into Course(CCode, CTime, Room, NbrStd) VALUES ('BA200', 'MWF9', 'SC110', 3)
Insert Into Course(CCode, CTime, Room, NbrStd) VALUES ('BD445', 'MWF3', 'SC213', 3)
Insert Into Course(CCode, CTime, Room, NbrStd) VALUES ('BF410', 'MWF8', 'SC213', 1)
Insert Into Course(CCode, CTime, Room, NbrStd) VALUES ('CS150', 'MWF3', 'EA304', 2)
Insert Into Course(CCode, CTime, Room, NbrStd) VALUES ('CS250', 'MWF12', 'EB210', 2)

INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(100, 'Jones', 'History', 'GR', 21)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(150, 'Parks', 'Accounting', 'SO', 19)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(200, 'Baker', 'Math', 'GR', 50)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(250, 'Glass', 'History', 'SR', 41)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(300, 'Baker', 'Accounting', 'SR', 41)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(350, 'Russell', 'Math', 'JR', 20)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(400, 'Rye', 'Accounting', 'GR', 18)
INSERT INTO Student(SID, SName, Major, Year, Age) VALUES(450, 'Jones', 'History', 'FR', 24)

INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(100, 'BD445', 70, 77)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(150, 'BA200', 65, 89)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(200, 'BD445', 71, 93)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(200, 'CS250', 93, 98)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(300, 'CS150', 88, 99)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(400, 'BA200', 100, 78)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(400, 'BD445', 54, 68)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(400, 'BF410', 47, 69)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(400, 'CS150', 33, 55)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(400, 'CS250', 86, 87)
INSERT INTO Enrollment(SID, CCode, Midterm, Final) VALUES(450, 'BA200', 79, 81)

SELECT * FROM Student
SELECT * FROM Course
SELECT * FROM Enrollment

--if student's age is greater than or equal to 25, update Grade as AA(4.00),
--otherwise, update it as BB(3.00).

CREATE PROCEDURE sp_UpdateGrade
	@stuID int
AS
BEGIN
	Declare @age int
	Set @age = (Select Age From Student Where StudentId = @stuID)
	If (@age >= 25)
	Begin
		--AA
		Update Transcript Set Grade = 4.00 Where StudentID = @stuID
	End

	Else
	Begin
		--BB
		Update Transcript Set Grade = 3.00 Where StudentID = @stuID
	End
END


----------------
Declare @num int
--Set @num = 5
--Set @num = (Select StudentID From Studen Where FirstName = 'Ali')

Select @num = StudentID
From Student
Where FirstName = 'Ali'

Select @num
----------------

CREATE TABLE Log
(
	LogID int identity(1,1),
	CCode varchar(8),
	ErrCode varchar(2),
	Primary Key (LogID)
)

CREATE PROCEDURE sp_UpdateAvgTotal
	@CCode varchar(8)
AS
BEGIN
	Update Enrollment Set Total = Midterm * 0.3 + Final * 0.7
	Where CCode = @CCode
	IF (not exists (Select * From Course Where CCode = @CCode))
	Begin
		--I: Invalid course
		INSERT INTO Log(CCode, ErrCode) Values(@CCode, 'I')
	End

	ELSE
	Begin
		If (not exists (Select * From Enrollment Where CCode = @CCode))
		Begin
			--NC: no enrolled course
			INSERT INTO Log(CCode, ErrCode) Values(@CCode, 'NC')
		End

		Else
		Begin
			--Update AvgTotal
			Update c
			Set c.AvgTotal = eav.avTot
			From Course c, 
				(Select e.CCode, AVG(Total) avTot
				From Enrollment e
				Group by e.CCode) eav
			Where c.CCode = eav.CCode
		End
	End
END



sp_UpdateAvgTotal 'BF410'

SELECT * FROM Student
SELECT * FROM Course
SELECT * FROM Enrollment
