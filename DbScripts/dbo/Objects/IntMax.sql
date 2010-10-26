
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'IntMax')
	DROP FUNCTION dbo.IntMax
GO

CREATE FUNCTION dbo.IntMax 
(
	@v1 int,
	@v2 int
)
RETURNS int
AS
BEGIN
	RETURN
		case when @v1 > @v2 then @v1 else @v2 end

END
GO

