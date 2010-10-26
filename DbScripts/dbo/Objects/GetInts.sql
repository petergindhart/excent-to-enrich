if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetInts]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetInts]
GO


 CREATE FUNCTION dbo.GetInts (@idArray intarray)  
	RETURNS @idTable table(id int) AS  
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
		values (cast(substring(@idArray, @start, @finish-@start) as int))
		set @start = @finish + 1
		set @finish = charindex('|', @idArray, @start)
	end

	insert into @idTable
	values (cast(substring(@idArray, @start, datalength(@idArray)-@start+1) as int))

	return 
END
