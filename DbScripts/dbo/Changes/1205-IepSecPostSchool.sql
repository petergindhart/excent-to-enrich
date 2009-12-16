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
insert PrgSectionDef values ( '3C6C85FD-6E9F-477C-91DF-0ACC2988A809', '3B28AFDE-CAE9-4BFB-B010-535E1A8D68CA', '251DA756-A67A-453C-A676-3B88C1B9340C', 3, 1, null, null, null, null, null )

-- post-school considerations
insert IepGraduationType values( 'B7F48C72-B240-4E39-99C9-7D06E3EF046A', 'Diploma' )
insert IepGraduationType values( '75C194FA-69C8-4D4E-9E71-B046A7125191', 'Certificate' )

insert IepPostSchoolAreaDef values( 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1', 0, 'Post-School Education/Training Goal' )
insert IepPostSchoolAreaDef values( '823BA9DB-AF13-42BD-9CC2-EAA884701523', 1, 'Career Employment Goal' )
insert IepPostSchoolAreaDef values( '2B5D9C8A-7FA7-4E74-9F0C-53327209E751', 2, 'Independent Living Skills Goal (when appropriate)' )

-- sample config of post-school courses/services/agencies
insert IepTransitionCourse values( '001D19B2-FACF-49DE-93CC-463A68B81FE0', null, 'Arts, Media & Communication' )
insert IepTransitionCourse values( 'CB24C0B2-3C1F-45EC-8E2D-0EA9DFEC56EB', null, 'Business Management & Finance' )
insert IepTransitionCourse values( 'CD883763-5A60-47EE-9424-66D9D6677A37', null, 'Construction & Development' )
insert IepTransitionCourse values( '24AD5859-44DC-4804-9A86-8D3C5E48A053', null, 'Education, Training & Child Services' )
insert IepTransitionCourse values( '84F734D9-1347-4E4D-BD74-F0F74DBE4FCD', null, 'Health, Bioscience, & Medicine' )
insert IepTransitionCourse values( 'B233F18D-C6A8-4BF7-A686-EF728C5546B8', null, 'Information Technology' )
insert IepTransitionCourse values( '02A12FE7-2628-4394-AD3D-AD527D1F1D38', null, 'Engineering, Scientific Research & Manufacturing Technology' )
insert IepTransitionCourse values( '3DABB2E0-9CE2-4B93-B505-4CF0BCA1EAC6', null, 'Environmental, Agricultural & Natural Resource Systems' )
insert IepTransitionCourse values( '905E1947-D18A-4051-A1FD-B072427B739D', null, 'Transportation, Distribution & Logistics' )
insert IepTransitionCourse values( '00829710-ED06-422B-9C93-EBB7718653E6', null, 'Law, Government, Public Safety & Administration' )
insert IepTransitionCourse values( 'AE9EC9E0-F768-4D53-9CC9-08855077A9E3', null, 'Human, Consumer Services, Hospitality & Tourism' )

insert IepTransitionService values( '64004C5E-C9C5-41E2-865D-DA381CDD2998', null, 'No Services Needed: upon exiting from the educational system.' )
insert IepTransitionService values( '5EE8ED50-8019-4068-9A43-8B6FA518E85B', null, 'Public income maintenance: Social Security Income (SSI), Social Security' )
insert IepTransitionService values( 'A17A5EA1-6F89-415E-A123-D76576CD2BC9', null, 'Disability Income (SSDI), welfare, Medicaid, public health insurance, etc.' )
insert IepTransitionService values( '5E5D881F-2F46-448A-8F08-3AAC2423CDEB', null, 'Transportation: specialized transportation including paratransit.' )
insert IepTransitionService values( '97C0A3E9-6329-4BA2-AC27-9CEE8FB73244', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1', 'Higher Education Support Services: note takers, educational technology, modified testing time, mentoring and guidance, study skills, and self advocacy training.' )

insert IepTransitionAgency values( 'D3E846C8-2801-4C3F-88FA-BF8D5663E33F', null, 'DORS (Department of Rehabilitative Services)' )
insert IepTransitionAgency values( 'ED4F5523-8DC0-465D-AED1-7CEF9826F34B', null, 'DDA (Developmental Disabilities Agency)' )
insert IepTransitionAgency values( '5DFCCD20-996F-4543-8A5B-2B0664BEE334', null, 'MHA (Mental Hygiene Administration)' )

insert EnumType values( 'C8235CD7-001C-45F9-9583-E8C75479870E', 'IEP.PostSchool.ParentsInformed', 0, 0, NULL )
insert EnumValue values( 'A2B683CD-BEA7-4EC8-8BF8-41C1ACBC909E', 'C8235CD7-001C-45F9-9583-E8C75479870E', 'Yes', 'Y', 1, 0 )
insert EnumValue values( '36DB0EF7-2E5A-4A21-BFF7-7087A25EE9BD', 'C8235CD7-001C-45F9-9583-E8C75479870E', 'No', 'Y', 1, 1 )
insert EnumValue values( 'B44F8929-6EDB-44BC-AB85-7D6DC46DFC89', 'C8235CD7-001C-45F9-9583-E8C75479870E', 'N/A', 'Y', 1, 2 )