IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GradeLevel_GetFirstGradeLevelByDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GradeLevel_GetFirstGradeLevelByDate]
GO

 /*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE [dbo].[GradeLevel_GetFirstGradeLevelByDate]
	@studentId			uniqueidentifier,
	@date				datetime
AS

IF EXISTS(select * from GradeLevel sch join StudentGradeLevelHistory hist on hist.GradeLevelID = sch.ID WHERE hist.StudentID = @studentId and dbo.DateInRange(@date, hist.StartDate, hist.EndDate) = 1)
BEGIN
	-- OPTIMIZATION: Search for exact date if possible
	select top 1 gl.*
	from 
		GradeLevel gl join
		StudentGradeLevelHistory hist on hist.GradeLevelID = gl.ID
	WHERE
		hist.StudentID = @studentId and
		dbo.DateInRange(@date, hist.StartDate, hist.EndDate) = 1
	ORDER BY
		StartDate asc
END
ELSE
BEGIN
	select top 1 gl.*
	from 
		GradeLevel gl join
		StudentGradeLevelHistory hist on hist.GradeLevelID = gl.ID
	WHERE
		hist.StudentID = @studentId and
		(EndDate is null OR @date <= hist.StartDate)
	ORDER BY
		StartDate asc
END		
	
	
	
