
-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetImportDefaultStartDate')
	DROP FUNCTION dbo.GetImportDefaultStartDate
GO

/*
Used during imports to determine default end dates
for history tables.
*/
CREATE FUNCTION dbo.GetImportDefaultStartDate()
RETURNS datetime
AS
BEGIN
	declare @d datetime

	select 
		@d = case 
			-- First import EVER.
			when LastImportRosterYearID is null then lcry.StartDate

			-- Importing a new roster year.
			when SnapshotRosterYearID <> LastImportRosterYearID then lcry.StartDate

			-- Re-importing a roster year
			-- NOTE: This is the typical case throughout the year.
			else sasi.SnapshotDate
			end
	from 
		SisDatabase sasi left join
		RosterYear lcry on lcry.Id = sasi.SnapshotRosterYearID

	return @d
END
GO