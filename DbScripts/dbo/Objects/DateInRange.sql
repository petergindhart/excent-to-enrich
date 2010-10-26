--#include DateInRangeAdvanced.sql

-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'DateInRange')
	DROP FUNCTION dbo.DateInRange
GO

CREATE FUNCTION dbo.DateInRange (
		@aDate datetime,
		@bStart datetime,
		@bEnd datetime
)

RETURNS bit
AS
BEGIN
	return dbo.DateInRangeAdvanced(@aDate,@bStart,@bEnd,0)
END
GO

-- =============================================
-- Example to execute function
-- =============================================

if 0 <> dbo.DateInRange('1/1/00', '2/1/00', '3/1/00')
	print 'Should NOT be in range
		a: 1    
		b:  2------3
'

if 1 <> dbo.DateInRange('1/1/00', '1/1/00', '2/1/00')
	print 'Should be in range
		a:  1    
		b:  1------2
'

if 1 <> dbo.DateInRange('2/1/00', '1/1/00', '3/1/00')
	print 'Should be in range
		a:      2
		b:  1------3
'

if 0 <> dbo.DateInRange('2/1/00', '1/1/00', '2/1/00')
	print 'Should NOT be in range
		a:         2
		b:  1------2
'

if 0 <> dbo.DateInRange('3/1/00', '1/1/00', '2/1/00')
	print 'Should NOT be in range
		a:           3
		b:  1------2
'

-- null end date
if 0 <> dbo.DateInRange('1/1/00', '2/1/00', null)
	print 'Should NOT be in range
		a: 1    
		b:  2-----( )
'

if 1 <> dbo.DateInRange('1/1/00', '1/1/00', null)
	print 'Should be in range
		a:  1    
		b:  1-----( )
'

if 1 <> dbo.DateInRange('2/1/00', '1/1/00', null)
	print 'Should be in range
		a:      2
		b:  1----( )
'

GO
