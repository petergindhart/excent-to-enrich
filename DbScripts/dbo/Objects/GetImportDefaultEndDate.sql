
-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetImportDefaultEndDate')
	DROP FUNCTION dbo.GetImportDefaultEndDate
GO

/*
Used during imports to determine default end dates
for history tables.
*/
CREATE FUNCTION dbo.GetImportDefaultEndDate()
RETURNS datetime
AS
BEGIN
	declare @d datetime

	select 
		@d = case 
			-- First import EVER.
			-- NOTE: End date's really shouldn't ever get set during the very first import 
			-- b/c nothing is getting deleted.
			when LastImportRosterYearID is null then lcry.EndDate

			-- Importing a new roster year.
			when SnapshotRosterYearID <> LastImportRosterYearID then liry.EndDate 

			-- Re-importing a roster year
			-- NOTE: This is the typical case throughout the year.
			else sasi.SnapshotDate
			end
	from 
		SisDatabase sasi left join
		RosterYear lcry on lcry.Id = sasi.SnapshotRosterYearID left join
		RosterYear liry on liry.Id = sasi.LastImportRosterYearID

	return @d
END
GO