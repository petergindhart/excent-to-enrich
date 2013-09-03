
create table #TEMP_ConversionCounts (
Tbl varchar(100) not null,
Total int not null)


declare @t varchar(100), @m varchar(100), @c int, @q varchar(max)
declare T cursor for
select Distinct MapTable, DestTable, Sequence from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and Sequence between 0 and 99 and DestTable is not null and DestTable not like 'LEGACYSPED%' And DestTable <> '' and Enabled = 1 order by Sequence, DestTable

open T
fetch T into @m, @t, @c

while @@fetch_status = 0

begin

set @q = 'insert #TEMP_ConversionCounts
select Tbl = '''+  case when @m = 'LEGACYSPED.MAP_PrgSectionID_NonVersioned' then @t+' (non-versioned)' else @t end +''', Total = count(*) from dbo.'+@t+case when @t = 'PrgSection' then /**/ case when @m = 'LEGACYSPED.MAP_PrgSectionID_NonVersioned' then ' where VersionID is null ' else ' where VersionID is not null ' end /**/ else '' end + ''
exec (@q)


fetch T into @m, @t, @c
end
close T
deallocate T

insert #TEMP_ConversionCounts
select 'School (manual)' Tbl, count(*) tot from School where ManuallyEntered = 1
union all
select 'Student (manual)' Tbl, count(*) tot from Student where ManuallyEntered = 1

select * from #TEMP_ConversionCounts
drop table #TEMP_ConversionCounts
