-- cleanup generated procedure for person refactor
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[PrgItemTeamMember_GetRecordsByUserProfile]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgItemTeamMember_GetRecordsByUserProfile]
GO

-- add Min/MaxAge to IepPlacementType
ALTER TABLE dbo.IepPlacementType ADD
	MinAge int NULL,
	MaxAge int NULL
GO

UPDATE IepPlacementType SET MinAge = 6, MaxAge = 21 WHERE ID = 'D9D84E5B-45F9-4C72-8265-51A945CD0049'
UPDATE IepPlacementType SET MinAge = 3, MaxAge = 5 WHERE ID = 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC'
GO

ALTER TABLE dbo.IepPlacementType ALTER COLUMN
	MinAge int NOT NULL
GO
ALTER TABLE dbo.IepPlacementType ALTER COLUMN
	MaxAge int NOT NULL
GO

-- add any missing placements
INSERT IepPlacement
SELECT
	ID = NEWID(),
	InstanceID = lre.ID,
	TypeID = pt.ID,
	OptionID = NULL
FROM
	IepPlacementType pt CROSS JOIN
	IepLeastRestrictiveEnvironment lre LEFT JOIN
	IepPlacement p ON p.InstanceID = lre.ID AND p.TypeID = pt.ID
WHERE p.ID IS NULL
GO

-- add IsEnabled, IsDecOneCount to IepPlacement
ALTER TABLE dbo.IepPlacement ADD
	IsEnabled bit NULL
GO
ALTER TABLE dbo.IepPlacement ADD
	IsDecOneCount bit NULL
GO

-- update new columns
UPDATE p
SET	IsEnabled = CASE WHEN AgeAtStart BETWEEN t.MinAge - 1 AND t.MaxAge THEN 1 ELSE 0 END,
	IsDecOneCount = CASE WHEN AgeAtDecOne BETWEEN t.MinAge AND t.MaxAge THEN 1 ELSE 0 END
FROM
	IepPlacement p JOIN
	IepPlacementType t on p.TypeID = t.ID JOIN
	(
		SELECT
			PlacementID,
			AgeAtStart = DATEPART(YEAR, StartDate) - DATEPART(YEAR, DOB) - CASE
				WHEN DATEPART(MONTH, StartDate) < DATEPART(MONTH, DOB) OR (DATEPART(MONTH, StartDate) = DATEPART(MONTH, DOB) AND DATEPART(DAY, StartDate) < DATEPART(DAY, DOB)) THEN 1
				ELSE 0
				END,
			AgeAtDecOne = DATEPART(YEAR, NextDecOne) - DATEPART(YEAR, DOB) - CASE
				WHEN DATEPART(MONTH, NextDecOne) < DATEPART(MONTH, DOB) OR (DATEPART(MONTH, NextDecOne) = DATEPART(MONTH, DOB) AND DATEPART(DAY, NextDecOne) < DATEPART(DAY, DOB)) THEN 1
				ELSE 0
				END
		FROM
			(
				SELECT
					PlacementID = p.ID,
					i.StartDate,
					NextDecOne = CAST(CAST(CASE WHEN DATEPART(MONTH, i.StartDate) < 12 THEN DATEPART(YEAR, i.StartDate) ELSE DATEPART(YEAR, i.StartDate) + 1 END AS CHAR(10)) + '-12-01' AS DATETIME),
					s.DOB
				FROM
					Student s JOIN
					PrgItem i ON i.StudentID = s.ID JOIN
					PrgSection sec ON sec.ItemID = i.ID JOIN
					IepPlacement p ON p.InstanceID = sec.ID
			) a
	) d on d.PlacementID = p.ID
GO

UPDATE IepPlacement SET IsEnabled = 1 WHERE IsEnabled IS NULL
UPDATE IepPlacement SET IsDecOneCount = 0 WHERE IsDecOneCount IS NULL
GO

ALTER TABLE dbo.IepPlacement ALTER COLUMN
	IsEnabled bit NOT NULL
GO
ALTER TABLE dbo.IepPlacement ALTER COLUMN
	IsDecOneCount bit NOT NULL
GO
