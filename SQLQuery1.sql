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
		CHECK (gender_type='ч' OR gender_type='ж')

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
	DEFAULT 'так';

ALTER TABLE Employees
	DROP CONSTRAINT DF__Employees__Singl__693CA210;

ALTER TABLE Employees
DROP COLUMN Single;

EXEC SP_RENAME  'Employees' , 'Employees1';

EXEC SP_RENAME  'Employees1' , 'Employees';

*/
INSERT INTO Disciplines (disciplines_title) 
VALUES('Алгебра'),('Геометрія'),
('Вища математика'),('Диференціальні рівняння'),
('Теорія ймовірності'),('Бази даних'),
('Аналітика даних'),('Фізика'),
('Англійська мова'),('Дискретна математика');

INSERT INTO Department_type (department_title)
VALUES('Факультет'),('Інститут');

INSERT INTO Subdivisions (subdivision_title, department_ID)
VALUES('ТЕФ', 1),('ФАКС', 1),
('ФТІ', 2),('ІФФ', 2),
('ФІОТ', 1),('ІТС', 1),
('ІПСА', 2),('ФЕЛ', 1),
('ФМФ', 1),('ІСЗЗІ', 2);

INSERT INTO Position(position_title)
VALUES('Асистент'),('Доцент'),
('Завідувач кафедри'),('Старший викладач'),
('Професор'),('Професор'),
('Асистент'),('Професор'),
('Доцент'),('Професор');

INSERT INTO Employees(surname, name, patronymic, gender_type, birth_date, residence_address, position_id, subdivision_id)
VALUES('Петров', 'Петро', 'Петрочвич', 'ч', '19.04.1955', 'Київ, вул. Крещатик 5', 1, 1),
('Іванов', 'Іван', 'Іванович', 'ч', '26.05.1960', 'Київ, вул. Курська, 32', 2, 2),
('Малик', 'Олена', 'Борисівна', 'ж', '18.02.1943', 'Київ, вул. Борщагівська 124', 3, 3),
('Липа', 'Ярослава', 'Сергіївна', 'ч', '29.03.1951', 'Київ, вул. Івана Франка 7', 4, 4),
('Лозинська', 'Ольга', 'Володимирівна', 'ж', '11.09.1952', 'Київ, вул. Ереванська 20', 5, 5),
('Кінь', 'Василь', 'Андрійович', 'ч', '15.01.1959', 'Київ, вул. Фучіка 8', 6, 6),
('Кіт', 'Оксана', 'Петрівна', 'ж', '05.04.1961', 'Київ, вул. Виборгзька 35', 7, 7),
('Лис', 'Ігор', 'Віталійович', 'ч', '12.05.1948', 'Київ, вул. Радужна 45', 8, 8),
('Вовк', 'Володимир', 'Семенович', 'ч', '01.08.1949', 'Київ, вул. Голова 12', 9, 9),
('Ластівка', 'Алла', 'Володимирівна', 'ж', '20.02.1965', 'Київ, бул. Лесі Українки 156', 10, 10);

INSERT INTO DisList(IDEmployee, ID_Discipline)
VALUES(1,1),(1,2),(2,2),(2,3),(5,4),(4,5),(5,5),(2,5),(6,6),(6,4),(7,7),(3,8),(8,8),(9,9),(10,10),(1,10),(1,9), (1,4);

/*SELECT surname 'Прізвище', name 'Ім''я', patronymic 'По батькові', disciplines_title 'Дисципліна' 
	FROM Employees E INNER JOIN Disciplines Dn ON E.disciplines_id = Dn.ID_Discipline 	WHERE surname = 'Липа'
	ORDER BY IDEmployee;
SELECT subdivision_title 'Підрозділ', surname 'Прізвище', name 'Ім''я', patronymic 'По батькові'
	FROM Subdivisions Sb INNER JOIN Employees E ON Sb.ID_Sub = E.IDEmployee WHERE 	subdivision_title = 'ФТІ'
	ORDER BY ID_Sub;
SELECT subdivision_title 'Підрозділ', disciplines_title 'Дисципліна' 
	FROM Subdivisions Sb INNER JOIN Disciplines Dn ON Sb.ID_Sub = Dn.ID_Discipline 	WHERE subdivision_title = 'ФТІ'
	ORDER BY ID_Sub;
SELECT position_title 'Должность', COUNT(E.position_id)
	FROM Position P INNER JOIN Employees E ON E.position_id=P.ID_Position Group by P.position_title

SELECT surname 'Прізвище', disciplines_title 'Дисципліна'
	FROM Employees E INNER JOIN DisList D1 ON E.IDEmployee=D1.IDEmployee INNER JOIN Disciplines D2 ON D1.ID_Discipline=D2.ID_Discipline;*/
	/*
SELECT surname 'Прізвище', name 'Ім''я', birth_date 'Дата народження'
	FROM Employees WHERE birth_date > (SELECT (CAST(AVG(CAST(CAST(birth_date AS DATETIME) AS FLOAT)) AS DATETIME)) FROM Employees);

SELECT surname 'Прізвище', name 'Ім''я', birth_date 'Дата народження'
	FROM Employees WHERE birth_date = (SELECT (CAST(MAX(CAST(CAST(birth_date AS DATETIME) AS FLOAT)) AS DATETIME)) FROM Employees);

SELECT surname 'Прізвище', name 'Ім''я', disciplines_title 'Дисципліна'
	FROM Employees E INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee 
	AND birth_date < (SELECT (CAST(AVG(CAST(CAST(birth_date AS DATETIME) AS FLOAT)) AS DATETIME)) FROM Employees);

SELECT surname 'Прізвище', Count(Ds.ID_Discipline) 'Count'
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
  RAISERROR('Співробітник вже занесений до таблиці!',16,1)
  ROLLBACK TRANSACTION
END
ELSE
  INSERT INTO Employees(surname, name, patronymic, gender_type, birth_date, residence_address, position_id, subdivision_id) SELECT surname, name, patronymic, gender_type, birth_date, residence_address, position_id, subdivision_id FROM inserted
