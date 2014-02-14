


if exists (select 1 from sys.objects where name = 'DataConversionFrequencyCode')
drop table DataConversionFrequencyCode
go

create table DataConversionFrequencyCode (
SDECode	varchar(100) not null,
SDEDesc	varchar(100) not null,
FuzzyDesc varchar(100) not null
)
go

alter table DataConversionFrequencyCode 
	add constraint PK_DataConversionFrequencyCode_Code primary key (SDECode)
go

create index IX_DataConversionFrequencyCode_SDEDesc on DataConversionFrequencyCode (SDEDesc)
go

set nocount on;
insert DataConversionFrequencyCode values ('SDE01', 'Twice Daily', 'Twice Daily')
insert DataConversionFrequencyCode values ('SDE02', 'Alternating days as per schedule', 'Alternat% days%')
insert DataConversionFrequencyCode values ('SDE03', 'Twice weekly', 'Twice weekly')
insert DataConversionFrequencyCode values ('SDE04', 'Three times per week', '[Three|3] times per week')
insert DataConversionFrequencyCode values ('SDE05', '', '')
insert DataConversionFrequencyCode values ('SDE06', '', '')
insert DataConversionFrequencyCode values ('SDE07', '', '')
insert DataConversionFrequencyCode values ('SDE08', '', '')
insert DataConversionFrequencyCode values ('SDE09', '', '')
insert DataConversionFrequencyCode values ('SDE10', '', '')
insert DataConversionFrequencyCode values ('SDE11', '', '')
insert DataConversionFrequencyCode values ('SDE12', '', '')
insert DataConversionFrequencyCode values ('SDE13', '', '')
insert DataConversionFrequencyCode values ('SDE14', '', '')
insert DataConversionFrequencyCode values ('SDE15', '', '')
insert DataConversionFrequencyCode values ('SDE16', '', '')
insert DataConversionFrequencyCode values ('SDE17', '', '')
insert DataConversionFrequencyCode values ('SDE18', '', '')

-- update icservicetbl set Frequency = 'Three times per week' where IEPComplSeqnum = 13833 and ServSeqNum = 31955

declare @fuzzy varchar(100) ; set @fuzzy = '''Three %W%k%'' or Frequency like ''3%W%k%'''
print @fuzzy
--SDE04	
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE04', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency like @Fuzzy

-- where isnull(del_flag,0)=0 and Frequency not like '%min%' and Frequency not like '%h%r[s]%' and  (Frequency like 'Three%W%k%' or Frequency like '3%W%k%')
-- and iepcomplseqnum = 13833

union all
--SDE05	Four times per week
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE05', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency not like '%min%' and Frequency not like '%h%r%s%' and  (Frequency like 'Four%W%k%' or Frequency like '4%W%k%')
union all
--SDE06	Weekly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE06', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Weekly'
union all
--SDE07	Biweekly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE07', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency like 'Bi%weekly'
union all
--SDE08	Monthly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE08', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Monthly'
union all
--SDE09	Quarterly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE09', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Quarterly'
union all
--SDE10	One semester
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE10', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('One semester', '1 semester')
union all
--SDE11	Semester
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE11', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Semester'
union all
--SDE12	Yearly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE12', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Yearly'
union all
--SDE13	One time
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE13', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('One time', 'Once')
union all
--SDE14	Two times
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE14', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Two times', 'Twice', '2x')
union all
--SDE15	Three times
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE15', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Three times', '3x')
union all
--SDE16	Four times
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE16', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Four times', '4x')
union all
--SDE17	Daily
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE17', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Daily', 'Every day')
union all
--SDE18	Consultation
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE18', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency like 'Consult%'





if exists (select 1 from sys.objects where name = 'DataConversionFrequencyCodeView')
drop view DataConversionFrequencyCodeView
go

create view DataConversionFrequencyCodeView
as
with ServiceCTE as
(
	select v.IEPComplSeqNum, 
		v.ServSeqNum, 
		FrequencyCode = case when v.FrequencyCode like 'SDE%' then v.FrequencyCode else NULL end, 
		v.FrequencyDesc
	from DataConvICServiceTbl v
)
 get exact matches and fuzzy matches
select 
	Match = 'Match 1',
	IEPComplSeqNum = isnull(convert(varchar(10), v.IEPComplSeqNum), ''), 
	ServSeqNum = isnull(convert(varchar(10), v.ServSeqNum), ''), 
	OriginalFrequencyCode = v.FrequencyCode,
	 Use original Code, if not, get code from Name match, if not get code from fuzzy match. 
	FrequencyCode = coalesce(
		v.FrequencyCode, 
		case when v.FrequencyCode is null and m.SDEDesc = v.FrequencyDesc then m.SDECode else NULL end,
		case when not (m.SDECode = isnull(v.FrequencyCode,'') or m.SDEDesc = isnull(v.FrequencyDesc,'')) and v.FrequencyDesc like m.FuzzyDesc then m.SDECode else NULL end
		),
	v.FrequencyDesc
from DataConversionServiceDefCode m
join ServiceCTE v on 
	m.SDECode = v.FrequencyCode or 
	m.SDEDesc = v.FrequencyDesc or
	v.FrequencyDesc like m.FuzzyDesc

union all

select 
	Match = 'Match 2',
	convert(varchar(10), v.IEPComplSeqNum), 
	convert(varchar(10), v.ServSeqNum), 
	OriginalFrequencyCode = v.FrequencyCode,
	FrequencyCode = isnull(v.FrequencyDesc, 'ZZZ'),
	FrequencyDesc = isnull(v.FrequencyDesc, 'Not Provided')
from DataConversionServiceDefCode m
right join ServiceCTE v on -------------------------------- right join
	m.SDECode = v.FrequencyCode or 
	m.SDEDesc = v.FrequencyDesc or
	v.FrequencyDesc like m.FuzzyDesc
where m.SDECode is null ------ this is the trick!













if exists (select 1 from sys.objects where name = 'DataConversionFrequencyCodeView')
drop view DataConversionFrequencyCodeView
go

create view DataConversionFrequencyCodeView
as
select t.IEPComplSeqNum, t.ServSeqNum, k.FrequencyCode, k.FrequencyDesc
from (
--SDE01	Twice daily
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE01', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Twice Daily'
union all
--SDE02	Alternating days as per schedu
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE02', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency like 'Alternat%Da%'
union all
--SDE03	Twice weekly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE03', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Twice Weekly'
union all
--SDE04	Three times per week
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE04', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency not like '%min%' and Frequency not like '%h%r%s%' and  (Frequency like 'Three%W%k%' or Frequency like '3%W%k%')
union all
--SDE05	Four times per week
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE05', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency not like '%min%' and Frequency not like '%h%r%s%' and  (Frequency like 'Four%W%k%' or Frequency like '4%W%k%')
union all
--SDE06	Weekly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE06', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Weekly'
union all
--SDE07	Biweekly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE07', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency like 'Bi%weekly'
union all
--SDE08	Monthly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE08', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Monthly'
union all
--SDE09	Quarterly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE09', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Quarterly'
union all
--SDE10	One semester
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE10', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('One semester', '1 semester')
union all
--SDE11	Semester
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE11', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Semester'
union all
--SDE12	Yearly
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE12', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency = 'Yearly'
union all
--SDE13	One time
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE13', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('One time', 'Once')
union all
--SDE14	Two times
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE14', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Two times', 'Twice', '2x')
union all
--SDE15	Three times
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE15', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Three times', '3x')
union all
--SDE16	Four times
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE16', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Four times', '4x')
union all
--SDE17	Daily
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE17', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency in ('Daily', 'Every day')
union all
--SDE18	Consultation
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'SDE18', Frequency
from ICServiceTbl 
where isnull(del_flag,0)=0 and Frequency like 'Consult%'
) t
join SpecialEdStudentsAndIEPs x on t.IEPComplSeqNum = x.IEPSeqNum
left join (
select FrequencyCode = cast('SDE01' as varchar(150)), FrequencyDesc = cast('Twice daily' as varchar(255))
union all
select 'SDE02', 'Alternating days as per schedule' 
union all
select 'SDE03', 'Twice weekly' 
union all
select 'SDE04', 'Three times per week' 
union all
select 'SDE05', 'Four times per week' 
union all
select 'SDE06', 'Weekly' 
union all
select 'SDE07', 'Biweekly' 
union all
select 'SDE08', 'Monthly' 
union all
select 'SDE09', 'Quarterly' 
union all
select 'SDE10', 'One semester' 
union all
select 'SDE11', 'Semester' 
union all
select 'SDE12', 'Yearly' 
union all
select 'SDE13', 'One time' 
union all
select 'SDE14', 'Two times' 
union all
select 'SDE15', 'Three times' 
union all
select 'SDE16', 'Four times' 
union all
select 'SDE17', 'Daily' 
union all
select 'SDE18', 'Consultation' 
) k on t.FrequencyCode = k.FrequencyCode
union all
--all criteria above, negated
select IEPComplSeqNum, ServSeqNum, FrequencyCode = 'ZZZ', Frequency = 'Manually Entered Frequency'
from ICServiceTbl v
--join SpecialEdStudentsAndIEPs x on v.IEPComplSeqNum = x.IEPSeqNum			-- does not provide benefit and slows query down.
where not (Frequency = 'Twice Daily')
and not (Frequency like 'Alternat%Da%')
and not (Frequency = 'Twice Weekly')
and not (Frequency not like '%min%' and Frequency not like '%h%r%s%' and  (Frequency like 'Three%W%k%' or Frequency like '3%W%k%'))
and not (Frequency not like '%min%' and Frequency not like '%h%r%s%' and  (Frequency like 'Four%W%k%' or Frequency like '4%W%k%'))
and not (Frequency = 'Weekly')
and not (Frequency like 'Bi%weekly')
and not (Frequency = 'Monthly')
and not (Frequency = 'Quarterly')
and not (Frequency in ('One semester', '1 semester'))
and not (Frequency = 'Semester')
and not (Frequency = 'Yearly')
and not (Frequency in ('One time', 'Once'))
and not (Frequency in ('Two times', 'Twice', '2x'))
and not (Frequency in ('Three times', '3x'))
and not (Frequency in ('Four times', '4x'))
and not (Frequency in ('Daily', 'Every day'))
and not (Frequency like 'Consult%')
go
