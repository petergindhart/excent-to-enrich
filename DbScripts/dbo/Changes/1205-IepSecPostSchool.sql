CREATE TABLE dbo.IepPostSchoolAreaDef
	(
	ID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaDef ADD CONSTRAINT
	PK_IepPostSchoolAreaDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepTransitionAgency
	(
	ID uniqueidentifier NOT NULL,
	AreaDefID uniqueidentifier NULL,
	Name varchar(200) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTransitionAgency ADD CONSTRAINT
	PK_IepTransitionAgency PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepTransitionAgency ADD CONSTRAINT
	FK_IepTransitionAgency#AreaDef#TransitionAgencies FOREIGN KEY
	(
	AreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepTransitionService
	(
	ID uniqueidentifier NOT NULL,
	AreaDefID uniqueidentifier NULL,
	Name varchar(200) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTransitionService ADD CONSTRAINT
	PK_IepTransitionService PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepTransitionService ADD CONSTRAINT
	FK_IepTransitionService#AreaDef#TransitionServices FOREIGN KEY
	(
	AreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepTransitionCourse
	(
	ID uniqueidentifier NOT NULL,
	AreaDefID uniqueidentifier NULL,
	Name varchar(200) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepTransitionCourse ADD CONSTRAINT
	PK_IepTransitionCourse PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepTransitionCourse ADD CONSTRAINT
	FK_IepTransitionCourse#AreaDef#TransitionCourses FOREIGN KEY
	(
	AreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepGraduationType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepGraduationType ADD CONSTRAINT
	PK_IepGraduationType PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepPostSchoolConsiderations
	(
	ID uniqueidentifier NOT NULL,
	ProjectedGradDate datetime NULL,
	ProjectedGradTypeID uniqueidentifier NULL,
	ParentsInformedID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolConsiderations ADD CONSTRAINT
	PK_IepPostSchoolConsiderations PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolConsiderations ADD CONSTRAINT
	FK_IepPostSchoolConsiderations#ProjectedGradType# FOREIGN KEY
	(
	ProjectedGradTypeID
	) REFERENCES dbo.IepGraduationType
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepPostSchoolConsiderations ADD CONSTRAINT
	FK_IepPostSchoolConsiderations#ParentsInformed# FOREIGN KEY
	(
	ParentsInformedID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO
CREATE TABLE dbo.IepPostSchoolArea
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	AreaDefID uniqueidentifier NOT NULL,
	MeasurableGoal text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolArea ADD CONSTRAINT
	PK_IepPostSchoolArea PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolConsiderations ADD CONSTRAINT
	FK_IepPostSchoolConsiderations_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepPostSchoolArea ADD CONSTRAINT
	FK_IepPostSchoolArea#Instance#PostSchoolAreas FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepPostSchoolConsiderations
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepPostSchoolArea WITH NOCHECK ADD CONSTRAINT
	FK_IepPostSchoolArea#AreaDef# FOREIGN KEY
	(
	AreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepPostSchoolAreaAgency
	(
	PostSchoolAreaID uniqueidentifier NOT NULL,
	AgencyID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaAgency ADD CONSTRAINT
	PK_IepPostSchoolAreaAgency PRIMARY KEY CLUSTERED 
	(
	PostSchoolAreaID,
	AgencyID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaAgency ADD CONSTRAINT
	FK_IepPostSchoolArea#TransitionAgencies FOREIGN KEY
	(
	PostSchoolAreaID
	) REFERENCES dbo.IepPostSchoolArea
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepPostSchoolAreaAgency ADD CONSTRAINT
	FK_IepTransitionAgency# FOREIGN KEY
	(
	AgencyID
	) REFERENCES dbo.IepTransitionAgency
	(
	ID
	)
GO
CREATE TABLE dbo.IepPostSchoolAreaService
	(
	PostSchoolAreaID uniqueidentifier NOT NULL,
	ServiceID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaService ADD CONSTRAINT
	PK_IepPostSchoolAreaService PRIMARY KEY CLUSTERED 
	(
	PostSchoolAreaID,
	ServiceID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaService ADD CONSTRAINT
	FK_IepPostSchoolArea#TransitionServices FOREIGN KEY
	(
	PostSchoolAreaID
	) REFERENCES dbo.IepPostSchoolArea
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepPostSchoolAreaService ADD CONSTRAINT
	FK_IepTransitionService# FOREIGN KEY
	(
	ServiceID
	) REFERENCES dbo.IepTransitionService
	(
	ID
	)
GO
CREATE TABLE dbo.IepPostSchoolAreaCourse
	(
	PostSchoolAreaID uniqueidentifier NOT NULL,
	CourseID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaCourse ADD CONSTRAINT
	PK_IepPostSchoolAreaCourse PRIMARY KEY CLUSTERED 
	(
	PostSchoolAreaID,
	CourseID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolAreaCourse ADD CONSTRAINT
	FK_IepPostSchoolArea#TransitionCourses FOREIGN KEY
	(
	PostSchoolAreaID
	) REFERENCES dbo.IepPostSchoolArea
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepPostSchoolAreaCourse ADD CONSTRAINT
	FK_IepTransitionCourse# FOREIGN KEY
	(
	CourseID
	) REFERENCES dbo.IepTransitionCourse
	(
	ID
	)
GO


insert PrgSectionType values ( '3B28AFDE-CAE9-4BFB-B010-535E1A8D68CA', 'IEP Post-School Considerations', 'ieppostsch', 'Post-School Considerations', null, null, null, '~/SpecEd/SectionPostSchoolConsiderations.ascx' )

insert EnumType values( 'C8235CD7-001C-45F9-9583-E8C75479870E', 'IEP.PostSchool.ParentsInformed', 0, 0, NULL )
insert EnumValue values( 'A2B683CD-BEA7-4EC8-8BF8-41C1ACBC909E', 'C8235CD7-001C-45F9-9583-E8C75479870E', 'Yes', 'Y', 1, 0 )
insert EnumValue values( '36DB0EF7-2E5A-4A21-BFF7-7087A25EE9BD', 'C8235CD7-001C-45F9-9583-E8C75479870E', 'No', 'Y', 1, 1 )
insert EnumValue values( 'B44F8929-6EDB-44BC-AB85-7D6DC46DFC89', 'C8235CD7-001C-45F9-9583-E8C75479870E', 'N/A', 'Y', 1, 2 )
