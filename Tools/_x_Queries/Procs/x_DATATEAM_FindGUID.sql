--create schema x_DATATEAM

create proc x_DATATEAM.FindGuid
	@guid uniqueidentifier
as

declare @s varchar(150), @o varchar(150), @c varchar(150), @g varchar(36) ; select @g = @guid

declare OC cursor for 
select s.name, o.name, c.name
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id join 
sys.columns c on o.object_id = c.object_id join
sys.types t on c.user_type_id = t.user_type_id
where o.type = 'U'
-- and s.name in ('dbo')
and (t.name = 'uniqueidentifier' or t.name = 'varchar' and c.max_length = 150)
-- and o.name not like '%[_]%'
order by o.name, c.name

open OC
fetch OC into @s, @o, @c

while @@FETCH_STATUS = 0
begin

exec ('if exists (select 1 from '+@s+'.'+@o+' where '+@c+' = '''+@g+''')
print ''select * from '+@s+'.'+@o+' where '+@c+' = '''''+@g+'''''''')

fetch OC into @s, @o, @c
end

close OC
deallocate OC

go


