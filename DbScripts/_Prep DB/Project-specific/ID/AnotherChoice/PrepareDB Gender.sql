set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Gender', NULL, 'ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD', 'F', 'Female')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Gender', NULL, '2FF51A82-9351-481A-8288-DCF8F7D96083', 'M', 'Male')

--=================================Gender=====================
select * from @SelectLists where Type = 'Gender'
select * from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B'

begin tran FixGender
set nocount on;

declare @s varchar(150), @o varchar(150), @c varchar(150), @TossID varchar(36), @KeepID varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'
declare @MAP_Gender table (KeepID uniqueidentifier, TossID uniqueidentifier) 
-- based on COMPARE OLD AND NEW above, please fill in the OLD values below.  If there are OLD values that do not corespond to the NEW values, do not include them in the MAP table
--insert @MAP_Gender values ('ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD','') -- 'Female', 
--insert @MAP_Gender values ('2FF51A82-9351-481A-8288-DCF8F7D96083','') -- 'Male', 
--ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD	Female
--2FF51A82-9351-481A-8288-DCF8F7D96083	Male

---- insert test
select t.EnrichID, x.Type, t.EnrichLabel, 1, t.StateCode
from EnumValue x right join
(select * from @SelectLists where Type = 'Gender') t on x.ID = t.EnrichID 
where x.ID is null
order by x.StateCode, x.DisplayValue

-- insert missing.  This has to be done before updating related tables with new EnumValue.
insert EnumValue (ID, Type, DisplayValue, isActive, StateCode)
select t.EnrichID, x.Type, t.EnrichLabel, 1, t.StateCode
from EnumValue x right join
(select * from @SelectLists where Type = 'Gender') t on x.ID = t.EnrichID 
where x.ID is null
order by x.StateCode, x.DisplayValue

--this cursor will check for the existance of the specific EnumValue ID everywhere it exists in the database (as a GUID) and update it to the new value
-- this operation is especially important to update the SIS import MAP table DestID
declare G cursor for 
select TossID, KeepID from @MAP_Gender

open G
fetch G into @TossID, @KeepID

while @@fetch_status = 0
begin

set @g = @TossID

	declare OC cursor for 
	select s.name, o.name, c.name
	from sys.schemas s join
	sys.objects o on s.schema_id = o.schema_id join 
	sys.columns c on o.object_id = c.object_id join
	sys.types t on c.user_type_id = t.user_type_id
	where o.type = 'U'
	and t.name = 'uniqueidentifier'
	and o.name <> 'EnumValue' -- don't touch this!
	order by o.name, c.name

	open OC
	fetch OC into @s, @o, @c

	while @@FETCH_STATUS = 0
	begin

	exec ('if exists (select 1 from '+@s+'.'+@o+' o where '+@c+' = '''+@g+''')
	exec (''update x set '+@c+' = '''''+@KeepID+''''' from '+@s+'.'+@o+' x where '+@c+' = '''''+@TossID+''''''')')

	fetch OC into @s, @o, @c
	end

	close OC
	deallocate OC

print ''

fetch G into @TossID, @KeepID
end
close G
deallocate G

update EnumValue set IsActive = 0 where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and ID not in (select EnrichID from @SelectLists where Type = 'Gender')


commit tran FixGender
-- rollback tran FixGender