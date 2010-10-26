if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityTaskCategory_DeleteRecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SecurityTaskCategory_DeleteRecord]
GO

 /*
<summary>
Deletes a SecurityTaskCategory record
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE [dbo].[SecurityTaskCategory_DeleteRecord] 
	@id uniqueidentifier
AS
	CREATE TABLE #itemsToDelete
	(
		ID uniqueidentifier, 
		Depth int
	)
	
	DECLARE @depth int
	SET @depth = 1
	
	INSERT INTO #itemsToDelete
	SELECT ID, @depth
	FROM SecurityTaskCategory
	WHERE ID = @id
	
	WHILE @@ROWCOUNT > 0
	BEGIN
		SET @depth = (@depth + 1)
		
		INSERT #itemsToDelete
		SELECT c.ID, @depth
		FROM SecurityTaskCategory c JOIN
		#itemsToDelete d ON (c.ParentID = d.ID AND d.Depth = (@depth - 1))
	END	

	DELETE c
	FROM SecurityTaskCategory c JOIN
	#itemsToDelete d ON c.ID = d.ID
	
	DROP TABLE #itemsToDelete