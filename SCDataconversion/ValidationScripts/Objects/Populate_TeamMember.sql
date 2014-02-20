IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Populate_TeamMember')
DROP PROC x_DATAVALIDATION.Populate_TeamMember
GO

CREATE PROC x_DATAVALIDATION.Populate_TeamMember
AS
BEGIN
DECLARE @dsql NVARCHAR(MAX)
DECLARE @sql NVARCHAR(MAX)
DECLARE @Linkedserver VARCHAR(100)
DECLARE @DatabaseOwner VARCHAR(100)
DECLARE @DatabaseName VARCHAR(100)

SELECT @Linkedserver = LinkedServer FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-000000000000'
SELECT @DatabaseOwner=DatabaseOwner FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-000000000000'
SELECT @DatabaseName=DatabaseName FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-000000000000'

SET @dsql = 'DROP TABLE X_DATAVALIDATION.TeamMember_LOCAL'
EXEC sp_executesql @stmt=@dsql

SET @sql='SELECT * INTO  X_DATAVALIDATION.TeamMember_LOCAL FROM  '+@Linkedserver+'.'+@DatabaseName+'.'+@DatabaseOwner+'.'+'TeamMember_EO'
--PRINT @sql
EXEC sp_executesql @stmt=@sql

END
GO


--exec x_DATAVALIDATION.Populate_TeamMember