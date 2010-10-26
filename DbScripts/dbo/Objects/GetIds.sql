SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
NOTE: This function is deprecated.  Use GetUniqueIdentifers instead even
though they do the same thing.  The VC3 dev tools have been changed to
use GetUniqueIdentifers now.

*/
ALTER     FUNCTION dbo.GetIds (@idArray uniqueidentifierarray)  
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
