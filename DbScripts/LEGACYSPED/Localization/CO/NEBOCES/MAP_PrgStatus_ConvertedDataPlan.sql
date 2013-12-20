if not exists (select 1 from PrgStatus where ID = '0B5D5C72-5058-4BF5-A414-BDB27BD5DD94')
insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry, StatusStyleID) values ('0B5D5C72-5058-4BF5-A414-BDB27BD5DD94', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, 'Converted Data Plan', 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285')

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_PrgStatus_ConvertedDataPlan ')
drop table LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan
go

create table LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan (DestID uniqueidentifier not null)
insert LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan values ('0B5D5C72-5058-4BF5-A414-BDB27BD5DD94')
go
