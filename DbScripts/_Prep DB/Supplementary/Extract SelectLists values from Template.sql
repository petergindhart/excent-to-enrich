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
select Type = 'Exit', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  PrgStatus where DeletedDate is null 
union all
--select Type = 'Service', SubType = 'SpecialEd', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceDef where DeletedDate is null
select Type = 'Service', SubType = case isc.Name when 'Special Education' then 'SpecialEd' else isc.Name end, EnrichID = sd.ID, StateCode = isnull(sd.StateCode,''), LegacySpedCode = '', EnrichLabel = sd.Name from ServiceDef sd join IepServiceDef isd on sd.ID = isd.ID join IepServiceCategory isc on isd.CategoryID = isc.ID where sd.DeletedDate is null
union all
select Type = 'ServFreq', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceFrequency where DeletedDate is null 
union all
select Type = 'ServProv', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceProviderTitle where DeletedDate is null
order by Type, SubType, EnrichLabel

/*
select Type = 'Grade', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  GradeLevel 
union all
select Type = 'GoalArea', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  IepGoalAreaDef where DeletedDate is null 
union all
select Type = 'LRE', SubType = 'PK', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Text from  IepPlacementOption where DeletedDate is null
union all
select Type = 'PostSchArea', SubType = '', EnrichID = ID, StateCode = '', LegacySpedCode = '', EnrichLabel = Name from  IepPostSchoolAreaDef x 
union all
select Type = 'ServLoc', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  PrgLocation where DeletedDate is null
union all
select Type = 'Exit', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  PrgStatus where DeletedDate is null 
union all
select Type = 'Service', SubType = 'SpecialEd', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceDef where DeletedDate is null
union all
select Type = 'ServFreq', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceFrequency where DeletedDate is null 
union all
select Type = 'ServProv', SubType = '', EnrichID = ID, StateCode = isnull(StateCode,''), LegacySpedCode = '', EnrichLabel = Name from  ServiceProviderTitle where DeletedDate is null
order by Type, SubType, StateCode, EnrichLabel
*/
