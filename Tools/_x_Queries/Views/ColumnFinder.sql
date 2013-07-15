create view x_DATATEAM.ColumnFinder
as
select SchemaName = s.Name, TableName = o.name, ColumnName = c.name
from sys.schemas s 
join sys.objects o on s.schema_id = o.schema_id
join sys.columns c on o.object_id = c.object_id
where o.type = 'U'
and o.name not like '%[_]%'

