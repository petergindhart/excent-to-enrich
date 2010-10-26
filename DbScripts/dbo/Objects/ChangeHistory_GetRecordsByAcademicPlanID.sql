SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ChangeHistory_GetRecordsByAcademicPlanID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ChangeHistory_GetRecordsByAcademicPlanID]
GO


/*
<summary>
Gets records from the ChangeHistory table for the specified AcademicPlanIDs 
</summary>
<param name="ids">Ids of the AcademicPlan's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.ChangeHistory_GetRecordsByAcademicPlanID 
	@ids uniqueidentifierarray
AS
	SELECT c.AcademicPlanID, c.*
	FROM
		ChangeHistory c INNER JOIN
		GetIds(@ids) AS Keys ON c.AcademicPlanID = Keys.Id 
	ORDER BY c.ChangeDate DESC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO