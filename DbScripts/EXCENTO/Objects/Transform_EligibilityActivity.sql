IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_EligibilityActivity]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_EligibilityActivity]
GO

CREATE VIEW EXCENTO.Transform_EligibilityActivity
AS

	SELECT
		iep.GStudentID,
		act.DestID,
		ItemDefID = '2DD5FDB4-85E6-4F8F-BF8A-44E962B7D416',
		StudentID = iep.StudentID,
		StartDate = dis.StartDate,
		CreatedDate = iep.CreatedDate,
		CreatedBy = iep.CreatedBy,
		SchoolID = iep.SchoolID,
		GradeLevelID = iep.GradeLevelID,
		InvolvementID = iep.InvolvementID,
		StartStatus = '2E9F71DF-05ED-447E-B496-3B47ACB49BE4', -- Eligible
		ReasonID = 'FF63110D-D40A-407C-99BF-3A8C77EE4CDD', -- imported from EO
		SectionDestID = ISNULL(sec.ID, NEWID()),
		SectionDefID = '98F55873-FB51-4B1A-AE46-4BABC4B0FBA0',
		VersionDestID = CAST(NULL AS UNIQUEIDENTIFIER)
	FROM
		EXCENTO.Transform_Iep iep JOIN
		(	-- has disability records
			SELECT GStudentID, StartDate = MIN(CreateDate)
			FROM EXCENTO.StudDisability
			WHERE ISNULL(Del_Flag, 0) = 0
			GROUP BY GStudentID
		) dis ON dis.GStudentID = iep.GStudentID LEFT JOIN
		EXCENTO.MAP_EligibilityActivityID act ON act.GStudentID = iep.GStudentID LEFT JOIN
		PrgSection sec on sec.DefID = '98F55873-FB51-4B1A-AE46-4BABC4B0FBA0' and sec.ItemID = act.DestID

GO