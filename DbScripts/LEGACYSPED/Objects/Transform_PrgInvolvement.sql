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
		StatusID = '0B5D5C72-5058-4BF5-A414-BDB27BD5DD94'
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
--and 
--iep.StudentRefID in ('BDDAF781-28CA-4DF5-B029-8E77BCA49D76', 'FB90A0E8-C5A1-4434-8D72-58C0ACE18ACC')
-- before removing group by, 12077
-- after removing group by, 12132

-- 	GROUP BY stu.StudentRefID, stu.DestID,coalesce(x.ID, t.ID, m.DestID, ev.ExistingInvolvementID)
GO
--

-- set transaction isolation level read uncommitted

--select mstu.StudentRefID, mDestID = min(coalesce(convert(varchar(36), mx.ID), convert(varchar(36), mt.ID), convert(varchar(36), mm.DestID)))
--from LEGACYSPED.Transform_Student mstu join 
--	LEGACYSPED.IEP miep on mstu.StudentRefID = miep.StudentRefID join
--	dbo.PrgInvolvement mx on mstu.DestID = mx.StudentID and mx.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' left join 
--	LEGACYSPED.MAP_PrgInvolvementID mm on miep.StudentRefID = mm.StudentRefID left join
--		dbo.PrgInvolvement mt on 
--			(mstu.DestID = mt.StudentID and 
--			mt.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and
--			dbo.DateInRange( miep.IEPStartDate, mt.StartDate, mt.EndDate ) = 1)
--group by mstu.StudentRefID


--select mDestID = min(coalesce(convert(varchar(36), mx.ID), convert(varchar(36), mt.ID), convert(varchar(36), mm.DestID)))
--FROM
--	LEGACYSPED.Transform_Student mstu JOIN 
--	LEGACYSPED.IEP miep on mstu.StudentRefID = miep.StudentRefID LEFT JOIN 
--	dbo.PrgInvolvement mx on mstu.DestID = mx.StudentID and mx.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' left join 
--	LEGACYSPED.MAP_PrgInvolvementID mm on miep.StudentRefID = mm.StudentRefID LEFT JOIN
--	-- identify students that already have a sped invovlement that will overlap with this involvement
--	dbo.PrgInvolvement mt on 
--		(mstu.DestID = mt.StudentID and 
--		mt.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' 
--		and
--	--	dbo.DateRangesOverlap (miep.IEPStartDate, miep.IEPEndDate, t.StartDate, t.EndDate, null) = 1)
--		dbo.DateInRange( miep.IEPStartDate, mt.StartDate, mt.EndDate ) = 1)
--WHERE 
--	miep.IEPStartDate is not null 
--group by mstu.StudentRefID



--select StudentRefID, count(*) tot
--from LEGACYSPED.Transform_PrgInvolvement 
--group by StudentRefID
--having count(*) > 1



-- select * from LEGACYSPED.MAP_PrgInvolvementID 


		/*			-- TEST to see invalid current data alongside output of this transform (add columns to select list and group by)
		and not (
		(t.EndDate is null and t.EndStatus is null and t.IsManuallyEnded = 0) 
		or
		(t.EndDate is not null and t.EndStatus is not null)
		)
		*/




