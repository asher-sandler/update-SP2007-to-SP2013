USE [WSS_Content-s29sps]
GO
CREATE USER [region\29astahovab] FOR LOGIN [region\29astahovab]
GO
USE [WSS_Content-s29sps]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [region\29astahovab]
GO
USE [WSS_Content-s29sps]
GO
EXEC sp_addrolemember N'db_owner', N'region\29astahovab'
GO
