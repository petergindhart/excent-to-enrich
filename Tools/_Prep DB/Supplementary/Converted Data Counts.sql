
create table #TEMP_ConversionCounts (
Tbl varchar(100) not null,
Total int not null)


declare @t varchar(100), @c int, @q varchar(max)
declare T cursor for
select Distinct DestTable, Sequence from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and Sequence between 0 and 99 and DestTable is not null and DestTable not like 'LEGACYSPED%' And DestTable <> '' order by Sequence, DestTable

open T
fetch T into @t, @c

while @@fetch_status = 0

begin

set @q = 'insert #TEMP_ConversionCounts
select Tbl = '''+@t+''', Total = count(*) from dbo.'+@t+''
exec (@q)

fetch T into @t, @c
end
close T
deallocate T

select * from #TEMP_ConversionCounts
drop table #TEMP_ConversionCounts


--select Name, Number from OrgUnit
--select name, Number from School
--select * from GradeLevel order by BitMask

-- select * from Setup order by InstallDate desc





-- EXCENTDATATEAM.Util_VerifyProgramDataAssumptions_New









