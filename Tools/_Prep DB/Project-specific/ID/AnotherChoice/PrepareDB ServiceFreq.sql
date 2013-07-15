set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '71590A00-2C40-40FF-ABD9-E73B09AF46A1', 'D5', 'daily')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '3D4B557B-0C2E-4A41-9410-BA331F1D20DD', 'M4', 'monthly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, 'A2080478-1A03-4928-905B-ED25DEC259E6', 'W1', 'weekly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '25F0F5BE-AEC6-4E16-B694-E51F089B5FBF', 'W2', 'bi-monthly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '5F3A2822-56F3-49DA-9592-F604B0F202C3', 'Y36', 'yearly')


--===================================================================================================
--						ServFreq
--===================================================================================================
select * from @SelectLists where Type ='ServFreq'
select * from ServiceFrequency

declare @ServiceFrequency table (ID uniqueidentifier, Sequence int, WeekFactor float)
insert @ServiceFrequency (ID) values  ('71590A00-2C40-40FF-ABD9-E73B09AF46A1')
insert @ServiceFrequency (ID) values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
insert @ServiceFrequency (ID) values ('A2080478-1A03-4928-905B-ED25DEC259E6')
insert @ServiceFrequency (ID) values ('25F0F5BE-AEC6-4E16-B694-E51F089B5FBF')
insert @ServiceFrequency (ID) values ('5F3A2822-56F3-49DA-9592-F604B0F202C3')

update tsf set Sequence = isnull(tsf.Sequence,99), WeekFactor = isnull(tsf.WeekFactor,1)
from (select *from @SelectLists where Type ='ServFreq') t  join 
@ServiceFrequency tsf on t.EnrichID = tsf.ID

--insert test 
select t.EnrichID, t.EnrichLabel, tsf.Sequence, tsf.WeekFactor
from ServiceFrequency x right join
(select *from @SelectLists where Type ='ServFreq')  t on x.ID = t.EnrichID left JOIN 
@ServiceFrequency tsf on t.EnrichID = tsf.ID
where x.ID is null order by x.Name

---- delete test
select x.*
from ServiceFrequency x left join
(select *from @SelectLists where Type ='ServFreq')  t on x.ID = t.EnrichID left JOIN 
@ServiceFrequency tsf on x.ID = tsf.ID
where t.EnrichID is null order by x.Name

begin tran fixfreq

insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
select t.EnrichID, t.EnrichLabel, tsf.Sequence, tsf.WeekFactor
from ServiceFrequency x right join
(select *from @SelectLists where Type ='ServFreq')  t on x.ID = t.EnrichID left JOIN 
@ServiceFrequency tsf on t.EnrichID = tsf.ID
where x.ID is null
order by x.Name


commit tran fixfreq
------rollback tran fixfreq