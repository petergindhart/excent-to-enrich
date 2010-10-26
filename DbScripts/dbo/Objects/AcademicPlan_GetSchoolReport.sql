SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_GetSchoolReport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlan_GetSchoolReport]
GO

/*
<summary>
Gets all Schools and counts their Academic Plans for each Roster Year that plans exist.
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AcademicPlan_GetSchoolReport 
AS

DECLARE @caseStr as varchar(1200)
DECLARE @roster as int
DECLARE @rosterStr as varchar(25)
DECLARE @rosterYearID as varchar(40) 

DECLARE auRosterCursor CURSOR OPTIMISTIC FOR 
	SELECT DISTINCT CAST(RosterYear.[ID] AS VARCHAR(40)), StartYear 
		FROM RosterYear INNER JOIN AcademicPlan 
			ON RosterYear.[ID] = AcademicPlan.RosterYearID 
	ORDER BY StartYear DESC

SELECT @caseStr = ''

OPEN auRosterCursor
FETCH NEXT FROM auRosterCursor INTO @rosterYearID, @roster

WHILE (@@FETCH_STATUS = 0)
BEGIN
	SELECT @rosterStr = CAST(@roster as varchar(4)) + '-' + CAST(@roster+1 as varchar(4))
	IF (LEN(@caseStr) = 0)
	BEGIN
--		SELECT @caseStr = 'SUM( CASE AcademicPlan.RosterYear WHEN ''ID'' THEN 1 ELSE 0 END ) AS ''String'', '
		SELECT @caseStr = 'SUM( CASE AcademicPlan.RosterYearID WHEN ''' + @rosterYearID + ''' THEN 1 ELSE 0 END ) AS ''' + @rosterStr + ''', '
	END
	ELSE
	BEGIN
--		SELECT @caseStr = @caseStr + 'SUM( CASE AcademicPlan.RosterYear WHEN ''ID'' THEN 1 ELSE 0 END ) AS ''String'', '
		SELECT @caseStr = @caseStr + 'SUM( CASE AcademicPlan.RosterYearID WHEN ''' + @rosterYearID + ''' THEN 1 ELSE 0 END ) AS ''' + @rosterStr + ''', '
	END

	FETCH NEXT FROM auRosterCursor INTO @rosterYearID, @roster
END

CLOSE auRosterCursor
DEALLOCATE auRosterCursor

IF (LEN(@caseStr) > 0)
BEGIN
	/* Truncate the trailing comma off the string */
	SELECT @caseStr = SUBSTRING(@caseStr, 1, LEN(@caseStr) - 1 )

	exec(N'SELECT School.[Name] As School, ' + @caseStr + ' FROM AcademicPlan INNER JOIN School ON AcademicPlan.SchoolID = School.[ID] GROUP BY School.[Name]')
END

GO