IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Involvement') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Involvement
GO

-- #############################################################################
-- Involvement
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgInvolvementID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgInvolvementID
(
	StudentRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.Map_PrgInvolvementID ADD CONSTRAINT
PK_MAP_PrgInvolvementID PRIMARY KEY CLUSTERED
(
	StudentRefID
)
END
GO

-- 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgInvolvement') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgInvolvement
GO

CREATE VIEW LEGACYSPED.Transform_PrgInvolvement
AS
	SELECT
		StudentRefID = stu.StudentRefID,
		DestID = max(isnull(
						isnull(
							convert(varchar(36), x.ID), 
							convert(varchar(36), t.ID)
							), 
							convert(varchar(36), m.DestID)
						)
					),
		StudentID = stu.DestID,
		ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',   -- Special Education
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A',   -- Special Education
		StartDate = min(iep.IEPStartDate),   -- school start for this IEP period
		EndDate = min(isnull(t.EndDate, case when stu.SpecialEdStatus = 'I' then iep.IEPEndDate else NULL end)),
		EndStatusID = min(case when stu.SpecialEdStatus = 'I' then '12086FE0-B509-4F9F-ABD0-569681C59EE2' else NULL end),
		IsManuallyEnded = min(cast(case when stu.SpecialEdStatus = 'I' then 1 else 0 end as tinyint)),
		Touched = min(isnull(cast(t.IsManuallyEnded as int),0))
	FROM
		LEGACYSPED.Transform_Student stu JOIN 
		LEGACYSPED.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN 
		dbo.PrgInvolvement x on stu.DestID = x.StudentID and x.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and dbo.DateInRange( iep.IEPStartDate, x.StartDate, x.EndDate ) = 1 left join 
		LEGACYSPED.MAP_PrgInvolvementID m on iep.StudentRefID = m.StudentRefID LEFT JOIN
		-- identify students that already have a sped invovlement that will overlap with this involvement
		dbo.PrgInvolvement t on m.DestID = t.ID
			--(stu.DestID = t.StudentID and 
			--t.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' 
			--and
		--	dbo.DateRangesOverlap (iep.IEPStartDate, iep.IEPEndDate, t.StartDate, t.EndDate, null) = 1)
		-- 	dbo.DateInRange( iep.IEPStartDate, t.StartDate, t.EndDate ) = 1)
	WHERE 
		iep.IEPStartDate is not null 
	GROUP BY stu.StudentRefID, stu.DestID
GO
--

-- set transaction isolation level read uncommitted


-- select * from legacysped.transform_prginvolvement where studentrefid = '84689AAE-F4B1-4EA5-8732-0C95DE51EBB5'





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




