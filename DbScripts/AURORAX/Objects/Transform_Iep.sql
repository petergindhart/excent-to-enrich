IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_Iep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_Iep
GO

CREATE VIEW AURORAX.Transform_Iep
AS
/*
	We are currently limiting the results to students that have both (dbo) school and grade level records 
	for the date range in which the (aurorax) iep meeting was held
*/
	SELECT
		iep.IEPPKID,
		iep.SASID,
		mt.DestID,
		DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3', -- PrgItemDef			Converted IEP
		StudentID = stu.DestID,
		StartDate = cast(iep.IEPMeetingDate as datetime),
		EndDate = cast(NULL as datetime), -- CASE WHEN cast(iep.NextAnnualDate as datetime) > GETDATE() THEN NULL ELSE cast(iep.NextAnnualDate as datetime) END,
		ItemOutcomeID = cast(NULL as uniqueidentifier),
		CreatedDate = cast(iep.IEPMeetingDate as datetime),
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		EndedDate = cast(NULL as datetime),
		EndedBy = cast(NULL as uniqueidentifier),
		SchoolID = sch.SchoolID,
		GradeLevelID = gl.GradeLevelID,
		InvolvementID = inv.DestID,
		StartStatus = '796C212F-6003-4CD3-878D-53BEBE087E9A', -- Placed
		-- StartStatusID = cast(NULL as uniqueidentifier)
		EndStatusID = cast(NULL as uniqueidentifier),
		PlannedEndDate = cast(iep.NextAnnualDate as datetime),
		-- how and where are the following columns used?
		IsTransitional = cast(0 as bit),
		VersionDestID = ver.DestID,
		VersionFinalizedDate = cast(iep.IEPMeetingDate as datetime)
	from AURORAX.MAP_StudentID stu JOIN
		AURORAX.IEP_Data iep ON stu.SASID = iep.SASID JOIN
			(
			select gl.StudentID, gl.StartDate, max(g.Sequence) maxSequence, max(g.Name) maxGradeLevelName, count(*) tot
			from StudentGradeLevelHistory gl JOIN
			GradeLevel g on gl.GradeLevelID = g.ID
			group by gl.StudentID, gl.StartDate
			-- having count(*) > 1 -- this was for testing
			) maxGL on stu.DestID = maxGL.StudentID JOIN
		StudentGradeLevelHistory gl on maxGL.StudentID = gl.StudentID AND
		maxGL.StartDate = gl.StartDate JOIN
		GradeLevel g on gl.GradeLevelID = g.ID AND
		maxGL.maxSequence = g.Sequence AND
		maxGL.maxGradeLevelName = g.Name JOIN
		StudentSchoolHistory sch on stu.DestID = sch.StudentID LEFT JOIN
		AURORAX.MAP_IepID mt ON iep.IEPPKID = mt.IEPPKID LEFT JOIN 
		AURORAX.MAP_InvolvementID inv ON iep.SASID = inv.SASID LEFT JOIN
		AURORAX.Map_VersionID ver ON iep.IEPPKId = ver.IEPPKId
	where gl.StartDate = (
		select max(StartDate) 
		from StudentGradeLevelHistory gIn
		where gl.StudentID = gIn.StudentID AND  -- ADD HERE IEP_Data.IEPMeetingDate logic
		dbo.DateInRange(iep.IEPMeetingDate, gl.StartDate, gl.EndDate) = 1 AND -- 1479 after this criterion added
		gl.GradeLevelID = g.ID) AND -- 0 duplicates, 49092 rows in 2 seconds
			iep.IEPPKID = ( -- there are duplicate records per student in IEP_Data
				select max(IEPPKID) 
				from AURORAX.IEP_Data iepIn
				where iepIn.SASID = iep.SASID) AND -- 3791
			sch.StartDate = (
				select max(StartDate)
				from StudentSchoolHistory schIn
				where stu.DestID = schIn.StudentID )
		AND 
		stu.DestID = (
 		select distinct sch.StudentID from StudentSchoolHistory sch where sch.StudentID = stu.DestID and dbo.DateInRange(iep.IEPMeetingDate, sch.StartDate, sch.EndDate) = 1 ) 
 		AND
		stu.DestID = (
		select distinct gl.StudentID from StudentGradeLevelHistory gl where gl.StudentID = stu.DestID and dbo.DateInRange(iep.IEPMeetingDate, gl.StartDate, gl.EndDate) = 1 	) -- 3556
GO
