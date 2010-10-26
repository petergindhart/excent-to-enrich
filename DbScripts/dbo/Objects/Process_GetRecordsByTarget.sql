if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Process_GetRecordsByTarget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Process_GetRecordsByTarget]
GO

 /*
<summary>
Gets records from the Process table with the specified ids
</summary>
<param name="id">Id of the Process to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Process_GetRecordsByTarget
	@id	uniqueidentifier
AS
	SELECT   p.*
	FROM
		Process p
	WHERE TargetID = @id
GO
