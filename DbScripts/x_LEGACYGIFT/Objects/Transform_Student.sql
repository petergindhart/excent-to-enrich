
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_EPStudentRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_EPStudentRefID
(
	EPRefID varchar(150) NOT NULL ,
	StudentRefID varchar(150) not null,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_EPStudentRefID ADD CONSTRAINT
PK_MAP_EPStudentRefID PRIMARY KEY CLUSTERED
(
	EPRefID
)
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_Student') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_Student
GO

CREATE VIEW x_LEGACYGIFT.Transform_Student
AS 
select 
	-- Student
	x.StudentRefID,
	DestID = coalesce(s.ID, n.ID, me.DestID), 
	--NumberMatchID = s.ID,
	--NameMatchID = n.ID,
	--MapMatchID = me.DestID,
	x.Firstname,
	x.Lastname,
	-- Item
	CurrentSchoolID = isnull(s.CurrentSchoolID, n.CurrentSchoolID),
	CurrentGradeLevelID = isnull(s.CurrentGradeLevelID, n.CurrentGradeLevelID),
	-- MAP EP
	x.EPRefID,
	ItemDestID = me.DestID,
	-- Dates
	x.EPMeetingDate,
	x.LastEPDate, 
	x.DurationDate,
	s.OID
from x_LEGACYGIFT.GiftedStudent x
left join dbo.Student s on x.StudentRefID = s.Number
	and s.CurrentGradeLevelID is not null 
	and s.CurrentSchoolID is not null
left join dbo.Student n on 
	x.Firstname = n.FirstName and 
	x.Lastname = n.LastName and
	isnull(x.Birthdate,'1970-01-01') = n.DOB
--left join x_LEGACYGIFT.MAP_StudentRefID ms on x.StudentRefID = ms.StudentRefID 
left join x_LEGACYGIFT.MAP_EPStudentRefID me on x.EPRefID = me.EpRefID -- ep map
left join dbo.PrgItem i on s.ID = i.StudentID and i.DefID = (select ConvertedEPID from x_LEGACYGIFT.MAP_GiftedProgramID)
where coalesce(s.ID, n.ID, me.DestID) is not null
and isnull(s.CurrentSchoolID, n.CurrentSchoolID) is not null
and isnull(s.CurrentGradeLevelID, n.CurrentGradeLevelID) is not null
GO