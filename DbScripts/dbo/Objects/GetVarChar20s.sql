
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetVarchar20s]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetVarchar20s]
GO

	CREATE   FUNCTION dbo.GetVarchar20s (@idArray varchar20array)  
	RETURNS @idTable table(id varchar(20)) AS  
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
		values (cast(substring(@idArray, @start, @finish-@start) as varchar(20)))
		set @start = @finish + 1
		set @finish = charindex('|', @idArray, @start)
	end

	insert into @idTable
	values (cast(substring(@idArray, @start, datalength(@idArray)-@start+1) as varchar(20)))

	return 
	END
					
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

		
