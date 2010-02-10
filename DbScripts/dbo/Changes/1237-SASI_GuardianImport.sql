IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sasi_aprn_local]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[sasi_aprn_local]
GO

CREATE TABLE [dbo].[SASI_APRN_LOCAL](
	[STATUS] [char](1) NOT NULL,
	[SCHOOLNUM] [varchar](3) NOT NULL,
	[STULINK] [numeric](18, 0) NOT NULL,
	[SEQUENCE] [numeric](18, 0) NOT NULL,
	[COMMENTS] [text] NULL,
	[RELATION] [varchar](2) NOT NULL,
	[SOCSECNUM] [varchar](10) NOT NULL,
	[LASTNAME] [varchar](20) NOT NULL,
	[FIRSTNAME] [varchar](20) NOT NULL,
	[MIDDLENAME] [varchar](13) NOT NULL,
	[SALUTATION] [varchar](4) NOT NULL,
	[BIRTHPLACE] [varchar](20) NOT NULL,
	[ADDRESS] [varchar](35) NOT NULL,
	[CITY] [varchar](24) NOT NULL,
	[STATE] [varchar](2) NOT NULL,
	[ZIPCODE] [varchar](10) NOT NULL,
	[TELEPHONE] [numeric](15, 0) NULL,
	[ALTTEL] [numeric](15, 0) NULL,
	[ALTTELEXTN] [varchar](4) NOT NULL,
	[OCCUPATION] [varchar](30) NOT NULL,
	[EMPLOYER] [varchar](40) NOT NULL,
	[WRKADDR] [varchar](35) NOT NULL,
	[WRKCITY] [varchar](24) NOT NULL,
	[WRKSTATE] [varchar](2) NOT NULL,
	[WRKZIP] [varchar](10) NOT NULL,
	[WRKTEL] [numeric](15, 0) NULL,
	[WRKEXTN] [varchar](4) NOT NULL,
	[WRKHRSFMOM] [numeric](4, 0) NULL,
	[WRKHRSTO] [numeric](4, 0) NULL,
	[EXTRAMAIL] [char](1) NOT NULL,
	[USCITIZEN] [char](1) NOT NULL,
	[PL874_MIL] [char](1) NOT NULL,
	[CONTACT_NA] [char](1) NOT NULL,
	[RESIDES] [char](1) NOT NULL,
	[RESP] [char](1) NOT NULL,
	[EDULEVEL] [varchar](2) NOT NULL,
	[USRCODE1] [varchar](2) NOT NULL,
	[USRCODE2] [varchar](2) NOT NULL,
	[USRCODE3] [varchar](2) NOT NULL,
	[USRCODE4] [varchar](2) NOT NULL,
	[USRCODE5] [varchar](2) NOT NULL,
	[GENDER] [char](1) NOT NULL,
	[LIFESTFTHR] [char](1) NOT NULL,
	[LIFESTMTHR] [char](1) NOT NULL,
	[PRNRTSMALE] [char](1) NOT NULL,
	[PRNRTSFEM] [char](1) NOT NULL,
	[COUNTRY] [varchar](30) NOT NULL,
	[PROVINCE] [varchar](30) NOT NULL,
	[EMAILADDR] [varchar](60) NOT NULL,
	[USERSTAMP] [varchar](10) NOT NULL,
	[DATESTAMP] [datetime] NULL,
	[TIMESTAMP] [numeric](6, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE VIEW [SASI_APRN]
AS
SELECT * FROM [SASI_APRN_LOCAL]
GO

INSERT VC3ETL.ExtractTable VALUES ('76E12D98-93EC-4D3A-9C06-4007CED744D1', '91BED6CC-69D6-4D4E-AAFA-D23E58934369','APRN','dbo','SASI_APRN','STULINK, SEQUENCE, SCHOOLNUM',NULL,0,0,'Len(IsNull(STATUS, '''''')) = 0',1,0,NULL)
INSERT VC3ETL.PearsonExtractTable VALUES ('76E12D98-93EC-4D3A-9C06-4007CED744D1', 1,'SchoolNum')

GO
CREATE TABLE [dbo].[SASI_Map_StudentGuardianRelationshipID](
	[Code] [char](8) NOT NULL,
	[DestID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SASI_Map_StudentGuardianRelationshipID] PRIMARY KEY CLUSTERED 
(
	[DestID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

UPDATE VC3ETL.LoadTable
SET Sequence = Sequence + 3
WHERE Sequence >= 32

INSERT INTO VC3ETL.LoadTable VALUES ('3CE36BB8-3F4C-4700-AF3E-7F436589B10A','91BED6CC-69D6-4D4E-AAFA-D23E58934369', 32, 'Sasi_Transform_StudentGuardianRelationship','StudentGuardianRelationship',1, 'SASI_Map_StudentGuardianRelationshipID', 'Code','DestID',1,1,0,1,1,NULL,NULL,NULL,0,0,NULL)

INSERT INTO VC3ETL.LoadColumn VALUES ('9AF579EB-47D9-4847-8E09-973E3A8B5F94' , '3CE36BB8-3F4C-4700-AF3E-7F436589B10A','DestID','ID','K',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('5C792EEE-78D0-4B68-9580-4AEA8BE9C0F8' , '3CE36BB8-3F4C-4700-AF3E-7F436589B10A','Name','Name','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('63D0E3F1-8E47-462E-BEF4-1D96D1601CA2' , '3CE36BB8-3F4C-4700-AF3E-7F436589B10A','Description','Description','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('0AE974AD-E7D3-4FCB-8682-6E6D5EB73FDB' , '3CE36BB8-3F4C-4700-AF3E-7F436589B10A','DeletedDate','DeletedDate','C',1,'@importDate',NULL)

INSERT INTO VC3ETL.LoadTable VALUES ('F3D021BA-690E-4512-9CA5-4CDCA0423889','91BED6CC-69D6-4D4E-AAFA-D23E58934369', 33, 'Sasi_Transform_Person','Person',1, 'SASI_Map_PersonID', 'Schoolnum, Stulink, Sequence','DestID',1,1,1,1,1,NULL,NULL,NULL,0,0,NULL)

INSERT INTO VC3ETL.LoadColumn VALUES ('02E2B250-1634-418C-B838-2B9155965BCC', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'DestID','ID','K',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('56A770D4-B06C-4A16-80FD-63C27B005424', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'TypeID','TypeID','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('C84325B5-D7CB-44F1-9D00-9A64E7F2A976', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'FirstName','FirstName','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('D62F9150-C025-4565-BD23-856D6D312E94', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'LastName','LastName','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('56830F59-DF3C-4283-A851-133D57BEE587', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'EmailAddr','EmailAddress','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('878785DF-4187-41F6-847B-92118699999F', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'ADDRESS','Street','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('078331C6-D74D-4C69-8332-5CC0E068413C', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'City','City','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('C875518C-4908-42C9-877B-8C2719270630', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'ZipCode','Zip','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('572BDE00-5CB5-42FD-B034-4CE494687F20', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'State','State','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('26EB60FA-0EEF-4773-BE52-25F9A2918F0B', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'Telephone','HomePhone','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('FB512285-735A-49C4-927F-595266590537', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'Wrktel','WorkPhone','C',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('A7055969-D6E7-4C12-962C-DFF60D644BE2', 'F3D021BA-690E-4512-9CA5-4CDCA0423889', 'Alttel','CellPhone','C',0,NULL,NULL)

INSERT INTO VC3ETL.LoadTable VALUES ('D079B2F1-6441-411D-862C-4471154B4F87','91BED6CC-69D6-4D4E-AAFA-D23E58934369', 34, 'Sasi_Transform_StudentGuardian','StudentGuardian',1,'SASI_Map_StudentGuardianID', 'StudentID, PersonID','DestID',1,0,1,1,1,NULL,NULL,NULL,0,0,NULL)

INSERT INTO VC3ETL.LoadColumn VALUES ('8AD6CBEA-161E-4713-9766-A88ABE22ACEF', 'D079B2F1-6441-411D-862C-4471154B4F87', 'DestID','ID','K',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('ABDC8033-935E-44BE-99E0-8BEFF6B05856', 'D079B2F1-6441-411D-862C-4471154B4F87', 'StudentID','StudentID','I',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('0B0FE26A-4154-4BD9-BFB1-9FAE7555C2F2', 'D079B2F1-6441-411D-862C-4471154B4F87', 'PersonID','PersonID','I',0,NULL,NULL)
INSERT INTO VC3ETL.LoadColumn VALUES ('9F3FBCB6-0122-44BA-9EE5-9067241C8A82', 'D079B2F1-6441-411D-862C-4471154B4F87', 'RelationshipID','RelationshipID','C',0,NULL,NULL)
--INSERT INTO VC3ETL.LoadColumn VALUES ('532F2BCB-6A10-4B23-BE7F-A44895C7137E', 'D079B2F1-6441-411D-862C-4471154B4F87', '0','Sequence','I',0,NULL,NULL)
--INSERT INTO VC3ETL.LoadColumn VALUES ('B5EF90D0-C7ED-4C0A-9BC3-5A3D14CD6E27', 'D079B2F1-6441-411D-862C-4471154B4F87', '(null)','DeletedDate','E',1,'@importDate',NULL)