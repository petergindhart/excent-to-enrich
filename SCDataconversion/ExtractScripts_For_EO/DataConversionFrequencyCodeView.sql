/*
-- update icservicetbl set Frequency = 'Three times per week' where IEPComplSeqnum = 13833 and ServSeqNum = 31955

declare @fuzzy varchar(100) ; set @fuzzy = '''Three %W%k%'' or Frequency like ''3%W%k%'''
print @fuzzy
*/

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
insert DataConversionFrequencyCode values ('SDE04', 'Three times per week', 'Three times per week')
insert DataConversionFrequencyCode values ('SDE05', 'Four times per week', 'Four times per week')
insert DataConversionFrequencyCode values ('SDE06', 'Weekly', 'Weekly')
insert DataConversionFrequencyCode values ('SDE07', 'Biweekly', 'Biweekly')
insert DataConversionFrequencyCode values ('SDE08', 'Monthly', 'Monthly')
insert DataConversionFrequencyCode values ('SDE09', 'Quarterly', 'Quarterly')
insert DataConversionFrequencyCode values ('SDE10', 'One semester', 'One semester')
insert DataConversionFrequencyCode values ('SDE11', 'Semester', 'Semester')
insert DataConversionFrequencyCode values ('SDE12', 'Yearly', 'Yearly')
insert DataConversionFrequencyCode values ('SDE13', 'One time', 'One time')
insert DataConversionFrequencyCode values ('SDE14', 'Two times', 'Two times')
insert DataConversionFrequencyCode values ('SDE15', 'Three times', 'Three times')
insert DataConversionFrequencyCode values ('SDE16', 'Four times', 'Four times')
insert DataConversionFrequencyCode values ('SDE17', 'Daily', 'Daily')
insert DataConversionFrequencyCode values ('SDE18', 'Consultation', 'Consultation')


if exists (select 1 from sys.objects where name = 'DataConversionFrequencyCodeView')
drop view DataConversionFrequencyCodeView
go

create view DataConversionFrequencyCodeView
as
with ServiceCTE as
(
	select v.IEPComplSeqNum, 
		v.ServSeqNum, 
		FrequencyCode = f.SDECode,
		FrequencyDesc = v.Frequency
	from DataConvICServiceTbl v
	left join DataConversionFrequencyCode f on v.Frequency = f.SDEDesc
)
 --get exact matches and fuzzy matches
select 
	IEPComplSeqNum = isnull(convert(varchar(10), v.IEPComplSeqNum), ''), 
	ServSeqNum = isnull(convert(varchar(10), v.ServSeqNum), ''), 
	OriginalFrequencyCode = v.FrequencyCode,
	 --Use original Code, if not, get code from Name match, if not get code from fuzzy match. 
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
	convert(varchar(10), v.IEPComplSeqNum), 
	convert(varchar(10), v.ServSeqNum), 
	OriginalFrequencyCode = v.FrequencyCode,
	FrequencyCode = isnull(v.FrequencyCode, 'ZZZ'),
	FrequencyDesc = case when v.FrequencyCode is null then 'Other' else v.FrequencyDesc end
from DataConversionServiceDefCode m
right join ServiceCTE v on -------------------------------- right join
	m.SDECode = v.FrequencyCode or 
	m.SDEDesc = v.FrequencyDesc or
	v.FrequencyDesc like m.FuzzyDesc
where m.SDECode is null ------ this is the trick!
go

--select OriginalFrequencyCode, FrequencyCode, FrequencyDesc, count(*) tot
--from DataConversionFrequencyCodeView
--group by OriginalFrequencyCode, FrequencyCode, FrequencyDesc
--order by case when FrequencyCode like 'SDE%' then 0 else 1 end, FrequencyCode
