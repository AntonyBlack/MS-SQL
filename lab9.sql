/*CREATE LOGIN basalt 
	WITH PASSWORD = 'lol';
CREATE USER basalt 
	FOR LOGIN basalt;
EXEC sp_addrolemember db_datareader, basalt;
GRANT EXECUTE ON OBJECT::n_dis 
	TO Bill;
REVOKE SELECT, UPDATE, DELETE, INSERT, EXECUTE, REFERENCES ON SCHEMA::dbo 
	TO John;*/
/*
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'abc';
CREATE CERTIFICATE Certificate2 
	WITH SUBJECT = 'Protect Data';
CREATE SYMMETRIC KEY SymmetricKey2 
	WITH ALGORITHM = AES_128 ENCRYPTION BY CERTIFICATE Certificate2;
ALTER TABLE Position 
	ADD P_enc VARBINARY(max) NULL;*/

OPEN SYMMETRIC KEY SymmetricKey2 
	DECRYPTION BY CERTIFICATE Certificate2;
UPDATE Position 
	SET P_enc = EncryptByKey(Key_GUID('SymmetricKey1'), position_title);
SELECT CONVERT(varchar, DecryptByKey(P_enc)) 
	FROM Position;
CLOSE SYMMETRIC KEY SymmetricKey2;
