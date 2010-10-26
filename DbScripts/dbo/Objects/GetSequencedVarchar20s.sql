if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetSequencedVarchar20s]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetSequencedVarchar20s]
GO

CREATE   FUNCTION [dbo].[GetSequencedVarchar20s] (@idArray varchar20array)  
RETURNS @idTable table(id varchar(20), position int) AS  
BEGIN 

	if (@idArray is null)
		return

	declare @start int
	declare @finish int
	declare @count int

	set @start = 1
	set @finish = charindex('|', @idArray)
	
	set @count = 0

	while @finish > 0
	begin
		insert into @idTable
		values (cast(substring(@idArray, @start, @finish-@start) as varchar(20)), @count)
		
		set @start = @finish + 1
		set	@count = @count + 1
		set @finish = charindex('|', @idArray, @start)
	end

	insert into @idTable
	values (cast(substring(@idArray, @start, datalength(@idArray)-@start+1) as varchar(20)), @count)

return 
END