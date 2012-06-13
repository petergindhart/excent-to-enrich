-- #############################################################################
-- Note:  Separated code for several MAP tables from Transform_PrgIep file because EvaluateIncomingItems depends on those MAPs, and Transform_PrgIep depends on EvaluateIncomingItems

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgIep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgIep
GO

CREATE VIEW LEGACYSPED.Transform_PrgIep
AS
select 
	ev.StudentRefID, 
	IEPRefID = ev.IncomingIEPRefID, 
	DestID = COALESCE(ev.ExistingConvertedItemID,MIep.DestID, NEWID()),
	DoNotTouch = ev.Touched, -- 0 is touchable
-- PrgItem
	-- notice:  if data previously imported and should not be touched, we need to derive t data where prev imp rec has been touched
	-- better idea:  expose Touched to be used in the source table filter
	DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3', -- Converted IEP
	StudentID = isnull(stu.DestID, ev.StudentID),
	MeetDate = iep.iepmeetdate, 
	StartDate = isnull(iep.IEPStartDate, convert(varchar, t.StartDate, 101)), -- logic :  if the iep coming in again, let's update with values coming in.  if it's not coming in and we didn't delete it, keep values the same
	EndDate = case when stu.SpecialEdStatus = 'I' then isnull(iep.IEPEndDate, convert(varchar, t.EndDate, 101)) else NULL end,
	ItemOutcomeID = cast(case when stu.SpecialEdStatus = 'I' then (select PrgItemOutcomeID from LEGACYSPED.PrgItemOutcome_EndIEP) else NULL end as uniqueidentifier), 
	CreatedDate = '1/1/1970',
	CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	EndedDate = cast(case when stu.SpecialEdStatus = 'I' then isnull(iep.IEPEndDate, convert(varchar, t.EndedDate, 101)) else NULL end as datetime),
	EndedBy = cast(t.EndedBy as uniqueidentifier),
	SchoolID = isnull(stu.CurrentSchoolID, t.SchoolID),
	GradeLevelID = isnull(stu.CurrentGradeLevelID, t.GradeLevelID),
	InvolvementID = isnull(minv.DestID, ev.ExistingInvolvementID), 
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
	VersionDestID = COALESCE (ev.ExistingConvertedVersionID, MPrg.DestID,NEWID()),	--------------- what did this used to be?
	VersionFinalizedDate = iep.IEPStartDate, -- expose the version finalized date in the ev view
-- Additional Elements
	AgeGroup = case when DATEDIFF(yy, stu.DOB, iep.IepStartDate) < 6 then 'PK' when DATEDIFF(yy, stu.DOB, iep.IepStartDate) > 5 then 'K12' End, 
	iep.LRECode,
	iep.MinutesPerWeek,
	iep.ConsentForServicesDate 
from LEGACYSPED.EvaluateIncomingItems ev left join 
	LEGACYSPED.Transform_Student stu on ev.StudentRefID = stu.StudentRefID left join 
	LEGACYSPED.IEP iep on ev.IncomingIEPRefID = iep.IepRefID left join -------------------------------------------------------------------------------- do we need to the Existing IEPRefID or the Incoming IEPRefID ?
	dbo.PrgItem t on ev.ExistingConvertedItemID = t.ID left join
	LEGACYSPED.MAP_PrgInvolvementID minv on ev.StudentRefID = minv.StudentRefID lEFT JOIN
    LEGACYSPED.MAP_IepRefID MIep ON  iep.IepRefID = MIep.IepRefID LEFT JOIN 
	LEGACYSPED.MAP_PrgVersionID MPrg ON iep.IepRefID = MPrg.IepRefID
		
	
	--left join
	--dbo.PrgInvolvement inv on minv.DestID = inv.ID
go
--
