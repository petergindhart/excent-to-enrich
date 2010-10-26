SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestImport_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TestImport_GetAllRecords]
GO

/*
<summary>
Gets all records from the TestImport table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TestImport_GetAllRecords
AS
	


create table #TestCount (ImportID uniqueidentifier, Tests int)

declare @sql varchar(8000)

set @sql = 	' insert into #TestCount'+
		' select importid, count(*)'+
		' from @tableName'+
		' where importid is not null'+
		' group by importid'

exec TestDefinition_ExecForEach @sql

SELECT ISNULL(tc.TestCount, 0) AS TestCount, t.*
	FROM
		TestImport t LEFT JOIN
		(select ImportID, sum(Tests) as TestCount
		from #TestCount
		group by ImportID) tc 
		ON t.ID = tc.ImportID
	ORDER BY ImportedOn DESC
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

