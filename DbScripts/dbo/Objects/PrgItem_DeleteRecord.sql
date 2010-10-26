if exists (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PrgItem_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItem_DeleteRecord]
GO

/*
<summary>
Deletes a PrgItem record
</summary>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[PrgItem_DeleteRecord]
	@id uniqueidentifier
AS
	-- delete activities
	DECLARE @acts TABLE(seq INT IDENTITY(1,1), id uniqueidentifier)
	INSERT INTO @acts SELECT Id FROM PrgActivity WHERE ItemID = @id
	
	DECLARE @index INT, @count INT, @actId uniqueidentifier
	SELECT @index = 0, @count = COUNT(*) FROM @acts
	WHILE @index < @count
	BEGIN
		SELECT @actId = id FROM @acts WHERE seq = @index + 1
		EXEC PrgActivity_DeleteRecord @actId
		SET @index = @index + 1
	END

	-- delete activity schedules
	DELETE s
	FROM PrgActivitySchedule s
	WHERE s.ItemID = @id

	-- remember the item's involvement
	DECLARE @involvementId UNIQUEIDENTIFIER
	SELECT @involvementId = InvolvementId FROM PrgItem WHERE Id = @id

	DECLARE @oldFiles table(ID uniqueidentifier)

	INSERT @oldFiles
	SELECT
		ContentFileId
	FROM
		PrgDocument
	WHERE
		ItemId = @id AND
		ContentFileId is not null
	
	-- clean up associated documents, first remove reference to doc files, then delete files, cascade deletes may unintentionally delete PrgDocument if FileData was removed
	UPDATE PrgDocument
	SET ContentFileId = null
	WHERE ItemId = @id
	
	DELETE FileData
	WHERE ID in (select ID from @oldFiles)
	
	DELETE d
	FROM PrgDocument d
	WHERE d.ItemId = @id
	
	-- clean up item relationships that were previously satisfied by this item
	--#############################################################################
	declare @itemRels table (
		PrgItemRelID uniqueidentifier,
		IsCrossProgram bit,
		ResultingItemDefID uniqueidentifier,
		TriggerDate datetime )
	
	insert @itemRels
	select
		PrgItemRelID = rel.ID,
		IsCrossProgram = case when iDef.ProgramID = rDef.ProgramID then 1 else 0 end,
		ResultingItemDefID = rDef.ID,
		TriggerDate = case when relDef.TriggerID = '3EAAE600-86AB-4CF8-8866-E7D70BCB0497' then item.EndDate else item.StartDate end
	from
		PrgItemRel rel join
		PrgItemRelDef relDef on rel.PrgItemRelDefID = relDef.ID join
		PrgItemDef iDef on relDef.InitiatingItemDefID = iDef.ID join
		PrgItemDef rDef on relDef.ResultingItemDefID = rDef.ID join	
		PrgItem item on rel.InitiatingItemID = item.ID
	where rel.ResultingItemID = @id

	update r
	set ResultingItemID = (
			select top 1 other.ID
			from
				PrgItem other
			where
				other.ID not in (i.ID, @id) and
				other.DefID = x.ResultingItemDefID and
				other.StudentID = i.StudentID and
				( x.IsCrossProgram = 1 OR other.InvolvementID = i.InvolvementID ) and
				other.StartDate >= x.TriggerDate
			order by other.StartDate
		)
	from
		PrgItemRel r join
		@itemRels x on r.ID = x.PrgItemRelID join
		PrgItem i on r.InitiatingItemID = i.ID
	--#############################################################################

	-- delete the item record
	DELETE FROM PrgItem
	WHERE Id = @id

	-- delete the involvement if it is orphaned
	IF NOT EXISTS(SELECT * FROM PrgItem WHERE InvolvementId = @involvementId)
		DELETE FROM PrgInvolvement WHERE Id = @involvementId
	
GO
