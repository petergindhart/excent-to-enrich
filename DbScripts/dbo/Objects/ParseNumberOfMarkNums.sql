if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParseNumberOfMarkNums]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[ParseNumberOfMarkNums]
GO

CREATE    FUNCTION [dbo].[ParseNumberOfMarkNums]
(
	@expression varchar(8000)
)
RETURNS int
AS
BEGIN	
	declare @count int
	set @count = 0

	SET @expression = rtrim(@expression)
	
	declare @counter int
	SET @counter = 0

	declare @maxNumberOfMarknums int
	SET @maxNumberOfMarknums = 30
	
	declare @StringToCompare varchar(64)
	SET @StringToCompare = 0

	while @counter < @maxNumberOfMarknums
	BEGIN
		SET @StringToCompare = SUBSTRING(@expression,(@counter * 63), 15)
		IF LEN(@StringToCompare) < 1
			return @count
		
		set @count = @count + 1
		SET @counter = @counter + 1
	END


	return(@count)
END


