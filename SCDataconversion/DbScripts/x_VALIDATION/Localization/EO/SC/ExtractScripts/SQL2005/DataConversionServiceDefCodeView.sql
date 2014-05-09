

-----------   THIS VIEW HAS CHANGED - SEE THE CODE BELOW --- GG 20140405


---- 20140405 -- it has been decided to update the ServCode in the EO database, so no fuzzy matches needed


if exists (select 1 from sys.objects where name = 'DataConversionServiceDefCode')
drop table DataConversionServiceDefCode
go

create table DataConversionServiceDefCode (
SDECode	varchar(100) not null,
SDEDesc	varchar(100) not null,
)
go

alter table DataConversionServiceDefCode 
	add constraint PK_DataConversionServiceDefCode_Code primary key (SDECode)
go

create index IX_DataConversionServiceDefCode_SDEDesc on DataConversionServiceDefCode (SDEDesc)
go

set nocount on;
insert DataConversionServiceDefCode values ('SDE01', 'Assistive Technology services')
insert DataConversionServiceDefCode values ('SDE02', 'Audiological Services')
insert DataConversionServiceDefCode values ('SDE03', 'Counseling')
insert DataConversionServiceDefCode values ('SDE04', 'Nursing Services')
insert DataConversionServiceDefCode values ('SDE05', 'Occupational Therapy')
insert DataConversionServiceDefCode values ('SDE06', 'Orientation and Mobility')
insert DataConversionServiceDefCode values ('SDE07', 'Physical Therapy')
insert DataConversionServiceDefCode values ('SDE08', 'Rehabilitation Counseling')
insert DataConversionServiceDefCode values ('SDE09', 'Social Work Services')
insert DataConversionServiceDefCode values ('SDE10', 'Transportation')
insert DataConversionServiceDefCode values ('SDE11', 'Speech-Language Services')
insert DataConversionServiceDefCode values ('SDE12', 'Interpreting Services')
insert DataConversionServiceDefCode values ('SDE13', 'Psychological Service')
insert DataConversionServiceDefCode values ('SDE14', 'Recreation')
insert DataConversionServiceDefCode values ('SDE15', 'School Health Services')
insert DataConversionServiceDefCode values ('SDE16', 'Parent Counseling and Training')
insert DataConversionServiceDefCode values ('SES08', 'Speech and Language (Specialized Instruction)')
go

if exists (select 1 from sys.objects where name = 'DataConversionServiceDefCodeView')
drop view DataConversionServiceDefCodeView
go

create view DataConversionServiceDefCodeView
as
select 
	v.IEPComplSeqNum, 
	v.ServSeqNum, 
	OriginalServCode = v.ServCode,
	ServCode = 
		case when (v.ServCode like 'SDE%' or v.ServCode like 'SES%') then v.ServCode else cast(isnull(v.ServDesc,'ZZZ') as varchar(150)) end, 
	ServDesc = case when (v.ServCode like 'SDE%' or v.ServCode like 'SES%') then c.SDEDEsc else v.ServDesc end, 
	v.Type
from DataConvICServiceTbl v
left join DataConversionServiceDefCode c on v.servcode = c.SDECode 
union all
-- supplementary services in EO do not look like services in EO, but they're going to the same place in Enrich
select ss.IEPComplSeqNum, 
	ServSeqNum = IEPSuppServSeq + 9000000,  --- we must ensure uniqueness. avoid possible duplicate with ICServiceTbl.ServSeqNum
	-- note that it will be necessary to test Type in Transform_Service when using this view to import supp svcs.
	OriginalServCode = cast(NULL as varchar(150)), 
	ServCode = cast(convert(varchar(max), service) as varchar(150)), 
	ServDesc = cast(convert(varchar(max), service) as varchar(150)),
	Type = cast('U' as char(1))
from ICIEPSuppServTbl_SC ss 
join specialedstudentsandieps x on ss.iepcomplseqnum = x.iepseqnum
where isnull(ss.del_flag,0)=0
and convert(varchar(max), service) not in ('NA', 'none', 'N/A')
and convert(varchar(max), service) not like 'Not Appl%'
go







--with ServiceCTE as
--(
--	select v.IEPComplSeqNum, 
--		v.ServSeqNum, 
--		ServCode = 
--			case when (v.ServCode like 'SDE%' or v.ServCode like 'SES%') then v.ServCode else cast(isnull(v.ServDesc,'ZZZ') as varchar(150)) end, 
--		v.ServDesc, 
--		v.Type
--	from DataConvICServiceTbl v
--)
---- get exact matches and fuzzy matches
--select 
--	--Match = 'Match 1',
--	IEPComplSeqNum = isnull(convert(varchar(10), v.IEPComplSeqNum), ''), 
--	ServSeqNum = isnull(convert(varchar(10), v.ServSeqNum), ''), 
---- 	OriginalServCode = v.ServCode,
--	-- Use original Code, if not, get code from Name match, if not get code from fuzzy match. 
--	ServCode = coalesce(
--		v.ServCode, 
--		case when v.ServCode is null and m.SDEDesc = v.ServDesc then m.SDECode else NULL end,
--		case when not (m.SDECode = isnull(v.ServCode,'') or m.SDEDesc = isnull(v.ServDesc,'')) and v.ServDesc like m.FuzzyDesc then m.SDECode else NULL end
--		),
--	ServDesc = isnull(m.SDEDesc,v.ServDesc),  --v.ServDesc), changed to avoid duplicate!
--	v.Type
--from DataConversionServiceDefCode m
--join ServiceCTE v on 
--	m.SDECode = v.ServCode or 
--	m.SDEDesc = v.ServDesc or
--	v.ServDesc like m.FuzzyDesc
--where v.Type = 'R'
--and m.SDECode is not null

--union all

--select 
--	--Match = 'Match 2',
--	convert(varchar(10), v.IEPComplSeqNum), 
--	convert(varchar(10), v.ServSeqNum), 
--	OriginalServCode = v.ServCode,
--	ServCode = isnull(v.ServDesc, 'ZZZ'),
--	ServDesc = isnull(v.ServDesc, 'Not Provided'),
--	v.Type
--from DataConversionServiceDefCode m
--right join ServiceCTE v on -------------------------------- right join
--	m.SDECode = v.ServCode or 
--	m.SDEDesc = v.ServDesc or
--	v.ServDesc like m.FuzzyDesc
--where v.Type = 'R'
--and m.SDECode is null ------ this is the trick!

--union all

---- SPECIAL ED SERVICES
--select 
--	--Match = 'Match 3',
--	v.IEPComplSeqNum,
--	v.ServSeqNum,
--	OriginalServCode = v.ServCode,
--	ServCode = isnull(v.ServDesc, 'ZZZ'),
--	ServDesc = v.ServDesc,
--	v.Type
--from DataConvICServiceTbl v
--where v.Type = 'S'
--go





