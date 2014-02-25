IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_StudentRefIDAll') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
create table LEGACYSPED.MAP_StudentRefIDAll (
StudentRefID varchar(150) not null,
DestID uniqueidentifier not null
)

ALTER TABLE LEGACYSPED.MAP_StudentRefIDAll ADD CONSTRAINT
	PK_MAP_StudentRefIDAll PRIMARY KEY CLUSTERED
	(
	StudentRefID
	) 
END
go

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_StudentRefIDAll_DestID')
create index IX_LEGACYSPED_MAP_StudentRefIDAll_DestID on LEGACYSPED.MAP_StudentRefIDAll (DestID)
go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'Populate_MAP_StudentRefIDAll')
drop proc LEGACYSPED.Populate_MAP_StudentRefIDAll 
go

create proc LEGACYSPED.Populate_MAP_StudentRefIDAll 
as
insert LEGACYSPED.MAP_StudentRefIDAll
select distinct t.StudentRefID, t.DestID
from LEGACYSPED.Transform_Student t left join
LEGACYSPED.MAP_StudentRefIDAll m on t.StudentRefID = m.StudentRefID 
where m.DestID is null
go
