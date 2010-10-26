-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetImportRosterYear')
	DROP FUNCTION dbo.GetImportRosterYear
GO

/*
Gets the roster year of the latest import
*/
CREATE FUNCTION dbo.GetImportRosterYear()
RETURNS uniqueidentifier
AS
BEGIN
	declare @ry uniqueidentifier
	select @ry = SnapshotRosterYearID
	from SisDatabase

	return @ry
END
GO

