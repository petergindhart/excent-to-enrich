-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'KeepDateInRange')
	DROP FUNCTION dbo.KeepDateInRange
GO

/*
Ensures that a date is within the specified range.
*/
CREATE FUNCTION dbo.KeepDateInRange (
		@aDate datetime,
		@bStart datetime,
		@bEnd datetime
)
RETURNS datetime
AS
BEGIN
	declare @d datetime

	if not(0 >= datediff(d, @aDate, @bStart))
		set @d = @bStart
	else if not(@bEnd is null) and not(0 < datediff(d, @aDate, @bEnd))
		set @d = DateAdd(d, -1, @bEnd)
	else
		set @d = @aDate

	return @d
END
GO
