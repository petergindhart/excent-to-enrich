-- #############################################################################
-- Note:  Separated PrgInvolvement MAP table code from Transform_PrgInvolvement files because EvaluateIncomingItems depends on this MAP, and Transform_PrgInvolvement depends on EvaluateIncomingItems

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgInvolvement') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgInvolvement
GO

CREATE VIEW LEGACYSPED.Transform_PrgInvolvement
AS
	SELECT
		StudentRefID = stu.StudentRefID,
		-- x = x.ID, t = t.ID, m = m.DestID, ev = ev.ExistingInvolvementID,
		DestID = coalesce(x.ID, t.ID, ev.ExistingInvolvementID, m.DestID),
		StudentID = stu.DestID,
		ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',   -- Special Education
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A',   -- Special Education
		StartDate = iep.IEPStartDate,   -- school start for this IEP period
		EndDate = isnull(t.EndDate, case when t.EndDate > getdate() then NULL else t.EndDate end),
		EndStatusID = t.EndStatus,
		IsManuallyEnded = cast(isnull(t.IsManuallyEnded,0) as tinyint),
		Touched = isnull(cast(t.IsManuallyEnded as int), 0),
		StartedByTransfer = CAST(0 AS BIT),
		-- PrgInvolvementStatus
		StatusID = (select DestID from LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan),
		Sequence = cast(0 as int)
	FROM
		LEGACYSPED.EvaluateIncomingItems ev join 
		LEGACYSPED.Transform_Student stu on ev.StudentRefID = stu.StudentRefID JOIN 
		LEGACYSPED.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN 
		dbo.PrgInvolvement x on stu.DestID = x.StudentID and x.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' /* and dbo.DateInRange( iep.IEPStartDate, x.StartDate, x.EndDate ) = 1 */ ------- this resulted in odd behavior for Brevard's import
			and x.StartDate = (
				select max(mxdt.startdate)
				from dbo.PrgInvolvement mxdt 
				where x.StudentID = mxdt.StudentID
				) left join 
		LEGACYSPED.MAP_PrgInvolvementID m on iep.StudentRefID = m.StudentRefID LEFT JOIN
		-- identify students that already have a sped invovlement that will overlap with this involvement
		dbo.PrgInvolvement t on m.DestID = t.ID
	WHERE iep.IEPStartDate is not null 
GO
--


