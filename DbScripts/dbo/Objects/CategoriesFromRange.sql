
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CategoriesFromRange]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CategoriesFromRange]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.CategoriesFromRange 
	(@lowerBound real, @upperBound real, @minCategories int, @maxCategories int, @categorizationInterval int)
RETURNS @categories table (Sequence int primary key, Name varchar(100), LowerBound real, UpperBound real)
AS
BEGIN

	declare @range real;	set @range = @upperBound - @lowerBound; 
	declare @round int;		set @round = -(ceiling(log10(@range))-2);
	
	declare @rangeRounded real;	set @rangeRounded = round(@range, @round-1);
	
	-- Determine the options available for each category count
	declare @catOptions table (Categories real, CatRangeExact real, CatRangeRounded real, CatRangeRounded2 real)
	
	IF(@minCategories > @upperBound)
	BEGIN
		SET @minCategories = @upperBound
		SEt @maxCategories = @upperBound
	END

	declare @i real 
	set @i = @minCategories
	
	IF @categorizationInterval > -1	 
	BEGIN			
		SET @maxCategories = 
		case
			when ((cast(@upperBound as int) - (cast(@lowerBound as int) - (cast(@lowerBound as int) % @categorizationInterval))) / @categorizationInterval) < @minCategories 
			then @minCategories 
			else (cast(@upperBound as int) - (cast(@lowerBound as int) - (cast(@lowerBound as int) % @categorizationInterval))) / @categorizationInterval
		end
	END


	-- If there is a super small number of records, then allow each value a separate category
	IF(@minCategories = @upperBound)
	BEGIN
		insert into @catOptions values (
				@i,
				1,
				1,
				1
			)
	END
	ELSE
	BEGIN
		while @i <= @maxCategories
		begin
			insert into @catOptions values (
				@i,
				@range/@i,
				round(@range/@i, @round),
				@rangeRounded/@i
			)
			
			set @i = @i + 1		
		end	
	END

	-- Calculate the best option
	declare @catRange real
	declare @count int

	IF @categorizationInterval > -1
	BEGIN
		SET @count = @maxCategories
		SET @catRange = @categorizationInterval
	END
	ELSE
	BEGIN
		select top 1
			@count 		= cast(Categories as int),
			@catRange	= CatRangeRounded
		from
			@catOptions
		order by
			abs(CatRangeExact - CatRangeRounded) + (Categories * abs(CatRangeRounded - CatRangeRounded2))
	END

	-- Generate the categories
	declare @seq int;			set @seq = 0
	declare @lower real;		set @lower = @lowerBound
	declare @upper real;		set @lower = @lowerBound
	declare @name varchar(100);
	declare @upperName real;

	declare @offset real;

	IF @categorizationInterval > -1
	BEGIN
		SET @offset =  (cast(@lower as int)- (cast(@lower as int) % cast(@categorizationInterval as int))) + 1
	END
	ELSE
	BEGIN
		if @catRange > @lower
			set @offset = 0
		else
			set @offset = @lower			
	END

	while @seq < @count
	begin

		set @lower =
			case when @seq = 0 then	-- first
				-(3.40E+38) --@lowerBound
			else -- Not first
				(@seq * @catRange) + @offset		
			end

		set @upper =
			case 
			when @categorizationInterval > -1 AND  @seq+1 < @count --not last and also a explicitly categorized interval that is upper-bound exclusive
				then ((@seq + 1) * @catRange) + @offset - 1			
			when @seq+1 < @count then -- not last
				(((@seq+1) * @catRange) + @offset  ) - 1 --upperbound should be noninclusive of lowerbound of next rung
			else -- last
				3.40E+38 -- @upperBound
			end
		
		set @upperName =
			case 
				when @categorizationInterval > -1 AND abs(@upper) > 1 then
					@upper 
				when abs(@upper) > 1 OR (@minCategories = @upperBound) then				
					@upper 
				else
					@upper - (1.0/power(10, -floor(log10(@upper))+1))
			end

		set @name = 
			case 
			when @seq = 0 then	-- first			
				cast(@upperName as varchar(6)) + ' or lower'
			when @lower = @upper then
				cast(@lower as varchar(3))
			when @seq+1 < @count then -- not last
				cast(@lower as varchar(6)) + ' - ' + cast(@upperName as varchar(6))
			
			else -- last
				cast(@lower as varchar(6)) + ' or higher'
			end

		insert into @categories
		values (@seq, @name, @lower, @upper)	

		set @seq = @seq + 1
	end
	
	/*
	IDEA:
		use log10(range) to get determine largest power of 10 less than range.  Use this to divide the range into categories.  IE, find category BOUNDARIES...
	
	*/

	RETURN 
END