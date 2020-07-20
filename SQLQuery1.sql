DROP TABLE IF EXISTS DisList, Employees, Position, Disciplines, Subdivisions, Department_type
DROP TRIGGER IF EXISTS InsertEmployee

CREATE TABLE Department_type (
	ID_Dep INT IDENTITY 
	CONSTRAINT ID_Dep_Primary PRIMARY KEY,
	Department_title varchar(20)
	CONSTRAINT DepTitlePrimary UNIQUE
);

CREATE TABLE Subdivisions (
	ID_Sub INT IDENTITY 
	CONSTRAINT ID_Sub_Primary PRIMARY KEY,
	subdivision_title varchar(20) 
	CONSTRAINT SubTitlePrimary UNIQUE, 
	department_ID INT FOREIGN KEY REFERENCES Department_type(ID_Dep) 
		ON DELETE CASCADE NOT NULL
);

CREATE TABLE Disciplines (
	ID_Discipline INT IDENTITY 
	CONSTRAINT ID_Dis_Primary PRIMARY KEY,
	disciplines_title varchar(50) NOT NULL
);

CREATE TABLE Position (
	ID_Position INT IDENTITY 
	CONSTRAINT ID_Pos_Primary PRIMARY KEY,
	position_title varchar(20) NOT NULL
);

CREATE TABLE Employees (
	IDEmployee INT IDENTITY 
	CONSTRAINT ID_Emp_Primary PRIMARY KEY,
	surname nvarchar(20) NOT NULL,
	name nvarchar(20) NOT NULL,
	patronymic nvarchar(20) NOT NULL,
	gender_type varchar(1) NOT NULL,
	birth_date date NOT NULL, 
	residence_address nvarchar(50) NOT NULL, 
	position_id INT FOREIGN KEY REFERENCES Position(ID_Position) 
		ON DELETE CASCADE NOT NULL, 
	subdivision_id INT FOREIGN KEY REFERENCES Subdivisions(ID_Sub) 
		ON DELETE CASCADE NOT NULL
);

CREATE TABLE DisList (
	ID_DisList INT IDENTITY
	CONSTRAINT ID_DisList_Primary PRIMARY KEY,
	IDEmployee INT FOREIGN KEY REFERENCES Employees(IDEmployee)
		ON DELETE CASCADE NOT NULL,
	ID_Discipline INT FOREIGN KEY REFERENCES Disciplines(ID_Discipline)
		ON DELETE CASCADE NOT NULL
);

ALTER TABLE Employees
	ADD CONSTRAINT GenderCheck
		CHECK (gender_type='�' OR gender_type='�')

ALTER TABLE Employees
	ADD CONSTRAINT BirthCheck
		CHECK (YEAR(GETDATE())-YEAR(birth_date)>18)
GO

/*
ALTER TABLE Subdivisions
	NOCHECK CONSTRAINT FK__Subdivisi__depar__1DB06A4F;

ALTER TABLE Subdivisions
	CHECK CONSTRAINT FK__Subdivisi__depar__1DB06A4F;*/

/*ALTER TABLE Employees
	ADD Single VARCHAR(3)
	DEFAULT '���';

ALTER TABLE Employees
	DROP CONSTRAINT DF__Employees__Singl__693CA210;

ALTER TABLE Employees
DROP COLUMN Single;

EXEC SP_RENAME  'Employees' , 'Employees1';

EXEC SP_RENAME  'Employees1' , 'Employees';

*/
INSERT INTO Disciplines (disciplines_title) 
VALUES('�������'),('��������'),
('���� ����������'),('������������� �������'),
('����� ���������'),('���� �����'),
('�������� �����'),('Գ����'),
('��������� ����'),('��������� ����������');

INSERT INTO Department_type (department_title)
VALUES('���������'),('��������');

INSERT INTO Subdivisions (subdivision_title, department_ID)
VALUES('���', 1),('����', 1),
('�Ҳ', 2),('���', 2),
('Բ��', 1),('���', 1),
('����', 2),('���', 1),
('���', 1),('���ǲ', 2);

INSERT INTO Position(position_title)
VALUES('��������'),('������'),
('�������� �������'),('������� ��������'),
('��������'),('��������'),
('��������'),('��������'),
('������'),('��������');

INSERT INTO Employees(surname, name, patronymic, gender_type, birth_date, residence_address, position_id, subdivision_id)
VALUES('������', '�����', '���������', '�', '19.04.1955', '���, ���. �������� 5', 1, 1),
('������', '����', '��������', '�', '26.05.1960', '���, ���. �������, 32', 2, 2),
('�����', '�����', '��������', '�', '18.02.1943', '���, ���. ����������� 124', 3, 3),
('����', '��������', '���㳿���', '�', '29.03.1951', '���, ���. ����� ������ 7', 4, 4),
('���������', '�����', '������������', '�', '11.09.1952', '���, ���. ���������� 20', 5, 5),
('ʳ��', '������', '���������', '�', '15.01.1959', '���, ���. ������ 8', 6, 6),
('ʳ�', '������', '�������', '�', '05.04.1961', '���, ���. ���������� 35', 7, 7),
('���', '����', '³��������', '�', '12.05.1948', '���, ���. ������� 45', 8, 8),
('����', '���������', '���������', '�', '01.08.1949', '���, ���. ������ 12', 9, 9),
('�������', '����', '������������', '�', '20.02.1965', '���, ���. ��� ������� 156', 10, 10);

INSERT INTO DisList(IDEmployee, ID_Discipline)
VALUES(1,1),(1,2),(2,2),(2,3),(5,4),(4,5),(5,5),(2,5),(6,6),(6,4),(7,7),(3,8),(8,8),(9,9),(10,10),(1,10),(1,9), (1,4);

/*SELECT surname '�������', name '��''�', patronymic '�� �������', disciplines_title '���������' 
	FROM Employees E INNER JOIN Disciplines Dn ON E.disciplines_id = Dn.ID_Discipline 	WHERE surname = '����'
	ORDER BY IDEmployee;
SELECT subdivision_title 'ϳ������', surname '�������', name '��''�', patronymic '�� �������'
	FROM Subdivisions Sb INNER JOIN Employees E ON Sb.ID_Sub = E.IDEmployee WHERE 	subdivision_title = '�Ҳ'
	ORDER BY ID_Sub;
SELECT subdivision_title 'ϳ������', disciplines_title '���������' 
	FROM Subdivisions Sb INNER JOIN Disciplines Dn ON Sb.ID_Sub = Dn.ID_Discipline 	WHERE subdivision_title = '�Ҳ'
	ORDER BY ID_Sub;
SELECT position_title '���������', COUNT(E.position_id)
	FROM Position P INNER JOIN Employees E ON E.position_id=P.ID_Position Group by P.position_title

SELECT surname '�������', disciplines_title '���������'
	FROM Employees E INNER JOIN DisList D1 ON E.IDEmployee=D1.IDEmployee INNER JOIN Disciplines D2 ON D1.ID_Discipline=D2.ID_Discipline;*/
	/*
SELECT surname '�������', name '��''�', birth_date '���� ����������'
	FROM Employees WHERE birth_date > (SELECT (CAST(AVG(CAST(CAST(birth_date AS DATETIME) AS FLOAT)) AS DATETIME)) FROM Employees);

SELECT surname '�������', name '��''�', birth_date '���� ����������'
	FROM Employees WHERE birth_date = (SELECT (CAST(MAX(CAST(CAST(birth_date AS DATETIME) AS FLOAT)) AS DATETIME)) FROM Employees);

SELECT surname '�������', name '��''�', disciplines_title '���������'
	FROM Employees E INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee 
	AND birth_date < (SELECT (CAST(AVG(CAST(CAST(birth_date AS DATETIME) AS FLOAT)) AS DATETIME)) FROM Employees);

SELECT surname '�������', Count(Ds.ID_Discipline) 'Count'
	FROM Employees E INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee
	Group by surname Having Count(Ds.ID_Discipline) >= ALL(select Count(Ds.ID_Discipline)
	FROM Employees E INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee
	Group by surname);*/

GO
CREATE TRIGGER InsertEmployee
ON Employees
INSTEAD OF INSERT
AS
IF EXISTS (SELECT 'TRUE'      
  FROM INSERTED I JOIN Employees E ON I.surname = E.surname
WHERE I.name = E.name AND I.surname = E.surname AND I.patronymic = E.patronymic AND I.birth_date = E.birth_date)
BEGIN
  RAISERROR('���������� ��� ��������� �� �������!',16,1)
  ROLLBACK TRANSACTION
END
ELSE
  INSERT INTO Employees(surname, name, patronymic, gender_type, birth_date, residence_address, position_id, subdivision_id) SELECT surname, name, patronymic, gender_type, birth_date, residence_address, position_id, subdivision_id FROM inserted
