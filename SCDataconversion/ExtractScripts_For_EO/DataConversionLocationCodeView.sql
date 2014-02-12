if exists (select 1 from sys.objects where name = 'DataConversionLocationCodeView')
drop view DataConversionLocationCodeView
go

create view DataConversionLocationCodeView
as
select t.IEPComplSeqNum, t.ServSeqNum, k.LocationCode, k.LocationDesc
from (
	--SDE01	Behavior Health Counselor Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE01'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Behavior %'
	union all
	--SDE02	Bus/District Transportation
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE02'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Bus%'
	union all
	--SDE03	Cafeteria
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE03'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Cafeteria%'
	union all
	--SDE04	Community
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE04'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Community%'
	union all
	--SDE05	General Education Classroom
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE05'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Gen% Ed%'
	union all
	--SDE06	Guidance Counselor Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE06'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Guid% Couns%'
	union all
	--SDE07	Home
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE07'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Home%'
	union all
	--SDE08	Nurse's Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE08'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Nurse%'
	union all
	--SDE09	Occupational Therapy Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE09'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Occu% Ther%'
	union all
	--SDE10	Physical Therapy Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE10'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Phys% Ther%'
	union all
	--SDE11	School Environment
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE11'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Sch% Env%'
	union all
	--SDE12	Special Education Classroom
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE12'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc = 'Special Education Classroom'
	union all
	--SDE13	Special Education Support Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE13'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc = 'Special Education Support Room'
	union all
	--SDE14	Speech Therapy Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE14'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Speech Ther%'
	union all
	--SDE15	Therapy Room
	select IEPComplSeqNum, ServSeqNum, LocationCode = 'SDE15'
	from ICServiceTbl 
	where isnull(del_flag,0)=0 and LocationDesc like 'Therapy R%'
) t
join SpecialEdStudentsAndIEPs x on t.IEPComplSeqNum = x.IEPSeqNum
join (
	select LocationCode = cast('SDE01' as varchar(150)), LocationDesc = cast('Behavior Health Counselor Room' as varchar(255))
	union all
	select 'SDE02', 'Bus/District Transportation' 
	union all
	select 'SDE03', 'Cafeteria' 
	union all
	select 'SDE04', 'Community' 
	union all
	select 'SDE05', 'General Education Classroom' 
	union all
	select 'SDE06', 'Guidance Counselor Room' 
	union all
	select 'SDE07', 'Home' 
	union all
	select 'SDE08', 'Nurse''s Room' 
	union all
	select 'SDE09', 'Occupational Therapy Room' 
	union all
	select 'SDE10', 'Physical Therapy Room' 
	union all
	select 'SDE11', 'School Environment' 
	union all
	select 'SDE12', 'Special Education Classroom' 
	union all
	select 'SDE13', 'Special Education Support Room' 
	union all
	select 'SDE14', 'Speech Therapy Room' 
	union all
	select 'SDE15', 'Therapy Room' 
) k on t.LocationCode = k.LocationCode
union all
select IEPComplSeqNum, ServSeqNum, LocationCode = convert(varchar(150), LocationDesc), LocationDesc
from SpecialEdStudentsAndIEPs x
join ICServiceTbl v on x.IEPSeqNum = v.IEPComplSeqNum
where isnull(del_flag,0)=0 
	and LocationDesc not like 'Behavior %'
	and LocationDesc not like 'Bus%'
	and LocationDesc not like 'Cafeteria%'
	and LocationDesc not like 'Community%'
	and LocationDesc not like 'Gen% Ed%'
	and LocationDesc not like 'Guid% Couns%'
	and LocationDesc not like 'Home%'
	and LocationDesc not like 'Nurse%'
	and LocationDesc not like 'Occu% Ther%'
	and LocationDesc not like 'Phys% Ther%'
	and LocationDesc not like 'Sch% Env%'
	and LocationDesc <> 'Special Education Classroom'
	and LocationDesc <> 'Special Education Support Room'
	and LocationDesc not like 'Speech Ther%'
	and LocationDesc not like 'Therapy R%'
go
