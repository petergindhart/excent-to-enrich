
-- #############################################################################
-- Involvement
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgInvolvementID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_PrgInvolvementID
(
	StudentRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.Map_PrgInvolvementID ADD CONSTRAINT
PK_MAP_PrgInvolvementID PRIMARY KEY CLUSTERED
(
	StudentRefID
)
END
GO

-- 
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgInvolvement') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgInvolvement
GO

CREATE VIEW AURORAX.Transform_PrgInvolvement
AS
	SELECT
		StudentRefID = stu.StudentRefID, --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
		DestID = isnull(t.ID, m.DestID),
		StudentID = stu.DestID,
		ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',   -- Special Education
		VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A',   -- Special Education
		StartDate = min(iep.IEPStartDate),   -- school start for this IEP period
		EndDate = NULL,
			--case when max(iep.IEPEndDate) > getdate() then NULL else max(iep.IEPEndDate) end,   -- school end for this IEP period.  MAX so we don't have to add to group by :-)
		IsManuallyEnded = cast(0 as bit)
	FROM
		AURORAX.Transform_Student stu JOIN
		AURORAX.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN 
		dbo.StudentSchoolHistory sh on 
			stu.DestID = sh.StudentID AND
			dbo.DateRangesOverlap(iep.IEPStartDate, iep.IEPEndDate, sh.StartDate, sh.EndDate, GETDATE()) = 1 LEFT JOIN -- will be full joins once the studentschoolhistory and studentgradelevelhistory data is inserted
		-- assumption that this was done to limit to students that have a grade level record at this time
		-- we converted grade level to be optional for PrgItem
		dbo.StudentGradeLevelHistory gh on
			dbo.DateRangesOverlap(iep.IEPStartDate, iep.IEPEndDate, gh.StartDate, gh.EndDate, GETDATE()) = 1 LEFT JOIN
		AURORAX.MAP_PrgInvolvementID m on iep.StudentRefID = m.StudentRefID LEFT JOIN
		dbo.PrgInvolvement t on m.DestID = t.ID
	WHERE 
		iep.IEPStartDate is not null
	GROUP BY stu.StudentRefID, isnull(t.ID, m.DestID), stu.DestID
GO
-- 
/*


Import strategy:  
	don't touch sis data (no updates or deletes)
	delete missing map records
		legacy student PrgInvolvement data remains in dbo.PrgInvolvement
			If we can devise a way to programmatically set dbo.Student.IsActive = 0 before / during / after we delete them from MAP, the "orphaned" PrgInvolvement records won't be a problem. 
			I don't like leaving these records, but not sure how to avoid it.
	update only legacy student records
	insert legacy student records that don't exist in dbo.Student 



GEO.ShowLoadTables PrgInvolvement

set nocount on;
declare @n varchar(100) ; select @n = 'PrgInvolvement'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_PrgInvolvement'
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'StudentRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.* 
-- DELETE AURORAX.MAP_PrgInvolvementID
FROM AURORAX.Transform_PrgInvolvement AS s RIGHT OUTER JOIN 
	AURORAX.MAP_PrgInvolvementID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)


select d.*
-- UPDATE PrgInvolvement SET ProgramID=s.ProgramID, StudentID=s.StudentID, StartDate=s.StartDate, EndDate=s.EndDate, IsManuallyEnded=s.IsManuallyEnded, VariantID=s.VariantID
FROM  PrgInvolvement d JOIN 
	AURORAX.Transform_PrgInvolvement  s ON s.DestID=d.ID

-- INSERT AURORAX.MAP_PrgInvolvementID
SELECT StudentRefID, NEWID()
FROM AURORAX.Transform_PrgInvolvement s
WHERE NOT EXISTS (SELECT * FROM PrgInvolvement d WHERE s.DestID=d.ID)

-- INSERT PrgInvolvement (ID, ProgramID, StudentID, StartDate, EndDate, IsManuallyEnded, VariantID)
SELECT s.DestID, s.ProgramID, s.StudentID, s.StartDate, s.EndDate, s.IsManuallyEnded, s.VariantID
FROM AURORAX.Transform_PrgInvolvement s
WHERE NOT EXISTS (SELECT * FROM PrgInvolvement d WHERE s.DestID=d.ID)


select * from PrgInvolvement


select * from AURORAX.MAP_PrgInvolvementID

select count(*) from AURORAX.Transform_PrgInvolvement 


*/



