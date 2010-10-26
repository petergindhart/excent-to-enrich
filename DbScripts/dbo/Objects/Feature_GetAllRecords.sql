
/****** Object:  StoredProcedure [dbo].[Feature_GetAllRecords]    Script Date: 12/07/2007 11:36:11 ******/
IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[Feature_GetAllRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Feature_GetAllRecords]

go
 /*
<summary>
Gets all records from the Feature table 
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Feature_GetAllRecords] 
AS
	SELECT f.*
	FROM
		Feature f 
	ORDER BY Name