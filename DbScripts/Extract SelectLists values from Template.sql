
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

