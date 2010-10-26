SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Test_GetMAPReadingTestsForGraph]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Test_GetMAPReadingTestsForGraph]
GO

/*
<summary>
Gets all MAP Tests for a particular student.
</summary>
<param name="studentID">The student to return tests for.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Test_GetMAPReadingTestsForGraph
	@studentID uniqueidentifier 
AS
/*
DECLARE @studentID uniqueidentifier
SELECT @studentID = '1E481D53-D3CA-49E0-A257-070D1494AA69'
*/

CREATE TABLE #mapScores 
(
	Score varchar(30),
	Third real, 
	Fourth real, 
	Fifth real, 
	Sixth real, 
	Seventh real, 
	Eigth real 
)



INSERT INTO #mapScores (Score) values ('Actual Student Scores')

UPDATE #mapScores SET Third =
	(SELECT TOP 1 ReadingSpringRIT FROM T_MAP_3 WHERE StudentID = @studentID AND ReadingSpringRIT IS NOT NULL )

UPDATE #mapScores SET Fourth =
	(SELECT TOP 1 ReadingSpringRIT FROM T_MAP_4 WHERE StudentID = @studentID AND ReadingSpringRIT IS NOT NULL )

UPDATE #mapScores SET Fifth =
	(SELECT TOP 1 ReadingSpringRIT FROM T_MAP_5 WHERE StudentID = @studentID AND ReadingSpringRIT IS NOT NULL )

UPDATE #mapScores SET Sixth =
	(SELECT TOP 1 ReadingSpringRIT FROM T_MAP_6 WHERE StudentID = @studentID AND ReadingSpringRIT IS NOT NULL )

UPDATE #mapScores SET Seventh =
	(SELECT TOP 1 ReadingSpringRIT FROM T_MAP_7 WHERE StudentID = @studentID AND ReadingSpringRIT IS NOT NULL )

UPDATE #mapScores SET Eigth =
	(SELECT TOP 1 ReadingSpringRIT FROM T_MAP_8 WHERE StudentID = @studentID AND ReadingSpringRIT IS NOT NULL )



SELECT 'Probable Basic' as Score, a.Basic as 'Third', b.Basic as 'Fourth', c.Basic as 'Fifth', d.Basic as 'Sixth', e.Basic as 'Seventh', f.Basic 'Eigth' 
FROM TestScoreProjection a, TestScoreProjection b, TestScoreProjection c, TestScoreProjection d, TestScoreProjection e, TestScoreProjection f 
WHERE a.TestName = 'MAP(3)' AND a.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND b.TestName = 'MAP(4)' AND b.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND c.TestName = 'MAP(5)' AND c.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND d.TestName = 'MAP(6)' AND d.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND e.TestName = 'MAP(7)' AND e.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND f.TestName = 'MAP(8)' AND f.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
UNION 
SELECT * FROM #mapScores 
UNION 
SELECT 'Probable Proficient' as Score, a.Proficient as 'Third', b.Proficient as 'Fourth', c.Proficient as 'Fifth', d.Proficient as 'Sixth', e.Proficient as 'Seventh', f.Proficient 'Eigth'  
FROM TestScoreProjection a, TestScoreProjection b, TestScoreProjection c, TestScoreProjection d, TestScoreProjection e, TestScoreProjection f 
WHERE a.TestName = 'MAP(3)' AND a.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND b.TestName = 'MAP(4)' AND b.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND c.TestName = 'MAP(5)' AND c.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND d.TestName = 'MAP(6)' AND d.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND e.TestName = 'MAP(7)' AND e.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'
AND f.TestName = 'MAP(8)' AND f.TestSectionID = '5A4125C5-18FC-4DF7-B486-06421E185B0C'

DROP TABLE #mapScores


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

