CREATE PROCEDURE sp_FirstNameToUpperCase
AS
BEGIN
	UPDATE Ogrenci
	SET ad = UPPER(ad)
END

EXECUTE sp_FirstNameToUpperCase

SELECT o.ogrno, COUNT(*) NumberOfTakenBooks
FROM Ogrenci o INNER JOIN Islem i on o.ogrno = i.ogrno
GROUP BY o.ogrno

CREATE PROCEDURE sp_UpdateNumberOfTakenBooks
AS
BEGIN
	UPDATE Ogrenci
	SET numberOfTakenBooks = notbl.NoOfTakenBooks
	FROM (	SELECT o.ogrno, COUNT(*) NoOfTakenBooks
			FROM Ogrenci o inner join Islem i on o.ogrno = i.ogrno
			GROUP BY o.ogrno) notbl
	WHERE Ogrenci.ogrno = notbl.ogrno
END

SELECT * FROM Ogrenci
EXECUTE sp_UpdateNumberOfTakenBooks

CREATE TRIGGER trg_UpdateNoOfTakenBooks
	ON Islem
	AFTER delete, insert, update
AS
BEGIN
	--incrementing number of taken books by 1 after inserting.
	UPDATE Ogrenci
	SET numberOfTakenBooks = numberOfTakenBooks + 1
	FROM Ogrenci o INNER JOIN inserted i on o.ogrno = i.ogrno
	
	--decrementing number of taken books by 1 after deleting.
	UPDATE Ogrenci
	SET numberOfTakenBooks = numberOfTakenBooks - 1
	FROM Ogrenci o INNER JOIN deleted d on o.ogrno = d.ogrno
END
GO

select *
from Ogrenci o inner join Islem i on o.ogrno = i.ogrno
where o.ogrno = 1

select * from Islem

delete
from Islem
WHERE ogrno = 1 and kitapno = 2
