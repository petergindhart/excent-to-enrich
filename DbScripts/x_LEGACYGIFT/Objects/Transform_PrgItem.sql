-- #############################################################################
-- Note:  Separated code for several MAP tables from Transform_PrgItem file because EvaluateIncomingItems depends on those MAPs, and Transform_PrgItem depends on EvaluateIncomingItems


declare @PrgStatusSeq int ;
select @PrgStatusSeq = sequence from PrgStatus where ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and DeletedDate is null and Name = 'Eligible'
If not exists (select 1 from PrgStatus where Name = 'Converted EP')
begin
	update PrgStatus set Sequence = Sequence+1 where ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and DeletedDate is null and Sequence > @PrgStatusSeq

	insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) 
	values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900', '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E', 3, convert(varchar(50), 'Converted EP'), 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285', NULL, NULL)
end
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgItem') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgItem
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgItem
AS
select 
	stu.StudentRefID, 
	stu.EPRefID, 
-- PrgItem
	DefID = '69942840-0E78-498D-ADE3-7454F69EA178', -- EP - Converted
	StudentID = stu.DestID,
	MeetDate = stu.EPMeetingDate, 
	StartDate = stu.EPMeetingDate,
	EndDate = stu.DurationDate,
	ItemOutcomeID = NULL, 
	CreatedDate = '1/1/1970',
	CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	EndedDate = NULL,
	EndedBy = NULL,
	SchoolID = stu.CurrentSchoolID, 
	GradeLevelID = stu.CurrentGradeLevelID,
	InvolvementID = minv.DestID, 
	StartStatusID = (select DestID from x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP), 
	EndStatusID = NULL,
	PlannedEndDate = stu.DurationDate,
	IsEnded = 0,
	Revision = 0,
	IsApprovalPending = 0,
	ApprovedDate = cast(t.ApprovedDate as datetime),
	ApprovedByID = cast(t.ApprovedByID as uniqueidentifier),
-- PrgIep
	IsTransitional = cast(0 as bit),
-- PrgVersion
	VersionDestID = '', -- need something here.
	VersionFinalizedDate = stu.EPMeetingDate, 
	CreatedByID = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB',
-- Additional Elements
	ServiceDeliveryStatement = NULL
from x_LEGACYGIFT.Transform_GiftedStudent stu left join 
	x_LEGACYGIFT.MAP_PrgInvolvementID minv on stu.StudentRefID = minv.StudentRefID left join
	dbo.PrgItem t on stu.ItemDestID = t.ID 
go

