USE [master]
RESTORE DATABASE [WSS_Content-s29sps] FROM  DISK = N'C:\AdminDir\Backup\JobPortal.bak' WITH  FILE = 1, 
MOVE N'WSS_Content' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\WSS_Content-s29sps.mdf',  
MOVE N'WSS_Content_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\WSS_Content-s29sps.LDF',  NOUNLOAD,  STATS = 5
GO

