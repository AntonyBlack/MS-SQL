CREATE LOGIN Dubas WITH PASSWORD = '123'
CREATE USER Dubas FOR LOGIN Dubas
GRANT SELECT ON Employees TO Dubas