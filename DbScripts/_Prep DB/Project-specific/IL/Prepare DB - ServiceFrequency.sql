

set nocount on;
declare @ServiceFrequency table (ID uniqueidentifier, Name varchar(50), Sequence int, WeekFactor float)
insert @ServiceFrequency (ID, Name) values ('71590A00-2C40-40FF-ABD9-E73B09AF46A1','daily')
insert @ServiceFrequency (ID, Name) values ('6BD808D0-B3BC-435F-88F3-D5BA2BF030C9','only once')
insert @ServiceFrequency (ID, Name) values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD','monthly')
insert @ServiceFrequency (ID, Name) values ('B4E2DE9C-C53F-4CB7-A8CA-556CFDD28897','yearly')
insert @ServiceFrequency (ID, Name) values ('A2080478-1A03-4928-905B-ED25DEC259E6','weekly')


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

declare @Map_ServiceFrequency table (KeepID uniqueidentifier, TossID uniqueidentifier)
--insert @Map_ServiceFrequency  values ('71590A00-2C40-40FF-ABD9-E73B09AF46A1','')--'daily'
insert @Map_ServiceFrequency  values ('6BD808D0-B3BC-435F-88F3-D5BA2BF030C9','E2996A26-3DB5-42F3-907A-9F251F58AB09')--'only once'
--insert @Map_ServiceFrequency  values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD','')--'monthly'
insert @Map_ServiceFrequency  values ('B4E2DE9C-C53F-4CB7-A8CA-556CFDD28897','5F3A2822-56F3-49DA-9592-F604B0F202C3')--'yearly'
--insert @Map_ServiceFrequency  values ('A2080478-1A03-4928-905B-ED25DEC259E6','')--'weekly'



begin tran fixfreq

insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
select t.ID, t.Name, t.Sequence, t.WeekFactor
from ServiceFrequency x right join
@ServiceFrequency t on x.ID = t.ID 
where x.ID is null
order by x.Name

declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

declare I cursor for 
select KeepID, TossID from @Map_ServiceFrequency 

open I
fetch I into @KeepID, @TossID

while @@fetch_status = 0

begin

	declare R cursor for 
	SELECT 
		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
		OBJECT_NAME(f.parent_object_id) AS TableName,
		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
	FROM sys.foreign_keys AS f
		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
		and OBJECT_NAME (f.referenced_object_id) = 'ServiceFrequency' ------------------------------- table name
		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
	order by SchemaName, TableName, ColumnName

	open R
	fetch R into @relschema, @RelTable, @relcolumn

	while @@fetch_status = 0
	begin

 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

	fetch R into @relschema, @RelTable, @relcolumn
	end
	close R
	deallocate R

fetch I into @KeepID, @TossID
end
close I
deallocate I


DELETE x
from ServiceFrequency x  join
@Map_ServiceFrequency t on x.ID = t.TossID 

update f 
set Name = t.Name
from @ServiceFrequency t  join 
ServiceFrequency f on t.ID = f.ID

commit tran fixfreq
--rollback tran fixfreq

-- select * from ServiceFrequency


