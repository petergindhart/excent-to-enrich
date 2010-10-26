--#include IntMax.sql

-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'DaysDateRangesOverlap')
	DROP FUNCTION dbo.DaysDateRangesOverlap
GO

/*
	Determines if two date ranges overlap
*/
CREATE FUNCTION dbo.DaysDateRangesOverlap (
	@aStart datetime, 
	@aEnd datetime, 
	@bStart datetime, 
	@bEnd datetime,
	@now datetime )
RETURNS int
AS
BEGIN

return
	case 
	-- unbounded ranges when @now is not specified
	when (@aStart is not null and @bStart is not null and @now is null ) and ( @aEnd is null or @bEnd is null) 
	then
		case
			when ( @aEnd is null and @bEnd is null ) then 2147483647
			when ( @aEnd is null and @aStart < @bEnd ) then datediff(d, @bEnd, @aStart)
			when ( @bEnd is null and @bStart < @aEnd ) then datediff(d, @aEnd, @bStart)
		else 0
		end
	else
		dbo.IntMax(0, datediff(d, dbo.DateMax(@aStart, @bStart), dbo.DateMin(isnull(@aEnd, @now), isnull(@bEnd, @now))) )
	end
END
GO
/*
-- =============================================
-- Example to execute function
-- =============================================

-- Tests for when all dates are specified
if 0 =  dbo.DaysDateRangesOverlap('2/1/00', '4/1/00', '1/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a:     2------4
	  b:   1------3
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '3/1/00', '1/1/00', '2/1/00', '1/1/00') 
	print  'Should overlap
	  a:   1--------3
	  b:   1------2 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '4/1/00', '2/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a: 1----------4
	  b:   2------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('2/1/00', '3/1/00', '1/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1--------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '1/1/00', '2/1/00', '1/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1--------2 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '3/1/00', '2/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2--------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('2/1/00', '3/1/00', '1/1/00', '4/1/00', '1/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1----------4 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '1/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1----------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '3/1/00', '2/1/00', '4/1/00', '1/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2----------4 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '3/1/00', '4/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a: 1-----2
	  b:         3------4 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '2/1/00', '3/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a: 1-------2
	  b:         2------3 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '3/1/00', '4/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a:         3------4 
	  b: 1-----2
	'

if 0 <> dbo.DaysDateRangesOverlap('2/1/00', '3/1/00', '1/1/00', '2/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a:         2------3 
	  b: 1-------2
	'

--- Tests for when A has null end date
if 0 =  dbo.DaysDateRangesOverlap('2/1/00', null, '1/1/00', '3/1/00', '4/1/00') 
	print  'Should overlap
	  a:     2-----(4)
	  b:   1------3
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '1/1/00', '2/1/00', '3/1/00') 
	print  'Should overlap
	  a:   1-------(3)
	  b:   1------2 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '2/1/00', '3/1/00', '4/1/00') 
	print  'Should overlap
	  a: 1---------(4)
	  b:   2------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('2/1/00', null, '1/1/00', '3/1/00', '3/1/00') 
	print  'Should overlap
	  a:     2-----(3)
	  b:   1--------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '1/1/00', '2/1/00', '2/1/00') 
	print  'Should overlap
	  a:   1-------(2)
	  b:   1--------2 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '2/1/00', '3/1/00', '3/1/00') 
	print  'Should overlap
	  a: 1---------(3)
	  b:   2--------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('2/1/00', null, '1/1/00', '4/1/00', '3/1/00') 
	print  'Should overlap
	  a:     2-----(3)
	  b:   1----------4 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '1/1/00', '3/1/00', '2/1/00') 
	print  'Should overlap
	  a:   1-------(2)
	  b:   1----------3 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '2/1/00', '4/1/00', '3/1/00') 
	print  'Should overlap
	  a: 1---------(3)
	  b:   2----------4 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', null, '3/1/00', '4/1/00', '2/1/00') 
	print  'Should NOT overlap
	  a: 1----(2)
	  b:         3------4 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', null, '2/1/00', '3/1/00', '2/1/00') 
	print  'Should NOT overlap
	  a: 1------(2)
	  b:         2------3 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', null, '3/1/00', '4/1/00', '2/1/00') 
	print  'Should NOT overlap
	  a:         3-----(4) 
	  b: 1-----2
	'

if 0 <> dbo.DaysDateRangesOverlap('2/1/00', null, '1/1/00', '2/1/00', '3/1/00') 
	print  'Should NOT overlap
	  a:         2------(3) 
	  b: 1-------2
	'




-- Tests for b has a null end date
if 0 =  dbo.DaysDateRangesOverlap('2/1/00', '4/1/00', '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:     2------4
	  b:   1-----(3)
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '3/1/00', '1/1/00', null, '2/1/00')
	print  'Should overlap
	  a:   1--------3
	  b:   1-----(2) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '4/1/00', '2/1/00', null, '3/1/00') 
	print  'Should overlap
	  a: 1----------4
	  b:   2-----(3) 
	'

if 0 =  dbo.DaysDateRangesOverlap('2/1/00', '3/1/00', '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1-------(3) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '1/1/00', null, '2/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1-------(2) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '3/1/00', '2/1/00', null, '3/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2-------(3) 
	'

if 0 =  dbo.DaysDateRangesOverlap('2/1/00', '3/1/00', '1/1/00', null, '4/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1---------(4) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1---------(3) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', '3/1/00', '2/1/00', null, '4/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2---------(4) 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '3/1/00', null, '4/1/00') 
	print  'Should NOT overlap
	  a: 1-----2
	  b:         3-----(4) 
	'

if 0 <> dbo.DaysDateRangesOverlap('1/1/00', '2/1/00', '2/1/00', null, '3/1/00') 
	print  'Should NOT overlap
	  a: 1-------2
	  b:         2-----(3) 
	'

if 0 <> dbo.DaysDateRangesOverlap('3/1/00', '4/1/00', '1/1/00', null, '2/1/00') 
	print  'Should NOT overlap
	  a:         3------4 
	  b: 1----(2)
	'

if 0 <> dbo.DaysDateRangesOverlap('2/1/00', '3/1/00', '1/1/00', null, '2/1/00') 
	print  'Should NOT overlap
	  a:         2------3 
	  b: 1------(2)
	'


-- Both a and b have null end dates
if 0 =  dbo.DaysDateRangesOverlap('2/1/00', null, '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:     2-----(3)
	  b:   1-------(3) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '1/1/00', null, '2/1/00') 
	print  'Should overlap
	  a:   1-------(2)
	  b:   1-------(2) 
	'

if 0 =  dbo.DaysDateRangesOverlap('1/1/00', null, '2/1/00', null, '3/1/00') 
	print  'Should overlap
	  a: 1---------(3)
	  b:   2-------(3) 
	'
*/