SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TeacherContentArea_GetRecordsByDateAndContentArea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TeacherContentArea_GetRecordsByDateAndContentArea]
GO

/*
<summary>
Gets records from the StudentClassRosterHistory table within a specific date range
</summary>
<param name="startdate">start date of the interval</param>
<param name="enddate">end date of the interval</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.TeacherContentArea_GetRecordsByDateAndContentArea
	@teacherid 	uniqueidentifier,
	@date		datetime,
	@contentarea	uniqueidentifier
AS
	SELECT TCA.*
	FROM
		TeacherContentArea TCA WHERE
		( dbo.DateInRange(@date, TCA.startDate, TCA.EndDate )  = 1) AND
		(  TCA.teacherid = @teacherid ) AND
		(  TCA.contentareaid = @contentarea )
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

