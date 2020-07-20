DROP TABLE IF EXISTS Employees

CREATE TABLE Employees (
	IDEmployee INT IDENTITY 
	CONSTRAINT ID_Emp_Primary PRIMARY KEY,
	surname nvarchar(20) NOT NULL,
	name nvarchar(20) NOT NULL,
	patronymic nvarchar(20) NOT NULL,
	gender_type varchar(1) NOT NULL,
	birth_date date NOT NULL, 
	residence_address nvarchar(50) NOT NULL
);


BACKUP DATABASE bd4 TO DISK = 'D:\Work\KPI\bd4.bak'

INSERT INTO Employees VALUES('Дубас', 'Антон', 'Сергійович', 'ч', '08.01.1999', 'Київ')

BACKUP DATABASE bd4 TO DISK = 'D:\Work\KPI\bd4d.bak' WITH DIFFERENTIAL

USE master
RESTORE DATABASE bd4
FROM  DISK = 'D:\Work\KPI\bd4.bak'
WITH  FILE = 1,  NORECOVERY, REPLACE

USE master
RESTORE DATABASE bd4
FROM  DISK = 'D:\Work\KPI\bd4d.bak'
WITH  FILE = 1,  RECOVERY
GO

