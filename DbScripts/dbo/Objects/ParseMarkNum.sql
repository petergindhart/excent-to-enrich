if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParseMarkNum]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[ParseMarkNum]
GO

CREATE    FUNCTION [dbo].[ParseMarkNum]
(
	@expression varchar(8000),
	@marknum int
)
RETURNS varchar(20)
AS
BEGIN	
	declare @returnVar varchar(20)
	declare @indexToSearch int
	declare @section varchar(64)--place to store the whole string for that particular MarkNum
	set @section =  SUBSTRING(@expression, (@marknum * 63 ), 63 ) --each section starts at marknum * 63 + 1    (ie section 3 starts at 190 and goes for 63)
	set @indexToSearch = charindex('N',@section,10) - 10
	
	IF @indexToSearch < 0 --if N is not found in the string, which means its an A, then look for the A around the same place
	BEGIN
		set @indexToSearch = charindex('A',@section,10) - 11 --the fact that the search starts so far back should mean that this A is the A that is normally an N
	END

	set @returnVar = SUBSTRING( @section , @indexToSearch , 8  ) --the second portion of the entry, that returns the item number
	return(@returnVar)
END