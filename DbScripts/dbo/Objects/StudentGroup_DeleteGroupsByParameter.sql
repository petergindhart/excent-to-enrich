IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentGroup_DeleteGroupsByParameter]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentGroup_DeleteGroupsByParameter]
GO

CREATE  PROCEDURE [dbo].[StudentGroup_DeleteGroupsByParameter]
	@parameterId uniqueidentifier	
AS

DELETE StudentGroup
WHERE Parameter = @parameterId