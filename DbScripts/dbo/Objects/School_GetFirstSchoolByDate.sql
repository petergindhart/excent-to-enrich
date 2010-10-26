IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[School_GetFirstSchoolByDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[School_GetFirstSchoolByDate]
GO

 /*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE [dbo].[School_GetFirstSchoolByDate]
	@studentId			uniqueidentifier,
	@date				datetime
AS

IF EXISTS(select * from School sch join StudentSchoolHistory hist on hist.SchoolID = sch.ID WHERE hist.StudentID = @studentId and dbo.DateInRange(@date, hist.StartDate, hist.EndDate) = 1)
BEGIN
	-- OPTIMIZATION: Search for exact date if possible
	select top 1 sch.*
	from 
		School sch join
		StudentSchoolHistory hist on hist.SchoolID = sch.ID
	WHERE
		hist.StudentID = @studentId and
		dbo.DateInRange(@date, hist.StartDate, hist.EndDate) = 1
	ORDER BY
		StartDate asc
END
ELSE
BEGIN
	select top 1 sch.*
	from 
		School sch join
		StudentSchoolHistory hist on hist.SchoolID = sch.ID
	WHERE
		hist.StudentID = @studentId and
		(EndDate is null OR @date <= hist.StartDate)
	ORDER BY
		StartDate asc
END		
	
	
	
