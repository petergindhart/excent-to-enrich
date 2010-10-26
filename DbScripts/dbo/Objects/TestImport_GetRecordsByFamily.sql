SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

if exists (
	select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[TestImport_GetRecordsByFamily]') and OBJECTPROPERTY(id, N'IsProcedure') = 1
	)
	drop procedure [dbo].[TestImport_GetRecordsByFamily]
GO

/*
<summary>
Gets TestImport data that belong to certain testdefinition family. 
</summary>
<param name="FamilyID">
The uniqueidentifier of the TestDefinitionFamily
</param> 
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.TestImport_GetRecordsByFamily
	@FamilyID uniqueidentifier
AS

create table #TestCount (ImportID uniqueidentifier, Tests int)

declare @sql varchar(1024)

set @sql = 	' insert into #TestCount'+
		' select importid, count(*)'+
		' from @tableName'+
		' where importid is not null'+
		' group by importid'

exec TestDefinition_ExecForFamily @FamilyID, @sql

SELECT 
	ISNULL(tc.TestCount, 0) AS TestCount, 
	import.* 
FROM
	TestImport import LEFT JOIN
	(
		SELECT ImportID, sum(Tests) as TestCount
		from #TestCount
		group by ImportID
	) tc ON import.ID = tc.ImportID
WHERE import.HandlerID in
	(
		SELECT handler.ID
		FROM
			TestImportHandler handler JOIN 
			TestImportHandlerTestDefinitionFamily handlerFamily ON handlerFamily.HandlerID = handler.ID
		WHERE
			handlerFamily.FamilyID = @FamilyID		
	)
ORDER BY import.ImportedOn DESC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

