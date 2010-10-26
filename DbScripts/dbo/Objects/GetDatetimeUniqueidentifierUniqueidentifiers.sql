-- =========================================================================================
-- Creates use defined function : GetDatetimeUniqueidentifierUniqueidentifiers
-- SAVE AS: C:\Projects\VC3\TestView\Product\Mainline\Database\Objects\GetDatetimeUniqueidentifierUniqueidentifiers.sql
-- =========================================================================================

IF EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = N'GetDatetimeUniqueidentifierUniqueidentifiers')
        DROP FUNCTION GetDatetimeUniqueidentifierUniqueidentifiers
GO


CREATE   FUNCTION dbo.GetDatetimeUniqueidentifierUniqueidentifiers (@idArray text)  
RETURNS @idTable table(id0 uniqueidentifier, id1 uniqueidentifier, id2 datetime) AS  
BEGIN 

if (@idArray is null)
return

declare @start int
declare @first int
declare @second int
declare @finish int


set @start = 1
set @first = dbo.CharIndexText(',', @idArray,1)
set @second = dbo.CharIndexText(',',@idArray,@first+1) 
set @finish = dbo.CharIndexText('|', @idArray,1)

--perform inserts as long as we find a pipe delimiter
while @finish > 0
begin

	insert into @idTable
	values
	(
		cast (substring(@idArray, @start, @first-@start)as uniqueidentifier),
		cast (substring(@idArray, @first + 1, (@second-@first -1 ))  as uniqueidentifier),
		cast (substring(@idArray, @second + 1, @finish-@second -1) as datetime)
	)

	set @start = @finish + 1
	set @first = dbo.CharIndexText(',', @idArray, @start)
	set @second = dbo.CharIndexText(',',@idArray,@first +1)
	set @finish = dbo.CharIndexText('|', @idArray, @start)

	
end

--catch the last record (or only one)

	insert into @idTable
	values
	 (
		cast (substring(@idArray, @start, @first-@start) as uniqueidentifier),
		cast (substring(@idArray, @first + 1, (@second-@first -1 )) as uniqueidentifier),
		cast (substring(@idArray, @second + 1, datalength(@idArray)) as datetime)
	 )
return 
END

