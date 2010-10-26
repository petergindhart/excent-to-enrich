IF EXISTS (SELECT name
           FROM   sysobjects
           WHERE  name = N'GradeGoal_GetDescription'
           AND    type = 'P')
    DROP PROCEDURE dbo.GradeGoal_GetDescription
GO

/*
<summary>
Retrieve the description text of the curriculum goal for a subject for a
specific gradelevel 
</summary>
<param name="Title">The Title of the Academic Goal</param>
<param name="GradeLevelID">The id of the current gradelevel</param>
<model isGenerated="False" returnType="System.Data.IDataReader"/>
*/
CREATE PROCEDURE dbo.GradeGoal_GetDescription
	@Title varchar(128), 
	@GradeLevelID uniqueidentifier
AS

SELECT 
	gg.Description 
FROM 
	Subject ag 
INNER JOIN
	GradeGoal gg
ON 
	ag.ID = gg.SubjectID
WHERE
	ag.Name = @Title
AND
	gg.GradeLevelID = @GradeLevelID