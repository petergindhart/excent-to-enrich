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


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgIep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgIep
GO

CREATE VIEW LEGACYSPED.Transform_PrgIep
AS
select 
	stu.StudentRefID, 
	iep.IepRefID,
	-- if existing, we can determine what to do with it - if touched, leave it be.  if untouched, delete it and replace it
	--ExistingIepRefID = prevm.IepRefID,
	--ExistingItemID = exist.ID,
	--ExistingIsEnded = exist.isended,
	-- incoming iep
	--IncomingIepRefID = iep.IepRefID,
	-- IncomingDestID = isnull(t.ID, newm.DestID), ------------------------ this may not be right!!!!
	-- DestID = isnull(t.ID, newm.DestID), 
-- 	DestID = case when (exist.IsEnded = 0 and iep.IepRefID <> prevm.IepRefID) then exist.ID end,
	DestID = case when (exist.IsEnded = 0 and iep.IepRefID = prevm.IepRefID) then exist.ID else newm.DestID end,
	AgeGroup = case when DATEDIFF(yy, stu.DOB, iep.IepStartDate) < 6 then 'PK' when DATEDIFF(yy, stu.DOB, iep.IepStartDate) > 5 then 'K12' End,
	iep.LRECode,
	--DestID = isnull(exist.id, newm.DestID), -- logic :  If it exists and we return the row (see where clause) delete old and insert new (relies on cascading deletes!!!!!).  If not exists, need to insert it.
		-- note:  change approach.  See DeleteDestID and DestID
	DeleteDestID = case when (exist.IsEnded = 0 and iep.IepRefID <> prevm.IepRefID) then exist.ID end,
	-- PrgItem
	DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3', -- Converted IEP
	StudentID = stu.DestID,
	MeetDate = iep.iepmeetdate,
	StartDate = iep.IEPStartDate,
	EndDate = case when stu.SpecialEdStatus = 'I' then iep.IEPEndDate else NULL end,
	ItemOutcomeID = case when stu.SpecialEdStatus = 'I' then (select PrgItemOutcomeID from LEGACYSPED.PrgItemOutcome_EndIEP) else NULL end, 
	CreatedDate = iep.IEPStartDate,
	CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	EndedDate = cast(case when stu.SpecialEdStatus = 'I' then iep.IEPEndDate else NULL end as datetime),
	EndedBy = cast(t.EndedBy as uniqueidentifier),
	SchoolID = stu.CurrentSchoolID,
	GradeLevelID = stu.CurrentGradeLevelID,
	InvolvementID = inv.DestID,
	StartStatusID =  '796C212F-6003-4CD3-878D-53BEBE087E9A', 
	EndStatusID = case when stu.SpecialEdStatus = 'I' then '12086FE0-B509-4F9F-ABD0-569681C59EE2' else NULL end,
	PlannedEndDate = isnull(convert(datetime, iep.IEPEndDate), dateadd(yy, 1, dateadd(dd, -1, convert(datetime, iep.IEPStartDate)))),
	IsEnded = cast(case when stu.SpecialEdStatus = 'I' then 1 else 0 end as Bit),
	Revision = cast(isnull(t.Revision,0) as bigint),
	IsApprovalPending = cast(isnull(t.IsApprovalPending,0) as bit),
	ApprovedDate = cast(t.ApprovedDate as datetime),
	ApprovedByID = cast(t.ApprovedByID as uniqueidentifier),
	-- PrgIep
	IsTransitional = cast(0 as bit),
	-- PrgVersion
	VersionDestID = ver.DestID,
	VersionFinalizedDate = iep.IEPStartDate,
	iep.MinutesPerWeek,
	iep.ConsentForServicesDate 
from 
	LEGACYSPED.Transform_Student stu join 
-- incoming
	LEGACYSPED.IEP iep on stu.StudentRefID = iep.StudentRefID left join 
	LEGACYSPED.MAP_PrgInvolvementID inv on stu.StudentRefID = inv.StudentRefID left join 
	LEGACYSPED.MAP_PrgVersionID ver on iep.IepRefID = ver.IepRefID left join 
-- potentially exists, if so we decide how to act on it.  if touched, leave it alone and don't import this one.  if untouched, replace it.
	dbo.PrgItem exist on stu.DestID = exist.StudentID and exist.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' left join -- there is an existing Converted Data Item
	LEGACYSPED.MAP_IepRefID prevm on exist.ID = prevm.DestID left join 
-- target table
	LEGACYSPED.MAP_IepRefID newm on iep.IepRefID = newm.IepRefID left join 
	dbo.PrgItem t on newm.DestID = t.ID
 WHERE not isnull(exist.IsEnded,0) = 1 -- if exists and is ended, do not re-import or update
		
		
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




