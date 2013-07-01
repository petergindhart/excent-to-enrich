

-- #############################################################################
-- Student
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_StudentRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--CREATE TABLE x_LEGACYGIFT.MAP_StudentRefID
--	(
--	StudentRefID varchar(150) NOT NULL,
--	DestID uniqueidentifier NOT NULL
--	)  

--ALTER TABLE x_LEGACYGIFT.MAP_StudentRefID ADD CONSTRAINT
--	PK_MAP_StudentRefID PRIMARY KEY CLUSTERED
--	(
--	StudentRefID
--	) 
--END
--GO


-- #############################################################################
-- IEP
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_EpRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--CREATE TABLE LEGACYSPED.MAP_EpRefID
--(
--	EpRefID varchar(150) NOT NULL ,
--	DestID uniqueidentifier NOT NULL
--)

--ALTER TABLE LEGACYSPED.MAP_EpRefID ADD CONSTRAINT
--PK_MAP_EpRefID PRIMARY KEY CLUSTERED
--(
--	EpRefID
--)
--END
--GO


-- EP Dates
-- #############################################################################
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInstance_EPDates') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInstance_EPDates
(
	EpRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.MAP_FormInstance_EPDates ADD CONSTRAINT
PK_MAP_FormInstance_EPDates PRIMARY KEY CLUSTERED
(
	EpRefID
)
END
GO


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
	DestID = s.ID, 
	-- Item
	s.CurrentSchoolID,
	s.CurrentGradeLevelID,
	-- MAP EP
	x.EPRefID,
	ItemDestID = me.DestID,
	-- Dates
	x.EPMeetingDate,
	x.LastEPDate, 
	x.DurationDate
from x_LEGACYGIFT.GiftedStudent x
join dbo.Student s on x.StudentID = s.Number
	and s.CurrentGradeLevelID is not null 
	and s.CurrentSchoolID is not null
--left join x_LEGACYGIFT.MAP_StudentRefID ms on x.StudentRefID = ms.StudentRefID -- stu map is not necessary because we are not adding students, just matching
left join x_LEGACYGIFT.MAP_EPStudentRefID me on x.EPRefID = me.EpRefID -- ep map
left join dbo.PrgItem i on s.ID = i.StudentID and i.DefID = '69942840-0E78-498D-ADE3-7454F69EA178'
GO

--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'Transform_Student')
--begin
--	insert x_LEGACYGIFT.MAP_EPStudentRefID
--	select distinct s.EPRefID, s.StudentRefID, s.DestID
--	from x_LEGACYGIFT.Transform_Student s left join  
--	x_LEGACYGIFT.MAP_EPStudentRefID t on s.EPRefID = t.EPRefID
--	where t.EPRefID is null 
--end
--END
--GO
