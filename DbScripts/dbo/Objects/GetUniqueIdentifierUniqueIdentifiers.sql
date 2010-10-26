
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUniqueIdentifierUniqueIdentifiers]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetUniqueIdentifierUniqueIdentifiers]
GO



CREATE FUNCTION dbo.GetUniqueIdentifierUniqueIdentifiers (@idArray uniqueidentifieruniqueidentifierarray)  
RETURNS @idTable table(id0 uniqueidentifier, id1 uniqueidentifier) AS  
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
	values (cast(substring(@idArray, @start, @idSize) as uniqueidentifier), cast(substring(@idArray, @start + 1 + @idSize, @idSize) as uniqueidentifier))
	set @start = @start + @idSize * 2 + 2
end

return 
END



