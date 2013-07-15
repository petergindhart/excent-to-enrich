begin tran FixGender

declare @s varchar(150), @o varchar(150), @c varchar(150), @TossID varchar(36), @KeepID varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'

set nocount on;
-- (ID, Type, DisplayValue, Code, isActive, Sequence, StateCode)
declare @Gender table (ID uniqueidentifier, Type uniqueidentifier, DisplayValue varchar(512), Code varchar(8), isActive bit, Sequence int, StateCode varchar(50))
insert @Gender (ID, Type, DisplayValue, isActive, StateCode) values ('ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD', 'D6194389-17AC-494C-9C37-FD911DA2DD4B', 'Female', 1, NULL)
insert @Gender (ID, Type, DisplayValue, isActive, StateCode) values ('2FF51A82-9351-481A-8288-DCF8F7D96083', 'D6194389-17AC-494C-9C37-FD911DA2DD4B', 'Male', 1, NULL)

--ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD	01		Female
--2FF51A82-9351-481A-8288-DCF8F7D96083	02		Male

-- select * from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B'

update t set Code = e.Code
from @Gender t join
(select distinct DisplayValue, Code from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and isnull(Code,'') <> '') e on t.DisplayValue = e.DisplayValue

update t set Code = g.Code
from @Gender g join
EnumValue t on g.ID = t.ID

-- COMPARE OLD AND NEW --
select 'OLD' Age, ID, DisplayValue, Code from EnumValue v where v.Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' order by Code -- DisplayValue
select 'NEW' Age, ID, DisplayValue, Code, StateCode from @Gender order by StateCode -- DisplayValue 
-- COMPARE OLD AND NEW -- 

declare @MAP_Gender table (KeepID uniqueidentifier, TossID uniqueidentifier) 
-- based on COMPARE OLD AND NEW above, please fill in the OLD values below.  If there are OLD values that do not corespond to the NEW values, do not include them in the MAP table
--insert @MAP_Gender values ('ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD','') -- 'Female', 
--insert @MAP_Gender values ('2FF51A82-9351-481A-8288-DCF8F7D96083','') -- 'Male', 
--ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD	Female
--2FF51A82-9351-481A-8288-DCF8F7D96083	Male

---- insert test
--select t.ID, t.Type, t.DisplayValue, t.isActive, t.StateCode
--from EnumValue x right join
--@Gender t on x.ID = t.ID 
--where x.ID is null
--order by x.StateCode, x.DisplayValue

-- insert missing.  This has to be done before updating related tables with new EnumValue.
insert EnumValue (ID, Type, DisplayValue, Code, isActive, StateCode)
select t.ID, t.Type, t.DisplayValue, t.Code, t.isActive, t.StateCode
from EnumValue x right join
@Gender t on x.ID = t.ID 
where x.ID is null
order by x.StateCode, x.DisplayValue

-- this cursor will check for the existance of the specific EnumValue ID everywhere it exists in the database (as a GUID) and update it to the new value
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

update EnumValue set IsActive = 0 where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and ID not in (select ID from @Gender)


commit tran FixGender
-- rollback tran FixGender



