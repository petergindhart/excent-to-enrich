

set nocount on;
declare @ServiceFrequency table (ID uniqueidentifier, Name varchar(50), Sequence int, WeekFactor float)
insert @ServiceFrequency (ID, Name) values ('836D1E97-CE4D-4FD5-9D0A-148924AC007B', 'As needed for ESY')
insert @ServiceFrequency (ID, Name) values ('71590A00-2C40-40FF-ABD9-E73B09AF46A1', 'daily')
insert @ServiceFrequency (ID, Name) values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD', 'monthly')
insert @ServiceFrequency (ID, Name) values ('C42C50ED-863B-44B8-BF68-B377C8B0FA95', 'Not specified')
insert @ServiceFrequency (ID, Name) values ('E2996A26-3DB5-42F3-907A-9F251F58AB09', 'only once')
insert @ServiceFrequency (ID, Name) values ('A2080478-1A03-4928-905B-ED25DEC259E6', 'weekly')
insert @ServiceFrequency (ID, Name) values ('5F3A2822-56F3-49DA-9592-F604B0F202C3', 'yearly')


update t set Sequence = isnull(f.Sequence,99), WeekFactor = isnull(f.WeekFactor,1)
from @ServiceFrequency t left join 
ServiceFrequency f on t.Name = f.Name

--select * from ServiceFrequency
--select * from @ServiceFrequency


---- insert test
select t.ID, t.Name, t.Sequence, t.WeekFactor
from ServiceFrequency x right join
@ServiceFrequency t on x.ID = t.ID 
where x.ID is null order by x.Name

---- delete test
select x.*
from ServiceFrequency x left join
@ServiceFrequency t on x.ID = t.ID 
where t.ID is null order by x.Name

begin tran fixfreq

insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
select t.ID, t.Name, t.Sequence, t.WeekFactor
from ServiceFrequency x right join
@ServiceFrequency t on x.ID = t.ID 
where x.ID is null
order by x.Name


commit tran fixfreq

--rollback tran fixfreq
-- select * from ServiceFrequency


