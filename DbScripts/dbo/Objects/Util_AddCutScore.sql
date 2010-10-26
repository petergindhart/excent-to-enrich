if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Util_AddCutScore]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Util_AddCutScore]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Inserts a new record into the TestScoreDefinition table with the specified values
</summary>
<param name="TestGoalTypeId"></param>
<param name="TestGoalTypeTypeId">reference to enum determining cut score, capr, or calcd score</param>
<param name="TypeName"></param>
<param name="TestGoalId"></param>
<param name="GoalName"></param>
<param name="TestScoreGoalId"></param>
<param name="TestScoreDefId"></param>
<param name="TestScoreGoalValueId"></param>
<param name="StartDate"></param>
<param name="EndDate"></param>
<param name="GradeLevelId"></param>
<model isGenerated="False" />
*/
 CREATE PROCEDURE [dbo].[Util_AddCutScore]
	@TestGoalTypeId			uniqueidentifier,
	@TestGoalTypeTypeId		uniqueidentifier,
	@TypeName 				varchar(50), 
	@TestDefinitionId		uniqueidentifier,
	@TestGoalId 			uniqueidentifier, 
	@GoalName				varchar(50), 
	@TestScoreGoalId		uniqueidentifier, 
	@TestScoreDefId			uniqueidentifier, 
	@StartDate				datetime,
	@EndDate				datetime,
	@TestScoreGoalValueId	uniqueidentifier, 
	@GradeLevelId			uniqueidentifier,
	@Value					int
AS

--Insert TestGoalType if needed
if @TestGoalTypeId is not null and not exists (select * from TestGoalType where id = @TestGoalTypeId) begin
	insert into TestGoalType (id, Name, TestDefinitionId, TypeId) values (@TestGoalTypeId, @TypeName, @TestDefinitionId, @TestGoalTypeTypeId)
end

--Insert TestGoal if Needed
if @TestGoalId is not null and not exists (select * from TestGoal where id=@TestGoalId) begin
	insert into TestGoal (id, name, typeid) values (@TestGoalId, @GoalName, @TestGoalTypeId)
end

--Insert TestScoreGoal if Needed
if not exists (select * from TestScoreGoal where id=@TestScoreGoalId) begin
	insert into TestScoreGoal (id, TestGoalId, TestScoreDefinitionId, StartDate, EndDate) values 
	(@TestScoreGoalId, @TestGoalId, @TestScoreDefId, @StartDate, @EndDate)
end

--Insert TestScoreGoalValue
insert into TestScoreGoalValue (Id, TestScoreGoalId, GradeLevelId, Value) values
(@TestScoreGoalValueId, @TestScoreGoalId, @GradeLevelId, @Value)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
