
--begin tran
-- rollback

CREATE TABLE dbo.PersonType (
	ID char(1) NOT NULL,
	Name varchar(50)
)
GO
ALTER TABLE dbo.PersonType ADD CONSTRAINT
	PK_PersonType PRIMARY KEY CLUSTERED 
	(
	ID
	)
GO

CREATE TABLE dbo.Person
	(
	ID uniqueidentifier NOT NULL,
	TypeID char(1) NOT NULL,
	Deleted datetime NULL,
	FirstName varchar(50) NULL,
	LastName varchar(50) NULL,
	EmailAddress varchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Person ADD CONSTRAINT
	PK_Person PRIMARY KEY CLUSTERED 
	(
	ID
	)
GO
ALTER TABLE dbo.Person ADD CONSTRAINT
	FK_Person#Type# FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.PersonType
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE NO ACTION 
GO

insert into PersonType values ('U', 'User')
insert into PersonType values ('P', 'Person')

insert into Person
select ID, 'U', Deleted, FirstName, LastName, EmailAddress
from UserProfile
GO

ALTER TABLE dbo.UserProfile ADD CONSTRAINT
	FK_UserProfile_Person FOREIGN KEY
	(
	ID
	) REFERENCES dbo.Person
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE CASCADE
	
alter table UserProfile drop column FirstName
alter table UserProfile drop column LastName
alter table UserProfile drop column EmailAddress

GO

ALTER TABLE dbo.PrgItemTeamMember ADD
	MtgInvitee bit NULL,
	MtgAttendee bit NULL,
	PersonID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgItemTeamMember ADD CONSTRAINT
	FK_PrgItemTeamMember#Person# FOREIGN KEY
	(
	PersonID
	) REFERENCES dbo.Person
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE NO ACTION 
GO

update PrgItemTeamMember
set PersonID = UserProfileID,
	MtgInvitee = 0,
	MtgAttendee = 0
GO

ALTER TABLE PrgItemTeamMember ALTER COLUMN PersonID uniqueidentifier not null
ALTER TABLE PrgItemTeamMember ALTER COLUMN MtgInvitee bit not null
ALTER TABLE PrgItemTeamMember ALTER COLUMN MtgAttendee bit not null
GO
ALTER TABLE PrgItemTeamMember DROP CONSTRAINT FK_PrgItemTeamMember#UserProfile#
ALTER TABLE PrgItemTeamMember DROP COLUMN UserProfileID
GO

CREATE TABLE dbo.PrgItemDefResponsibility
	(
	ID uniqueidentifier NOT NULL,
	ItemDefID uniqueidentifier NOT NULL,
	ResponsibilityID uniqueidentifier NOT NULL,
	MustBeFilled bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgItemDefResponsibility ADD CONSTRAINT
	PK_PrgItemDefResponsibility PRIMARY KEY CLUSTERED 
	(
	ID
	) 

GO
ALTER TABLE dbo.PrgItemDefResponsibility ADD CONSTRAINT
	FK_PrgItemDefResponsibility#Responsibility# FOREIGN KEY
	(
	ResponsibilityID
	) REFERENCES dbo.PrgResponsibility
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PrgItemDefResponsibility ADD CONSTRAINT
	FK_PrgItemDefResponsibility#ItemDef#Responsibilities FOREIGN KEY
	(
	ItemDefID
	) REFERENCES dbo.PrgItemDef
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
GO
CREATE TABLE dbo.PrgMeeting
	(
	ID uniqueidentifier NOT NULL,
	StartTime datetime NOT NULL,
	EndTime datetime NOT NULL,
	AgendaText text NULL,
	MinutesText text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMeeting ADD CONSTRAINT
	PK_PrgMeeting PRIMARY KEY CLUSTERED 
	(
	ID
	)

GO
ALTER TABLE dbo.PrgMeeting ADD CONSTRAINT
	FK_PrgMeeting_PrgItem FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgItem
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE
	
GO
CREATE TABLE dbo.PrgMeetingItem
	(
	ItemID uniqueidentifier NOT NULL,
	MeetingID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrgMeetingItem ADD CONSTRAINT
	PK_PrgMeetingItem PRIMARY KEY CLUSTERED 
	(
	ItemID,
	MeetingID
	)

GO
ALTER TABLE dbo.PrgMeetingItem ADD CONSTRAINT
	FK_PrgMeetingItem#RelatedItems# FOREIGN KEY
	(
	MeetingID
	) REFERENCES dbo.PrgMeeting
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION
	
GO
ALTER TABLE dbo.PrgMeetingItem ADD CONSTRAINT
	FK_PrgMeetingItem#RelatedMeetings# FOREIGN KEY
	(
	ItemID
	) REFERENCES dbo.PrgItem
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
GO

insert into PrgItemType values ('B1B9173E-C987-4752-82DE-D7237A2BC060', 'Meeting', 'A kind of meeting that may be held as part of a program.')
