
set nocount on;

declare @ServiceDef table (ID uniqueidentifier, CategoryID uniqueidentifier, Name varchar(100)) 

insert @ServiceDef (ID, CategoryID, Name) values ('8C054380-B22F-4D2A-98DE-568498E06EAB', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Assistive Technology Services')
insert @ServiceDef (ID, CategoryID, Name) values ('6C1EA4EC-C0F0-4C7D-99F2-7AFBB2DBB68C', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Audiology Services')
insert @ServiceDef (ID, CategoryID, Name) values ('94C0C353-6595-4A7E-873E-CE77A52474FA', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Counseling')
insert @ServiceDef (ID, CategoryID, Name) values ('E3A7E8E5-72C4-4871-8381-E081EC81D1D6', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Interpreting Services')
insert @ServiceDef (ID, CategoryID, Name) values ('B874A136-2F0E-4955-AA1E-1F0D45F263FB', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Occupational Therapy')
insert @ServiceDef (ID, CategoryID, Name) values ('CABB2C1E-BC93-4D52-9E2D-AF52A259AD17', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Orientation & Mobility Services')
insert @ServiceDef (ID, CategoryID, Name) values ('AA695BB6-947F-44A8-8AB3-43E1B01B6877', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Parent Counseling and Training')
insert @ServiceDef (ID, CategoryID, Name) values ('829EA69A-629D-4883-B2A1-446E3ED2872D', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Personal Care Services')
insert @ServiceDef (ID, CategoryID, Name) values ('73107912-4959-4137-910B-B17E52076074', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Physical Therapy')
insert @ServiceDef (ID, CategoryID, Name) values ('7BBAAB01-398D-4835-B4B0-13D543FAC564', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Psychological Services')
insert @ServiceDef (ID, CategoryID, Name) values ('75D07F63-F586-4C55-8FDE-A5B6D0737157', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'School Health Services')
insert @ServiceDef (ID, CategoryID, Name) values ('B630AE87-E461-4DAC-B5B9-3FB85C78F56D', '4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD', 'Transportation Services')
insert @ServiceDef (ID, CategoryID, Name) values ('D4149322-3A4A-42C1-8590-5A5D919E7B28', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Indirect')
insert @ServiceDef (ID, CategoryID, Name) values ('2991CDE7-FB2A-4FDA-AD00-6BF56DCD4D09', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Instruction-Co-Teach')
insert @ServiceDef (ID, CategoryID, Name) values ('42176279-A1A0-4699-B01B-187FD0FF07E2', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Instruction-Direct In Gen Ed Class')
insert @ServiceDef (ID, CategoryID, Name) values ('E2819193-5118-4DC9-8433-6F35851C14FC', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Instruction-Direct Outside Gen Ed Class')
insert @ServiceDef (ID, CategoryID, Name) values ('9DE4CBF9-BD8D-490C-8E1B-34F5E73DEF11', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Specialized Instruction')
insert @ServiceDef (ID, CategoryID, Name) values ('BF859DEF-67A2-4285-A871-E80315AF3BD5', '4570E6F2-2691-4BB1-9BBB-A62AC3BEECB7', 'Speech/Language Services')


--select * from ServiceDef order by Name
--select ID, 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', Name from @ServiceDef order by Name

---- insert test
select t.ID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.Name
from ServiceDef x right join
@ServiceDef t on x.ID = t.ID 
where x.ID is null order by x.Name

------ delete test		-- we will not be deleting services that were entered manually by the customer.
--select x.*
--from ServiceDef x left join
--@ServiceDef t on x.ID = t.ID 
--where t.ID is null order by x.Name


--insert ServiceDef (ID, TypeID, Name)
select t.ID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.Name
from ServiceDef x right join
@ServiceDef t on x.ID = t.ID 
where x.ID is null order by x.Name

















