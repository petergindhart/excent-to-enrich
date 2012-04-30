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

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_IEPStudentRefID_DestID')
create nonclustered index IX_LEGACYSPED_MAP_IEPStudentRefID_DestID on LEGACYSPED.MAP_IEPStudentRefID (DestID)

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_IEPStudentRefID_StudentRefID')
create nonclustered index IX_LEGACYSPED_MAP_IEPStudentRefID_StudentRefID on LEGACYSPED.MAP_IEPStudentRefID (StudentRefID)

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_IEPStudentRefID_IepRefID_StudentRefID')
create nonclustered index IX_LEGACYSPED_MAP_IEPStudentRefID_IepRefID_StudentRefID on LEGACYSPED.MAP_IEPStudentRefID (IepRefID, StudentRefID)

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
-- PrgItemOutcome_EndIEP
if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'PrgItemOutcome_EndIEP')
begin
create table LEGACYSPED.PrgItemOutcome_EndIEP (
PrgItemOutcomeID uniqueidentifier not null
)
end
GO


-- #############################################################################
-- Note:  Separated PrgInvolvement MAP table code from Transform_PrgInvolvement files because EvaluateIncomingItems depends on this MAP, and Transform_PrgInvolvement depends on EvaluateIncomingItems


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

the output of this view is intended to be a distinct list of students comparing incoming to existing Involvements and Items.


Naming convention for table aliases used in this view
source
	X = Existing
	G = Incoming
type
	C = Converted (LEGACY)
	N = Non-converted (ENRICH)
object
	I = Item (IEP)
	P = Involvement (PROGRAM)
	V = Version
	M = Map

	S = Student

order
	source (existing vs incoming)
	type (converted vs non-converted)

*/

select distinct -- we are seeing 
-- Student
	s.StudentRefID, -- need a row for every student 
	StudentID = coalesce(xci.StudentID, xp.StudentID, xni.StudentID),
-- Involvement
	ExistingInvolvementID = isnull(xcpm.DestID, xp.ID), -- if no inv created through ETL, get the inv created through the UI
--	ExistingInvolvementIsEnded = isnull(case when xp.EndDate is null then 0 else 1 end, case when xp.EndDate is null then 0 else 1 end), -- (may not need this since we can ignore ended involvements).  don't want to resurrect one!
	InvolvementStartDate = case when xp.StartDate > gci.IEPStartDate then gci.IEPStartDate else xp.StartDate end, -- reset to start date of IEP if inv start is after IEP start.  to use in Transform_PrgInvolvement
	InvolvementEndDate = cast(case when ts.SpecialEdStatus = 'I' then gci.IEPEndDate else case when xp.EndDate > getdate() then NULL else xp.EndDate end end as datetime), -- reset to NULL if inv.EndDate is future.  This will be used in Transform_PrgInvolvement
-- Item
	ExistingIEPRefID = xcm.IepRefID, 
	IncomingIEPRefID = gci.IepRefID, Incoming = case when gci.IepRefID is null then 0 else 1 end, 
-- Exsting Converted
	ExistingConvertedItemID = xcm.DestID, ExistingConvertedVersionID = xcv.DestID, ExistingConvertedItemIsEnded = xci.IsEnded, 
-- Exsting Non-Converted
	ExistingNonConvertedItemID = xni.ItemID, ExistingNonConvertedVersionID = xnv.ID, ExistingNonConvertedItemIsEnded = xni.IsEnded, NonConvertedIEPExists = case when xni.ItemID is null then 0 else 1 end, 
-- if touched, we do nothing with the item (no update, no delete)
	Touched = cast(isnull(xci.IsEnded,0) as int)+isnull(xci.Revision,0)  -- + case when xni.ItemID is null then 0 else 1 end -- could be 2 different items.  Want this ??????????  no.  this causes incoming ieps not to be imported where a non-converted item exists
from 
-- All students, existing and incoming -- select ts.DestID, count(*) tot from 
	(select StudentRefID from LEGACYSPED.MAP_IEPStudentRefID union select StudentRefID from LEGACYSPED.IEP ) s left join -- 12084
	LEGACYSPED.Transform_Student ts on s.StudentRefID = ts.StudentRefID left join -- does not include those students that were imported previously, but not in new data set

-- EXISTING INVOLVEMENT.  either created through ETL or UI.  consider isnull(xcmp.DestID, xp.ID).  check for involvement date range
	PrgInvolvement xp on ts.DestID = xp.StudentID and 
		isnull(xp.EndDate, DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 1)) > DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 0) left join  -- if involvement ended today, we don't need this record

-- EXISTING Converted involvement. --------------------- change of thought:  look at all involvements.  see which ones were created through ETL by checking MAP.  
	LEGACYSPED.MAP_PrgInvolvementID xcpm on xp.ID = xcpm.DestID left join  -- order by xcpm.StudentRefID, xp.ID, ts.DestID -- determine if from legacy or created through UI

-- check for EXISTING converted ieps, non-converted ieps and incoming ieps (iep = ITEM).  Student may have 1 of each, so check for them separately (2 joins to PrgItem)

-- EXISTING converted ITEM   
	LEGACYSPED.MAP_IEPStudentRefID xcm on s.StudentRefID = xcm.StudentRefID left join 
	PrgItem xci on xcm.DestID = xci.ID left join 

-- EXISTING converted iep VERSION
	LEGACYSPED.MAP_PrgVersionID xcv on xcm.IepRefID = xcv.IepRefID left join -- 55 records.  xcm null, xcv null.  good

-- EXISTING non-conveted ITEM (IEP)
	( 
	select s.StudentRefID, i.StudentID, ItemID = i.ID, i.InvolvementID, i.IsEnded
	from PrgItem i join LEGACYSPED.Transform_Student s on i.StudentID = s.DestID -- if items are eliminated by join to Transform_Student not to worry, because we are not importing them anyway
	where i.ID = (
		select max(convert(varchar(36), i2.ID)) -- we are arbitrarily selecting only one of the non-converted items of type "IEP", because we just need to know if one exists
		from (select i3.ID, i3.StudentID from PrgItem i3 join PrgItemDef d3 on i3.DefID = d3.ID join PrgInvolvement v3 on i3.InvolvementID = v3.ID where d3.TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' and i3.DefID <> '8011D6A2-1014-454B-B83C-161CE678E3D3' and v3.EndDate is null) i2 -- TypeID = IEP, non-converted
			where i.StudentID = i2.StudentID) 
			) xni on s.StudentRefID = xni.StudentRefID left join 

-- EXISTING non-converted VERSION (since multiples may exist, we're getting the most recent version only)
	PrgVersion xnv on xni.ItemID = xnv.ItemID and 
		isnull(xnv.DateFinalized, DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 0)) = (
			select isnull(max(ncxvMax.DateFinalized), DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 0))  -- assumes there won't be any finalized today or after
			from PrgVersion ncxvMax
			where xnv.ItemID = ncxvMax.ItemID 
			) left join

-- INCOMING (legacy) converted IEP 
	LEGACYSPED.IEP gci on s.StudentRefID = gci.StudentRefID 
--	left join
---- INCOMING converted IEP version (map populated during import, of course)
--	LEGACYSPED.MAP_PrgVersionID gcv on gci.IepRefID = gcv.IepRefID ----------- was not using this, so removed from view
go 

-- set transaction isolation level read uncommitted
