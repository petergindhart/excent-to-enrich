
set nocount on;

declare @PrgStatus table (ID uniqueidentifier, ProgramID uniqueidentifier, Sequence int, Name varchar(50), IsExit bit, IsEntry bit,  StatusStyleID uniqueidentifier, StateCode varchar(20), Description text)

insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('BF898F66-AD71-451F-AD11-3639155A431F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Reached Maximum Age For Services'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '01', 'Reached Maximum Age For Services')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('4878A47C-1AAA-4697-BE30-42106F214E7D', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Death'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '02', 'Death')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('C425DBDE-4DBD-4A9D-B1F5-6C3D99262AFD', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'PK-6 Student Exited, not known to continue'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '06', 'PK-6 Student Exited, not known to continue')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('C2DF5F3F-D0EE-4493-BBA7-6D8327EA36D8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transferred to Regular Education'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '09', 'Transferred to Regular Education')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('8DCBA0CA-9560-4E3A-88AB-805FD659C9C2', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Public School in a Different District, known to continue'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '13', 'Transfer to a Public School in a Different District, known to continue')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('05F914D8-2A29-489A-82ED-A7506341A83F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a School in a Different State/Country'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '14', 'Transfer to a School in a Different State/Country')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('DFBE9247-8EBC-447B-87C2-A8FAEB37A96D', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Non-Public School'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '15', 'Transfer to a Non-Public School')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('3C35632F-8323-4CB7-8585-B7D3D4586152', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to Home-Based Education'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '16', 'Transfer to Home-Based Education')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('2D966F92-A821-47EF-B785-DE1E32C84C3A', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Career and Technical Education Program (Non-CO district or BOCES operated)'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '18', 'Transfer to a Career and Technical Education Program (Non-CO district or BOCES operated)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('BB19EFF0-AF1F-4F8A-A8F2-EC11F2A56711', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Transfer to a Facility Operated by CO Dept of Youth Corrections'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '21', 'Transfer to a Facility Operated by CO Dept of Youth Corrections')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('E8959582-644B-4AAC-B3FF-0580B1BE158F', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Discontinued Schooling / Dropped out'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '40', 'Discontinued Schooling / Dropped out')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('59BBBBE9-BF7C-44E0-B9FB-0E376A26E0B8', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Explusion'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '50', 'Explusion')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('A24AEA49-735D-425F-B803-168769054306', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Parent Revokes Consent for Services'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '60', 'Parent Revokes Consent for Services')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('825305B4-0600-4098-8B17-381499942419', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'GED Transfer'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '70', 'GED Transfer')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('3A7DEAC1-7A66-42D6-B452-3A0529DA133D', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Graduated with a Regular Deploma'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '90', 'Graduated with a Regular Deploma')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('2477C14E-7939-46D6-99E4-43F6E35701A4', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Completed (non-diploma certificate)'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '92', 'Completed (non-diploma certificate)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('977D0FE7-B5EA-4656-B193-5B0BF784EDCC', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'General Education Development Certificate (GED)'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '93', 'General Education Development Certificate (GED)')
insert @PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) values ('E6DB43DE-03DF-4C27-A61B-6B1277102B73', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 99, convert(varchar(50), 'Student received GED certificate at Non-District Program same year of transfer.'), 1, 0, 'FA528C27-E567-4CC9-A328-FF499BB803F6', '94', 'Student received GED certificate at Non-District Program same year of transfer.')

--select * from PrgStatus


---- insert test
select t.ID, t.ProgramID, t.Sequence, t.Name, t.IsExit, t.IsEntry, t.StatusStyleID, t.StateCode, t.Description
from PrgStatus g right join
@PrgStatus t on g.ID = t.ID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
where g.ID is null
order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name

---- delete test
select g.*, t.StateCode
from PrgStatus g left join
@PrgStatus t on g.ID = t.ID 
where t.ID is null
and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
and g.Sequence not between 5 and 9


begin tran FixPrgStatus

-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description)
select t.ID, t.ProgramID, t.Sequence, t.Name, t.IsExit, t.IsEntry, t.StatusStyleID, t.StateCode, t.Description
from PrgStatus g right join
@PrgStatus t on g.ID = t.ID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
where g.ID is null
order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name

-- delete unneeded values
delete g
-- select g.*, t.StateCode
from PrgStatus g left join
@PrgStatus t on g.ID = t.ID 
where t.ID is null
and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and g.IsExit = 1
and g.Sequence not between 5 and 9


commit tran FixPrgStatus


