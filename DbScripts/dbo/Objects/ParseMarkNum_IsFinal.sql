--#include ParseNumberOfMarkNums.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParseMarkNum_IsFinal]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[ParseMarkNum_IsFinal]
GO

CREATE    FUNCTION [dbo].[ParseMarkNum_IsFinal]
(	
	@expression varchar(8000)
)
RETURNS int
AS
BEGIN	
	DECLARE @count int
	SET @count = 0
	
	DECLARE @max int
	SET @max = dbo.ParseNumberOfMarkNums(@expression)

	declare @indexToSearch int
	declare @section varchar(64)--place to store the whole string for that particular MarkNum
	declare @searchString varchar(20)

	WHILE @count < @max
	BEGIN
		set @section =  SUBSTRING(@expression, (@count * 63 ), 63 ) --each section starts at marknum * 63 + 1    (ie section 3 starts at 190 and goes for 63)
		set @indexToSearch = charindex('N',@section,10)
	
		IF @indexToSearch < 0 --if N is not found in the string, which means its an A, then look for the A around the same place
		BEGIN
			set @indexToSearch = charindex('A',@section,10)  --the fact that the search starts so far back should mean that this A is the A that is normally an N
		END

		--set @searchString = SUBSTRING( @section , @indexToSearch , 20 )
		IF( SUBSTRING(@section , @indexToSearch + 8, 1 ) = 'X')
			return @count	
			
		SET @count = @count + 1
	END

	RETURN -1
END


