IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.DisabilityCode') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.DisabilityCode
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.DisabilityCode_LOCAL') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.DisabilityCode_LOCAL
GO

CREATE TABLE AURORAX.DisabilityCode_LOCAL (
	DisabilityCode nvarchar(10) NOT NULL,
	DisabilityDesc nvarchar(100) NULL
)
GO

CREATE VIEW AURORAX.DisabilityCode
AS
	SELECT * FROM AURORAX.DisabilityCode_LOCAL
GO

-- #############################################################################
-- Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepDisabilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_IepDisabilityID
GO
CREATE TABLE AURORAX.MAP_IepDisabilityID
	(
	DisabilityCode nvarchar(10) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 
GO
ALTER TABLE AURORAX.MAP_IepDisabilityID ADD CONSTRAINT
	PK_MAP_IepDisabilityID PRIMARY KEY CLUSTERED
	(
	DisabilityCode
	) 
GO

set nocount on;
-- populate the map table
insert AURORAX.MAP_IepDisabilityID values ('01', '8D0AA58F-597A-462F-B509-BB8F0B2AB593')
insert AURORAX.MAP_IepDisabilityID values ('03', 'A1504419-19F6-434B-B4A3-1E5A69E99A9B')
insert AURORAX.MAP_IepDisabilityID values ('04', '0E026822-6B22-43A1-BD6E-C1412E3A6FA3')
insert AURORAX.MAP_IepDisabilityID values ('05', '79450790-72A4-4F16-8840-6193DB199A1E')
insert AURORAX.MAP_IepDisabilityID values ('06', 'D31E4ED0-9A37-490F-B49B-FF18133644FE')
insert AURORAX.MAP_IepDisabilityID values ('07', '07093979-0C3F-414D-9750-8080C6BB7C45')
insert AURORAX.MAP_IepDisabilityID values ('08', '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09')
insert AURORAX.MAP_IepDisabilityID values ('10', 'CA41A561-16BE-4E21-BE8A-BC59ED86C921')
insert AURORAX.MAP_IepDisabilityID values ('11', 'B0439371-3A5E-4FD7-912E-0C3AA4963C26')
insert AURORAX.MAP_IepDisabilityID values ('13', '8D9B3B54-4080-4D5E-A196-956D5223E479')
insert AURORAX.MAP_IepDisabilityID values ('14', 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3')
-- (note:  at time of this coding, the following records did not have a corresponding row in IepDisability:
insert AURORAX.MAP_IepDisabilityID values ('09', 'CAFC7172-946C-4B6B-BC5E-2FC67F215C8D')
insert AURORAX.MAP_IepDisabilityID values ('12', '36B1ED81-4230-480C-BFCA-E17CFDEBB70D')
insert AURORAX.MAP_IepDisabilityID values ('15', 'E569D304-377A-4E82-8261-D7046B8DC294')
insert AURORAX.MAP_IepDisabilityID values ('16', '8AFF29C4-A480-4AE2-BBDC-DDE429FFEB03')
go

set nocount off;

-- the following records were added to the data conversion testing database, but at time of this writing not on the CO-template instance
--insert IepDisability (ID, Name, Definition) values ('CAFC7172-946C-4B6B-BC5E-2FC67F215C8D', 'Deaf-Blind', '<div></div>')
--insert IepDisability (ID, Name, Definition) values ('36B1ED81-4230-480C-BFCA-E17CFDEBB70D', 'Infant/Toddler with a Disability', '<div></div>')
--insert IepDisability (ID, Name, Definition) values ('E569D304-377A-4E82-8261-D7046B8DC294', 'Disability 15', '<div></div>')
--insert IepDisability (ID, Name, Definition) values ('8AFF29C4-A480-4AE2-BBDC-DDE429FFEB03', 'Disability 16', '<div></div>')
