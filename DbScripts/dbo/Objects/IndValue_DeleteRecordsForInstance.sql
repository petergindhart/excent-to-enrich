if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IndValue_DeleteRecordsForInstance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IndValue_DeleteRecordsForInstance]
GO


/*
<summary>
Deletes records from the IndValue table for the given ids
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IndValue_DeleteRecordsForInstance]
	@instances uniqueidentifierarray
AS
	DELETE FROM 
		IndValue 
	WHERE 
		InstanceID in (select Id from GetUniqueidentifiers(@instances))

GO
