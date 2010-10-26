if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgActivityBatch_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgActivityBatch_DeleteRecord]
GO

/*
<summary>
Deletes a PrgActivityBatch record
</summary>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[PrgActivityBatch_DeleteRecord]
	@id uniqueidentifier
AS
	
	-- delete activities
	DECLARE @acts TABLE(Seq INT IDENTITY(1,1), Id UNIQUEIDENTIFIER)
	INSERT INTO @acts SELECT Id FROM PrgActivity WHERE BatchId = @id
	
	DECLARE @index INT, @count INT, @actId UNIQUEIDENTIFIER
	SELECT @index = 0, @count = COUNT(*) FROM @acts
	WHILE @index < @count
	BEGIN
		SELECT @actId = id FROM @acts WHERE seq = @index + 1
		EXEC PrgActivity_DeleteRecord @actId
		SET @index = @index + 1
	END

	-- delete the batch record
	DELETE FROM 
		PrgActivityBatch
	WHERE
		Id = @id