SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessTypeSummary_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessTypeSummary_GetRecords]
GO

 /*
<summary>
Gets summary information for a specified
ProcessType and School
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[ProcessTypeSummary_GetRecords]
	@processTypeId uniqueidentifier,
	@schoolId uniqueidentifier
AS
	
	declare
		@totalProcesses int,
		@totalTargets int,
		@totalSteps int,
		@stepsComplete int
	
	-- totalProcesses
	select	@totalProcesses = count(*)
	from 
		dbo.GetProcessesBySchool(@processTypeId, @schoolId)
	
	-- totalTargets
	select	@totalTargets = count(*)
	from
		( 
			select p.TargetId
			from
				dbo.GetProcessesBySchool(@processTypeId, @schoolId) x join
				Process p on p.Id = x.Id
			group by p.TargetId
		) t
	
	-- totalSteps, totalCompleted
	select	@totalSteps = isnull(count(*), 0),
			@stepsComplete = isnull(sum(Completed), 0)
	from
		(
			select
				case when ev.Code = 0 then 1 else 0 end [Completed]
			from
				dbo.GetProcessesBySchool(@processTypeId, @schoolId) bySchool join
				ProcessStep ps on ps.ProcessId = bySchool.Id join
				EnumValue ev on ps.StatusId = ev.Id
			where
				ps.IsNa = 0
		) t
	
	-- RESULTS
	select
		@processTypeId [Id],
		@totalProcesses [TotalProcesses],
		@totalTargets [TotalTargets],
		@totalSteps [TotalSteps],
		@stepsComplete [StepsComplete]

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

