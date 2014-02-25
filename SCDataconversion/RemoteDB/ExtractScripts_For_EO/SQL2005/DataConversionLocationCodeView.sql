

if exists (select 1 from sys.objects where name = 'DataConversionLocationCode')
drop table DataConversionLocationCode
go

create table DataConversionLocationCode (
SDECode	varchar(100) not null,
SDEDesc	varchar(100) not null,
FuzzyDesc varchar(100) not null
)
go

alter table DataConversionLocationCode 
	add constraint PK_DataConversionLocationCode_Code primary key (SDECode)
go

create index IX_DataConversionLocationCode_SDEDesc on DataConversionLocationCode (SDEDesc)
go

set nocount on;
insert DataConversionLocationCode values ('SDE01', 'Behavior Health Counselor Room', 'Behavior %')
insert DataConversionLocationCode values ('SDE02', 'Bus/District Transportation', 'Bus%')
insert DataConversionLocationCode values ('SDE03', 'Cafeteria', 'Cafeteria%')
insert DataConversionLocationCode values ('SDE04', 'Community', 'Community%')
insert DataConversionLocationCode values ('SDE05', 'General Education Classroom', 'Gen% Ed%')
insert DataConversionLocationCode values ('SDE06', 'Guidance Counselor Room', 'Guid% Couns%')
insert DataConversionLocationCode values ('SDE07', 'Home', 'Home%')
insert DataConversionLocationCode values ('SDE08', 'Nurse''s Room', 'Nurse%')
insert DataConversionLocationCode values ('SDE09', 'Occupational Therapy Room', 'Occu% Ther%')
insert DataConversionLocationCode values ('SDE10', 'Physical Therapy Room', 'Phys% Ther%')
insert DataConversionLocationCode values ('SDE11', 'School Environment', 'Sch% Env%')
insert DataConversionLocationCode values ('SDE12', 'Special Education Classroom', 'Special Education Classroom')
insert DataConversionLocationCode values ('SDE13', 'Special Education Support Room', 'Special Education Support Room')
insert DataConversionLocationCode values ('SDE14', 'Speech Therapy Room', 'Speech Ther%')
insert DataConversionLocationCode values ('SDE15', 'Therapy Room', 'Therapy R%')



if exists (select 1 from sys.objects where name = 'DataConversionLocationCodeView')
drop view DataConversionLocationCodeView
go

create view DataConversionLocationCodeView
as
with ServiceCTE as
(
	select v.IEPComplSeqNum, 
		v.ServSeqNum, 
		LocationCode = case when v.LocationCode like 'SDE%' then v.LocationCode else NULL end, 
		v.LocationDesc
	from DataConvICServiceTbl v
)
-- get exact matches and fuzzy matches
select 
	--Match = 'Match 1',
	IEPComplSeqNum = isnull(convert(varchar(10), v.IEPComplSeqNum), ''), 
	ServSeqNum = isnull(convert(varchar(10), v.ServSeqNum), ''), 
	OriginalLocationCode = v.LocationCode,
	-- Use original Code, if not, get code from Name match, if not get code from fuzzy match. 
	LocationCode = coalesce(
		v.LocationCode, 
		case when v.LocationCode is null and m.SDEDesc = v.LocationDesc then m.SDECode else NULL end,
		case when not (m.SDECode = isnull(v.LocationCode,'') or m.SDEDesc = isnull(v.LocationDesc,'')) and v.LocationDesc like m.FuzzyDesc then m.SDECode else NULL end
		),
	LocationDesc = ISNULL(m.SDEDesc,v.LocationDesc)
from DataConversionLocationCode m
join ServiceCTE v on 
	m.SDECode = v.LocationCode or 
	m.SDEDesc = v.LocationDesc or
	v.LocationDesc like m.FuzzyDesc
where m.SDECode is not null

union all

select 
	--Match = 'Match 2',
	convert(varchar(10), v.IEPComplSeqNum), 
	convert(varchar(10), v.ServSeqNum), 
	OriginalLocationCode = v.LocationCode,
	LocationCode = isnull(v.LocationDesc, 'ZZZ'),
	LocationDesc = isnull(v.LocationDesc, 'Not Provided')
from DataConversionLocationCode m
right join ServiceCTE v on -------------------------------- right join
	m.SDECode = v.LocationCode or 
	m.SDEDesc = v.LocationDesc or
	v.LocationDesc like m.FuzzyDesc
where m.SDECode is null ------ this is the trick!

/*

select OriginalLocationCode, LocationCode, LocationDesc, count(*) tot
from DataConversionLocationCodeView
group by OriginalLocationCode, LocationCode, LocationDesc
order by case when LocationCode like 'SDE%' then 0 else 1 end, LocationCode

select count(*) from DataConversionLocationCodeView -- 6652
select count(*) from DataConversionServiceDefCodeView -- 6652

*/




