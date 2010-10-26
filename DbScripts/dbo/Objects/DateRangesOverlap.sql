-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'DateRangesOverlap')
	DROP FUNCTION dbo.DateRangesOverlap
GO

/*
	Determines if two date ranges overlap
*/
CREATE FUNCTION dbo.DateRangesOverlap (
	@aStart datetime, 
	@aEnd datetime, 
	@bStart datetime, 
	@bEnd datetime,
	@now datetime )
RETURNS bit
AS
BEGIN

return
	case 
	-- unbounded ranges when @now is not specified
	when (@aStart is not null and @bStart is not null and @now is null ) and ( @aEnd is null or @bEnd is null) 
	then
		case when ( @aEnd is null and @bEnd is null ) OR ( @aEnd is null and @aStart < @bEnd ) OR ( @bEnd is null and @bStart < @aEnd )
		then 1
		else 0
		end
	when 
		-- a:    |...
		-- b:  |-------|
		(0 >= datediff(d, @aStart, @bStart) and 0 < datediff(d, @aStart, isnull(@bEnd, @now))) OR
	
		-- a:    ...|
		-- b:  |-------|
		(0 > datediff(d, isnull(@aEnd, @now), @bStart) and 0 <= datediff(d, @aEnd, isnull(@bEnd, @now))) OR
	
		-- a:  |-------|
		-- b:    |...
		(0 >= datediff(d, @bStart, @aStart) and 0 < datediff(d, @bStart, isnull(@aEnd, @now))) OR
	
		-- a:  |-------|
		-- b:    ...|
		(0 > datediff(d, isnull(@bEnd, @now), @aStart) and 0 <= datediff(d, isnull(@bEnd, @now), @aEnd))
	then 1
	else 0
	end
END
GO

-- =============================================
-- Example to execute function
-- =============================================


-- Tests for when all dates are specified
if 1 <> dbo.DateRangesOverlap('2/1/00', '4/1/00', '1/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a:     2------4
	  b:   1------3
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '3/1/00', '1/1/00', '2/1/00', '1/1/00') 
	print  'Should overlap
	  a:   1--------3
	  b:   1------2 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '4/1/00', '2/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a: 1----------4
	  b:   2------3 
	'

if 1 <> dbo.DateRangesOverlap('2/1/00', '3/1/00', '1/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1--------3 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '1/1/00', '2/1/00', '1/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1--------2 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '3/1/00', '2/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2--------3 
	'

if 1 <> dbo.DateRangesOverlap('2/1/00', '3/1/00', '1/1/00', '4/1/00', '1/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1----------4 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '1/1/00', '3/1/00', '1/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1----------3 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '3/1/00', '2/1/00', '4/1/00', '1/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2----------4 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '3/1/00', '4/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a: 1-----2
	  b:         3------4 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '2/1/00', '3/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a: 1-------2
	  b:         2------3 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '3/1/00', '4/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a:         3------4 
	  b: 1-----2
	'

if 0 <> dbo.DateRangesOverlap('2/1/00', '3/1/00', '1/1/00', '2/1/00', '1/1/00') 
	print  'Should NOT overlap
	  a:         2------3 
	  b: 1-------2
	'

--- Tests for when A has null end date
if 1 <> dbo.DateRangesOverlap('2/1/00', null, '1/1/00', '3/1/00', '4/1/00') 
	print  'Should overlap
	  a:     2-----(4)
	  b:   1------3
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '1/1/00', '2/1/00', '3/1/00') 
	print  'Should overlap
	  a:   1-------(3)
	  b:   1------2 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '2/1/00', '3/1/00', '4/1/00') 
	print  'Should overlap
	  a: 1---------(4)
	  b:   2------3 
	'

if 1 <> dbo.DateRangesOverlap('2/1/00', null, '1/1/00', '3/1/00', '3/1/00') 
	print  'Should overlap
	  a:     2-----(3)
	  b:   1--------3 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '1/1/00', '2/1/00', '2/1/00') 
	print  'Should overlap
	  a:   1-------(2)
	  b:   1--------2 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '2/1/00', '3/1/00', '3/1/00') 
	print  'Should overlap
	  a: 1---------(3)
	  b:   2--------3 
	'

if 1 <> dbo.DateRangesOverlap('2/1/00', null, '1/1/00', '4/1/00', '3/1/00') 
	print  'Should overlap
	  a:     2-----(3)
	  b:   1----------4 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '1/1/00', '3/1/00', '2/1/00') 
	print  'Should overlap
	  a:   1-------(2)
	  b:   1----------3 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '2/1/00', '4/1/00', '3/1/00') 
	print  'Should overlap
	  a: 1---------(3)
	  b:   2----------4 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', null, '3/1/00', '4/1/00', '2/1/00') 
	print  'Should NOT overlap
	  a: 1----(2)
	  b:         3------4 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', null, '2/1/00', '3/1/00', '2/1/00') 
	print  'Should NOT overlap
	  a: 1------(2)
	  b:         2------3 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', null, '3/1/00', '4/1/00', '2/1/00') 
	print  'Should NOT overlap
	  a:         3-----(4) 
	  b: 1-----2
	'

if 0 <> dbo.DateRangesOverlap('2/1/00', null, '1/1/00', '2/1/00', '3/1/00') 
	print  'Should NOT overlap
	  a:         2------(3) 
	  b: 1-------2
	'




-- Tests for b has a null end date
if 1 <> dbo.DateRangesOverlap('2/1/00', '4/1/00', '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:     2------4
	  b:   1-----(3)
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '3/1/00', '1/1/00', null, '2/1/00')
	print  'Should overlap
	  a:   1--------3
	  b:   1-----(2) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '4/1/00', '2/1/00', null, '3/1/00') 
	print  'Should overlap
	  a: 1----------4
	  b:   2-----(3) 
	'

if 1 <> dbo.DateRangesOverlap('2/1/00', '3/1/00', '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1-------(3) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '1/1/00', null, '2/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1-------(2) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '3/1/00', '2/1/00', null, '3/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2-------(3) 
	'

if 1 <> dbo.DateRangesOverlap('2/1/00', '3/1/00', '1/1/00', null, '4/1/00') 
	print  'Should overlap
	  a:     2------3
	  b:   1---------(4) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:   1--------2
	  b:   1---------(3) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', '3/1/00', '2/1/00', null, '4/1/00') 
	print  'Should overlap
	  a: 1----------3
	  b:   2---------(4) 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '3/1/00', null, '4/1/00') 
	print  'Should NOT overlap
	  a: 1-----2
	  b:         3-----(4) 
	'

if 0 <> dbo.DateRangesOverlap('1/1/00', '2/1/00', '2/1/00', null, '3/1/00') 
	print  'Should NOT overlap
	  a: 1-------2
	  b:         2-----(3) 
	'

if 0 <> dbo.DateRangesOverlap('3/1/00', '4/1/00', '1/1/00', null, '2/1/00') 
	print  'Should NOT overlap
	  a:         3------4 
	  b: 1----(2)
	'

if 0 <> dbo.DateRangesOverlap('2/1/00', '3/1/00', '1/1/00', null, '2/1/00') 
	print  'Should NOT overlap
	  a:         2------3 
	  b: 1------(2)
	'


-- Both a and b have null end dates
if 1 <> dbo.DateRangesOverlap('2/1/00', null, '1/1/00', null, '3/1/00') 
	print  'Should overlap
	  a:     2-----(3)
	  b:   1-------(3) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '1/1/00', null, '2/1/00') 
	print  'Should overlap
	  a:   1-------(2)
	  b:   1-------(2) 
	'

if 1 <> dbo.DateRangesOverlap('1/1/00', null, '2/1/00', null, '3/1/00') 
	print  'Should overlap
	  a: 1---------(3)
	  b:   2-------(3) 
	'
