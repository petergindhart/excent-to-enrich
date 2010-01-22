-- nullable bits not supported
UPDATE ProbeScore SET FlagValue = 0 WHERE FlagValue IS NULL
UPDATE IepGoal SET HasObjectives = 0 WHERE HasObjectives IS NULL
UPDATE IepMeasurableGoal SET FlagTarget = 0 WHERE FlagTarget IS NULL

ALTER TABLE ProbeScore ALTER COLUMN FlagValue BIT NOT NULL
ALTER TABLE IepGoal ALTER COLUMN HasObjectives BIT NOT NULL
ALTER TABLE IepMeasurableGoal ALTER COLUMN FlagTarget BIT NOT NULL

-- use float/not real
ALTER TABLE ProbeScore ALTER COLUMN NumericValue FLOAT NULL
ALTER TABLE IepMeasurableGoal ALTER COLUMN IndTarget FLOAT NULL
ALTER TABLE IepMeasurableGoal ALTER COLUMN NumericTarget FLOAT NULL
ALTER TABLE IepMeasurableGoal ALTER COLUMN RatioPartTarget FLOAT NULL
ALTER TABLE IepMeasurableGoal ALTER COLUMN RatioOutOfTarget FLOAT NULL

-- forgot FK from IepAssessments.ParentsAreInformed
ALTER TABLE dbo.IepAssessments ADD CONSTRAINT
	FK_IepAssessments#ParentsAreInformed# FOREIGN KEY
	(
	ParentsAreInformedID
	) REFERENCES dbo.EnumValue
	(
	ID
	)
GO

-- add IepJustification.IsEnabled
ALTER TABLE dbo.IepJustification
	DROP CONSTRAINT FK_IepJustification#Def#
GO
ALTER TABLE dbo.IepJustification
	DROP CONSTRAINT FK_IepJustification#Instance#Justifications
GO
CREATE TABLE dbo.Tmp_IepJustification
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	Text text NULL,
	IsEnabled bit NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.IepJustification)
	 EXEC('INSERT INTO dbo.Tmp_IepJustification (ID, InstanceID, DefID, Text)
		SELECT ID, InstanceID, DefID, Text FROM dbo.IepJustification WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.IepJustification
GO
EXECUTE sp_rename N'dbo.Tmp_IepJustification', N'IepJustification', 'OBJECT' 
GO
ALTER TABLE dbo.IepJustification ADD CONSTRAINT
	PK_IepJustification PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepJustification ADD CONSTRAINT
	FK_IepJustification#Instance#Justifications FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepAssessments
	(
	ID
	)  
	 ON DELETE  CASCADE 
GO
ALTER TABLE dbo.IepJustification ADD CONSTRAINT
	FK_IepJustification#Def# FOREIGN KEY
	(
	DefID
	) REFERENCES dbo.IepJustificationDef
	(
	ID
	)  
GO

-- Add Cascade to IepEsy->PrgSection
ALTER TABLE dbo.IepEsy
	DROP CONSTRAINT FK_IepEsy_PrgSection
GO
ALTER TABLE dbo.IepEsy ADD CONSTRAINT
	FK_IepEsy_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	) ON DELETE  CASCADE	
GO
