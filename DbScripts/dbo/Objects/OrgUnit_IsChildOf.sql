IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[OrgUnit_IsChildOf]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[OrgUnit_IsChildOf]
GO

CREATE FUNCTION dbo.OrgUnit_IsChildOf
(
	@orgUnit uniqueidentifier,
	@candidateParent uniqueidentifier
)
RETURNS bit
AS
BEGIN

	DECLARE @return bit
	DECLARE @newParentCandidate uniqueidentifier

	SELECT 
		@newParentCandidate = ParentID	
	FROM 
		OrgUnit 
	WHERE 
		ID = @orgUnit

	IF @candidateParent = @orgUnit OR @newParentCandidate = @orgUnit
		SET @return = 1
	else if @newParentCandidate is null
		SET @return = 0
	else
		exec @return = dbo.OrgUnit_IsChildOf @newParentCandidate, @candidateParent
	
	RETURN @return
END
GO
