-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'DbDirectory')
	DROP FUNCTION dbo.DbDirectory
GO

CREATE FUNCTION dbo.DbDirectory()
RETURNS nvarchar(4000)
AS
BEGIN
	declare @dir nvarchar(4000)
	-- determine the path to the local dbase directory
	-- Use a sub directory relative to the TestView database
	select @dir = reverse(substring(reverse(rtrim(filename)), charindex('\', reverse(rtrim(filename)), 1), 4000 ))
	from sysfiles 
	where rtrim(filename) like '%.mdf'

	return @dir
END
GO


