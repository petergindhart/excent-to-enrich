-- =============================================
-- Create scalar function (FN)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'CompareVersionNumbers')
	DROP FUNCTION dbo.CompareVersionNumbers
GO

/*
<summary>
Less than zero when version1 is less than version2. 
Zero when verison1 equals y. 
Greater than zero when version1 is greater than version 2. 
</summary>
*/
CREATE FUNCTION dbo.CompareVersionNumbers 
	(@version1 varchar(20), 
	 @version2 varchar(20))
RETURNS int
AS
BEGIN
	declare @start1 int
	declare @start2 int
	declare @end1 int
	declare @end2 int
	declare @num1 int
	declare @num2 int
	declare @diff int

	set @diff = 0
	set @start1 = 1
	set @start2 = 1

	while @diff = 0 and (@start1 <= len(@version1) or @start2 <= len(@version2))
	begin
		-- Determine version component position
		set @end1 = charindex('.', @version1, @start1)
		set @end2 = charindex('.', @version2, @start2)

		if @end1 < 1
			set @end1 = len(@version1) + 1
		if @end2 < 1
			set @end2 = len(@version2) + 1


		-- Extract version component
		if @start1 <= len(@version1)
		begin
			set @num1 = cast(substring(@version1, @start1, @end1-@start1) as int)
			set @start1 = @end1 + 1
		end
		else
			set @num1 = 0

		if @start2 <= len(@version2)
		begin		
			set @num2 = cast(substring(@version2, @start2, @end2-@start2) as int)
			set @start2 = @end2 + 1
		end
		else
			set @num2 = 0

		-- Compare
		set @diff = @num1 - @num2

	end

	RETURN @diff
END
GO

-- =============================================
-- Example to execute function
-- =============================================
--SELECT dbo.CompareVersionNumbers('1.2.0.100', '1.2.0.0100')
