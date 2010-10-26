
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'DateMin')
	DROP FUNCTION dbo.DateMin
GO

CREATE FUNCTION dbo.DateMin 
(
	@v1 datetime,
	@v2 datetime
)
RETURNS DateTime
AS
BEGIN
	RETURN
		case
			when @v1 is null then @v2
			when @v2 is null then @v1
			when @v1 < @v2 then @v1
			else @v2
		end

END
GO

