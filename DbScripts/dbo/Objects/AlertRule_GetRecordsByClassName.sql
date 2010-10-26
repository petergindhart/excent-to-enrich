if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AlertRule_GetRecordsByClassName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AlertRule_GetRecordsByClassName]
GO

 /*
<summary>
Gets records from the AlertRule table for the specific class name
</summary>
<param name="ClassName">Ids of the AlertRuleType(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AlertRule_GetRecordsByClassName
	@ClassName	varchar(300)
AS
	SELECT a.*
	FROM
		AlertRule a
	WHERE
		ClassName = @ClassName
GO
