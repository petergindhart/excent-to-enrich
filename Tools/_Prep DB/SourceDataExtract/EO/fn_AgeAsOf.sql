if exists (select 1 from sysobjects where name = 'fn_AgeAsOf')
drop function fn_AgeAsOf
go

create function dbo.fn_AgeAsOf (@AgeAsOfDate datetime, @Birthdate datetime)  
returns int
as  
begin
declare @AgeOut int;
select @AgeOut = cast ((  
  (datepart(yy, @AgeAsOfDate)- datepart(yy, @Birthdate))*360.0 +  
  (datepart(mm, @AgeAsOfDate)- datepart(mm, @Birthdate))*30 +  
  (datepart(dd, @AgeAsOfDate)- datepart(dd, @Birthdate)))/30/12 as int)
return @AgeOut
end
go
