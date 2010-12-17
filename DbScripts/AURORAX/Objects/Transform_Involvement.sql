IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Involvement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Involvement]
GO

CREATE VIEW AURORAX.Transform_Involvement
AS
	SELECT
		iep.SASID,
		mt.DestID,
		StudentID = stu.DestID,
		ProgramID = '9F5E8A89-D027-4076-9759-FFED1B107E94', -- Special Education (CO)
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A', -- Special Education
		StartDate = MIN(cast(iep.IEPMeetingDate as datetime)),
		EndDate = CASE WHEN MAX(cast(iep.NextAnnualDate as datetime)) > GETDATE() THEN NULL ELSE MAX(cast(iep.NextAnnualDate as datetime))END
	FROM
		AURORAX.MAP_StudentID stu JOIN
		AURORAX.Transform_IEP ti on stu.SASID = ti.SASID JOIN
		AURORAX.IEP_Data iep ON iep.SASID = stu.SASID LEFT JOIN
		AURORAX.MAP_InvolvementID mt ON iep.SASID = mt.SASID -- 3816
--	WHERE 
--		stu.DestID = (
-- 		select distinct sch.StudentID from StudentSchoolHistory sch where sch.StudentID = stu.DestID and dbo.DateInRange(iep.IEPMeetingDate, sch.StartDate, sch.EndDate) = 1 ) 
-- 		AND
--		stu.DestID = (
--		select distinct gl.StudentID from StudentGradeLevelHistory gl where gl.StudentID = stu.DestID and dbo.DateInRange(iep.IEPMeetingDate, gl.StartDate, gl.EndDate) = 1 	) -- 3556
	GROUP BY
		iep.SASID, stu.DestID, mt.DestID
GO

-- select * from AURORAX.Transform_Involvement -- 3556
-- select DestID, Count(*) tot from AURORAX.Transform_Involvement group by DestID having count(*) > 1 -- 0
