--select * from EnumType where Type = 'ETH'

begin tran FixRace

declare @s varchar(150), @o varchar(150), @c varchar(150), @gold varchar(36), @gnew varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'

set nocount on;
-- (ID, Type, DisplayValue, Code, isActive, Sequence, StateCode)
declare @Race table (ID uniqueidentifier, Type uniqueidentifier, DisplayValue varchar(512), Code varchar(8), isActive bit, Sequence int, StateCode varchar(50))

insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('3722D2F9-43DE-4B0C-BA4F-5D2393E99AFB', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: American Indian or Alaska Native', 1, '12')
insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('77C1BF9F-B798-4352-894F-F029BDE72405', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Asian', 1, '13')
insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('49553226-22A2-4811-87FB-AA26AD8CF5BA', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Black or African American', 1, '14')
insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('6FB5A09C-CC40-42C8-AE0D-002E634BF5C5', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Ethnicity: Hispanic or Latino', 1, '11')
insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('403478BC-1E55-4A59-9BEF-750444AE2B77', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: White', 1, '16')
insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('39007092-52B7-49BD-BF1F-8B8C60D8D61E', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Native Hawaiian or Other Pacific Islander', 1, '15')
insert @Race (ID, Type, DisplayValue, isActive, StateCode) values ('49DF5C6E-6971-4544-86D1-DED67EA4B70E', 'CBB84AE3-A547-4E81-82D2-060AA3A50535', 'Race: Two or more races', 1, '17')


-- COMPARE OLD AND NEW --
select 'OLD' Age, ID, DisplayValue, Code from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' order by Code -- DisplayValue
select 'NEW' Age, ID, DisplayValue, StateCode from @Race order by StateCode -- DisplayValue 
-- COMPARE OLD AND NEW -- 


set nocount on;

declare @MAP_Race table (OldRace uniqueidentifier, NewRace uniqueidentifier) 
-- based on COMPARE OLD AND NEW above, please fill in the OLD values below.  If there are OLD values that do not corespond to the NEW values, do not include them in the MAP table

--insert @MAP_Race values ('3722D2F9-43DE-4B0C-BA4F-5D2393E99AFB', 'E1611EE9-7FC3-4CEF-80D6-D67EE6EE1F6F') -- Race: American Indian or Alaska Native
--insert @MAP_Race values ('77C1BF9F-B798-4352-894F-F029BDE72405', '953025B8-4102-4C8F-B8AB-766068ACC978') -- Race: Asian
--insert @MAP_Race values ('49553226-22A2-4811-87FB-AA26AD8CF5BA', '628814D0-09B4-4B77-A1A7-A9CEEC360C2B') -- Race: Black or African American
--insert @MAP_Race values ('6FB5A09C-CC40-42C8-AE0D-002E634BF5C5', '68F95480-110E-45EB-84DC-566A930E8C67') -- Ethnicity: Hispanic or Latino
--insert @MAP_Race values ('403478BC-1E55-4A59-9BEF-750444AE2B77', '3A074939-80D2-4138-97E9-149345528E9F') -- Race: White
--insert @MAP_Race values ('39007092-52B7-49BD-BF1F-8B8C60D8D61E', '80034B85-658B-497E-8793-E2382CB6AF51') -- Race: Native Hawaiian or Other Pacific Islander
--insert @MAP_Race values ('49DF5C6E-6971-4544-86D1-DED67EA4B70E', 'E97F2925-C985-4C26-BC60-1F0B42C1719D') -- Race: Two or more races


-- isnert test
select t.ID, t.Type, t.DisplayValue, t.isActive, t.StateCode
from EnumValue x right join
@Race t on x.ID = t.ID 
where x.ID is null
order by x.StateCode, x.DisplayValue

-- insert missing.  This has to be done before updating related tables with new EnumValue.
insert EnumValue (ID, Type, DisplayValue, isActive, StateCode)
select t.ID, t.Type, t.DisplayValue, t.isActive, t.StateCode
from EnumValue x right join
@Race t on x.ID = t.ID 
where x.ID is null
order by x.StateCode, x.DisplayValue

-- this cursor will check for the existance of the specific EnumValue ID everywhere it exists in the database (as a GUID) and update it to the new value
-- this operation is especially important to update the SIS import MAP table DestID
declare G cursor for 
select OldRace, NewRace from @MAP_Race

open G
fetch G into @gold, @gnew

while @@fetch_status = 0
begin

set @g = @gold

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
	exec (''update x set '+@c+' = '''''+@gnew+''''' from '+@s+'.'+@o+' x where '+@c+' = '''''+@gold+''''''')')

	fetch OC into @s, @o, @c
	end

	close OC
	deallocate OC

print ''

fetch G into @gold, @gnew
end
close G
deallocate G

UPDATE x
SET StateCode = t.StateCode,
    DisplayValue = t.DisplayValue
from EnumValue x  join
@Race t on x.ID = t.ID 



update EnumValue set IsActive = 0 where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and ID not in (select ID from @Race)

commit tran FixRace
--rollback tran FixRace



--SELECT * from EnumValue where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 order by statecode


