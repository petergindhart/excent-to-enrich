SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IntvToolDef_GetRecordsByStatusAndSubVariants]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IntvToolDef_GetRecordsByStatusAndSubVariants]
GO

 /*
<summary>
Gets records from the IntvToolDef table matching the
specified Status and SubVariants
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.IntvToolDef_GetRecordsByStatusAndSubVariants
	@statusId uniqueidentifier,
	@subVariants uniqueidentifierarray
AS

	select
		t.*
	from
		IntvToolDef t
	where
		t.ID in 
			(
				-- Tools that either AllowCustomSchedule, or have
				-- configured schedule(s) at the specified Status
				select DefinitionID
				from IntvToolDefStatus
				where StatusID = @statusId and AllowCustomSchedules = 1
				union
				select DefinitionID
				from IntvToolDefStatus tt join
					IntvToolSchedule tts on tts.ToolDefStatusID = tt.ID
				where tt.StatusID = @statusId and AllowCustomSchedules = 0
			) and
		t.ID in 
			(
				-- Tools that are associated with at least one
				-- of the specified SubVariants
				select
					t.ToolDefID
				from
					PrgToolDefSubVariant t join
					GetUniqueidentifiers(@subVariants) s on t.SubVariantID = s.ID
				group by t.ToolDefID
			)
		and t.DeletedDate is null
	order by t.Name
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO