IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Populate_SpedObjects')
DROP PROC x_DATAVALIDATION.Populate_SpedObjects
GO

CREATE PROC x_DATAVALIDATION.Populate_SpedObjects
AS
BEGIN

EXEC master..xp_CMDShell 'E:\GIT\excent-to-enrich\SCDataconversion\ValidationScripts\Support\VPNConnect.bat'

EXEC master..xp_CMDShell 'E:\GIT\excent-to-enrich\SCDataconversion\ValidationScripts\Support\PopulateDataconversionspeedobjects.bat'

END
