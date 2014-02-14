
if exists (select 1 from sys.objects where name = 'DataConversionServiceDefCode')
drop table DataConversionServiceDefCode
go

create table DataConversionServiceDefCode (
SDECode	varchar(100) not null,
SDEDesc	varchar(100) not null,
FuzzyDesc varchar(100) not null
)
go

alter table DataConversionServiceDefCode 
	add constraint PK_DataConversionServiceDefCode_Code primary key (SDECode)
go

create index IX_DataConversionServiceDefCode_SDEDesc on DataConversionServiceDefCode (SDEDesc)
go

set nocount on;
insert DataConversionServiceDefCode values ('SDE01', 'Assistive Technology services', '%Assist%Tech%')
insert DataConversionServiceDefCode values ('SDE02', 'Audiological Services', '%Audiologic%')
insert DataConversionServiceDefCode values ('SDE03', 'Counseling', 'Counseling%')
insert DataConversionServiceDefCode values ('SDE04', 'Nursing Services', 'Nurs%')
insert DataConversionServiceDefCode values ('SDE05', 'Occupational Therapy', 'Occupation%')
insert DataConversionServiceDefCode values ('SDE06', 'Orientation and Mobility', '%Orient%Mobil%')
insert DataConversionServiceDefCode values ('SDE07', 'Physical Therapy', '%Phys%Ther%')
insert DataConversionServiceDefCode values ('SDE08', 'Rehabilitation Counseling', 'Rehab%')
insert DataConversionServiceDefCode values ('SDE09', 'Social Work Services', '%Social%Work%')
insert DataConversionServiceDefCode values ('SDE10', 'Transportation', '%Transportation%')
insert DataConversionServiceDefCode values ('SDE11', 'Speech-Language Services', '%Speech%')
insert DataConversionServiceDefCode values ('SDE12', 'Interpreting Services', '%Interp%')
insert DataConversionServiceDefCode values ('SDE13', 'Psychological Service', '%Psych%')
insert DataConversionServiceDefCode values ('SDE14', 'Recreation', '%Recreation%')
insert DataConversionServiceDefCode values ('SDE15', 'School Health Services', 'School%Health%')
insert DataConversionServiceDefCode values ('SDE16', 'Parent Counseling and Training', 'Parent%Couns%')
go


if exists (select 1 from sys.objects where name = 'DataConversionServiceDefCodeView')
drop view DataConversionServiceDefCodeView
go

create view DataConversionServiceDefCodeView
as
with ServiceCTE as
(
	select v.IEPComplSeqNum, 
		v.ServSeqNum, 
		ServCode = case when v.ServCode like 'SDE%' then v.ServCode else NULL end, 
		v.ServDesc, 
		v.Type
	from SpecialEdStudentsAndIEPs x 
	join ICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum 
		and isnull(v.del_flag,0)=0 
--		and v.Type = 'R'
)
-- get exact matches and fuzzy matches
select 
	--Match = 'Match 1',
	IEPComplSeqNum = isnull(convert(varchar(10), v.IEPComplSeqNum), ''), 
	ServSeqNum = isnull(convert(varchar(10), v.ServSeqNum), ''), 
	OriginalServCode = v.ServCode,
	-- Use original Code, if not, get code from Name match, if not get code from fuzzy match. 
	ServCode = coalesce(
		v.ServCode, 
		case when v.ServCode is null and m.SDEDesc = v.ServDesc then m.SDECode else NULL end,
		case when not (m.SDECode = isnull(v.ServCode,'') or m.SDEDesc = isnull(v.ServDesc,'')) and v.ServDesc like m.FuzzyDesc then m.SDECode else NULL end
		),
	ServDesc = v.ServDesc,
	v.Type
from DataConversionServiceDefCode m
join ServiceCTE v on 
	m.SDECode = v.ServCode or 
	m.SDEDesc = v.ServDesc or
	v.ServDesc like m.FuzzyDesc
where v.Type = 'R'

union all

select 
	--Match = 'Match 2',
	convert(varchar(10), v.IEPComplSeqNum), 
	convert(varchar(10), v.ServSeqNum), 
	OriginalServCode = v.ServCode,
	ServCode = isnull(v.ServDesc, 'ZZZ'),
	ServDesc = isnull(v.ServDesc, 'Not Provided'),
	v.Type
from DataConversionServiceDefCode m
right join ServiceCTE v on -------------------------------- right join
	m.SDECode = v.ServCode or 
	m.SDEDesc = v.ServDesc or
	v.ServDesc like m.FuzzyDesc
where v.Type = 'R'
and m.SDECode is null ------ this is the trick!

union all

-- SPECIAL ED SERVICES
select 
	--Match = 'Match 3',
	v.IEPComplSeqNum,
	v.ServSeqNum,
	OriginalServCode = v.ServCode,
	ServCode = isnull(v.ServDesc, 'ZZZ'),
	ServDesc = v.ServDesc,
	v.Type
from SpecialEdStudentsAndIEPs x
join ICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum and isnull(v.del_flag,0)=0
where Type = 'S'
go

