

select f.ID, f.Name, e.name, f.BitMask, f.Active from Enrich_DC3_FL_Polk.dbo.GradeLevel f left join Enrich_DC3_FL_Polk_empty.dbo.GradeLevel e on e.ID = f.ID order by f.BitMask
select f.ID, f.Name, e.Name, f.DeletedDate, f.ProgramID from Enrich_DC3_FL_Polk.dbo.IepDisability f left join Enrich_DC3_FL_Polk_empty.dbo.IepDisability e on e.ID = f.ID order by f.Name, f.StateCode
select f.ID, f.Text, e.Text, f.DeletedDate from Enrich_DC3_FL_Polk.dbo.IepPlacementOption f left join Enrich_DC3_FL_Polk_empty.dbo.IepPlacementOption e on e.ID = f.ID order by f.TypeID, f.Sequence
select f.ID, f.Name, e.name, f.DeletedDate from Enrich_DC3_FL_Polk.dbo.IepServiceCategory f left join Enrich_DC3_FL_Polk_empty.dbo.IepServiceCategory e on e.ID = f.ID where f.DeletedDate is null order by f.Sequence
select f.ID, f.Name, e.name, f.DeletedDate from Enrich_DC3_FL_Polk.dbo.PrgStatus f left join Enrich_DC3_FL_Polk_empty.dbo.PrgStatus e on e.ID = f.ID where f.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and f.IsExit = 1 order by f.Sequence
select f.ID, f.Name, e.name, f.DeletedDate from Enrich_DC3_FL_Polk.dbo.PrgLocation f left join Enrich_DC3_FL_Polk_empty.dbo.PrgLocation e on e.ID = f.ID order by f.Name
select f.ID, f.Name, e.name, f.DeletedDate from Enrich_DC3_FL_Polk.dbo.ServiceDef f left join Enrich_DC3_FL_Polk_empty.dbo.ServiceDef e on e.ID = f.ID order by f.Name


select * from Enrich_DC3_FL_Polk_empty.dbo.IepDisability 



select Type = 'Disab', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from IepDisability x where x.DeletedDate is null
union all
select Type = 'Gender', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = DisplayValue from  EnumValue where Type = (select ID from EnumType where Type = 'GEN' and IsActive = 1)
union all
select Type = 'Race', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = DisplayValue from  EnumValue where Type = (select ID from EnumType where Type = 'ETH' and IsActive = 1)
union all
select Type = 'Grade', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  GradeLevel 
union all
select Type = 'GoalArea', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  IepGoalAreaDef where DeletedDate is null 
union all
select Type = 'LRE', SubType = case pt.Name when 'Ages 3-5' then 'PK' when 'Ages 6-21' then 'K12' else pt.Name end, EnrichID = po.ID, StateCode = isnull(po.StateCode,''), LegacySpedCode = '', EnrichLabel = po.Text from IepPlacementOption po join IepPlacementType pt on po.TypeID = pt.ID where po.DeletedDate is null
union all
select Type = 'PostSchArea', SubType = '', EnrichID = ID, StateCode = '', LegacySpedCode = '', EnrichLabel = Name from  IepPostSchoolAreaDef x 
union all
select Type = 'ServLoc', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  PrgLocation where DeletedDate is null
union all
select Type = 'Exit', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  PrgStatus where ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' and DeletedDate is null 
union all
--select Type = 'Service', SubType = 'SpecialEd', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceDef where DeletedDate is null
select Type = 'Service', SubType = case isc.Name when 'Special Education' then 'SpecialEd' else isc.Name end, EnrichID = sd.ID, StateCode = isnull(sd.StateCode,''), LegacySpedCode = '', EnrichLabel = sd.Name from ServiceDef sd join IepServiceDef isd on sd.ID = isd.ID join IepServiceCategory isc on isd.CategoryID = isc.ID where sd.DeletedDate is null
union all
select Type = 'ServFreq', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceFrequency where DeletedDate is null 
union all
select Type = 'ServProv', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceProviderTitle where DeletedDate is null
order by Type, SubType, EnrichLabel


select * from Program









select Type = 'Service', SubType = case isc.Name when 'Special Education' then 'SpecialEd' else isc.Name end, EnrichID = sd.ID, StateCode = isnull(sd.StateCode,''), LegacySpedCode = '', EnrichLabel = sd.Name, sd.UserDefined
from ServiceDef sd 
join IepServiceDef isd on sd.ID = isd.ID 
join IepServiceCategory isc on isd.CategoryID = isc.ID 
where sd.DeletedDate is null
and sd.name like 'Transp%'
