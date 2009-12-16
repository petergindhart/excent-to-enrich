CREATE TABLE dbo.IepDistrict
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL,
	IsCustom bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDistrict ADD CONSTRAINT
	PK_IepDistrict PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepSchool
	(
	ID uniqueidentifier NOT NULL,
	DistrictID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepSchool ADD CONSTRAINT
	PK_IepSchool PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.IepSchool ADD CONSTRAINT
	FK_IepSchool#District#Schools FOREIGN KEY
	(
	DistrictID
	) REFERENCES dbo.IepDistrict
	(
	ID
	) ON DELETE CASCADE
GO
CREATE TABLE dbo.IepLanguage
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepLanguage ADD CONSTRAINT
	PK_IepLanguage PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
CREATE TABLE dbo.IepDemographics
	(
	ID uniqueidentifier NOT NULL,
	PrimaryLanguageID uniqueidentifier NULL,
	PrimaryLanguageHomeID uniqueidentifier NULL,
	ServiceDistrictID uniqueidentifier NULL,
	ServiceSchoolID uniqueidentifier NULL,
	HomeDistrictID uniqueidentifier NULL,
	HomeSchoolID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	PK_IepDemographics PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE CASCADE
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#PrimaryLanguage# FOREIGN KEY
	(
	PrimaryLanguageID
	) REFERENCES dbo.IepLanguage
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#PrimaryLanguageHome# FOREIGN KEY
	(
	PrimaryLanguageHomeID
	) REFERENCES dbo.IepLanguage
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#ServiceDistrict# FOREIGN KEY
	(
	ServiceDistrictID
	) REFERENCES dbo.IepDistrict
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#ServiceSchool# FOREIGN KEY
	(
	ServiceSchoolID
	) REFERENCES dbo.IepSchool
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#HomeDistrict# FOREIGN KEY
	(
	HomeDistrictID
	) REFERENCES dbo.IepDistrict
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#HomeSchool# FOREIGN KEY
	(
	HomeSchoolID
	) REFERENCES dbo.IepSchool
	(
	ID
	)
GO
CREATE TABLE dbo.IepParent
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	GuardianStudentID uniqueidentifier NULL,
	RelationshipID uniqueidentifier NULL,
	FirstName varchar(50) NOT NULL,
	MiddleName varchar(50) NULL,
	LastName varchar(50) NOT NULL,
	Address varchar(50) NULL,
	City varchar(50) NULL,
	State varchar(2) NULL,
	Email varchar(50) NULL,
	HomePhone varchar(50) NULL,
	CellPhone varchar(50) NULL,
	Employer varchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepParent ADD CONSTRAINT
	PK_IepParent PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]

GO
ALTER TABLE dbo.IepParent ADD CONSTRAINT
	FK_IepParent#Instance#Parents FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepDemographics
	(
	ID
	) ON DELETE CASCADE
GO


insert PrgSectionType values ( 'F2A1374B-46D6-4E25-9733-D7F3256369ED', 'IEP Demographics', 'iepdemo', 'Demographics', null, null, null, '~/SpecEd/SectionDemographics.ascx' )
insert PrgSectionDef values ( 'C26636EE-5939-45C7-A43A-D1D18049B9BD', 'F2A1374B-46D6-4E25-9733-D7F3256369ED', '251DA756-A67A-453C-A676-3B88C1B9340C', 0, 1, null, null, null, null, null )



-- insert IepLanguage (taken from ELDA_Language enum)
insert IepLanguage values('2A5C794B-E6D7-41E7-B108-7BA958AEC9B3', 'Arabic')
insert IepLanguage values('CEFDB71B-B2B4-4237-B8C7-F8867AE95BC7', 'Bosnian')
insert IepLanguage values('C1642F50-CE34-43DF-8B8E-2194DA5D9568', 'Cambodian')
insert IepLanguage values('B8BBA96D-5C89-4B3A-82D6-5C3A8728F38A', 'Cantonese')
insert IepLanguage values('29157D21-6806-44AD-BFD7-A630D90C41DD', 'Chinese')
insert IepLanguage values('CB6C94CC-58C5-4783-AC94-C9E142E8D11E', 'English')
insert IepLanguage values('E6120773-AFB1-49B7-BBCB-F2BFDF7DEB4E', 'Farsi')
insert IepLanguage values('A868C257-50E7-4710-BA5C-6C7750122825', 'French')
insert IepLanguage values('F4434E96-8736-4ACB-B951-64F551A9AD4A', 'German')
insert IepLanguage values('AFCF8654-2635-4C44-86D5-9EDB82BF87C3', 'Gujarati')
insert IepLanguage values('FB049693-5270-4F81-8205-A342F8DB3445', 'Hindi')
insert IepLanguage values('C127E97E-E675-4F2F-BA0C-14408A2897A0', 'Hmong')
insert IepLanguage values('307D1D0B-525D-4D44-AD07-FBC0398B1451', 'Japanese')
insert IepLanguage values('5C879E06-C465-4CD7-870D-7EB47B898255', 'Korean')
insert IepLanguage values('BCD22641-26B3-4152-ADCC-12B862FFC8F5', 'Kurdish')
insert IepLanguage values('34F89C96-DFF0-4B93-A377-B3615CC3DAB8', 'Laothian')
insert IepLanguage values('A6312123-BD5D-4A1E-A5D6-6AA9D78524FD', 'Mandarin')
insert IepLanguage values('7B5F3DCC-AA14-45CA-ABBA-FB9C5F68EF60', 'Nuer')
insert IepLanguage values('165E54E8-C981-48CA-878D-12FB24DA986F', 'Other')
insert IepLanguage values('779CF742-88ED-4125-A7A4-1474BE0E1980', 'Portuguese')
insert IepLanguage values('919AE2F2-557B-4023-912B-7CC3E17FE57C', 'Russian')
insert IepLanguage values('C811CB2B-1601-4693-B6F9-136A02A78183', 'Somali')
insert IepLanguage values('CF807A04-CCAD-4BBA-A4D2-7D3A9C6834A9', 'Spanish')
insert IepLanguage values('9FB27C44-3142-47F0-8CB2-A5BADF41AACF', 'Tagalog')
insert IepLanguage values('500EEDEE-F162-4A58-9935-E5CDC30F32B1', 'Ukrainian')
insert IepLanguage values('3D1F5AC2-217F-4B2D-8361-4DBA0A1BD774', 'Unknown')
insert IepLanguage values('2FFE8C3E-678F-46E5-8FEF-E299EF7A3EEB', 'Urdu')
insert IepLanguage values('8CF9AA84-CCDF-4714-9DDC-D6451ECC1C29', 'Vietnamese')

-- insert IepDistrict, IepSchool 
-- (need to figure this out)######################
insert IepDistrict
select '2A54E70F-9673-4DE7-BCAC-2C100D68DFBE', DistrictName, 0 from SystemSettings

insert IepSchool
select ID, '2A54E70F-9673-4DE7-BCAC-2C100D68DFBE', Name from School order by Name