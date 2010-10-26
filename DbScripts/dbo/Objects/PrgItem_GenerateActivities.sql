if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivityBatch_GenerateActivities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivityBatch_GenerateActivities]
GO

/*
<summary>
Generates activities for all active plans
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgActivityBatch_GenerateActivities]
	@programId UNIQUEIDENTIFIER,
	@itemDefId UNIQUEIDENTIFIER,
	@activityDefId UNIQUEIDENTIFIER,
	@activityReasonId UNIQUEIDENTIFIER,
	@doNotDuplicate BIT,
	@comment TEXT,
	@userProfileId UNIQUEIDENTIFIER
AS
	DECLARE @now DATETIME
	SET @now = GETDATE()

	DECLARE @items TABLE(ID UNIQUEIDENTIFIER, ParentId UNIQUEIDENTIFIER, StudentId UNIQUEIDENTIFIER, SchoolId UNIQUEIDENTIFIER, GradeLevelId UNIQUEIDENTIFIER, InvolvementId UNIQUEIDENTIFIER)
	INSERT INTO @items
	SELECT NEWID(), 
		p.Id, 
		p.StudentId, 
		p.SchoolID,
		p.GradeLevelId,
		p.InvolvementId
	FROM PrgItem p JOIN 
		PrgItemDef d ON d.Id = p.DefId LEFT OUTER JOIN 
		(
			SELECT i.Id, ParentId = a.ItemId
			FROM PrgItem i JOIN 
				PrgActivity a ON a.id = i.id
			WHERE DefId = @activityDefId AND 
				ItemOutcomeId IS NULL
		) a ON a.ParentId = p.Id
	WHERE d.ProgramId = @programId AND d.Id = @itemDefId AND p.ItemOutcomeId IS NULL
	GROUP BY p.Id, p.StudentId, p.SchoolID, p.GradeLevelId, p.InvolvementId
	-- conditionally require that an open action of the same type does not already exist
	HAVING @doNotDuplicate = 0 OR COUNT(CAST(a.Id as VARCHAR(40))) = 0

	DECLARE @batchId UNIQUEIDENTIFIER
	SET @batchId = NEWID()

	-- create batch
	INSERT INTO PrgActivityBatch (ID, ProgramId, CreatedBy, CreatedDate, DefId, ReasonId)
	SELECT @batchId, @programId, @userProfileId, @now, @activityDefId, @activityReasonId

	-- create item
	INSERT INTO PrgItem (Id, DefId, StudentId, StartDate, CreatedDate, CreatedBy, InvolvementId, SchoolId, GradeLevelId)
	SELECT ID, @activityDefId, StudentId, @now, @now, @userProfileId, InvolvementId, SchoolID, GradeLevelId
	FROM @items

	-- create matching activity
	INSERT INTO PrgActivity (Id, ReasonId, ItemId, BatchId)
	SELECT ID, @activityReasonId, ParentId, @batchId
	FROM @items
	
	-- write a comment if it was provided
	IF @comment IS NOT NULL AND LEN(RTRIM(LTRIM(CAST(@comment AS VARCHAR(8000))))) > 0
		INSERT INTO PrgItemComment (ID, ItemId, UserProfileId, [Date], [Text])
		SELECT NEWID(), ID, @userProfileId, @now, @comment
		FROM @items

	SELECT * FROM PrgActivityBatch WHERE Id = @batchId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
exec [PrgActivityBatch_GenerateActivities] 
	'D3AB11A2-96C0-4BA5-914A-C250EDDEA995', --program
	'93D319FB-091D-4B67-8FB9-34805C6F1187', --itemdef
	'50BDE13A-EC59-4A45-9AD9-7205209EE256',--activitydef
	'BFAFFC6B-2D1F-4133-9B5F-E886E1E753A6',--reason
	1,--do not duplicate
	NULL,--comment
	'EEE133BD-C557-47E1-AB67-EE413DD3D1AB'--user profile
*/