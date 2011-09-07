if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_IepRefID_DeleteOrphans')
drop proc AURORAX.MAP_IepRefID_DeleteOrphans
go

create PROC AURORAX.MAP_IepRefID_DeleteOrphans
as
	delete s 
	from AURORAX.MAP_IepRefID s left join 
		PrgItem d on s.DestID=d.ID 
	where d.ID is null
go
