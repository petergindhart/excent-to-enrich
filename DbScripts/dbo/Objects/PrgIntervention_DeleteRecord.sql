SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgIntervention_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgIntervention_DeleteRecord]
GO

 /*
<summary>
Deletes a PrgIntervention record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[PrgIntervention_DeleteRecord]
	@id uniqueidentifier
AS
	-- delete activities via child tools
	declare @actId uniqueidentifier
	declare actCursor cursor for
		select a.ID
		from PrgActivity a join IntvTool t on a.ParentToolID = t.ID
		where t.InterventionID = @id
	
	open actCursor
	fetch next from actCursor into @actId
	while @@FETCH_STATUS = 0
	begin
		exec PrgActivity_DeleteRecord @actId
		fetch next from actCursor into @actId
	end
	close actCursor
	deallocate actCursor

	-- delete activity schedules via child tools
	delete s
	from PrgActivitySchedule s join
		IntvTool t on s.ToolID = t.ID
	where t.InterventionID = @id

	-- delete intervention sub-variants
	delete isv
	from PrgInterventionSubVariant isv
	where isv.InterventionID = @id


	-- delete the intervention record
	DELETE FROM PrgIntervention
	WHERE Id = @id

	-- call the base item delete stored procedure
	EXEC PrgItem_DeleteRecord @id

GO