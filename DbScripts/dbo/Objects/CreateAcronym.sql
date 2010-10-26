--=========================================
-- Create scalar-valued function template
--=========================================

IF OBJECT_ID (N'dbo.CreateAcronym') IS NOT NULL
   DROP FUNCTION dbo.CreateAcronym
GO

CREATE FUNCTION dbo.CreateAcronym (@text varchar(8000))
RETURNS varchar(8000)
AS
BEGIN
	set @text = replace(@text, ' ', '|')

	declare @ret varchar(8000)

	select @ret = isnull(@ret, '') + upper(substring(Item, 1, 1))
	from dbo.Split(@text, '|')

	RETURN @ret
END
GO

