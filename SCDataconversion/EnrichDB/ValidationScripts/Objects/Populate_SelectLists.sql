IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Populate_SelectLists')
DROP PROC x_DATAVALIDATION.Populate_SelectLists
GO

CREATE PROC x_DATAVALIDATION.Populate_SelectLists
AS
BEGIN
DECLARE @dsql NVARCHAR(MAX), @sql NVARCHAR(MAX), @Linkedserver VARCHAR(100), @DatabaseOwner VARCHAR(100), @DatabaseName VARCHAR(100)

SELECT @Linkedserver = LinkedServer, @DatabaseOwner = DatabaseOwner, @DatabaseName = DatabaseName
FROM VC3ETL.ExtractDatabase 
WHERE ID = '54DD3C28-8F7F-4A54-BCF1-000000000000'

SET @dsql = 'DROP TABLE X_DATAVALIDATION.SelectLists_LOCAL'
EXEC sp_executesql @stmt=@dsql

SET @sql='
SELECT * 
INTO  X_DATAVALIDATION.SelectLists_LOCAL 
FROM  '+@Linkedserver+'.'+@DatabaseName+'.'+@DatabaseOwner+'.'+'SELECTLISTS_EO'
--PRINT @sql
EXEC sp_executesql @stmt=@sql

END
GO


--exec x_DATAVALIDATION.Populate_SelectLists