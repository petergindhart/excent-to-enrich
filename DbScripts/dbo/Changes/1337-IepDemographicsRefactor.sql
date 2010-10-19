-- Drop relationships between IepDemographics and IepDistrict/IepSchool
ALTER TABLE dbo.IepDemographics
	DROP CONSTRAINT FK_IepDemographics#ServiceDistrict#
GO
ALTER TABLE dbo.IepDemographics
	DROP CONSTRAINT FK_IepDemographics#HomeDistrict#
GO
ALTER TABLE dbo.IepDemographics
	DROP CONSTRAINT FK_IepDemographics#ServiceSchool#
GO
ALTER TABLE dbo.IepDemographics
	DROP CONSTRAINT FK_IepDemographics#HomeSchool#
GO

UPDATE IepDemographics SET
	HomeDistrictID = null,
	HomeSchoolID = null,
	ServiceDistrictID = null,
	ServiceSchoolID = null

-- move FKs over to OrgUnit and School
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#ServiceDistrict# FOREIGN KEY
	(
	ServiceDistrictID
	) REFERENCES dbo.OrgUnit
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#HomeDistrict# FOREIGN KEY
	(
	HomeDistrictID
	) REFERENCES dbo.OrgUnit
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#ServiceSchool# FOREIGN KEY
	(
	ServiceSchoolID
	) REFERENCES dbo.School
	(
	ID
	)
GO
ALTER TABLE dbo.IepDemographics ADD CONSTRAINT
	FK_IepDemographics#HomeSchool# FOREIGN KEY
	(
	HomeSchoolID
	) REFERENCES dbo.School
	(
	ID
	)
GO

-- add Minutes instruction and migrate data
ALTER TABLE dbo.School ADD
	MinutesInstruction int NULL
GO

UPDATE s SET
	MinutesInstruction = ISNULL(iSch.MinutesInstruction, iDis.MinutesInstruction)
FROM
	School s join
	IepSchool iSch on iSch.ID = s.ID join
	IepDistrict iDis on iSch.DistrictID = iDis.ID
GO

-- cleanup IepDistrict/IepSchool objects

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSchool_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepSchool_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSchool_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepSchool_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSchool_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepSchool_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSchool_GetRecordsByDistrict]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepSchool_GetRecordsByDistrict]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSchool_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepSchool_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepSchool_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepSchool_UpdateRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepDistrict_DeleteRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepDistrict_DeleteRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepDistrict_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepDistrict_GetAllRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepDistrict_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepDistrict_GetRecords]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepDistrict_InsertRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepDistrict_InsertRecord]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepDistrict_UpdateRecord]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[IepDistrict_UpdateRecord]
GO

ALTER TABLE dbo.IepSchool
	DROP CONSTRAINT FK_IepSchool#District#Schools
GO
DROP TABLE dbo.IepDistrict
GO
DROP TABLE dbo.IepSchool
GO
