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
		DefID = def.ID, -- Converted IEP
		StudentID = stu.DestID,
		ItemOutcomeID = cast(NULL as uniqueidentifier),
		StartDate = iep.IEPStartDate,
		StartStatusID = def.StatusID, -- IEP
		EndedDate = cast(NULL as datetime),
		EndStatusID = cast(NULL as uniqueidentifier),
		EndedBy = cast(NULL as uniqueidentifier),
		EndDate = case when iep.IEPEndDate > getdate() then NULL else iep.IEPEndDate end,
		CreatedDate = iep.IEPStartDate,
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		SchoolID = stu.CurrentSchoolID,
		GradeLevelID = stu.CurrentGradeLevelID,
		InvolvementID = inv.DestID,
		StartStatus = '30D6BCD2-94BF-4B7E-BA00-15724A543F0E', -- Placed
		PlannedEndDate = iep.IEPEndDate,
		IsTransitional = cast(0 as bit),  -- These will be Converted IEPs, but if they are over 14 is it considered Transitional?
		VersionDestID = ver.DestID,
		VersionFinalizedDate = iep.IEPStartDate,
		IsEnded = case when iep.IEPEndDate > getdate() then 0 else 1 end,
		Revision = cast(0 as bigint)
	FROM
		AURORAX.Transform_Student stu JOIN
		AURORAX.IEP iep ON iep.StudentRefID = stu.StudentRefID JOIN
		PrgItemDef def ON def.ID = '8011D6A2-1014-454B-B83C-161CE678E3D3' JOIN -- Converted IEP
		AURORAX.MAP_InvolvementID inv ON iep.StudentRefID = inv.StudentRefID LEFT JOIN
		AURORAX.MAP_IepRefID mt ON iep.IepRefID = mt.IepRefID LEFT JOIN
		AURORAX.Map_VersionID ver ON iep.IepRefID = ver.IepRefID
GO
---