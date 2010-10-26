SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[School_GetOtherSchoolByTeacherID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[School_GetOtherSchoolByTeacherID]
GO

/*
<summary>
Gets records from the School table for the specified TeacherIDs 
</summary>
<param name="ids">Ids of the Teacher </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.School_GetOtherSchoolByTeacherID
	@ids uniqueidentifierarray
AS

	select hist.TeacherID, s.*
	from
		School s INNER JOIN 
		(
			SELECT
				th.TeacherID, th.SchoolID, AsOfDate=MIN(th.StartDate)
			FROM
				TeacherSchoolHistory th INNER JOIN
				GetIds(@ids) AS Keys ON th.TeacherID = Keys.Id
			WHERE
				th.EndDate is not null
			GROUP BY
				th.TeacherID, th.SchoolID
		) hist ON s.ID = hist.SchoolID
	order by hist.AsOfDate

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

