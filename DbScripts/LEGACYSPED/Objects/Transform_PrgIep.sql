--#include Transform_PrgInvolvement.sql
--#include Transform_Student.sql

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Iep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Iep
GO

-- #############################################################################
-- IEP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepRefID
(
	IepRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepRefID ADD CONSTRAINT
PK_MAP_IepRefID PRIMARY KEY CLUSTERED
(
	IepRefID
)
END
GO


-- #############################################################################
-- Version
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgVersionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgVersionID
(
	IepRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgVersionID ADD CONSTRAINT
PK_MAP_PrgVersionID PRIMARY KEY CLUSTERED
(
	IepRefID
)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgIep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgIep
GO

CREATE VIEW LEGACYSPED.Transform_PrgIep
AS
	SELECT
-- expose legacy data
		iep.StudentRefID,
		iep.IepRefID,
		AgeGroup = case when DATEDIFF(yy, stu.DOB, iep.IepStartDate) < 6 then 'PK' when DATEDIFF(yy, stu.DOB, iep.IepStartDate) > 5 then 'K12' End,
		iep.LRECode,
		mt.DestID,
-- PrgItem
		DefID = def.ID, -- Converted IEP
		StudentID = stu.DestID,
		StartDate = iep.IEPStartDate,
		EndDate = case when iep.IEPEndDate > getdate() then NULL else iep.IEPEndDate end, 
		ItemOutcomeID = cast(NULL as uniqueidentifier),
		CreatedDate = iep.IEPStartDate,
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		EndedDate = cast(NULL as datetime),
		EndedBy = cast(NULL as uniqueidentifier),
		SchoolID = stu.CurrentSchoolID,
		GradeLevelID = stu.CurrentGradeLevelID,
		InvolvementID = inv.DestID,
		StartStatusID =  '796C212F-6003-4CD3-878D-53BEBE087E9A', -- def.StatusID, -- Converted IEP is a soft-deleted PrgStatus record that we use by default.  Update TEMPLATE PrgItemDef.StatusID for Conveted IEP if the customer requests it
		EndStatusID = case when iep.IEPEndDate > getdate() then NULL else '12086FE0-B509-4F9F-ABD0-569681C59EE2' end, -- select * from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and IsExit = 1 and sequence < 99
		PlannedEndDate = iep.IEPEndDate,
		IsEnded = case when iep.IEPEndDate > getdate() then 0 else 1 end,
		--LastModifiedDate,
		--LastModifiedByID,
		Revision = cast(0 as bigint),
-- other tables
		-- StartStatus = def.StatusID, (why did this exist along with StartStatusID at the same time? -- IEP 
-- PrgIep
		IsTransitional = cast(0 as bit),
-- PrgVersion
		VersionDestID = ver.DestID,
		VersionFinalizedDate = iep.IEPStartDate,
		iep.MinutesPerWeek,
		iep.ConsentForServicesDate
	FROM
		LEGACYSPED.Transform_Student stu JOIN
		LEGACYSPED.IEP iep ON iep.StudentRefID = stu.StudentRefID JOIN
		PrgItemDef def ON def.ID = '8011D6A2-1014-454B-B83C-161CE678E3D3' JOIN -- Converted IEP -- select * from PrgItemDef where ID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
		LEGACYSPED.MAP_PrgInvolvementID inv ON iep.StudentRefID = inv.StudentRefID LEFT JOIN
		LEGACYSPED.MAP_IepRefID mt ON iep.IepRefID = mt.IepRefID LEFT JOIN
		LEGACYSPED.MAP_PrgVersionID ver ON iep.IepRefID = ver.IepRefID -- when we insert PrgItem we don't need this yet.  
GO
---

/*

-- update VC3ETL.LoadTable set Enabled = 1 where ID = '86A1D977-790C-4852-B574-1D305B814A17'

-- ==================================================================================================================== 
-- ===================================================== PrgItem  ===================================================== 
-- ==================================================================================================================== 


GEO.ShowLoadTables PrgItem

set nocount on;
declare @n varchar(100) ; select @n = 'PrgItem'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'LEGACYSPED.Transform_PrgIep'
	, HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_IepRefID'
	, KeyField = 'IepRefID'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = 'd.DefID = ''8011D6A2-1014-454B-B83C-161CE678E3D3'''
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n



DELETE LEGACYSPED.MAP_IepRefID
FROM LEGACYSPED.Transform_PrgIep AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_IepRefID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)


DELETE PrgItem
FROM LEGACYSPED.MAP_IepRefID AS s RIGHT OUTER JOIN 
	PrgItem as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  d.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

UPDATE PrgItem SET StudentID=s.StudentID, PlannedEndDate=s.PlannedEndDate, ItemOutcomeID=s.ItemOutcomeID, EndedDate=s.EndedDate, EndDate=s.EndDate, Revision=s.Revision, StartDate=s.StartDate, EndStatusID=s.EndStatusID, IsEnded=s.IsEnded, InvolvementID=s.InvolvementID, DefID=s.DefID, CreatedBy=s.CreatedBy, StartStatusID=s.StartStatusID, EndedBy=s.EndedBy, CreatedDate=s.CreatedDate, SchoolID=s.SchoolID, GradeLevelID=s.GradeLevelID
FROM  PrgItem d JOIN 
	LEGACYSPED.Transform_PrgIep  s ON s.DestID=d.ID
	AND d.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

INSERT LEGACYSPED.MAP_IepRefID
SELECT IepRefID, NEWID()
FROM LEGACYSPED.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgItem d WHERE s.DestID=d.ID)

INSERT PrgItem (ID, StudentID, PlannedEndDate, ItemOutcomeID, EndedDate, EndDate, Revision, StartDate, EndStatusID, IsEnded, InvolvementID, DefID, CreatedBy, StartStatusID, EndedBy, CreatedDate, SchoolID, GradeLevelID)
SELECT s.DestID, s.StudentID, s.PlannedEndDate, s.ItemOutcomeID, s.EndedDate, s.EndDate, s.Revision, s.StartDate, s.EndStatusID, s.IsEnded, s.InvolvementID, s.DefID, s.CreatedBy, s.StartStatusID, s.EndedBy, s.CreatedDate, s.SchoolID, s.GradeLevelID
FROM LEGACYSPED.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgItem d WHERE s.DestID=d.ID)

select * from PrgItem

select * from LEGACYSPED.MAP_PrgInvolvementID

select * from PrgItem where InvolvementID = 'FF6A037C-93DF-418C-9FF0-EB1EB553CACB'


declare @involvementID uniqueidentifier ; select @involvementID = 'FF6A037C-93DF-418C-9FF0-EB1EB553CACB'
update PrgItem set StartStatusID = '796C212F-6003-4CD3-878D-53BEBE087E9A' where InvolvementID = @involvementID
exec PrgInvolvement_RecalculateStatuses @involvementID = @involvementID

update PrgItem set StartStatusID = '796C212F-6003-4CD3-878D-53BEBE087E9A' where ID = ''


select top 10 ID, Sequence, Name, IsExit, IsEntry, DeletedDate from PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and Name in ('IEP Completed', 'Converted IEP') order by sequence


select * from LEGACYSPED.Transform_PrgIep where EndStatusID is not null



-- ==================================================================================================================== 
-- ====================================================== PrgIep  ===================================================== 
-- ==================================================================================================================== 

GEO.ShowLoadTables PrgIep

set nocount on;
declare @n varchar(100) ; select @n = 'PrgIep'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'LEGACYSPED.Transform_PrgIep'
	, HasMapTable = 0
	, MapTable = NULL
	, KeyField = NULL
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select d.*
--  UPDATE PrgIep SET IsTransitional=s.IsTransitional
FROM  PrgIep d JOIN 
	LEGACYSPED.Transform_PrgIep  s ON s.DestID=d.ID

-- INSERT PrgIep (ID, IsTransitional)
SELECT s.DestID, s.IsTransitional
FROM LEGACYSPED.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgIep d WHERE s.DestID=d.ID)


select * from PrgIep



-- ==================================================================================================================== 
-- ==================================================== PrgVersion  ===================================================
-- ==================================================================================================================== 

GEO.ShowLoadTables PrgVersion

set nocount on;
declare @n varchar(100) ; select @n = 'PrgVersion'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'LEGACYSPED.Transform_PrgIep'
	, HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_PrgVersionID'
	, KeyField = 'IepRefID'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

begin tran testver
UPDATE PrgVersion
SET DateCreated=s.CreatedDate, ItemID=s.DestID, DateFinalized=s.VersionFinalizedDate
FROM  PrgVersion d JOIN 
	LEGACYSPED.Transform_PrgIep  s ON s.VersionDestID=d.ID

INSERT LEGACYSPED.MAP_PrgVersionID
SELECT IepRefID, NEWID()
FROM LEGACYSPED.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgVersion d WHERE s.VersionDestID=d.ID)
	and s.IepRefID in (select IepRefID from LEGACYSPED.MAP_PrgVersionID)

Msg 2627, Level 14, State 1, Line 7
Violation of PRIMARY KEY constraint 'PK_MAP_PrgVersionID'. Cannot insert duplicate key in object 'LEGACYSPED.MAP_PrgVersionID'.
The statement has been terminated.

select m.*
from LEGACYSPED.MAP_PrgVersionID m left join 
	dbo.PrgVersion v on m.DestID = v.ID
where v.ID is null




SELECT IepRefID, count(*) tot
FROM LEGACYSPED.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgVersion d WHERE s.VersionDestID=d.ID)
group by IepRefID
-- 366




INSERT PrgVersion (ID, DateCreated, ItemID, DateFinalized)
SELECT s.VersionDestID, s.CreatedDate, s.DestID, s.VersionFinalizedDate
FROM LEGACYSPED.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgVersion d WHERE s.VersionDestID=d.ID)




rollback tran testver



select * from PrgVersion









*/





