set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '24827AAC-3DE7-432D-A15B-00BE41BF8BDF', NULL, 'No Consent')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '73DC240D-EF00-42C9-910D-3953ED3540D4', NULL, 'Not Eligible')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '12086FE0-B509-4F9F-ABD0-569681C59EE2', NULL, 'Exited After Eligibility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '1A10F969-4C63-4EB0-A00A-5F0563305D7A', NULL, 'Exited Before Eligibility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '9B1CC467-3D34-4AA1-BED5-7EE37ECBD799', NULL, 'No Disability Suspected')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'B6FD50F7-3154-4831-974E-E41D91A49525', '01', 'Graduate - Met Regular Requirements')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'CD184A31-1F54-4FC0-96CA-5DD8653B0CD9', '02', 'Graduate - Met Reduced Requirements')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'F7C2F259-7497-42AB-8274-274CFB5EFE1F', '03', 'Certificate of Completion/Attendance')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '63272934-A855-4E96-B75B-865ADD84DC70', '04', 'Reached Maximum Age')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'E28E543A-A45B-4C55-9EAF-C2DCDFD0A84E', '05', 'Dropped Out')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '910B6CAA-72E3-4AA0-A40F-823AAD29FCBC', '06', 'Transfer to Another Education Environment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '95B9417B-9746-4076-91BE-F0A4E51E4AE9', '07', 'No Longer Eligible for Program')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'E776A203-2701-49DE-BFB3-2B9E53763F4B', '08', 'Deceased')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'E6DAFFA8-1A83-4FD3-B7E5-8D7FBE784F80', '09', 'Status Unknown (dropout)')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '91E0214F-F587-40C8-B859-E8819B347572', '12', 'Summer Break')

--======================================================================================================
--								PrgStatus
--========================================================================================================
--select EnrichID,EnrichLabel from @SelectLists where Type = 'Exit' ORDER BY StateCode
--select * from PrgStatus order by StateCode



declare @PrgStatus table (ID uniqueidentifier, ProgramID uniqueidentifier, Sequence int, IsExit bit, IsEntry bit,  StatusStyleID uniqueidentifier)

insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('24827AAC-3DE7-432D-A15B-00BE41BF8BDF','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',7,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--No Consent
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('73DC240D-EF00-42C9-910D-3953ED3540D4','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',8,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Not Eligible
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('12086FE0-B509-4F9F-ABD0-569681C59EE2','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',10,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Exited After Eligibility
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('1A10F969-4C63-4EB0-A00A-5F0563305D7A','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',9,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Exited Before Eligibility
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('9B1CC467-3D34-4AA1-BED5-7EE37ECBD799','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',6,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--No Disability Suspected
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('B6FD50F7-3154-4831-974E-E41D91A49525','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',11,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('CD184A31-1F54-4FC0-96CA-5DD8653B0CD9','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',12,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Graduate - Met Reduced Requirements
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('F7C2F259-7497-42AB-8274-274CFB5EFE1F','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',13,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Certificate of Completion/Attendance
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('63272934-A855-4E96-B75B-865ADD84DC70','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',14,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Reached Maximum Age
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('E28E543A-A45B-4C55-9EAF-C2DCDFD0A84E','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',15,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Dropped Out
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('910B6CAA-72E3-4AA0-A40F-823AAD29FCBC','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',16,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Transfer to Another Education Environment
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('95B9417B-9746-4076-91BE-F0A4E51E4AE9','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',17,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--No Longer Eligible for Program
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('E776A203-2701-49DE-BFB3-2B9E53763F4B','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',18,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Deceased
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('E6DAFFA8-1A83-4FD3-B7E5-8D7FBE784F80','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',99,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Status Unknown (dropout)
insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('91E0214F-F587-40C8-B859-E8819B347572','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',20,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Summer Break


--- insert test
select t.EnrichID, tpgs.ProgramID, tpgs.Sequence, t.EnrichLabel, tpgs.IsExit, tpgs.IsEntry, tpgs.StatusStyleID, t.StateCode
from PrgStatus g right join
(select * from @SelectLists where Type = 'Exit') t on g.ID = t.EnrichID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' JOIN 
@PrgStatus tpgs on t.EnrichID = tpgs.ID
where g.ID is null
order by tpgs.Sequence, t.stateCode, t.EnrichLabel 

---- delete test
select g.*
from PrgStatus g left join
(select * from @SelectLists where Type = 'Exit') t on g.ID = t.EnrichID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'  
where t.EnrichID is null and g.IsExit = 1
order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name

begin tran FixPrgStatus

declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);



-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode)
select t.EnrichID, tpgs.ProgramID, tpgs.Sequence, t.EnrichLabel, tpgs.IsExit, tpgs.IsEntry, tpgs.StatusStyleID, t.StateCode
from PrgStatus g right join
(select * from @SelectLists where Type = 'Exit') t on g.ID = t.EnrichID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' JOIN 
@PrgStatus tpgs on t.EnrichID = tpgs.ID
where g.ID is null
order by tpgs.Sequence, t.stateCode, t.EnrichLabel 

declare @MAP_PrgStatus table (KeepID uniqueidentifier, TossID uniqueidentifier)
--insert @MAP_PrgStatus (KeepID, TossID) values ('24827AAC-3DE7-432D-A15B-00BE41BF8BDF','')--	No Consent
--insert @MAP_PrgStatus (KeepID, TossID) values ('73DC240D-EF00-42C9-910D-3953ED3540D4','')--	Not Eligible
--insert @MAP_PrgStatus (KeepID, TossID) values ('12086FE0-B509-4F9F-ABD0-569681C59EE2','')--	Exited After Eligibility
--insert @MAP_PrgStatus (KeepID, TossID) values ('1A10F969-4C63-4EB0-A00A-5F0563305D7A','')--	Exited Before Eligibility
--insert @MAP_PrgStatus (KeepID, TossID) values ('9B1CC467-3D34-4AA1-BED5-7EE37ECBD799','')--	No Disability Suspected
insert @MAP_PrgStatus (KeepID, TossID) values ('B6FD50F7-3154-4831-974E-E41D91A49525','CCFEA3D2-5A97-4590-89B7-5B72C3462222')--	Graduate - Met Regular Requirements
insert @MAP_PrgStatus (KeepID, TossID) values ('CD184A31-1F54-4FC0-96CA-5DD8653B0CD9','F8E18ACA-4147-4D80-8026-5DAD21177ED3')--	Graduate - Met Reduced Requirements
insert @MAP_PrgStatus (KeepID, TossID) values ('F7C2F259-7497-42AB-8274-274CFB5EFE1F','0BB89AF0-544E-478A-AD21-5DE93698EB27')--	Certificate of Completion/Attendance
insert @MAP_PrgStatus (KeepID, TossID) values ('63272934-A855-4E96-B75B-865ADD84DC70','7F95788C-4317-4450-9540-3C14A7316E3B')--	Reached Maximum Age
insert @MAP_PrgStatus (KeepID, TossID) values ('E28E543A-A45B-4C55-9EAF-C2DCDFD0A84E','338F2F0A-A8FF-47C4-AF04-423D6094243A')--	Dropped Out
insert @MAP_PrgStatus (KeepID, TossID) values ('910B6CAA-72E3-4AA0-A40F-823AAD29FCBC','22F4F0D4-1463-435C-B2C7-01B3CCAFF31F')--	Transfer to Another Education Environment
insert @MAP_PrgStatus (KeepID, TossID) values ('95B9417B-9746-4076-91BE-F0A4E51E4AE9','D21EC563-676A-44A6-9650-0433C3BC0EA0')--	No Longer Eligible for Program
insert @MAP_PrgStatus (KeepID, TossID) values ('E776A203-2701-49DE-BFB3-2B9E53763F4B','25B25E2B-ECBB-4392-BF09-11D7F011FDB5')--	Deceased
--insert @MAP_PrgStatus (KeepID, TossID) values ('E6DAFFA8-1A83-4FD3-B7E5-8D7FBE784F80','')--	Status Unknown (dropout)
insert @MAP_PrgStatus (KeepID, TossID) values ('91E0214F-F587-40C8-B859-E8819B347572','979F387E-8AE3-473E-9854-2649A82B15F0')--	Summer Break


declare I cursor for 
select KeepID, TossID from @MAP_PrgStatus 

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
		and OBJECT_NAME (f.referenced_object_id) = 'PrgStatus' ------------------------- Table name here
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

-- delete unneeded
delete x
-- select g.*, t.StateCode
from PrgStatus x join
@MAP_PrgStatus t on x.ID = t.TossID 


commit tran FixPrgStatus
--rollback tran FixPrgStatus