-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'DateInRangeAdvanced')
	DROP FUNCTION dbo.DateInRangeAdvanced
GO

CREATE FUNCTION dbo.DateInRangeAdvanced (
		@aDate DATETIME,
		@bStart DATETIME,
		@bEnd DATETIME,
		@isInclusive BIT = 0
)

RETURNS BIT
AS
BEGIN
	RETURN 
	CASE
		WHEN @aDate IS NULL THEN 0
		WHEN @bStart IS NULL AND @bEnd IS NULL THEN 1
		ELSE
			CASE
				WHEN @isInclusive = 1 THEN
					CASE
						WHEN (@bStart IS NULL OR 0 >= DATEDIFF(d, @aDate, @bStart)) AND (@bEnd IS NULL OR 0 <= DATEDIFF(d, @aDate, @bEnd)) THEN 1
						ELSE 0
					END
				ELSE 
					CASE
						WHEN (@bStart IS NULL OR 0 >= DATEDIFF(d, @aDate, @bStart)) AND (@bEnd IS NULL OR 0 < DATEDIFF(d, @aDate, @bEnd)) THEN 1
						ELSE 0
					END
			END
	END
END
GO

-- =============================================
-- Example to exclusive function
-- =============================================

IF 0 <> dbo.DateInRangeAdvanced(NULL, '2/1/00', '3/1/00', 0)
	PRINT 'Should NOT be in range
		a:  No date   
		b:  2------3
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', NULL, NULL, 0)
	PRINT 'Should be in range
		a:      2
		b:  ( )----( )
'

IF 0 <> dbo.DateInRangeAdvanced('1/1/00', '2/1/00', '3/1/00', 0)
	PRINT 'Should NOT be in range
		a: 1    
		b:  2------3
'

IF 1 <> dbo.DateInRangeAdvanced('1/1/00', '1/1/00', '2/1/00', 0)
	PRINT 'Should be in range
		a:  1    
		b:  1------2
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', '1/1/00', '3/1/00', 0)
	PRINT 'Should be in range
		a:      2
		b:  1------3
'

IF 0 <> dbo.DateInRangeAdvanced('2/1/00', '1/1/00', '2/1/00', 0)
	PRINT 'Should NOT be in range
		a:         2
		b:  1------2
'

IF 0 <> dbo.DateInRangeAdvanced('3/1/00', '1/1/00', '2/1/00', 0)
	PRINT 'Should NOT be in range
		a:           3
		b:  1------2
'

-- null end date
IF 0 <> dbo.DateInRangeAdvanced('1/1/00', '2/1/00', NULL, 0)
	PRINT 'Should NOT be in range
		a: 1    
		b:  2-----( )
'

IF 1 <> dbo.DateInRangeAdvanced('1/1/00', '1/1/00', NULL, 0)
	PRINT 'Should be in range
		a:  1    
		b:  1-----( )
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', '1/1/00', NULL, 0)
	PRINT 'Should be in range
		a:      2
		b:  1----( )
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', NULL, '3/1/00', 0)
	PRINT 'Should be in range
		a:      2
		b:  ( )----3
'

-- =============================================
-- Example to inclusive function
-- =============================================

IF 0 <> dbo.DateInRangeAdvanced(NULL, '2/1/00', '3/1/00', 1)
	PRINT 'Should NOT be in range
		a:  No date   
		b:  2------3
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', NULL, NULL, 1)
	PRINT 'Should be in range
		a:      2
		b:  ( )----( )
'

IF 0 <> dbo.DateInRangeAdvanced('1/1/00', '2/1/00', '3/1/00', 1)
	PRINT 'Should NOT be in range
		a: 1    
		b:  2------3
'

IF 1 <> dbo.DateInRangeAdvanced('1/1/00', '1/1/00', '2/1/00', 1)
	PRINT 'Should be in range
		a:  1    
		b:  1------2
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', '1/1/00', '3/1/00', 1)
	PRINT 'Should be in range
		a:      2
		b:  1------3
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', '1/1/00', '2/1/00', 1)
	PRINT 'Should be in range
		a:         2
		b:  1------2
'

IF 0 <> dbo.DateInRangeAdvanced('3/1/00', '1/1/00', '2/1/00', 1)
	PRINT 'Should NOT be in range
		a:           3
		b:  1------2
'

-- null end date
IF 0 <> dbo.DateInRangeAdvanced('1/1/00', '2/1/00', NULL, 1)
	PRINT 'Should NOT be in range
		a: 1    
		b:  2-----( )
'

IF 1 <> dbo.DateInRangeAdvanced('1/1/00', '1/1/00', NULL, 1)
	PRINT 'Should be in range
		a:  1    
		b:  1-----( )
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', '1/1/00', NULL, 1)
	PRINT 'Should be in range
		a:      2
		b:  1----( )
'

IF 1 <> dbo.DateInRangeAdvanced('2/1/00', NULL, '3/1/00', 0)
	PRINT 'Should be in range
		a:      2
		b:  ( )----3
'

GO
