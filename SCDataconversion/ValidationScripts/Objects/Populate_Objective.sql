IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Populate_Objective')
DROP PROC x_DATAVALIDATION.Populate_Objective
GO

CREATE PROC x_DATAVALIDATION.Populate_Objective
AS
BEGIN
DECLARE @dsql NVARCHAR(MAX)
DECLARE @sql NVARCHAR(MAX)
DECLARE @Linkedserver VARCHAR(100)
DECLARE @DatabaseOwner VARCHAR(100)
DECLARE @DatabaseName VARCHAR(100)

SELECT @Linkedserver = LinkedServer FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-975173CB485C'
SELECT @DatabaseOwner=DatabaseOwner FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-975173CB485C'
SELECT @DatabaseName=DatabaseName FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-975173CB485C'

SET @dsql = 'DROP TABLE X_DATAVALIDATION.Objective_LOCAL'
EXEC sp_executesql @stmt=@dsql

SET @sql='SELECT * INTO  X_DATAVALIDATION.Objective_LOCAL FROM  '+@Linkedserver+'.'+@DatabaseName+'.'+@DatabaseOwner+'.'+'Objective_EO'
--PRINT @sql
EXEC sp_executesql @stmt=@sql

END
GO


--exec x_DATAVALIDATION.Populate_Objective