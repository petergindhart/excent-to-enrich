-- =============================================
-- Creates use defined function : GetChar1s		
-- SAVE AS: C:\Projects\VC3\TestView\Product\Mainline\Database\Objects\GetChar1s.sql
-- =============================================
IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetChar1s' and user_name(uid)='testview')
	DROP FUNCTION testview.GetChar1s
GO

IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'GetChar1s' and user_name(uid)='dbo')
	DROP FUNCTION dbo.GetChar1s
GO

CREATE   FUNCTION dbo.GetChar1s (@idArray char1array)  
RETURNS @idTable table(id char(1)) AS  
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
	values (cast(substring(@idArray, @start, @finish-@start) as char(1)))
	set @start = @finish + 1
	set @finish = charindex('|', @idArray, @start)
end

insert into @idTable
values (cast(substring(@idArray, @start, datalength(@idArray)-@start+1) as char(1)))

return 
END
					
