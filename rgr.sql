DROP TABLE IF EXISTS  Rozklad, Groups, DisList, Employees, Position, Disciplines, Subdivisions
CREATE TABLE Subdivisions (
	ID_Sub INT IDENTITY 
	CONSTRAINT ID_Sub_Primary PRIMARY KEY,
	subdivision_title varchar(20) 
	CONSTRAINT SubTitlePrimary UNIQUE
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
	NaukStupin nvarchar(20) NOT NULL, 
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

CREATE TABLE Groups(
	ID_Groups INT IDENTITY
	CONSTRAINT ID_Groups_Primary PRIMARY KEY,
	GroupNumber int NOT NULL
);

CREATE TABLE Rozklad(
	ID_Rozklad INT IDENTITY
	CONSTRAINT ID_Rozklad_Primary PRIMARY KEY,
	WeekDay varchar(2) NOT NULL,
	Time time NOT NULL,
	RoomNumber int NOT NULL,
	ID_DisList INT FOREIGN KEY REFERENCES DisList(ID_DisList)
		ON DELETE CASCADE,
	ID_Groups INT FOREIGN KEY REFERENCES Groups(ID_Groups)
		ON DELETE CASCADE
);


ALTER TABLE Employees
	ADD CONSTRAINT GenderCheck
		CHECK (gender_type='�' OR gender_type='�')

ALTER TABLE Employees
	ADD CONSTRAINT BirthCheck
		CHECK (YEAR(GETDATE())-YEAR(birth_date)>18)
GO

INSERT INTO Disciplines (disciplines_title) 
VALUES('�������'),('��������'),
('���� ����������'),('������������� �������'),
('����� ���������'),('���� �����'),
('�������� �����'),('Գ����'),
('��������� ����'),('��������� ����������');

INSERT INTO Subdivisions (subdivision_title)
VALUES('��'),('���'),
('��'),('��ǲ'),
('���ǲ');

INSERT INTO Position(position_title)
VALUES('��������'),('������');

INSERT INTO Employees(surname, name, patronymic, gender_type, birth_date, residence_address, NaukStupin, position_id, subdivision_id)
VALUES('������', '�����', '���������', '�', '19.04.1955', '���, ���. �������� 5','������', 1, 1),
('������', '����', '��������', '�', '26.05.1960', '���, ���. �������, 32','������', 2, 2),
('�����', '�����', '��������', '�', '18.02.1943', '���, ���. ����������� 124','������', 1, 3),
('����', '��������', '���㳿���', '�', '29.03.1951', '���, ���. ����� ������ 7','��������', 2, 4),
('���������', '�����', '������������', '�', '11.09.1952', '���, ���. ���������� 20','��������', 1, 5),
('ʳ��', '������', '���������', '�', '15.01.1959', '���, ���. ������ 8','��������', 2, 1);

INSERT INTO DisList(IDEmployee, ID_Discipline)
VALUES(1,1),(1,2),(1,3),
(2,6),(2,7),
(3,4),
(4,9),
(5,10),(5,10),
(6,5);

INSERT INTO Groups(GroupNumber)
VALUES(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO Rozklad(WeekDay, Time, RoomNumber, ID_DisList, ID_Groups)
VALUES('��', '10:25',101, 1,1),('��', '12:20',102, 2,2),('��', '14:15',103, 3,3),
('��', '10:25',106, 4,4),('��', '12:20',105, 5,5),('��', '8:30',104, 6,6),
('��', '10:25',107, 7,7),('��', '8:30',108, 8,8),('��', '14:15',109, 9,9),
('��', '10:25',110, 10,10),('��', '10:25',101, 1,5);

---------------------------------
/*
SELECT subdivision_title '�������', surname '�������', disciplines_title '���������' FROM
Employees E INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee
INNER JOIN Subdivisions S ON E.subdivision_id=S.ID_Sub order by subdivision_title;--1.1
*/
---------------------------------
/*
SELECT surname FROM
Employees E INNER JOIN Position P ON E.position_id=P.ID_Position
WHERE (position_title='������' AND NaukStupin='������') OR (position_title='��������' AND NaukStupin='��������')--1.2
*/
---------------------------------
/*
SELECT surname, WeekDay, Count(ID_Rozklad) FROM
Employees E INNER JOIN (DisList Dl INNER JOIN Rozklad R ON Dl.ID_DisList=R.ID_DisList) ON E.IDEmployee = Dl.IDEmployee
group by surname, WeekDay having Count(ID_Rozklad) > 3--2
GO
*/
---------------------------------

DROP PROC IF EXISTS ZminaRozkladu
GO

CREATE PROC ZminaRozkladu
	 @RoomNumber INT,
	 @WeekDay varchar(2),
	 @Time time,
	 @RoomNumber1 INT,
	 @WeekDay1 varchar(2),
	 @Time1 time
AS
	UPDATE Rozklad
	SET RoomNumber=@RoomNumber1,
		WeekDay=@WeekDay1,
		Time=@Time1
	WHERE
		RoomNumber=@RoomNumber AND
		WeekDay=@WeekDay AND
		Time=@Time
GO

SELECT * FROM Rozklad
Exec ZminaRozkladu 101, '��', '10:25', 201, '��', '10:36'
SELECT * FROM Rozklad--3

---------------------------------
/*
SELECT GroupNumber, surname, name, patronymic, disciplines_title, WeekDay, Time, RoomNumber FROM
Employees E INNER JOIN DisList DL ON E.IDEmployee = DL.IDEmployee INNER JOIN Rozklad R ON DL.ID_DisList=R.ID_DisList
INNER JOIN Disciplines D ON D.ID_Discipline=DL.ID_Discipline INNER JOIN Groups G ON R.ID_Groups=G.ID_Groups
WHERE GroupNumber='5' --4.1
*/
---------------------------------
/*
SELECT subdivision_title, Count(IDEmployee) S, position_title  FROM
Employees E INNER JOIN Subdivisions S ON E.subdivision_id=S.ID_Sub INNER JOIN Position P ON E.position_id=P.ID_Position
group by position_title, subdivision_title--4.2
*/
---------------------------------
/*
GO
DROP PROC IF EXISTS RozkladX
GO

CREATE PROC RozkladX
	@SubdivisionTitle varchar(20)
AS
	SELECT subdivision_title, surname, name, patronymic, disciplines_title, WeekDay, GroupNumber, Time, RoomNumber FROM
	Employees E INNER JOIN DisList DL ON E.IDEmployee = DL.IDEmployee INNER JOIN Rozklad R ON DL.ID_DisList=R.ID_DisList
	INNER JOIN Disciplines D ON D.ID_Discipline=DL.ID_Discipline INNER JOIN Groups G ON R.ID_Groups=G.ID_Groups
	INNER JOIN Subdivisions S ON E.subdivision_id=S.ID_Sub
	where subdivision_title=@SubdivisionTitle
GO

EXEC RozkladX '��'--4.3
*/
---------------------------------
/*
SELECT subdivision_title '�������', surname '�������', Count(ID_Discipline) '�-��� ��������', Count(ID_Discipline)*2 '�-��� �����' FROM
Employees E INNER JOIN DisList D ON E.IDEmployee=D.IDEmployee INNER JOIN Subdivisions S ON E.subdivision_id=S.ID_Sub
group by subdivision_title, surname--4.4
*/



