CREATE TABLE dbo.ProbeTime
	(
	ID uniqueidentifier NOT NULL,
	ScheduleID uniqueidentifier NULL,
	DateTaken datetime NOT NULL,
	StudentID uniqueidentifier NOT NULL,
	ProbeTypeID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeTime ADD CONSTRAINT
	PK_ProbeTime PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.ProbeRubricType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeRubricType ADD CONSTRAINT
	PK_ProbeRubricType PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.ProbeRubricValue
	(
	ID uniqueidentifier NOT NULL,
	TypeID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	Name varchar(50) NOT NULL,
	Description text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeRubricValue ADD CONSTRAINT
	PK_ProbeRubricValue PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeRubricValue ADD CONSTRAINT
	FK_ProbeRubricValue#RubricType#Values FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.ProbeRubricType
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.ProbeDataType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeDataType ADD CONSTRAINT
	PK_ProbeDataType PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeType ADD
	DataTypeID uniqueidentifier NULL,
	RubricTypeID uniqueidentifier NULL,
	StudentID uniqueidentifier NULL,
	IncreaseIsBetter bit NULL
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	FK_ProbeType#DataType#ProbeTypes FOREIGN KEY
	(
	DataTypeID
	) REFERENCES dbo.ProbeDataType
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	FK_ProbeType#RubricType# FOREIGN KEY
	(
	RubricTypeID
	) REFERENCES dbo.ProbeRubricType
	(
	ID
	)  
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	FK_ProbeType#Student#CustomProbeTypes FOREIGN KEY
	(
	StudentID
	) REFERENCES dbo.Student
	(
	ID
	)  
GO
ALTER TABLE dbo.ProbeScore ADD
	ProbeTimeID uniqueidentifier NULL,
	Sequence int NULL,
	RubricValueID uniqueidentifier NULL,
	NumericValue real NULL,
	FlagValue bit NULL,
	RatioPartValue int NULL,
	RatioOutOfValue int NULL
GO
ALTER TABLE dbo.ProbeScore ADD CONSTRAINT
	FK_ProbeScore#ProbeTime#Scores FOREIGN KEY
	(
	ProbeTimeID
	) REFERENCES dbo.ProbeTime
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeScore ADD CONSTRAINT
	FK_ProbeScore#RubricValue# FOREIGN KEY
	(
	RubricValueID
	) REFERENCES dbo.ProbeRubricValue
	(
	ID
	)  
GO

--##############################################################################
-- remove duplicate scores taken on the same day
DECLARE @scoreConflicts TABLE (
	StudentID UNIQUEIDENTIFIER,
	ProbeTypeID UNIQUEIDENTIFIER,
	DateTaken DATETIME,
	MaxScore REAL,
	MaxScoreID UNIQUEIDENTIFIER )

-- find the duplicates and the max scores
INSERT @scoreConflicts
SELECT StudentId, ProbeTypeID, DateTaken, MAX(Score), NULL
FROM ProbeScore
GROUP BY StudentId, ProbeTypeID, DateTaken
HAVING COUNT(*) > 1

-- resolve any ties for max
UPDATE c
SET MaxScoreID = (
		SELECT MIN(CAST(ID AS VARCHAR(36)))
		FROM ProbeScore
		WHERE	
			StudentID = c.StudentID AND
			ProbeTypeID = c.ProbeTypeID AND
			DateTaken = c.DateTaken AND
			Score = c.MaxScore )
FROM @scoreConflicts c

-- delete the dups
DELETE s
FROM
	ProbeScore s JOIN
	@scoreConflicts c ON
		s.StudentID = c.StudentID AND
		s.ProbeTypeID = c.ProbeTypeID AND
		s.DateTaken = c.DateTaken AND
		s.ID <> c.MaxScoreID
GO

--##############################################################################
-- add ProbeDataType records
INSERT ProbeDataType VALUES ( '9AA64DC0-35A2-459F-967D-1E202B917CE1', 'Numeric' )
INSERT ProbeDataType VALUES ( '97DD0578-26C5-4947-8507-262D00BB71A8', 'Rubric' )
INSERT ProbeDataType VALUES ( '1074B7AE-D0A2-468C-9D3D-DDF4E3210A7B', 'Flag' )
INSERT ProbeDataType VALUES ( '45683CFB-AFF4-4FC1-951A-471E3B9AC880', 'Ratio' )

-- migrate ProbeType
UPDATE ProbeType SET DataTypeID = '9AA64DC0-35A2-459F-967D-1E202B917CE1', IncreaseIsBetter = 1

-- migrate ProbeScore
DECLARE @mapProbeTime TABLE ( ProbeScoreID UNIQUEIDENTIFIER, ProbeTimeID UNIQUEIDENTIFIER )

INSERT @mapProbeTime
SELECT ID [ProbeScoreID], NEWID() [ProbeTimeID] FROM ProbeScore

INSERT ProbeTime
SELECT
	m.ProbeTimeID,
	NULL,
	s.DateTaken,
	s.StudentID,
	s.ProbeTypeID
FROM
	ProbeScore s JOIN
	@mapProbeTime m ON s.ID = m.ProbeScoreID

UPDATE s
SET
	ProbeTimeID = m.ProbeTimeID,
	Sequence = 0,
	NumericValue = s.Score
FROM
	ProbeScore s JOIN
	@mapProbeTime m ON s.ID = m.ProbeScoreID
GO

--##############################################################################
ALTER TABLE dbo.ProbeType
	DROP CONSTRAINT FK_ProbeType#DataType#ProbeTypes
GO
ALTER TABLE dbo.ProbeType
	DROP CONSTRAINT FK_ProbeType#RubricType#
GO
ALTER TABLE dbo.ProbeScore
	DROP CONSTRAINT FK_ProbeScore#RubricValue#
GO
ALTER TABLE dbo.ProbeScore
	DROP CONSTRAINT FK_ProbeScore#Student#
GO
ALTER TABLE dbo.ProbeType
	DROP CONSTRAINT FK_ProbeType#Student#CustomProbeTypes
GO
CREATE TABLE dbo.Tmp_ProbeType
	(
	ID uniqueidentifier NOT NULL,
	Name varchar(40) NOT NULL,
	Description text NULL,
	AdoptionDate datetime NOT NULL,
	DataTypeID uniqueidentifier NOT NULL,
	RubricTypeID uniqueidentifier NULL,
	CustomForStudentID uniqueidentifier NULL,
	IncreaseIsBetter bit NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.ProbeType)
	 EXEC('INSERT INTO dbo.Tmp_ProbeType (ID, Name, Description, AdoptionDate, DataTypeID, RubricTypeID, CustomForStudentID, IncreaseIsBetter)
		SELECT ID, Name, Description, AdoptionDate, DataTypeID, RubricTypeID, StudentID, IncreaseIsBetter FROM dbo.ProbeType WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.PrgProbeTypeSubVariant
	DROP CONSTRAINT FK_ProbeType#SubVariants
GO
ALTER TABLE dbo.ProbeStandard
	DROP CONSTRAINT FK_ProbeStandard#ProbeType#Standards
GO
ALTER TABLE dbo.IntvGoal
	DROP CONSTRAINT FK_IntvGoal#ProbeType#
GO
ALTER TABLE dbo.ProbeScore
	DROP CONSTRAINT FK_ProbeScore#ProbeType#
GO
DROP TABLE dbo.ProbeType
GO
EXECUTE sp_rename N'dbo.Tmp_ProbeType', N'ProbeType', 'OBJECT' 
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	PK_ProbeType PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	FK_ProbeType#DataType#ProbeTypes FOREIGN KEY
	(
	DataTypeID
	) REFERENCES dbo.ProbeDataType
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	FK_ProbeType#RubricType# FOREIGN KEY
	(
	RubricTypeID
	) REFERENCES dbo.ProbeRubricType
	(
	ID
	)  
GO
ALTER TABLE dbo.ProbeType ADD CONSTRAINT
	FK_ProbeType#CustomForStudent#CustomProbeTypes FOREIGN KEY
	(
	CustomForStudentID
	) REFERENCES dbo.Student
	(
	ID
	)  
GO
ALTER TABLE dbo.ProbeScore
	DROP CONSTRAINT FK_ProbeScore#ProbeTime#Scores
GO
ALTER TABLE dbo.ProbeTime ADD CONSTRAINT
	FK_ProbeTime#Student#ProbeTimes FOREIGN KEY
	(
	StudentID
	) REFERENCES dbo.Student
	(
	ID
	)  
GO
ALTER TABLE dbo.ProbeTime ADD CONSTRAINT
	FK_ProbeTime#ProbeType# FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	)  
GO
ALTER TABLE dbo.ProbeScore
	DROP CONSTRAINT FK_ProbeScore#IntvGoal#ProbeScores
GO
ALTER TABLE dbo.IntvGoal ADD CONSTRAINT
	FK_IntvGoal#ProbeType# FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeStandard ADD CONSTRAINT
	FK_ProbeStandard#ProbeType#Standards FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.PrgProbeTypeSubVariant WITH NOCHECK ADD CONSTRAINT
	FK_ProbeType#SubVariants FOREIGN KEY
	(
	ProbeTypeID
	) REFERENCES dbo.ProbeType
	(
	ID
	) ON DELETE  CASCADE 
GO
CREATE TABLE dbo.Tmp_ProbeScore
	(
	ID uniqueidentifier NOT NULL,
	ProbeTimeID uniqueidentifier NOT NULL,
	Sequence int NOT NULL,
	RubricValueID uniqueidentifier NULL,
	NumericValue real NULL,
	FlagValue bit NULL,
	RatioPartValue int NULL,
	RatioOutOfValue int NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.ProbeScore)
	 EXEC('INSERT INTO dbo.Tmp_ProbeScore (ID, ProbeTimeID, Sequence, RubricValueID, NumericValue, FlagValue, RatioPartValue, RatioOutOfValue)
		SELECT ID, ProbeTimeID, Sequence, RubricValueID, NumericValue, FlagValue, RatioPartValue, RatioOutOfValue FROM dbo.ProbeScore WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ProbeScore
GO
EXECUTE sp_rename N'dbo.Tmp_ProbeScore', N'ProbeScore', 'OBJECT' 
GO
ALTER TABLE dbo.ProbeScore ADD CONSTRAINT
	PK_ProbeScore PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ProbeScore ADD CONSTRAINT
	FK_ProbeScore#ProbeTime#Scores FOREIGN KEY
	(
	ProbeTimeID
	) REFERENCES dbo.ProbeTime
	(
	ID
	) ON DELETE  CASCADE 
GO
ALTER TABLE dbo.ProbeScore ADD CONSTRAINT
	FK_ProbeScore#RubricValue# FOREIGN KEY
	(
	RubricValueID
	) REFERENCES dbo.ProbeRubricValue
	(
	ID
	)  
GO

--##############################################################################
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScore_GetRecordsByIntvGoal]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScore_GetRecordsByIntvGoal]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScore_GetRecordsByProbeType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScore_GetRecordsByProbeType]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProbeScore_GetRecordsByStudent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProbeScore_GetRecordsByStudent]
GO

--##############################################################################
-- update IndSource for new schema
UPDATE IndSource
SET SqlText = 
	'SELECT
		[Instance] = g.ID,
		[Date] = t.DateTaken, 
		[EndedDate] = i.EndedDate, 
		[Target] = g.Value, 
		[Score] = s.NumericValue, 
		[Value] = s.NumericValue - 
					(((g.Value - g.BaselineScore) / (CAST(i.PlannedEndDate AS INT) - CAST(g.BaselineDate AS INT))) 
						* (CAST(t.DateTaken AS INT) - CAST(g.BaselineDate AS INT)) 
						+ g.BaselineScore)
	FROM
		IntvGoal g JOIN
		PrgIntervention x ON x.ID = g.InterventionID JOIN 
		PrgItem i ON x.ID = i.ID JOIN
		ProbeType p ON g.ProbeTypeID = p.ID JOIN
		ProbeTime t ON t.ProbeTypeID = p.ID AND t.StudentID = i.StudentID JOIN	
		ProbeScore s ON s.ProbeTimeID = t.ID 
	{filters}'
WHERE ID = 'CEB90D38-4868-4DF6-8548-649CAA8FBA3E'

UPDATE IndParameter
SET ArgumentName = 'g.ID' -- was IntvGoalID
WHERE
	TypeID IN ( SELECT ID FROM IndType WHERE SourceID = 'CEB90D38-4868-4DF6-8548-649CAA8FBA3E' ) AND
	Name = 'Goal'