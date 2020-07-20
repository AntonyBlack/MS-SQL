DROP PROC IF EXISTS n_dis
GO

CREATE PROC n_dis @Subdivision varchar(20) OUTPUT, @department_ID int OUTPUT AS
	IF NOT EXISTS (SELECT subdivision_title ϳ������ 
FROM Subdivisions
WHERE subdivision_title = @Subdivision)
	BEGIN
	INSERT INTO Subdivisions Values (@Subdivision, @department_ID)
	END
ELSE
	BEGIN
	SELECT '����� ������� ��� ����';
	END
GO

EXEC n_dis '���', 1
