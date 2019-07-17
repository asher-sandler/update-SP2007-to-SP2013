USE [WSS_CONTENT_2007]
GO
CREATE USER [region\29astahovab] FOR LOGIN [region\29astahovab]
GO
USE [WSS_CONTENT_2007]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [region\29astahovab]
GO
USE [WSS_CONTENT_2007]
GO
EXEC sp_addrolemember N'db_owner', N'region\29astahovab'
GO