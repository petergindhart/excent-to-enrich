
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedStudent_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.GiftedStudent_LOCAL
GO

CREATE TABLE x_LEGACYGIFT.GiftedStudent_LOCAL (
StudentRefID	varchar(150)	not null,
EPRefID	varchar(150)	not null,
StudentID	varchar(20)	not null, -- used for matching
Firstname	varchar(50)	not null,
Lastname	varchar(50)	not null,
Birthdate	datetime	not null,
EPMeetingDate	datetime	not null,
LastEPDate	datetime null,
DurationDate	datetime	not null
)
GO

alter table x_LEGACYGIFT.GiftedStudent_LOCAL 
add constraint PK_x_LEGACYGIFT_GiftedStudent_LOCAL_StudentRefID primary key (StudentRefID)
Go

create unique index IX_x_LEGACYGIFT_GiftedStudent_LOCAL_First_Last_DOB on x_LEGACYGIFT.GiftedStudent_LOCAL (Firstname, lastname, birthdate)
go


IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedStudent'))
DROP VIEW x_LEGACYGIFT.GiftedStudent
GO  

CREATE VIEW x_LEGACYGIFT.GiftedStudent
AS
 SELECT * FROM x_LEGACYGIFT.GiftedStudent_LOCAL
GO
--
