if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GradeLevel_GetRecordsByClassRoster]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GradeLevel_GetRecordsByClassRoster]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
	Checks grade level of a class roster.  Determines by grade info from sasi
	if any, otherwise by enrolled students.
*/
CREATE PROCEDURE dbo.GradeLevel_GetRecordsByClassRoster
	@classRosterId uniqueidentifier
AS


	select
		gl.*
	From	
		GradeLevel gl join
		(
			select distinct 
				minLevel.Sequence AS minSequence,	
				maxLevel.Sequence AS maxSequence	
			FROM
				GradeRangeBitMask mask join
				GradeLevel minLevel on mask.MinGradeID = minLevel.ID JOIN
				GradeLevel maxLevel on mask.MaxGradeId = maxLevel.ID
			where
				mask.BItmask = dbo.GetClassRosterGradeBitMask(@classRosterId)
		) bounds on gl.Sequence >= bounds.minSequence AND gl.Sequence <= bounds.maxSequence
	order by
		Sequence	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO