/*
Replacement for the builtin CHARINDEX SQL Server function
that works with TEXT-typed data.
*/

IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'CharIndexText')
	DROP FUNCTION CharIndexText
GO

Create FUNCTION dbo.CharIndexText(@search char, @idArray text, @start int )  
RETURNS int AS  
BEGIN

	declare @ret int

	if datalength(@idArray) <= 8000
	begin
		-- Use real charindex if possible
		set @ret = charindex(@search, @idArray, @start)
	end
	else if @idArray is null or @search is null
	begin
		set @ret = null
	end
	else
	begin
		-- search string manually
		set @ret = @start

		while substring(@idArray, @ret, 1) <> @search and @ret <= datalength(@idArray)
		begin
			set @ret = @ret + 1
		end

		if @ret > datalength(@idArray)
			set @ret = 0
	end

	return @ret
end
