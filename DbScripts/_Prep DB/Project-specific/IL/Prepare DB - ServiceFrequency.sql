

set nocount on;
declare @ServiceFrequency table (ID uniqueidentifier, Name varchar(50), Sequence int, WeekFactor float)
insert @ServiceFrequency (ID, Name) values ('71590A00-2C40-40FF-ABD9-E73B09AF46A1','Daily')
insert @ServiceFrequency (ID, Name) values ('6BD808D0-B3BC-435F-88F3-D5BA2BF030C9','Four days a week')
insert @ServiceFrequency (ID, Name) values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD','Monthly')
insert @ServiceFrequency (ID, Name) values ('B4E2DE9C-C53F-4CB7-A8CA-556CFDD28897','Once a year')
insert @ServiceFrequency (ID, Name) values ('A2080478-1A03-4928-905B-ED25DEC259E6','Weekly')



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


