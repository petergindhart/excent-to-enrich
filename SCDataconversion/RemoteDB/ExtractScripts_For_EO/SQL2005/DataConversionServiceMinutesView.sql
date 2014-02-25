
if exists (select 1 from sys.objects where name = 'DataConversionServiceMinutes')
drop table DataConversionServiceMinutes
go

create table DataConversionServiceMinutes (
SDECode	varchar(100) not null,
SDEDesc	varchar(100) not null,
FuzzyDesc varchar(100) not null,
Minutes	int	NULL
)
go

alter table DataConversionServiceMinutes 
	add constraint PK_DataConversionServiceMinutes_Code primary key (SDECode)
go

create index IX_DataConversionServiceMinutes_SDEDesc on DataConversionServiceMinutes (SDEDesc)
go

set nocount on;
insert DataConversionServiceMinutes values ('SDE01', '1 period', '1 period', NULL)
insert DataConversionServiceMinutes values ('SDE02', '2 periods', '2 periods', NULL)
insert DataConversionServiceMinutes values ('SDE03', '3 periods', '3 periods', NULL)
insert DataConversionServiceMinutes values ('SDE04', '5 minutes', '5 minutes', 5)
insert DataConversionServiceMinutes values ('SDE05', '10 minutes', '10 minutes', 10)
insert DataConversionServiceMinutes values ('SDE06', '15 minutes', '15 minutes', 15)
insert DataConversionServiceMinutes values ('SDE07', '20 minutes', '20 minutes', 20)
insert DataConversionServiceMinutes values ('SDE08', '30 minutes', '30 minutes', 30)
insert DataConversionServiceMinutes values ('SDE09', '40 minutes', '40 minutes', 40)
insert DataConversionServiceMinutes values ('SDE10', '45 minutes', '45 minutes', 45)
insert DataConversionServiceMinutes values ('SDE11', '50 minutes', '50 minutes', 50)
insert DataConversionServiceMinutes values ('SDE12', '1 hour', '1 hour', 60)
insert DataConversionServiceMinutes values ('SDE13', '1 1/4 hours', '1 1/4 hours', 75)
insert DataConversionServiceMinutes values ('SDE14', '1 1/2 hours', '1 1/2 hours', 90)
insert DataConversionServiceMinutes values ('SDE15', '2 hours', '2 hours', 120)
insert DataConversionServiceMinutes values ('SDE16', '2 1/2 hours', '2 1/2 hours', 150)
insert DataConversionServiceMinutes values ('SDE17', '3 hours', '3 hours', 180)
insert DataConversionServiceMinutes values ('SDE18', '1 quarter', '1 quarter', NULL)
insert DataConversionServiceMinutes values ('SDE19', '1 semester', '1 semester', NULL)
insert DataConversionServiceMinutes values ('SDE20', 'Len:', '[0-9]% Minutes', NULL)

if exists (select 1 from sys.objects where name = 'DataConversionServiceMinutesView')
drop view DataConversionServiceMinutesView
go

create view DataConversionServiceMinutesView
as
with ServiceCTE as
(
	select v.IEPComplSeqNum, 
		v.ServSeqNum, 
		LengthCode = m.SDECode,
		LengthDesc = v.Length,
		m.Minutes
	from DataConvICServiceTbl v
	left join DataConversionServiceMinutes m on v.Length = m.SDEDesc
)
 --get exact matches and fuzzy matches
select 
	IEPComplSeqNum = isnull(convert(varchar(10), v.IEPComplSeqNum), ''), 
	ServSeqNum = isnull(convert(varchar(10), v.ServSeqNum), ''), 
	OriginalLengthCode = v.LengthCode,
	 --Use original Code, if not, get code from Name match, if not get code from fuzzy match. 
	LengthCode = coalesce(
		v.LengthCode, 
		case when v.LengthCode is null and m.SDEDesc = v.LengthDesc then m.SDECode else NULL end,
		case when not (m.SDECode = isnull(v.LengthCode,'') or m.SDEDesc = isnull(v.LengthDesc,'')) and v.LengthDesc like m.FuzzyDesc then m.SDECode else NULL end
		),
	v.LengthDesc,
	Minutes = 
		case when coalesce(v.LengthCode, case when v.LengthCode is null and m.SDEDesc = v.LengthDesc then m.SDECode else NULL end, case when not (m.SDECode = isnull(v.LengthCode,'') or m.SDEDesc = isnull(v.LengthDesc,'')) and v.LengthDesc like m.FuzzyDesc then m.SDECode else NULL end) != 'SDE20' then v.Minutes 
		else case when
			(v.LengthDesc like '[0-9] Minutes' or v.LengthDesc like '[0-9][0-9] Minutes' or v.LengthDesc like '[0-9][0-9][0-9] Minutes') 
			then left(v.LengthDesc, patindex('% %', v.LengthDesc)-1)
			else NULL end
		end
from DataConversionServiceMinutes m
join ServiceCTE v on 
	m.SDECode = v.LengthCode or 
	m.SDEDesc = v.LengthDesc or
	v.LengthDesc like m.FuzzyDesc

union all

select 
	convert(varchar(10), v.IEPComplSeqNum), 
	convert(varchar(10), v.ServSeqNum), 
	OriginalLengthCode = v.LengthCode,
	LengthCode = isnull(v.LengthCode, 'ZZZ'),
	LengthDesc = case when v.LengthCode is null then 'Other' else v.LengthDesc end,
	Minutes = cast(NULL as int)
from DataConversionServiceMinutes m
right join ServiceCTE v on -------------------------------- right join
	m.SDECode = v.LengthCode or 
	m.SDEDesc = v.LengthDesc or
	v.LengthDesc like m.FuzzyDesc
where m.SDECode is null ------ this is the trick!
go


--select match, LengthCode, LengthDesc, Minutes, count(*) tot
--from DataConversionServiceMinutesView
--group by match, LengthCode, LengthDesc, Minutes
--order by case when LengthCode like 'SDE%' then 0 else 1 end, LengthCode




--declare @lengthdesc varchar(100) ; set @lengthdesc = '100 minutes'
--select left(@LengthDesc, patindex('% %', @LengthDesc)-1)

