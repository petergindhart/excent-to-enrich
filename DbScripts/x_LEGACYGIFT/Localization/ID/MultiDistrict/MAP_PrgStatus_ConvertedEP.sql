if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'MAP_PrgStatus_ConvertedEP')
drop table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP
go

create table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP (DestID uniqueidentifier not null)
insert x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900') -- should eventually coordinate with VC3 how the sequence should be coordinated.  
go

