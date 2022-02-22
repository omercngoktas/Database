select * from Student
select * from Course
select * from Transcript

CREATE PROCEDURE sp_FirstNameToUpperCase
AS
BEGIN
	UPDATE Student
	SET FirstName = UPPER(FirstName)
END

EXECUTE sp_FirstNameToUpperCase