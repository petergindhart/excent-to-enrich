IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TestGoalType_IsGradeValid]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TestGoalType_IsGradeValid]
GO

CREATE PROCEDURE [dbo].[TestGoalType_IsGradeValid]
	@testGoalType	uniqueidentifier,
	@gradelevel		uniqueidentifier
AS


select 
	case when  (select Sequence from gradelevel gl1 where gl1.id = @gradelevel) >= MIN(gl.Sequence) AND 
		(select Sequence from gradelevel gl2 where gl2.id = @gradelevel) <= MAX(gl.Sequence) then cast(1 as bit)
		else cast(0 as bit) end 
From 
	TestGoalType type join
	TestGoal tg on type.ID = tg.TypeID join
	TestScoreGoal tsg on tsg.TestGoalID = tg.ID join
	TestScoreGoalValue tsgv on tsgv.TestScoreGoalID = tsg.ID join
	GradeLEvel gl on gl.ID = tsgv.GradeLevelID	
where 
	type.id = @testGoalType