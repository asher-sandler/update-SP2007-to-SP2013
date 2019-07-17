

BACKUP DATABASE [WSS_Content] TO  DISK = N'\\s29portaldb.region.cbr.ru\c$\AdminDir\Backup\WSS_CONTENT.BAK' 
WITH NOFORMAT, NOINIT,  
NAME = N'WSS_Content-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
