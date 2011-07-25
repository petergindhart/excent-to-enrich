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
		StartDate = iep.IEPStartDate,
		StartStatusID = '796C212F-6003-4CD3-878D-53BEBE087E9A', -- IEP
		EndedDate = cast(NULL as datetime),
		EndStatusID = cast(NULL as uniqueidentifier), -- need to modify this for the Exited IEPs
		EndedBy = cast(NULL as uniqueidentifier),
		EndDate = case when iep.IEPEndDate > getdate() then NULL else iep.IEPEndDate end,
		CreatedDate = iep.IEPStartDate,
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		SchoolID = stu.CurrentSchoolID,
		GradeLevelID = stu.CurrentGradeLevelID,
		InvolvementID = inv.DestID,
		StartStatus = '30D6BCD2-94BF-4B7E-BA00-15724A543F0E', -- Placed
		PlannedEndDate = isnull(iep.IEPEndDate, dateadd(yy, 1, iep.IEPStartDate)), -- Aurora sets to 1 year from start date
		IsTransitional = cast(0 as bit),  -- These will be Converted IEPs, but if they are over 14 is it considered Transitional?
		VersionDestID = ver.DestID,
		VersionFinalizedDate = iep.IEPStartDate,
		IsEnded = cast(0 as bit),  -- change for exited
		iep.MinutesPerWeek
	FROM
		AURORAX.Transform_Student stu JOIN
		AURORAX.IEP iep ON iep.StudentRefID = stu.StudentRefID JOIN
		AURORAX.MAP_InvolvementID inv ON iep.StudentRefID = inv.StudentRefID LEFT JOIN
		AURORAX.MAP_IepRefID mt ON iep.IepRefID = mt.IepRefID LEFT JOIN
		AURORAX.Map_VersionID ver ON iep.IepRefID = ver.IepRefID
GO
---