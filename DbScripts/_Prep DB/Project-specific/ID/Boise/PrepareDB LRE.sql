declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'DBC87BF4-FECF-4AB7-9C02-8E36E488BC8E', '01', 'General ed class 80% or more')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'F237216A-3969-4740-836D-D7B060F28B98', '02', 'General ed class 40 - 80%')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'B0CDC7EC-244D-43EB-A94D-82D6F307DB71', '03', 'General ed class less than 40%')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '64667C72-E29E-43B6-A00E-9B04CC529C18', '11', 'Public separate day school')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '0225B74D-A711-47A4-8991-3C2C4430BC77', '12', 'Private separate day school')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '29CAFE39-B62F-4A48-A8A9-7DB2E688C46E', '13', 'Public residential facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '58A2C111-088B-4AB1-9E20-68137D757536', '14', 'Private residential facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '019E3868-3B14-453F-A7E1-482E153C3B06', '15', 'Homebound/Hospital')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'A2B46B82-2CA0-4511-BA3B-3C334F130C93', '16', 'Correctional facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '1267E203-0111-4348-AAB7-155BA2D4F6C5', '21', 'Enrolled private by parents')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'F7A4B6C5-0A87-4228-BDE2-8B80743CC6A9', '44', 'Separate Class')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', '8026D621-4C8D-4C15-92BE-5B07BF02B102', '45', 'Separate School')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', '914AD573-0C9A-43B4-9A3E-0800CEB6709E', '46', 'Residential Facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'E84CC109-FF37-4154-B93C-16AE5D9448DF', '47', 'Service Provider Location')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'BCC5FF10-E35F-44E0-9F31-9964A292BED1', '48', 'Home')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'FB3F9819-4295-498F-929B-9194909CB165', '49', '>10 hours Regular EC Program provides majority of services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'D388B0AC-FD80-4D73-A702-3C240F73C6E7', '50', '>10 hours Regular EC Program; majority of services provided elsewhere')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', '6B1194D7-A73B-4850-A4F0-CBEC499174EC', '51', '<10 hours Regular EC Program provides majority of services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'AAD2442C-5AA7-43CC-9959-C9A38DBB725E', '52', '< 10 hours Regular EC Program; majority of services provided elsewhere')


--=================================================================================================================
--						IepPlacementOption
--=================================================================================================================
select EnrichID,EnrichLabel from @SelectLists where Type = 'LRE' order by StateCode
select * from IepPlacementOption order by StateCode


declare @IepPlacementOption table (ID uniqueidentifier, TypeID uniqueidentifier, Sequence int)


insert @IepPlacementOption (ID, TypeID, Sequence) values ('DBC87BF4-FECF-4AB7-9C02-8E36E488BC8E','D9D84E5B-45F9-4C72-8265-51A945CD0049',0)--General ed class 80% or more
insert @IepPlacementOption (ID, TypeID, Sequence) values ('F237216A-3969-4740-836D-D7B060F28B98','D9D84E5B-45F9-4C72-8265-51A945CD0049',1)--General ed class 40 - 80%
insert @IepPlacementOption (ID, TypeID, Sequence) values ('B0CDC7EC-244D-43EB-A94D-82D6F307DB71','D9D84E5B-45F9-4C72-8265-51A945CD0049',2)--General ed class less than 40%
insert @IepPlacementOption (ID, TypeID, Sequence) values ('64667C72-E29E-43B6-A00E-9B04CC529C18','D9D84E5B-45F9-4C72-8265-51A945CD0049',3)--Public separate day school
insert @IepPlacementOption (ID, TypeID, Sequence) values ('0225B74D-A711-47A4-8991-3C2C4430BC77','D9D84E5B-45F9-4C72-8265-51A945CD0049',4)--Private separate day school
insert @IepPlacementOption (ID, TypeID, Sequence) values ('29CAFE39-B62F-4A48-A8A9-7DB2E688C46E','D9D84E5B-45F9-4C72-8265-51A945CD0049',5)--Public residential facility
insert @IepPlacementOption (ID, TypeID, Sequence) values ('58A2C111-088B-4AB1-9E20-68137D757536','D9D84E5B-45F9-4C72-8265-51A945CD0049',6)--Private residential facility
insert @IepPlacementOption (ID, TypeID, Sequence) values ('019E3868-3B14-453F-A7E1-482E153C3B06','D9D84E5B-45F9-4C72-8265-51A945CD0049',7)--Homebound/Hospital
insert @IepPlacementOption (ID, TypeID, Sequence) values ('A2B46B82-2CA0-4511-BA3B-3C334F130C93','D9D84E5B-45F9-4C72-8265-51A945CD0049',8)--Correctional facility
insert @IepPlacementOption (ID, TypeID, Sequence) values ('1267E203-0111-4348-AAB7-155BA2D4F6C5','D9D84E5B-45F9-4C72-8265-51A945CD0049',9)--Enrolled private by parents
insert @IepPlacementOption (ID, TypeID, Sequence) values ('F7A4B6C5-0A87-4228-BDE2-8B80743CC6A9','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',3)--Separate Class
insert @IepPlacementOption (ID, TypeID, Sequence) values ('8026D621-4C8D-4C15-92BE-5B07BF02B102','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',4)--Separate School
insert @IepPlacementOption (ID, TypeID, Sequence) values ('914AD573-0C9A-43B4-9A3E-0800CEB6709E','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',5)--Residential Facility
insert @IepPlacementOption (ID, TypeID, Sequence) values ('E84CC109-FF37-4154-B93C-16AE5D9448DF','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',6)--Service Provider Location
insert @IepPlacementOption (ID, TypeID, Sequence) values ('BCC5FF10-E35F-44E0-9F31-9964A292BED1','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',7)--Home
insert @IepPlacementOption (ID, TypeID, Sequence) values ('FB3F9819-4295-498F-929B-9194909CB165','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',0)-->10 hours Regular EC Program provides majority of services
insert @IepPlacementOption (ID, TypeID, Sequence) values ('D388B0AC-FD80-4D73-A702-3C240F73C6E7','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',1)-->10 hours Regular EC Program; majority of services provided elsewhere
insert @IepPlacementOption (ID, TypeID, Sequence) values ('6B1194D7-A73B-4850-A4F0-CBEC499174EC','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',2)--<10 hours Regular EC Program provides majority of services
insert @IepPlacementOption (ID, TypeID, Sequence) values ('AAD2442C-5AA7-43CC-9959-C9A38DBB725E','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',3)--< 10 hours Regular EC Program; majority of services provided elsewhere


------ insert test
select t.EnrichID, tiepop.TypeID, tiepop.Sequence, t.EnrichLabel, t.StateCode
from IepPlacementOption x right join
(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID JOIN 
@IepPlacementOption tiepop on t.EnrichID = tiepop.ID
where x.ID is null order by x.StateCode
------ delete test
select x.*
from IepPlacementOption x left join
(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID  
where t.EnrichID is null order by x.StateCode

begin tran fixLRE

insert IepPlacementOption (ID, TypeID, Sequence, Text, StateCode)
select t.EnrichID, tiepop.TypeID, tiepop.Sequence, t.EnrichLabel, t.StateCode
from IepPlacementOption x right join
(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID JOIN 
@IepPlacementOption tiepop on t.EnrichID = tiepop.ID
where x.ID is null order by x.StateCode

declare @MAP_IepPlacementOption table (KeepID uniqueidentifier, TossID uniqueidentifier)


--/* ============================================================================= NOTE ============================================================================= 

--	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
--	will need to be updated for all hosted districts in Coloardo.  
	
--	HOWEVER
	
--	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

--   ============================================================================= NOTE ============================================================================= */


declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

insert @MAP_IepPlacementOption values ('DBC87BF4-FECF-4AB7-9C02-8E36E488BC8E','DC20B53C-0559-44F6-A463-3A92D9D4F69A')--General ed class 80% or more
insert @MAP_IepPlacementOption values ('F237216A-3969-4740-836D-D7B060F28B98','E5741B2C-CE35-4F3B-8AD5-58774E31C531')--	General ed class 40 - 80%
insert @MAP_IepPlacementOption values ('B0CDC7EC-244D-43EB-A94D-82D6F307DB71','A3FA6E17-E828-4A7C-A002-0A49B834BD1E')--	General ed class less than 40%
insert @MAP_IepPlacementOption values ('64667C72-E29E-43B6-A00E-9B04CC529C18','77E0EE80-143B-41E5-84B9-5076605CCC9A')--	Public separate day school
insert @MAP_IepPlacementOption values ('0225B74D-A711-47A4-8991-3C2C4430BC77','E4EE85F2-8307-4C8D-BA77-4EB5D12D8470')--	Private separate day school
insert @MAP_IepPlacementOption values ('29CAFE39-B62F-4A48-A8A9-7DB2E688C46E','9C830385-8B5E-4CB4-AA2E-9C8DB80E9F8B')--	Public residential facility
--insert @MAP_IepPlacementOption values ('58A2C111-088B-4AB1-9E20-68137D757536','84DAF081-F700-4F57-99DA-A2A983FDE919')--	Private residential facility
--insert @MAP_IepPlacementOption values ('019E3868-3B14-453F-A7E1-482E153C3B06','035CDD42-06A6-498D-B5AA-B16EE4A06FE9')--	Homebound/Hospital
--insert @MAP_IepPlacementOption values ('A2B46B82-2CA0-4511-BA3B-3C334F130C93','9B2DB2E0-CAE8-4CD0-AD4B-2BD61FD6C773')--	Correctional facility
--insert @MAP_IepPlacementOption values ('1267E203-0111-4348-AAB7-155BA2D4F6C5','9C830385-8B5E-4CB4-AA2E-9C8DB80E9F8B')--	Enrolled private by parents
--insert @MAP_IepPlacementOption values ('F7A4B6C5-0A87-4228-BDE2-8B80743CC6A9','5654E9A5-10A8-4B58-8A5C-79DA92674A27')--	Separate Class
--insert @MAP_IepPlacementOption values ('8026D621-4C8D-4C15-92BE-5B07BF02B102','0B2E63D7-6493-44A7-95B1-8DF327D77C38')--	Separate School
--insert @MAP_IepPlacementOption values ('914AD573-0C9A-43B4-9A3E-0800CEB6709E','2E45FDA2-0767-43D0-892D-D1BB40AFCEC1')--	Residential Facility
--insert @MAP_IepPlacementOption values ('E84CC109-FF37-4154-B93C-16AE5D9448DF','0DA48AA5-183C-4434-91C1-AC3C9941BE15')--	Service Provider Location
--insert @MAP_IepPlacementOption values ('BCC5FF10-E35F-44E0-9F31-9964A292BED1','0980382F-594C-453F-A0C9-77D54A0443B1')--	Home
--insert @MAP_IepPlacementOption values ('FB3F9819-4295-498F-929B-9194909CB165','')--	>10 hours Regular EC Program provides majority of services
--insert @MAP_IepPlacementOption values ('D388B0AC-FD80-4D73-A702-3C240F73C6E7','')--	>10 hours Regular EC Program; majority of services provided elsewhere
--insert @MAP_IepPlacementOption values ('6B1194D7-A73B-4850-A4F0-CBEC499174EC','')--	<10 hours Regular EC Program provides majority of services
--insert @MAP_IepPlacementOption values ('AAD2442C-5AA7-43CC-9959-C9A38DBB725E','')--	< 10 hours Regular EC Program; majority of services provided elsewhere

declare I cursor for 
select KeepID, TossID from @MAP_IepPlacementOption 

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
		and OBJECT_NAME (f.referenced_object_id) = 'IepPlacementOption' ------------------------- Table name here
		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
	order by SchemaName, TableName, ColumnName

	open R
	fetch R into @relschema, @RelTable, @relcolumn

	while @@fetch_status = 0
	begin

 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )
--print 'update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' 
	fetch R into @relschema, @RelTable, @relcolumn
	end
	close R
	deallocate R

fetch I into @KeepID, @TossID
end
close I
deallocate I


UPDATE x
set Text = t.EnrichLabel,
	Sequence = tiepop.Sequence
from IepPlacementOption x  join
(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID  JOIN 
@IepPlacementOption tiepop On t.EnrichID = tiepop.ID

-- delete unneeded
delete x
-- select g.*, t.StateCode
from IepPlacementOption x join
@MAP_IepPlacementOption t on x.ID = t.TossID 

commit tran fixLRE
----rollback tran fixLRE