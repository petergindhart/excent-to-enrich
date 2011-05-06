--#include Transform_Student.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Iep]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Iep]
GO

CREATE VIEW AURORAX.Transform_Iep
AS
	SELECT
		iep.StudentRefID,
		iep.IepRefID,
		mt.DestID,
		DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3', -- Converted IEP
		StudentID = stu.DestID,
		ItemOutcomeID = cast(NULL as uniqueidentifier),
		StartDate = iep.IEPMeetingDate,
		StartStatusID = '796C212F-6003-4CD3-878D-53BEBE087E9A', -- IEP
		EndedDate = cast(NULL as datetime),
		EndStatusID = cast(NULL as uniqueidentifier),
		EndedBy = cast(NULL as uniqueidentifier),
		EndDate = case when dateadd(yy, 1, iep.IEPMeetingDate) > getdate() then NULL else dateadd(yy, 1, iep.IEPMeetingDate) end,
		CreatedDate = iep.IEPMeetingDate,
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		SchoolID = stu.CurrentSchoolID,
		GradeLevelID = stu.CurrentGradeLevelID,
		InvolvementID = inv.DestID,
		StartStatus = '30D6BCD2-94BF-4B7E-BA00-15724A543F0E', -- Placed
		PlannedEndDate = dateadd(yy, 1, iep.IEPMeetingDate),
		IsTransitional = cast(0 as bit),  -- These will be Converted IEPs, but if they are over 14 is it considered Transitional?
		VersionDestID = ver.DestID,
		VersionFinalizedDate = iep.IEPMeetingDate,
		IsEnded = cast(0 as bit)
	FROM
		AURORAX.Transform_Student stu JOIN
		AURORAX.IEP iep ON iep.StudentRefID = stu.StudentRefID JOIN
		AURORAX.MAP_InvolvementID inv ON iep.StudentRefID = inv.StudentRefID LEFT JOIN
		AURORAX.MAP_IepRefID mt ON iep.IepRefID = mt.IepRefID LEFT JOIN
		AURORAX.Map_VersionID ver ON iep.IepRefID = ver.IepRefID
GO
---