-- #############################################################################
-- Note:  Separated PrgInvolvement MAP table code from Transform_PrgInvolvement files because EvaluateIncomingItems depends on this MAP, and Transform_PrgInvolvement depends on EvaluateIncomingItems


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgInvolvement') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgInvolvement
GO

CREATE VIEW LEGACYSPED.Transform_PrgInvolvement
AS
--------------------------- remember that the group by was removed here
	SELECT
		StudentRefID = stu.StudentRefID,
		DestID = coalesce(x.ID, t.ID, m.DestID, ev.ExistingInvolvementID),
		StudentID = stu.DestID,
		ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',   -- Special Education
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A',   -- Special Education
		StartDate = iep.IEPStartDate,   -- school start for this IEP period
		EndDate = isnull(t.EndDate, 
			case when stu.SpecialEdStatus = 'I' then 
				case when iep.IEPEndDate > getdate() then NULL else iep.IEPEndDate end 
				else
				case when t.EndDate > getdate() then NULL else t.EndDate end
			end),
		EndStatusID = case when stu.SpecialEdStatus = 'I' then '12086FE0-B509-4F9F-ABD0-569681C59EE2' else t.EndStatus end,
		IsManuallyEnded = cast(case when stu.SpecialEdStatus = 'I' then 1 else isnull(t.IsManuallyEnded,0) end as tinyint),
		Touched = isnull(cast(t.IsManuallyEnded as int),0) -- select ev.StudentRefID
		,
		stu.SpecialEdStatus,
		-- PrgInvolvementStatus 
		StatusID = '0B5D5C72-5058-4BF5-A414-BDB27BD5DD94' -- if and when this breaks we'll know that we need to create an object in the 0002-Prep_District.sql file to contain the value for each district
	FROM
		LEGACYSPED.EvaluateIncomingItems ev join 
		LEGACYSPED.Transform_Student stu on ev.StudentRefID = stu.StudentRefID JOIN 
		LEGACYSPED.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN 
		dbo.PrgInvolvement x on stu.DestID = x.StudentID and x.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and dbo.DateInRange( iep.IEPStartDate, x.StartDate, x.EndDate ) = 1 left join 
		LEGACYSPED.MAP_PrgInvolvementID m on iep.StudentRefID = m.StudentRefID LEFT JOIN
		-- identify students that already have a sped invovlement that will overlap with this involvement
		dbo.PrgInvolvement t on m.DestID = t.ID
	WHERE 
		iep.IEPStartDate is not null 
GO
--
