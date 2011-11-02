-- This script does not work anywhere else in ETL.  Tried as an importtype 0 stored procedure & straight SQL.  Tried referencing a view for a delete statement.  Now trying as an upgrade db script.
delete s 
from LEGACYSPED.MAP_IepRefID s left join 
	PrgItem d on s.DestID=d.ID 
where d.ID is null
go
