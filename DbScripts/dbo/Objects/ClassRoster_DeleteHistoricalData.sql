if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClassRoster_DeleteHistoricalData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ClassRoster_DeleteHistoricalData]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
<summary>
Deletes a ClassRoster historical data
</summary>
<param name="startdate">historical data on of after this date will be delete</param>
<param name="enddate">historical data on or before this date will be delete</param>
*/
CREATE PROCEDURE dbo.ClassRoster_DeleteHistoricalData
	@startdate datetime,
	@enddate datetime
AS
-- delete teacher history
DELETE ClassRosterTeacherHistory  
FROM
	ClassRosterTeacherHistory
WHERE
	StartDate >= @startdate and
	EndDate <= @enddate
	
-- delete student history
DELETE StudentClassRosterHistory 
FROM
	StudentClassRosterHistory
WHERE
	StartDate >= @startdate and
	EndDate <= @enddate

-- delete all empty classes
delete cr
from
	ClassRoster cr left join
	StudentClassRosterHistory scrh on cr.Id = scrh.ClassRosterId
where
	scrh.ClassRosterId is null

delete from SASI_Map_ClassRosterID
where DestId not in (select Id from ClassRoster)

delete from PWRSCH.Map_ClassRosterID
where DestId not in (select Id from ClassRoster)

delete from IC.Map_ClassRosterID
where DestId not in (select Id from ClassRoster)

-- recalculate de-normalized tables
exec VC3ETL.LoadTable_Run '639D17E7-AD8B-47CA-8749-98FE9F5E0FFD','',0,1
exec VC3ETL.LoadTable_Run 'DE508B60-6C7A-41FE-9A0A-266CC1D740CC','',0,1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

