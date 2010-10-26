/****** Object:  StoredProcedure [dbo].[FormInterval_GetRecordsByCummulativeUpTo]    Script Date: 06/05/2008 11:26:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInterval_GetRecordsByCummulativeUpTo]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInterval_GetRecordsByCummulativeUpTo]
GO

 /*
<summary>
Gets records from the FormInterval table
with the specified ids
</summary>
<param name="ids">Ids of the FormInterval(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE  PROCEDURE [dbo].[FormInterval_GetRecordsByCummulativeUpTo]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.CumulativeUpTo,
		f.*
	FROM
		FormInterval f
	where
		f.Sequence <= 
			(
				select 
					top 1 Sequence 
				From FormInterval 
				where ID = 
						(					
							select 
								top 1 ID 
							from 
								GetUniqueidentifiers(@ids)
						)
			)