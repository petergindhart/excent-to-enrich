SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[School_GetOtherSchoolByStudentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[School_GetOtherSchoolByStudentID]
GO

/*
<summary>
Gets records from the School table for the specified StudentIDs 
</summary>
<param name="ids">Ids of the Student </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.School_GetOtherSchoolByStudentID
	@ids uniqueidentifierarray
AS
	
	select hist.StudentID, s.*
	from
		School s INNER JOIN 
		(
			SELECT
				sh.StudentID, sh.SchoolID, AsOfDate=MIN(sh.StartDate)
			FROM
				StudentSchoolHistory sh INNER JOIN
				GetIds(@ids) AS Keys ON sh.StudentID = Keys.Id
			WHERE
				sh.EndDate is not null
			GROUP BY
				sh.StudentID, sh.SchoolID
		) hist ON s.ID = hist.SchoolID
	order by hist.AsOfDate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

