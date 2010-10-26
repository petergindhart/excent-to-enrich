SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Returns a calculated score value
</summary>
*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetCalculatedTestScoreValue]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetCalculatedTestScoreValue]
GO

CREATE FUNCTION dbo.GetCalculatedTestScoreValue (
	@testGoalId uniqueidentifier,
	@testScoreDefinitionId uniqueidentifier,
	@gradeLevelId uniqueidentifier,
	@adminId uniqueidentifier,
	@dateTaken datetime,
	@inputScore real
)

RETURNS REAL
AS
BEGIN

	--################################################################################
	--	Return the value of the closest matching TestScoreGoalValue record
	--	having InputScore <= @inputScore
	--################################################################################
	return
	(
		select top 1 v.Value
		from
			TestScoreGoal g join
			TestScoreGoalValue v on v.TestScoreGoalID = g.ID
		where
			g.TestGoalID = @testGoalId and
			g.TestScoreDefinitionID = @testScoreDefinitionId and
			dbo.DateInRange(@dateTaken, g.StartDate, g.EndDate) = 1 and
			v.TestAdministrationTypeID1 = (select TypeID from TestAdministration where ID = @adminId) and
			(
				v.GradeLevelID is null or
				v.GradeLevelID = @gradeLevelId
			) and
			v.InputScore <= @inputScore
		order by v.InputScore desc
	)

END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
