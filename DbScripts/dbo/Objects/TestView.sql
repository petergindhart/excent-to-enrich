-- =============================================
-- Create view basic template
-- =============================================
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'TestView')
    DROP VIEW dbo.TestView
GO

CREATE VIEW dbo.TestView
AS 
SELECT    dbo.TestDefinition.TableName, dbo.TestSectionDefinition.Name, dbo.TestScoreDefinition.ColumnName, dbo.TestScoreDefinition.Name AS ScoreName, 
                      dbo.TestScoreDefinition.MinValue, dbo.TestScoreDefinition.MaxValue, dbo.TestScoreDefinition.EnumType, 
                      dbo.TestScoreDefinition.Sequence AS ScoreSequence
FROM         dbo.TestDefinition INNER JOIN
                      dbo.TestSectionDefinition ON dbo.TestDefinition.ID = dbo.TestSectionDefinition.TestDefinitionID RIGHT OUTER JOIN
                      dbo.TestScoreDefinition ON dbo.TestSectionDefinition.ID = dbo.TestScoreDefinition.TestSectionDefinitionID

GO

