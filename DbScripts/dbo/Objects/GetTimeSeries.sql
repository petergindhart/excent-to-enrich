-- =============================================
-- Create table function (TF)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetTimeSeries')
	DROP FUNCTION dbo.GetTimeSeries
GO

CREATE FUNCTION dbo.GetTimeSeries(
	@start datetime,
	@end datetime,
	@step int,
	@stepUnit varchar(10))
RETURNS @series TABLE 
	(
		Item datetime
	)
AS
BEGIN
	DECLARE @cur datetime	

	set @cur = @start


	if @stepUnit in ('dd', 'd', 'Day')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(dd, @step, @cur)
		end
	end
	else if @stepUnit in ('yy', 'yyyy', 'Year')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(yy, @step, @cur)
		end
	end
	else if @stepUnit in ('quarter', 'q', 'qq')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(q, @step, @cur)
		end
	end
	else if @stepUnit in ('month', 'm', 'mm')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(m, @step, @cur)
		end
	end
	else if @stepUnit in ('Hour', 'hh')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(hh, @step, @cur)
		end
	end
	else if @stepUnit in ('minute', 'mi', 'n')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(mi, @step, @cur)
		end
	end
	else if @stepUnit in ('second', 'ss', 's')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(s, @step, @cur)
		end
	end
	else if @stepUnit in ('millisecond', 'ms')
	begin
		while @cur < @end
		begin
			insert @series values (@cur)
	
			set @cur = DateAdd(ms, @step, @cur)
		end
	end

	RETURN 
END
GO

-- =============================================
-- Example to execute function
-- =============================================
--SELECT * from dbo.GetTimeSeries('12/1/2003', '2/15/2004', 3601, 'mi')
GO

