IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Iep]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Iep]
GO

CREATE VIEW AURORAX.Transform_Iep
AS
	SELECT
		iep.IEPPKID,
		iep.SASID,
		mt.DestID,
		DefID = '128417C8-782E-4E91-84BE-C0621442F29E', -- IEP - Direct Placement, CO
		StudentID = stu.DestID,
		StartDate = iep.IEPMeetingDate,
		EndDate = CASE WHEN iep.NextAnnualDate > GETDATE() THEN NULL ELSE iep.NextAnnualDate END,
		CreatedDate = iep.IEPMeetingDate,
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		SchoolID = cast(NULL as varchar(20)),
		GradeLevelID = cast(NULL as uniqueidentifier),
		InvolvementID = inv.DestID,
		StartStatus = '30D6BCD2-94BF-4B7E-BA00-15724A543F0E', -- Placed
		PlannedEndDate = iep.NextAnnualDate,
		IsTransitional = cast(NULL as bit),
		VersionDestID = ver.DestID,
		VersionFinalizedDate = iep.IEPMeetingDate,
		  EndStatusID = cast(NULL as uniqueidentifier),
		  StartStatusID = cast(NULL as uniqueidentifier),
		  ItemOutcomeID = cast(NULL as uniqueidentifier),
		  EndedDate = cast(NULL as datetime),
		  EndedBy = cast(NULL as uniqueidentifier)
	FROM
		AURORAX.MAP_StudentID stu JOIN -- what to do if this is the same table?  create two intances of it for now?
		AURORAX.IEP_Data iep ON iep.SASID = stu.SASID LEFT JOIN
		AURORAX.MAP_IepID mt ON iep.IEPPKID = mt.IEPPKID LEFT JOIN 
		AURORAX.MAP_InvolvementID inv ON iep.SASID = inv.SASID LEFT JOIN
		AURORAX.Map_VersionID ver ON iep.IEPPKId = ver.IEPPKId

GO
-- last line