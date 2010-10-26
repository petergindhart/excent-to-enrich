
/****** Object:  StoredProcedure [dbo].[Person_GetAllRecords]    Script Date: 10/07/2010 08:28:35 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Person_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Person_GetAllRecords]
GO


GO
 /*
<summary>
Gets all records from the Person table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Person_GetAllRecords]
AS
	SELECT
		p.*
	FROM
		Person p
	WHERE
		p.Deleted is null
