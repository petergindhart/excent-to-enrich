if exists (select 1 from sys.objects where name = 'DataConversionServiceDefCodeView')
drop view DataConversionServiceDefCodeView
go

create view DataConversionServiceDefCodeView
as
-- RELATED SERVICES
--select t.IEPComplSeqNum, t.ServSeqNum, ServCode = k.Code, ServDesc = k.LookDesc, Type = 'R'
select t.IEPComplSeqNum, t.ServSeqNum, k.ServCode, k.ServDesc, Type = 'R'
from (
select IEPComplSeqNum, ServSeqNum, ServCode
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and ServCode like 'SDE%'
union all
--SDE01	Assistive Technology services
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE01'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Assist% Tech%'
union all
--SDE02	Audiological Services
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE02'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Audio% S%'
union all
--SDE04	Nursing Services
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE04'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Nurs%'
union all
--SDE05	Occupational Therapy
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE05'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Occup%'
union all
--SDE06	Orientation and Mobility
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE06'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Orienta%'
union all
--SDE07	Physical Therapy
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE07'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Physical%'
union all
--SDE10	Transportation
select IEPComplSeqNum, ServSeqNum, ServCode = 'SDE10'
from ICServiceTbl 
where Type = 'R' and isnull(del_flag,0)=0 and isnull(ServCode,'') not like 'SDE%' and ServDesc like 'Transport%'
) t
join SpecialEdStudentsAndIEPs x on t.IEPComplSeqNum = x.IEPSeqNum
--join CodeDescLook k on t.ServCode = k.Code and k.UsageID = 'IEPServiceSC' --- for some reason this is much slower than a derived table
join (
select ServCode = 'SDE01', ServDesc = 'Assistive Technology services'
union all
select ServCode = 'SDE02', 'Audiological Services'
union all
select ServCode = 'SDE04', 'Nursing Services'
union all
select ServCode = 'SDE05', 'Occupational Therapy'
union all
select ServCode = 'SDE06', 'Orientation and Mobility'
union all
select ServCode = 'SDE07', 'Physical Therapy'
union all
select ServCode = 'SDE10', 'Transportation'
) k on t.ServCode = k.ServCode

union all

select 
	k.IEPComplSeqNum, 
	k.ServSeqNum,
	ServCode = convert(varchar(150), isnull(k.ServDesc, 'ZZZ')), 
	ServDesc = isnull(k.ServDesc, 'No Descripion Provided'),
	k.Type
from ICServiceTbl k
join SpecialEdStudentsAndIEPs x on k.IEPComplSeqNum = x.IEPSeqNum
where Type = 'R' 
and isnull(ServCode,'') not like 'SDE%'
and isnull(ServDesc,'') not like 'Assist% Tech%'
and isnull(ServDesc,'') not like 'Audio% S%'
and isnull(ServDesc,'') not like 'Nurs%'
and isnull(ServDesc,'') not like 'Occup%'
and isnull(ServDesc,'') not like 'Orienta%'
and isnull(ServDesc,'') not like 'Physical%'
and isnull(ServDesc,'') not like 'Transport%'
and isnull(del_flag,0)=0

union all

-- SPECIAL ED SERVICES
select 
	v.IEPComplSeqNum,
	v.ServSeqNum,
	ServCode = convert(varchar(150), isnull(v.ServDesc, 'ZZZ')), 
	v.ServDesc,
	v.Type
from SpecialEdStudentsAndIEPs x
join ICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum and isnull(v.del_flag,0)=0
where Type = 'S'
go

