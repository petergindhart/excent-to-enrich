--#include Transform_Student.sql
--#include Transform_PrgInvolvement.sql

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


-- IEPStudent -- We will migrate away from LEGACYSPED.MAP_IepRefID.  Do not drop it until we populate the new map table with it.
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IEPStudentRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IEPStudentRefID
(
	IepRefID varchar(150) NOT NULL ,
	StudentRefID varchar(150) not null,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IEPStudentRefID ADD CONSTRAINT
PK_MAP_IEPStudentRefID PRIMARY KEY CLUSTERED
(
	IepRefID
)

create nonclustered index IX_MAP_IEPStudentRefID_StudentRefID on LEGACYSPED.MAP_IEPStudentRefID (StudentRefID)

-- here were are transitioning from the old MAP_IEPRefID to the new MAP_IEPStudentRefID
-- we insert the new map with the contents of the old map plus the StudentRefID
-- objective of using studentrefid is to aid query performance where needed.
-- it is assumed that there is a 1:1 relationship between students and IEPs
-- after the first upgrade_db where this new map is implemented, the old map data will be present
-- however, after the new source files are imported, and thus LEGACYSPED.IEP is populated with new data, the query below will return new rows that have not been inserted.
-- but the script to insert the new map should only be run once ever, when the table is first created.
insert LEGACYSPED.MAP_IEPStudentRefID
select distinct m.IepRefID, s.StudentRefID, m.DestID
from LEGACYSPED.MAP_IepRefID m join --  we could have just used the transform, but using the MAP facilitates excluding NULLs
LEGACYSPED.Transform_PrgIep s on m.IepRefID = s.IepRefID left join  -- since this map table already exists, this is okay.
LEGACYSPED.MAP_IEPStudentRefID t on m.IepRefID = t.IepRefID
where t.IepRefID is null 
-- this was NULL during testing because we have already deleted some superfluous records from the map tables.  will need to test this after restore

-- consider dropping MAP_IepRefID here.  There will be issues with existing views if this does not happen in the correct order.

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


-- #############################################################################
-- Version
if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'PrgItemOutcome_EndIEP')
begin
create table LEGACYSPED.PrgItemOutcome_EndIEP (
PrgItemOutcomeID uniqueidentifier not null
)
end
GO

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'EvaluateIncomingItems')
drop view LEGACYSPED.EvaluateIncomingItems
go

create view LEGACYSPED.EvaluateIncomingItems
as
/*
	This view was created to attempt to address performance issues introduced with logic to determine how to handle previously touched data.
	
	The output of this view will be different before and after the new data is loaded into MAP tables.
	This view shows:
		IEPRefID 
		StudentID
			In this view we do not have access to the StudentRefID before the data is imported into Enrich.  
		ExistingItemID
		ExistingVersionID
			After the files are extracted and loaded to the LEGACYSPED tables (incoming data) we are able to compare incoming to existing data (previously imported)
				IEPRefID has a value, but StudentiD, ExistingItemID and ExistingVersionID are NULL - new record needs to be inserted
				IEPRefID & ExistingItemID/ExistingVersionID/StudentID - previously imported
		Incoming
			0 = Existing record NOT in the new data set
			1 = Record in the new data set (existing or not)
		IsEnded
			PrgItem.IsEnded value.
		Revision
			PrgItem.Revsion value.
		NCItem (non-converted item)
			There is an IEP record started that is not a converted IEP (such as trasition, school age or PK IEP)
		Touched
			Any value > 0 indicates that the previously imported item has been somehow modified since it was imported
		
*/
select distinct a.IepRefID, a.StudentRefID, ExistingItemID = mi.DestID, ExistingVersionID = mv.DestID, -- a student may have multiple NC Items.  dstinct the easy way.
	Incoming = case when newiep.IepRefID is null then 0 else 1 end,
	IsEnded = isnull(item.IsEnded,0), Revision = isnull(item.Revision,0),
	NCItem = case when ncitem.ID is null then 0 else 1 end,
	Touched = cast(isnull(item.IsEnded,0) as int)+isnull(item.Revision,0)+case when ncitem.ID is null then 0 else 1 end
from (select IEPRefID, StudentRefID from LEGACYSPED.MAP_IEPStudentRefID union select IEPRefID, StudentRefID from LEGACYSPED.IEP ) a left join
LEGACYSPED.MAP_IEPStudentRefID mi on a.IepRefID = mi.IepRefID left join
LEGACYSPED.MAP_PrgVersionID mv on a.IepRefID = mv.IepRefID left join 
dbo.PrgItem item on mi.DestID = item.ID left join 
LEGACYSPED.IEP newiep on a.IepRefID = newiep.IepRefID left join -- incoming
dbo.PrgItem ncitem on item.StudentID = ncitem.StudentID and ncitem.DefID in (select top 1 d.ID from PrgItemDef d where d.Name like '%IEP%' and d.ID <> '8011D6A2-1014-454B-B83C-161CE678E3D3' and ncitem.DefID = d.ID) and ncitem.IsEnded = 0
-- order by Incoming, item.IsEnded desc, item.Revision desc, NCItem desc
go


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgIep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgIep
GO

CREATE VIEW LEGACYSPED.Transform_PrgIep
AS
select 
	ev.StudentRefID, 
	ev.IepRefID,
	DestID = ev.ExistingItemID,
	DoNotTouch = ev.Touched, -- 0 is touchable
-- PrgItem
	-- notice:  if data previously imported and should not be touched, we need to derive t data where prev imp rec has been touched -- set transaction isolation level read uncommitted
	-- better idea:  expose Touched to be used in the source table filter
	DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3', -- Converted IEP
	StudentID = stu.DestID,
	MeetDate = iep.iepmeetdate,
	StartDate = iep.IEPStartDate,
	EndDate = case when stu.SpecialEdStatus = 'I' then iep.IEPEndDate else NULL end,
	ItemOutcomeID = cast(case when stu.SpecialEdStatus = 'I' then (select PrgItemOutcomeID from LEGACYSPED.PrgItemOutcome_EndIEP) else NULL end as uniqueidentifier), 
	CreatedDate = '1/1/1970',
	CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	EndedDate = cast(case when stu.SpecialEdStatus = 'I' then iep.IEPEndDate else NULL end as datetime),
	EndedBy = cast(t.EndedBy as uniqueidentifier),
	SchoolID = cast(stu.CurrentSchoolID as uniqueidentifier),
	GradeLevelID = cast(stu.CurrentGradeLevelID as uniqueidentifier),
	InvolvementID = isnull(minv.DestID, allinv.ID), 
	StartStatusID =  cast('796C212F-6003-4CD3-878D-53BEBE087E9A' as uniqueidentifier), 
	EndStatusID = cast(case when stu.SpecialEdStatus = 'I' then '12086FE0-B509-4F9F-ABD0-569681C59EE2' else NULL end as uniqueidentifier),
	PlannedEndDate = isnull(convert(datetime, iep.IEPEndDate), dateadd(yy, 1, dateadd(dd, -1, convert(datetime, iep.IEPStartDate)))),
	IsEnded = cast(case when stu.SpecialEdStatus = 'I' then 1 else 0 end as Bit),
	Revision = cast(isnull(t.Revision,0) as bigint),
	IsApprovalPending = cast(isnull(t.IsApprovalPending,0) as bit),
	ApprovedDate = cast(t.ApprovedDate as datetime),
	ApprovedByID = cast(t.ApprovedByID as uniqueidentifier),
-- PrgIep
	IsTransitional = cast(0 as bit),
-- PrgVersion
	VersionDestID = cast(ev.ExistingVersionID as uniqueidentifier),
	VersionFinalizedDate = iep.IEPStartDate, 
-- Additional Elements
	AgeGroup = case when DATEDIFF(yy, stu.DOB, iep.IepStartDate) < 6 then 'PK' when DATEDIFF(yy, stu.DOB, iep.IepStartDate) > 5 then 'K12' End,
	iep.LRECode,
	iep.MinutesPerWeek,
	iep.ConsentForServicesDate -- select *
from LEGACYSPED.EvaluateIncomingItems ev join -- select * from LEGACYSPED.EvaluateIncomingItems -- 11903
	LEGACYSPED.Transform_Student stu on ev.StudentRefID = stu.StudentRefID join -- select * from LEGACYSPED.Transform_Student -- 11902
	LEGACYSPED.IEP iep on ev.IepRefID = iep.IepRefID left join 
	dbo.PrgItem t on ev.ExistingItemID = t.ID left join
	(select distinct ID, StudentID 
		from PrgInvolvement v
		where v.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and 
			v.EndDate is null and
			v.ID = (
				select min(convert(varchar(36), p.ID)) 
				from PrgInvolvement p 
				where p.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and
					p.StudentID = v.StudentID
				)
	
	) allinv on stu.DestID = allinv.StudentID left join
	LEGACYSPED.MAP_PrgInvolvementID minv on ev.StudentRefID = minv.StudentRefID left join
	dbo.PrgInvolvement inv on minv.DestID = inv.ID
where
	stu.DestID = '70BAB93D-380F-4016-B589-149FBAAE38A1' -- studentid
	-- 01DE4791-4A02-4DB5-8250-7CFC86401906


/*


this student has 2 involvements 

select * from PrgInvolvement where StudentID = '70BAB93D-380F-4016-B589-149FBAAE38A1' -- 1 before conversion
	6A40885C-EB6E-4ECA-A87D-20723488758E
	E029AC66-3B94-45FA-863E-7BDB0EE5433E

2 ieps

select HasPrgIep = case when iep.ID is not null then 1 else 0 end, i.ID, i.InvolvementID, d.Name
from PrgItem i join 
PrgItemDef d on i.DefID = d.ID left join
PrgIep iep on i.ID = iep.ID
where i.StudentID = '70BAB93D-380F-4016-B589-149FBAAE38A1' and 
d.TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870'

	0	01DE4791-4A02-4DB5-8250-7CFC86401906	6A40885C-EB6E-4ECA-A87D-20723488758E	Converted IEP 
	1	0B6504CA-57FE-4CAE-9BDE-12527BD6A4F2	E029AC66-3B94-45FA-863E-7BDB0EE5433E	IEP - School Age (6-12)			-- has IEP record

-- 1 before conversion

	
select * from PrgIEP where ID = '01DE4791-4A02-4DB5-8250-7CFC86401906'

set transaction isolation level read uncommitted


select * 
from PrgInvolvement inv left join 
LEGACYSPED.MAP_PrgInvolvementID m on inv.ID = m.DestID
where m.DestID is null

--where StudentID in ('8654A765-ECE1-49BC-873C-7CF55377C4EB',
--'0B437A26-E8DD-400B-98CF-24EAADD16EE2',
--'B905F5D9-88EC-4E84-B72C-8C67BAFD784B',
--'FB642A19-B009-469A-93C8-7FEEFACCCA4E',
--'B2734F54-732A-4A63-B312-355DE824A167',
--'3C348BBB-B121-4534-8E2F-B5B7931A6458')

set transaction isolation level read uncommitted



4CA7BC15-48C7-4B26-B56F-D29699FC8EEA
85327387-45C9-4484-BF76-049C9465026C
E8D415BF-BD6E-45FD-AE7A-253C92FE3D5A
DBBB75F7-315D-4AB4-9A57-259152875299
6BE7C7F7-AF32-4DC3-821E-64881CF05B96
A3EEF18B-77E1-402C-A8B0-A8BF02C4E973



-- create schema GEORGE

select * from legacysped.transform_prginvolvement where studentrefid = '84689AAE-F4B1-4EA5-8732-0C95DE51EBB5'



select distinct * 
-- into GEORGE.Transform_PrgIep 
from LEGACYSPED.Transform_PrgIep

select StudentRefID, count(*) tot
from GEORGE.Transform_PrgIep
group by StudentRefID
having count(*) > 1

select * from LEGACYSPED.Transform_PrgIep where StudentRefID in ('46C8707D-6BED-4435-9531-09DAEEC578E6', '8B7E81E5-CCE3-4176-A33A-FD118721549F')
-- they have 2 involvements now!!

select * from LEGACYSPED.Transform_Student where StudentRefID in ('46C8707D-6BED-4435-9531-09DAEEC578E6', '8B7E81E5-CCE3-4176-A33A-FD118721549F')


select * 
from LEGACYSPED.Transform_PrgInvolvement
where StudentRefID in ('46C8707D-6BED-4435-9531-09DAEEC578E6', '8B7E81E5-CCE3-4176-A33A-FD118721549F')

select * from PrgInvolvement where ID in ('EA1A6630-E1D4-433C-B876-BDA918742C3C', '8214EDC7-74DB-4975-B0CB-C4F6B3CC9EF1')

*/


/*					TEST changes to select list side-by-side with current records with invalid state
WHERE not  (
	(item.IsEnded = 0 and item.ItemOutcomeID is null and item.EndStatusID is null and item.EndDate is null)
	or
	(item.IsEnded = 1 and item.ItemOutcomeID is null and item.EndStatusID is null and item.EndDate is not null)
	or
	(item.IsEnded = 1 and item.ItemOutcomeID is not null and item.EndStatusID is null and item.EndDate is not null)
	or
	(item.IsEnded = 1 and item.ItemOutcomeID is not null and item.EndStatusID is not null and item.EndDate is not null)
	)
order by 
	item.IsEnded,
	case when item.ItemOutcomeID IS NULL then 0 else 1 end, 
	case when item.EndStatusID IS NULL then 0 else 1 end, 
	case when item.EndDate IS NULL then 0 else 1 end
*/


GO
---




