DROP VIEW IF EXISTS Employees_view, Sub_Emp_view, Sub_Dis_view
GO

CREATE VIEW Employees_view AS
SELECT surname 'Співробітник', disciplines_title 'Дисципліна'
FROM Employees E INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee
GO

SELECT * FROM Employees_view
WHERE Співробітник = 'Іванов'
GO

CREATE VIEW Sub_Emp_view AS
SELECT subdivision_title 'Підрозділ', surname 'Співробітник'
FROM Subdivisions Sb INNER JOIN Employees E ON Sb.ID_Sub = E.subdivision_id
GO

SELECT * FROM Sub_Emp_view
WHERE Підрозділ = 'ФТІ'
GO

CREATE VIEW Sub_Dis_view AS
SELECT subdivision_title 'Підрозділ', disciplines_title 'Дисципліна'
FROM Subdivisions Sb INNER JOIN Employees E ON Sb.ID_Sub = E.subdivision_id INNER JOIN (DisList Dl INNER JOIN Disciplines Ds ON Dl.ID_Discipline=Ds.ID_Discipline) ON E.IDEmployee = Dl.IDEmployee
GO

SELECT * FROM Sub_Dis_view
WHERE Підрозділ = 'ФТІ'
GO