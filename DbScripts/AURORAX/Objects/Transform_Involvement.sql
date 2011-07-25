IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Involvement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Involvement]
GO

CREATE VIEW [AURORAX].[Transform_Involvement]
AS  
	SELECT
		StudentRefID = stu.StudentRefID, --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
		DestID = m.DestID,
		StudentID = stu.DestID,
		ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',   -- Special Education
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A',   -- Special Education
		StartDate = min(iep.IEPStartDate),   -- school start for this IEP period
		EndDate = NULL,
			--case when max(iep.IEPEndDate) > getdate() then NULL else max(iep.IEPEndDate) end,   -- school end for this IEP period.  MAX so we don't have to add to group by :-)
		IsManuallyEnded = cast(0 as bit)
	FROM
		AURORAX.Transform_Student stu JOIN
		AURORAX.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
		StudentSchoolHistory sh on 
			stu.DestID = sh.StudentID AND
			dbo.DateRangesOverlap(iep.IEPStartDate, iep.IEPEndDate, sh.StartDate, sh.EndDate, GETDATE()) = 1 LEFT JOIN -- will be full joins once the studentschoolhistory and studentgradelevelhistory data is inserted
		-- assumption that this was done to limit to students that have a grade level record at this time
		-- we converted grade level to be optional for PrgItem
		StudentGradeLevelHistory gh on
			dbo.DateRangesOverlap(iep.IEPStartDate, iep.IEPEndDate, gh.StartDate, gh.EndDate, GETDATE()) = 1 LEFT JOIN
		AURORAX.MAP_InvolvementID m on iep.StudentRefID = m.StudentRefID --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
	WHERE 
		iep.IEPStartDate is not null
	GROUP BY stu.StudentRefID, m.DestID, stu.DestID
GO
---