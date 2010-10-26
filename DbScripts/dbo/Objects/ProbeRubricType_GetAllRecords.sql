if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProbeRubricType_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProbeRubricType_GetAllRecords]
GO

 /*
<summary>
Gets all records from the ProbeRubricType table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE ProbeRubricType_GetAllRecords
AS
	SELECT
		p.*
	FROM
		ProbeRubricType p
	ORDER BY 
		p.Name ASC