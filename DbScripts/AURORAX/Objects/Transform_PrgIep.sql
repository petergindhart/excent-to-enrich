--#include Transform_PrgInvolvement.sql
--#include Transform_Student.sql

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_Iep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_Iep
GO

-- #############################################################################
-- IEP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_IepRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.Map_IepRefID
(
	IepRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.Map_IepRefID ADD CONSTRAINT
PK_Map_IepRefID PRIMARY KEY CLUSTERED
(
	IepRefID
)
END
GO


-- #############################################################################
-- Version
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgVersionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_PrgVersionID
(
	IepRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE AURORAX.MAP_PrgVersionID ADD CONSTRAINT
PK_MAP_PrgVersionID PRIMARY KEY CLUSTERED
(
	IepRefID
)
END
GO





-- drop view AURORAX.Transform_Iep

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgIep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgIep
GO

CREATE VIEW AURORAX.Transform_PrgIep
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
		StartStatusID = def.StatusID, -- Converted IEP is a soft-deleted PrgStatus record that we use by default.  Update TEMPLATE PrgItemDef.StatusID for Conveted IEP if the customer requests it
		EndStatusID = cast(NULL as uniqueidentifier),
		PlannedEndDate = iep.IEPEndDate,
		IsEnded = case when iep.IEPEndDate > getdate() then 0 else 1 end,
		--LastModifiedDate,
		--LastModifiedByID,
		Revision = cast(0 as bigint),
-- other tables
		-- StartStatus = def.StatusID, (why did this exist along with StartStatusID at the same time? -- IEP 
-- PrgIep
		IsTransitional = cast(0 as bit),  -- These will be Converted IEPs, but if they are over 14 is it considered Transitional?
-- PrgVersion
		VersionDestID = ver.DestID,
		VersionFinalizedDate = iep.IEPStartDate,
		iep.MinutesPerWeek,
		iep.ConsentForServicesDate
	FROM
		AURORAX.Transform_Student stu JOIN
		AURORAX.IEP iep ON iep.StudentRefID = stu.StudentRefID JOIN
		PrgItemDef def ON def.ID = '8011D6A2-1014-454B-B83C-161CE678E3D3' JOIN -- Converted IEP -- select * from PrgItemDef where ID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
		AURORAX.MAP_PrgInvolvementID inv ON iep.StudentRefID = inv.StudentRefID LEFT JOIN
		AURORAX.MAP_IepRefID mt ON iep.IepRefID = mt.IepRefID LEFT JOIN
		AURORAX.MAP_PrgVersionID ver ON iep.IepRefID = ver.IepRefID -- when we insert PrgItem we don't need this yet.  
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
	SourceTable = 'AURORAX.Transform_PrgIep'
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_IepRefID'
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


select d.*
-- DELETE AURORAX.MAP_IepRefID
FROM AURORAX.Transform_PrgIep AS s RIGHT OUTER JOIN 
	AURORAX.MAP_IepRefID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

select d.*
-- DELETE PrgItem
FROM AURORAX.MAP_IepRefID AS s RIGHT OUTER JOIN 
	PrgItem as d ON s.DestID=d.ID
WHERE s.DestID IS NULL AND 1=1 AND  d.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'


select d.*
-- UPDATE PrgItem SET StudentID=s.StudentID, PlannedEndDate=s.PlannedEndDate, ItemOutcomeID=s.ItemOutcomeID, EndedDate=s.EndedDate, EndDate=s.EndDate, Revision=s.Revision, StartDate=s.StartDate, EndStatusID=s.EndStatusID, IsEnded=s.IsEnded, InvolvementID=s.InvolvementID, DefID=s.DefID, CreatedBy=s.CreatedBy, StartStatusID=s.StartStatusID, EndedBy=s.EndedBy, CreatedDate=s.CreatedDate, SchoolID=s.SchoolID, GradeLevelID=s.GradeLevelID
FROM  PrgItem d JOIN 
	AURORAX.Transform_PrgIep  s ON s.DestID=d.ID
	AND d.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

-- INSERT AURORAX.MAP_IepRefID
SELECT IepRefID, NEWID()
FROM AURORAX.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgItem d WHERE s.DestID=d.ID)

-- INSERT PrgItem (ID, StudentID, PlannedEndDate, ItemOutcomeID, EndedDate, EndDate, Revision, StartDate, EndStatusID, IsEnded, InvolvementID, DefID, CreatedBy, StartStatusID, EndedBy, CreatedDate, SchoolID, GradeLevelID)
SELECT s.DestID, s.StudentID, s.PlannedEndDate, s.ItemOutcomeID, s.EndedDate, s.EndDate, s.Revision, s.StartDate, s.EndStatusID, s.IsEnded, s.InvolvementID, s.DefID, s.CreatedBy, s.StartStatusID, s.EndedBy, s.CreatedDate, s.SchoolID, s.GradeLevelID
FROM AURORAX.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgItem d WHERE s.DestID=d.ID)


select * from PrgItem


select * from PrgItem




-- ==================================================================================================================== 
-- ====================================================== PrgIep  ===================================================== 
-- ==================================================================================================================== 

GEO.ShowLoadTables PrgIep

set nocount on;
declare @n varchar(100) ; select @n = 'PrgIep'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_PrgIep'
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
	AURORAX.Transform_PrgIep  s ON s.DestID=d.ID

-- INSERT PrgIep (ID, IsTransitional)
SELECT s.DestID, s.IsTransitional
FROM AURORAX.Transform_PrgIep s
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
	SourceTable = 'AURORAX.Transform_PrgIep'
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_PrgVersionID'
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

select d.*
-- UPDATE PrgVersion SET DateCreated=s.CreatedDate, ItemID=s.DestID, DateFinalized=s.VersionFinalizedDate
FROM  PrgVersion d JOIN 
	AURORAX.Transform_PrgIep  s ON s.VersionDestID=d.ID

-- INSERT AURORAX.MAP_PrgVersionID
SELECT IepRefID, NEWID()
FROM AURORAX.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgVersion d WHERE s.VersionDestID=d.ID)

-- INSERT PrgVersion (ID, DateCreated, ItemID, DateFinalized)
SELECT s.VersionDestID, s.CreatedDate, s.DestID, s.VersionFinalizedDate
FROM AURORAX.Transform_PrgIep s
WHERE NOT EXISTS (SELECT * FROM PrgVersion d WHERE s.VersionDestID=d.ID)

select * from PrgVersion


*/





