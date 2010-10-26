IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Student_GetGradeLevel]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[Student_GetGradeLevel]
GO

CREATE FUNCTION Student_GetGradeLevel
(
	@studentID uniqueidentifier,
	@date datetime
)
RETURNS uniqueidentifier
AS
BEGIN
	RETURN
	(
		select top 1 GradeLevelID 
		FROM
			StudentGradeLevelHistory hist
		WHERE
			StudentID = @studentID AND
			dbo.DateInRange(@date, hist.StartDate, hist.EndDate) = 1
	)
END