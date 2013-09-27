-- #############################################################################
-- Note:  Separated code for several MAP tables from Transform_PrgIep file because EvaluateIncomingItems depends on those MAPs, and Transform_PrgIep depends on EvaluateIncomingItems

If not exists (select 1 from PrgStatus where Name = 'Converted Data Plan')
begin
	insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) 
	values ('0B5D5C72-5058-4BF5-A414-BDB27BD5DD94', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 5, convert(varchar(50), 'Converted Data Plan'), 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285', NULL, NULL)
end
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgIep') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgIep
GO

CREATE VIEW LEGACYSPED.Transform_PrgIep
AS
select 
	ev.StudentRefID, 
	IEPRefID = ev.IncomingIEPRefID, 
	DestID = ev.ExistingConvertedItemID,
	DoNotTouch = ev.Touched, -- 0 is touchable
-- PrgItem
	-- notice:  if data previously imported and should not be touched, we need to derive t data where prev imp rec has been touched
	-- better idea:  expose Touched to be used in the source table filter
	DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3', -- Converted IEP
	StudentID = isnull(stu.DestID, ev.StudentID),
	MeetDate = iep.iepmeetdate, 
	StartDate = isnull(iep.IEPStartDate, convert(varchar, t.StartDate, 101)), -- logic :  if the iep coming in again, let's update with values coming in.  if it's not coming in and we didn't delete it, keep values the same
	EndDate = case when stu.SpecialEdStatus = 'E' then isnull(iep.IEPEndDate, convert(varchar, t.EndDate, 101)) else NULL end,
	ItemOutcomeID = cast(case when stu.SpecialEdStatus = 'E' then (select PrgItemOutcomeID from LEGACYSPED.PrgItemOutcome_EndIEP) else NULL end as uniqueidentifier), 
	CreatedDate = '1/1/1970',
	CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	EndedDate = cast(case when stu.SpecialEdStatus = 'E' then isnull(iep.IEPEndDate, convert(varchar, t.EndedDate, 101)) else NULL end as datetime),
	EndedBy = cast(t.EndedBy as uniqueidentifier),
	SchoolID = isnull(stu.CurrentSchoolID, t.SchoolID),
	GradeLevelID = isnull(stu.CurrentGradeLevelID, t.GradeLevelID),
	InvolvementID = isnull(minv.DestID, ev.ExistingInvolvementID), 
	StartStatusID =  case when stu.SpecialEdStatus = 'E' then '64736B6C-4C2C-4CE0-BED1-3EA7D825B2D6' else -- select * from PrgStatus where ID = '72E79F66-A103-4F72-B8BE-364B586FAF35'
		(select DestID from LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan) end, --- 64736B6C-4C2C-4CE0-BED1-3EA7D825B2D6 (Eligible) -- 0B5D5C72-5058-4BF5-A414-BDB27BD5DD94 (Converted Data Plan)
	EndStatusID = cast(case when stu.SpecialEdStatus = 'E' then '12086FE0-B509-4F9F-ABD0-569681C59EE2' else NULL end as uniqueidentifier), -- Exited After Eligibility
	PlannedEndDate = isnull(convert(datetime, iep.IEPEndDate), dateadd(yy, 1, dateadd(dd, -1, convert(datetime, iep.IEPStartDate)))),
	IsEnded = cast(case when stu.SpecialEdStatus = 'E' then 1 else 0 end as Bit),
	Revision = cast(isnull(t.Revision,0) as bigint),
	IsApprovalPending = cast(isnull(t.IsApprovalPending,0) as bit),
	ApprovedDate = cast(t.ApprovedDate as datetime),
	ApprovedByID = cast(t.ApprovedByID as uniqueidentifier),
-- PrgIep
	IsTransitional = cast(0 as bit),
-- PrgVersion
	VersionDestID = ev.ExistingConvertedVersionID,	--------------- what did this used to be?
	VersionFinalizedDate = iep.IEPStartDate, -- expose the version finalized date in the ev view
	CreatedByID = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- select * from UserProfile where username like '%Support%'
-- Additional Elements
	AgeGroup = case 
		when (select DistrictState from SystemSettings) = 'CO' then case when iep.LRECode between '200' and '299' then 'PK' when iep.LRECode between '300' and '399' then 'K12' else '' end 
		when (select DistrictState from SystemSettings) = 'ID' then case when iep.LREAgeGroup IS null then k.SubType end
		else case when DATEDIFF(yy, stu.DOB, iep.IepStartDate) < 6 then 'PK' when DATEDIFF(yy, stu.DOB, iep.IepStartDate) > 5 then 'K12' End
		end, 
	iep.LRECode,
	iep.MinutesPerWeek,
	iep.ConsentForServicesDate,
	iep.ConsentForEvaluationDate,
	iep.ServiceDeliveryStatement, 
	OID = isnull(stu.OID, '6531EF88-352D-4620-AF5D-CE34C54A9F53'), 
	stu.SpecialEdStatus
from LEGACYSPED.EvaluateIncomingItems ev left join 
	LEGACYSPED.Transform_Student stu on ev.StudentRefID = stu.StudentRefID left join 
	LEGACYSPED.IEP iep on ev.IncomingIEPRefID = iep.IepRefID left join -------------------------------------------------------------------------------- do we need to the Existing IEPRefID or the Incoming IEPRefID ?
	LEGACYSPED.SelectLists k on iep.LRECode = k.LegacySpedCode and k.Type = 'LRE' -- ID sees some students with wrong LREAgeGroup
		and k.SubType = iep.LREAgeGroup left join --- fixes issue for flagler
	dbo.PrgItem t on ev.ExistingConvertedItemID = t.ID left join
	LEGACYSPED.MAP_PrgInvolvementID minv on iep.StudentRefID = minv.StudentRefID 
go


