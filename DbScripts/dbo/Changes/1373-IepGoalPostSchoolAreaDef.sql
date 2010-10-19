-- update IepGoal to reference PostSchoolAreaDef instead of PostSchoolArea
ALTER TABLE dbo.IepGoal
	DROP CONSTRAINT FK_IepGoal#PostSchoolArea#AnnualGoals
GO

EXECUTE sp_rename N'dbo.IepGoal.PostSchoolAreaID', N'Tmp_PostSchoolAreaDefID', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.IepGoal.Tmp_PostSchoolAreaDefID', N'PostSchoolAreaDefID', 'COLUMN' 
GO

ALTER TABLE dbo.IepGoal ADD CONSTRAINT
	FK_IepGoal#PostSchoolAreaDef# FOREIGN KEY
	(
	PostSchoolAreaDefID
	) REFERENCES dbo.IepPostSchoolAreaDef
	(
	ID
	)
GO

-- drop no longer needed sp
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IepGoal_GetRecordsByPostSchoolArea]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IepGoal_GetRecordsByPostSchoolArea]
GO

