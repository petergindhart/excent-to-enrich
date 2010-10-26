IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[School_GetRecordByNumber]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[School_GetRecordByNumber]
GO


 /*
<summary>
Gets a school by its number
</summary>
<param name="number">The number to search for</param>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[School_GetRecordByNumber] 
	@number VARCHAR(10)
AS
	SELECT *
	FROM School
	WHERE Number = @number