-- =============================================
-- Create table function (TF)
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetChars')
	DROP FUNCTION dbo.GetChars
GO

CREATE FUNCTION dbo.GetChars (@idArray chararray)  
	RETURNS @idTable table(id char(1)) AS  
BEGIN 
	if (@idArray is null)
		return

	declare @start int
	declare @finish int

	set @start = 1
	set @finish = charindex('|', @idArray)

	while @finish > 0
	begin
		insert into @idTable
		values (cast(substring(@idArray, @start, @finish-@start) as char(1)))
		set @start = @finish + 1
		set @finish = charindex('|', @idArray, @start)
	end

	insert into @idTable
	values (cast(substring(@idArray, @start, datalength(@idArray)-@start+1) as char(1)))

	return 
END
