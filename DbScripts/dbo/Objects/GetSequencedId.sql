-- Drop GetSequencedIds function
IF EXISTS (SELECT * 
         FROM   sysobjects 
         WHERE  name = N'GetSequencedIds')
      DROP FUNCTION GetSequencedIds
GO

-- Create the GetSequencedIds function
CREATE FUNCTION [dbo].[GetSequencedIds] (@idArray uniqueidentifierarray)  
RETURNS @idTable table(id uniqueidentifier, position int) AS  
BEGIN 

if (@idArray is null)
	return

declare @start int
declare @count int
declare @idSize int
declare @arraySize int

set @arraySize = datalength(@idArray)
set @idSize = 36
set @count = 0
set @start = 1

while @start <= @arraySize
begin
	insert into @idTable
	values (cast(substring(@idArray, @start, @idSize) as uniqueidentifier), @count)
	set @start = @start + @idSize + 1
	set @count = @count + 1
end

return 
END

--Old function didn't seem to function as expected, as it didn't compensate for using the pipe as a delimeter,
--Code was rewritten to use GetUniqueIdentifiers logic, with the addition of a simple zero-based counter
--old method below:
--
--ALTER FUNCTION [dbo].[GetSequencedIds] (@idArray uniqueidentifierarray)  
--RETURNS @idTable table(id uniqueidentifier, position int) AS  
--BEGIN 
--declare @count int
--set @count = datalength(@idArray) / 36
--while @count > 0
--begin
--      set @count = @count - 1
--
--      insert into @idTable
--      values (cast(substring(@idArray, @count * 36 + 1, 36) as uniqueidentifier), @count)
--end
--
--return 
--END
--
