IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Involvement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Involvement]
GO

CREATE VIEW AURORAX.Transform_Involvement
AS

	SELECT
		iep.SASID,
		mt.DestID,
		stu.DestID [StudentID],
		ProgramID = '9F5E8A89-D027-4076-9759-FFED1B107E94', -- Special Education (CO)
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A', -- Special Education
		StartDate = MIN(iep.IEPMeetingDate),
		EndDate = CASE WHEN MAX(iep.NextAnnualDate) > GETDATE() THEN NULL ELSE MAX(iep.NextAnnualDate)END
	FROM
		AURORAX.MAP_StudentID stu JOIN
		AURORAX.IEP_Data iep ON iep.SASID = stu.SASID LEFT JOIN
		-- StudentSchoolHistory sch ON sch.StudentID = stu.DestID AND dbo.DateInRange(sc.IEPInitDate, sch.StartDate, sch.EndDate) = 1 JOIN
		AURORAX.MAP_InvolvementID mt ON iep.SASID = mt.SASID
	GROUP BY
		iep.SASID, stu.DestID, mt.DestID

GO