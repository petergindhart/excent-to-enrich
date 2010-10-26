
/****** Object:  UserDefinedFunction [dbo].[GradeInRange]    Script Date: 07/15/2008 09:09:28 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[GradeInRange]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[GradeInRange]
GO

CREATE FUNCTION [dbo].[GradeInRange] (
		@aGrade uniqueidentifier,
		@startGrade uniqueidentifier,
		@endGrade uniqueidentifier
)

RETURNS bit
AS
BEGIN
	DECLARE @lowerMask int
	DECLARE @upperMask int
	DECLARE @inRange bit
	SET @inRange = 0
	
	SELECT
		@lowerMask = BitMask
	FROM
		GradeLevel
	Where 
		id = @startGrade

	SELECT
		@upperMask = BitMask
	FROM
		GradeLevel
	Where 
		id = @endGrade

	SELECT
		@inRange = case 
					when BitMask <= @upperMask AND BItMask >= @lowerMask 
					then 1 else 0 end
	FROM	
		GradeLevel
	where 
		id = @aGrade

	return @inRange
END
