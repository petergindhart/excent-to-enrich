set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '4B3DB67E-21B2-4ABC-B7FF-6CE7194B9973', '01', 'Race: American Indian or Alaska Native')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '9089FEE5-A947-47DF-A75E-48FD36497634', '02', 'Race: Asian')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '016E70C1-28B8-4DE3-B497-7D63E157031B', '03', 'Race: Black or African American')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '6039E197-C060-4ACD-BD46-410517E5EA0A', '06', 'Ethnicity: Hispanic or Latino')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '77C31E40-CAC1-43F8-9537-39A0003FE84C', '04', 'Race: Native Hawaiian or Other Pacific Islander')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '5E9AD89E-04D1-449D-B052-D8D3B57D748E', '07', 'Race: Two or more races')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, 'B8D4CB59-4714-4D23-A066-1CF408FE480F', '05', 'Race: White')

----==============================Race=======================================
select * from @SelectLists where Type = 'Race' order by StateCode
select * from EnumValue v where v.Type = (select ID from EnumType t where t.Type = 'ETH') order by StateCode

begin tran FixRace

declare @s varchar(150), @o varchar(150), @c varchar(150), @gold varchar(36), @gnew varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'

declare @MAP_Race table (Code varchar(10), OldRace uniqueidentifier, NewRace uniqueidentifier) -- based on COMPARE OLD AND NEW above, please fill in the OLD values below.  If there are OLD values that do not corespond to the NEW values, do not include them in the MAP table
--Vallivue
insert @MAP_Race values ('01','06D1BB41-9516-4C56-B12B-37EA8CACD083', '4B3DB67E-21B2-4ABC-B7FF-6CE7194B9973') -- Race: American Indian or Alaska Native
insert @MAP_Race values ('02','1C012C25-3BC1-40CC-8FD3-CF8A874DAF69', '9089FEE5-A947-47DF-A75E-48FD36497634') -- Race: Asian
insert @MAP_Race values ('03','CC8E3624-8D04-43DA-B9F8-41B60D06D015', '016E70C1-28B8-4DE3-B497-7D63E157031B') -- Race: Black or African American
insert @MAP_Race values ('06','3D89F11D-449F-4CDB-9386-33072073A52C', '6039E197-C060-4ACD-BD46-410517E5EA0A') -- Ethnicity: Hispanic or Latino
insert @MAP_Race values ('05','7A4383F3-CC9C-4A9A-AE16-0A052CCFD775', 'B8D4CB59-4714-4D23-A066-1CF408FE480F') -- Race: White
insert @MAP_Race values ('04','7B7CCD93-AF44-45DD-BD74-0502DC2B2E50', '77C31E40-CAC1-43F8-9537-39A0003FE84C') -- Race: Native Hawaiian or Other Pacific Islander
insert @MAP_Race values ('07','9A65D79B-AD12-4F21-8276-EC01ADE19503', '5E9AD89E-04D1-449D-B052-D8D3B57D748E') -- Race: Two or more races

update r set StateCode = m.Code
from (select * from @SelectLists where Type = 'Race') r join
@MAP_Race m on r.EnrichID = m.NewRace


-- isnert test
select t.EnrichID, t.Type, t.EnrichLabel,1, t.StateCode
from EnumValue x right join
(select * from @SelectLists where Type = 'Race')t on x.ID = t.EnrichID 
where x.ID is null
order by x.StateCode, x.DisplayValue

insert EnumValue (ID, Type, DisplayValue, isActive, StateCode)
select t.EnrichID, 'CBB84AE3-A547-4E81-82D2-060AA3A50535', t.EnrichLabel,1, t.StateCode
from EnumValue x right join
(select * from @SelectLists where Type = 'Race')t on x.ID = t.EnrichID 
where x.ID is null
order by x.StateCode, x.DisplayValue

update ev set Code = r.StateCode
from EnumValue ev join
(select * from @SelectLists where Type = 'Race')r on ev.ID = r.EnrichID

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

-- print ''

fetch G into @gold, @gnew
end
close G
deallocate G

update EnumValue set IsActive = 0 where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and ID not in (select EnrichID from @SelectLists where Type = 'Race')

commit tran FixRace
--rollback tran FixRace

select * from EnumValue where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1