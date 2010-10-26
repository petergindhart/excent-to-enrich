if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProcessTypeRoleSummary_GetRecordsByRole]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ProcessTypeRoleSummary_GetRecordsByRole]
GO

CREATE PROCEDURE [dbo].[ProcessTypeRoleSummary_GetRecordsByRole]
	@processTypeRoleId uniqueidentifier,
	@schoolId uniqueidentifier
AS

	declare @processTypeId uniqueidentifier
	
	select
		@processTypeId = ptr.ProcessId
	from
		ProcessTypeRole ptr
	where
		ptr.Id = @processTypeRoleId
	
	select
		@processTypeRoleId [Id],
		count(*) [Total],
		sum( case when prup.RoleId is null then 1 else 0 end ) [Unassigned],
		sum( case when prup.RoleId is null then 0 else 1 end ) [Assigned]
	from
		ProcessRole pr join
		GetProcessesBySchool(@processTypeId, @schoolId) p on pr.ProcessId = p.Id left join
		(
			select distinct RoleId
			from ProcessRoleUserProfile
		) prup on prup.RoleId = pr.Id
	where
		pr.TypeId = @processTypeRoleId

GO