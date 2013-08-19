-- #############################################################################
-- Note:  Separated code for several MAP tables from Transform_PrgItem file because EvaluateIncomingItems depends on those MAPs, and Transform_PrgItem depends on EvaluateIncomingItems



-- #############################################################################
-- Version
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PrgVersionID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_PrgVersionID
(
	EpRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_PrgVersionID ADD CONSTRAINT
PK_MAP_PrgVersionID PRIMARY KEY CLUSTERED
(
	EpRefID
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgItem') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgItem
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgItem
AS
select 
	stu.StudentRefID, 
	stu.EPRefID, 
	DestID = stu.ItemDestID,
-- PrgItem
	DefID = (select ConvertedEPID from x_LEGACYGIFT.MAP_GiftedProgramID), -- EP - Converted
	StudentID = stu.DestID,
	MeetDate = stu.EPMeetingDate, 
	StartDate = stu.EPMeetingDate,
	EndDate = cast(Null as datetime), -- may need to set any with a duration date in the past to that date.
	-- EndDate = case when stu.DurationDate < getdate() then stu.DurationDate else NULL end, -- have not decided to do this yet.
	ItemOutcomeID = cast(NULL as uniqueidentifier), 
	CreatedDate = '1/1/1970',
	CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
	EndedDate = cast(NULL as datetime),
	EndedBy = cast(NULL as uniqueidentifier), 
	SchoolID = stu.CurrentSchoolID, 
	GradeLevelID = stu.CurrentGradeLevelID,
	InvolvementID = minv.DestID, 
	StartStatusID = (select DestID from x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP), 
	EndStatusID = cast(NULL as uniqueidentifier), 
	PlannedEndDate = stu.DurationDate,
	IsEnded = cast(0 as bit),
	Revision = cast(0 as int),
	IsApprovalPending = cast(0 as bit),
	ApprovedDate = cast(t.ApprovedDate as datetime),
	ApprovedByID = cast(t.ApprovedByID as uniqueidentifier),
-- PrgIep
	IsTransitional = cast(0 as bit),
-- PrgVersion
	VersionDestID = mver.DestID,
	VersionFinalizedDate = stu.EPMeetingDate, 
	CreatedByID = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB',
-- Additional Elements
	ServiceDeliveryStatement = NULL, 
	stu.OID
from x_LEGACYGIFT.Transform_Student stu left join 
	x_LEGACYGIFT.MAP_PrgInvolvementID minv on stu.StudentRefID = minv.StudentRefID left join
	x_LEGACYGIFT.MAP_PrgVersionID mver on stu.EPRefID = mver.EPRefID left join
	dbo.PrgVersion v on mver.DestID = v.ID left join
	dbo.PrgItem t on stu.ItemDestID = t.ID 
go

