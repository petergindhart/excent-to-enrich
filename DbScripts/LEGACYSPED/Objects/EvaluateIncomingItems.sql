-- #############################################################################
-- IEP_LOCAL
if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_IEP_LOCAL_StudentRefID')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_IEP_LOCAL_StudentRefID ON [LEGACYSPED].[IEP_LOCAL] ([StudentRefID])
go

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_IEP_LOCAL_IEPStartDate_StudentRefID')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_IEP_LOCAL_IEPStartDate_StudentRefID ON [LEGACYSPED].[IEP_LOCAL] ([IEPStartDate]) INCLUDE ([StudentRefID])
GO

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
if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_PrgInvolvementID_DestID')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_MAP_PrgInvolvementID_DestID ON LEGACYSPED.MAP_PrgInvolvementID (DestID)
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

select  
-- Student
	s.StudentRefID, -- need a row for every student 
	StudentID = coalesce(xci.StudentID, xp.StudentID, xni.StudentID, ts.DestID),
	-- xciStudentID = xci.StudentID, xpStudentID = xp.StudentID, xniStudentID = xni.StudentID, tsDestID = ts.DestID,
-- Involvement
-- 	xcpm = xcpm.DestID, xp = xp.ID, xci_inv = xci.InvolvementID,
	ExistingInvolvementID = coalesce(xcpm.DestID, xp.ID, xci.InvolvementID), -- if no inv created through ETL, get the inv created through the UI.  DO NOT display the xpe.ID here.  We need it to fail if no active involvement.
--	ExistingInvolvementIsEnded = isnull(case when xp.EndDate is null then 0 else 1 end, case when xp.EndDate is null then 0 else 1 end), -- (may not need this since we can ignore ended involvements).  don't want to resurrect one!
	InvolvementStartDate = case when isnull(xp.StartDate, xcip.StartDate) > gci.IEPStartDate then gci.IEPStartDate else isnull(xp.StartDate, xcip.StartDate) end, -- reset to start date of IEP if inv start is after IEP start.  to use in Transform_PrgInvolvement
	InvolvementEndDate = cast(case when ts.SpecialEdStatus = 'I' then gci.IEPEndDate else case when isnull(xp.EndDate, xcip.EndDate) > getdate() then NULL else isnull(xp.EndDate, xcip.EndDate) end end as datetime), -- reset to NULL if inv.EndDate is future.  This will be used in Transform_PrgInvolvement
-- Item
	ExistingIEPRefID = xcm.IepRefID, 
	IncomingIEPRefID = gci.IepRefID, 
	Incoming = case when gci.IepRefID is null then 0 else 1 end, 
	ExistingStartDate = xci.StartDate, -- convert(varchar, xci.StartDate, 101),
	IncomingIEPStartDate = gci.IEPStartDate, -- convert(varchar, gci.IEPStartDate, 101), 
	IncomingIsOlder = case when gci.IEPStartDate < xci.StartDate then 1 else 0 end,
-- Exsting Converted
	ExistingConvertedItemID = xcm.DestID, ExistingConvertedVersionID = xcv.DestID, ExistingConvertedItemIsEnded = xci.IsEnded, 
-- Exsting Non-Converted
	ExistingNonConvertedItemID = xni.ItemID, ExistingNonConvertedVersionID = xnv.ID, ExistingNonConvertedItemIsEnded = xni.IsEnded, NonConvertedIEPExists = case when xni.ItemID is null then 0 else 1 end, 
-- if touched, we do nothing with the item (no update, no delete)
	-- Touched = cast(isnull(xci.IsEnded,0) as int)+isnull(xci.Revision,0)+case when (xp.ID is null and xpe.ID is not null) then 1 else 0 end  -- + case when xni.ItemID is null then 0 else 1 end -- could be 2 different items.  Want this ??????????  no.  this causes incoming ieps not to be imported where a non-converted item exists
	Touched = cast(case when ts.SpecialEdStatus='A' then isnull(xci.IsEnded,0) else 0 end as int)+isnull(xci.Revision,0)+case when (isnull(xp.ID, xcip.ID) is null and (ts.SpecialEdStatus='A' and xpe.ID in (select DestID from LEGACYSPED.MAP_PrgInvolvementID))) then 1 else 0 end  -- + case when xni.ItemID is null then 0 else 1 end -- could be 2 different items.  Want this ??????????  no.  this causes incoming ieps not to be imported where a non-converted item exists
-- select xp.*
from 
-- All students, existing and incoming -- select ts.DestID, count(*) tot from 
	(select StudentRefID from LEGACYSPED.MAP_IEPStudentRefID union select StudentRefID from LEGACYSPED.IEP ) s left join -- 12084
--	(select i.IepRefID, i.StudentRefID, i.SpecialEdStatus, ItemID = i.DestID, s.DestID from LEGACYSPED.MAP_IEPStudentRefID i join LEGACYSPED.MAP_StudentRefIDAll s on i.StudentRefID = s.studentrefID)  ts on s.StudentRefID = ts.StudentRefID left join -- does not include those students that were imported previously, but not in new data set
	LEGACYSPED.Transform_Student ts on s.StudentRefID = ts.StudentRefID left join 
		-- need to make sure MAP_IEPStudentRefID will be populated any time this view is used.
-- EXISTING INVOLVEMENT (ACTIVE).  either created through ETL or UI.  consider isnull(xcmp.DestID, xp.ID).  check for involvement date range
	PrgInvolvement xp on ts.DestID = xp.StudentID and xp.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' 
	and 
		isnull(xp.EndDate, DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 1)) > DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 0) left join  -- if involvement ended today, we don't need this record

-- EXISTING INVOLVEMENT (ENDED).  either created through ETL or UI.  consider isnull(xcmp.DestID, xp.ID).  check for involvement date range
	PrgInvolvement xpe on ts.DestID = xpe.StudentID and
		xpe.EndDate is not null and
		xpe.ID = (
			select top 1 xpemax.id -- this is an arbitrary 
			from PrgInvolvement xpemax 
			where xpe.StudentID = xpemax.StudentID
			and xpemax.EndDate is not null
			and xpemax.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
			) left join  -- we want to know if the student had an involvement before, in case all involvements are ended.

-- EXISTING Converted involvement. --------------------- change of thought:  look at all involvements.  see which ones were created through ETL by checking MAP.  
	LEGACYSPED.MAP_PrgInvolvementID xcpm on xp.ID = xcpm.DestID left join  -- order by xcpm.StudentRefID, xp.ID, ts.DestID -- determine if from legacy or created through UI

-- check for EXISTING converted ieps, non-converted ieps and incoming ieps (iep = ITEM).  Student may have 1 of each, so check for them separately (2 joins to PrgItem)

-- EXISTING converted ITEM
	LEGACYSPED.MAP_IEPStudentRefID xcm on s.StudentRefID = xcm.StudentRefID left join 
--	LEGACYSPED.Transform_PrgIep xcm on s.StudentRefID = xcm.StudentRefID left join 
	PrgItem xci on xcm.DestID = xci.ID and xci.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' and xci.CreatedDate = '1/1/1970' left join 
-- NEW:   get the existing converted item InvolvementID here.  Covers case where the involvement is represented in the MAP table but not in the incoming data.
	PrgInvolvement xcip on xci.InvolvementID = xcip.ID left join 

-- EXISTING converted iep VERSION
	LEGACYSPED.MAP_PrgVersionID xcv on xcm.IepRefID = xcv.IepRefID left join -- xcm null, xcv null.  ........................................ assumes the item has never been touched! (or that we are not acting on touched records)

-- EXISTING non-conveted ITEM (IEP)
	( 
	select s.StudentRefID, i.StudentID, ItemID = i.ID, i.InvolvementID, i.IsEnded
	from PrgItem i join LEGACYSPED.MAP_StudentRefIDAll s on i.StudentID = s.DestID -- if items are eliminated by join to Transform_Student not to worry, because we are not importing them anyway
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
go 




