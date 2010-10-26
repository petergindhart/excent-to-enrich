SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUniqueIdentifiers]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetUniqueIdentifiers]
GO



CREATE    FUNCTION dbo.GetUniqueIdentifiers (@idArray uniqueidentifierarray)  
RETURNS @idTable table(id uniqueidentifier) AS  
BEGIN

if (@idArray is null)
	return

declare @start int
declare @idSize int
declare @arraySize int

set @arraySize = datalength(@idArray)
set @idSize = 36

set @start = 1

while @start <= @arraySize
begin
	insert into @idTable
	values (cast(substring(@idArray, @start, @idSize) as uniqueidentifier))
	set @start = @start + @idSize + 1
end

return 
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO