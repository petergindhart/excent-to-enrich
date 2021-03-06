DELETE x_DATAVALIDATION.ValidationRules WHERE TableName NOT IN ('Goal','Objective')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','StaffSchool','StaffEmail',1,'varchar','150','1','1','1','SpedStaffMember','StaffEmail','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','StaffSchool','SchoolCode',2,'varchar','10','1','1','1','School','SchoolCode','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SelectLists','Type',1,'varchar','20','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SelectLists','SubType',2,'varchar','20','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SelectLists','EnrichID',3,'varchar','150','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SelectLists','StateCode',4,'varchar','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SelectLists','LegacySpedCode',5,'varchar','150','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SelectLists','EnrichLabel',6,'varchar','254','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','District','DistrictCode',1,'varchar','10','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','District','DistrictName',2,'varchar','254','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','School','SchoolCode',1,'varchar','10','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','School','SchoolName',2,'varchar','254','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','School','DistrictCode',3,'varchar','10','1','1','1','District','DistrictCode','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','School','MinutesPerWeek',4,'int','4','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','StudentRefID',1,'varchar','150','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','StudentLocalID',2,'varchar','50','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','StudentStateID',3,'varchar','50','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Firstname',4,'varchar','50','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','MiddleName',5,'varchar','50','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','LastName',6,'varchar','50','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Birthdate',7,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Gender',8,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Gender','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','MedicaidNumber',9,'varchar','50','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','GradeLevelCode',10,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Grade','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','ServiceDistrictCode',11,'varchar','10','1','0','0',NULL,NULL,'1','District','Districtcode',NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','ServiceSchoolCode',12,'varchar','10','1','0','0',NULL,NULL,'1','School','Schoolcode ',NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','HomeDistrictCode',13,'varchar','10','1','0','0',NULL,NULL,'1','District','Districtcode',NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','HomeSchoolCode',14,'varchar','10','1','0','0',NULL,NULL,'1','School','Schoolcode ',NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','IsHispanic',15,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','IsAmericanIndian',16,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','IsAsian',17,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','IsBlackAfricanAmerican',18,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','IsHawaiianPacIslander',19,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','IsWhite',20,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability1Code',21,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability2Code',22,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability3Code',23,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability4Code',24,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability5Code',25,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability6Code',26,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability7Code',27,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability8Code',28,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','Disability9Code',29,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Disab','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','EsyElig',30,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','EsyTBDDate',31,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','ExitDate',32,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','ExitCode',33,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Exit','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Student','SpecialEdStatus',34,'char','1','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''A'',''E''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','IepRefID',1,'varchar','150','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','StudentRefID',2,'varchar','150','1','1','1','Student','StudentRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','IEPMeetDate',3,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','IEPStartDate',4,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','IEPEndDate',5,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','NextReviewDate',6,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','InitialEvaluationDate',7,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','LatestEvaluationDate',8,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','NextEvaluationDate',9,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','EligibilityDate',10,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','ConsentForServicesDate',11,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','ConsentForEvaluationDate',12,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','LREAgeGroup',13,'varchar','3','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','LRECode',14,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','LRE','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','MinutesPerWeek',15,'int','4','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','IEP','ServiceDeliveryStatement',16,'varchar','8000','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpedStaffMember','StaffEmail',1,'varchar','150','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpedStaffMember','Firstname',2,'varchar','50','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpedStaffMember','Lastname',3,'varchar','50','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpedStaffMember','EnrichRole',4,'varchar','50','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceType',1,'varchar','50','1','0','0',NULL,NULL,'1','SelectLists','SubType','Service','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceRefId',2,'varchar','150','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','IepRefId',3,'varchar','150','1','0','1','IEP','IepRefId','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceDefinitionCode',4,'varchar','150','0','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','Service','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','BeginDate',5,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','EndDate',6,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','IsRelated',7,'varchar','1','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','IsDirect',8,'varchar','1','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ExcludesFromGenEd',9,'varchar','1','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceLocationCode',10,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','ServLoc','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceProviderTitleCode',11,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','ServProv','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','Sequence',12,'int','2','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','IsESY',13,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceTime',14,'int','4','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceFrequencyCode',15,'varchar','150','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','ServFreq','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceProviderSSN',16,'varchar','11','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','StaffEmail',17,'varchar','150','0','0','0',NULL,NULL,'1','SpedStaffMember','StaffEmail',NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Service','ServiceAreaText',18,'varchar','254','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','TeamMember','StaffEmail',1,'varchar','150','1','1','1','SpedStaffMember','StaffEmail','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','TeamMember','StudentRefId',2,'varchar','150','1','1','1','Student','StudentRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','TeamMember','IsCaseManager',3,'varchar','1','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AccomMod','IEPRefID',1,'varchar','150','1','1','1','IEP','IEPRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AccomMod','AccomStatement',2,'varchar','8000','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AccomMod','ModStatement',3,'varchar','8000','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SchoolProgressFrequency','SchoolCode',1,'varchar','10','1','1','1','School','SchoolCode','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SchoolProgressFrequency','FrequencyName',2,'varchar','50','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--ClassroomAccommMod
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','ClassroomAccommMod','IEPRefID',1,'varchar','150','1','1','1','IEP','IepRefId','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','ClassroomAccommMod','AccommOrMod',2,'varchar','1','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''A'',''M''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','ClassroomAccommMod','Statement',3,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--PresentLevel
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PresentLevel','IEPRefID',1,'varchar','150','1','0','1','IEP','IepRefId','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PresentLevel','PresentLevelType',2,'varchar','50','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','PresentLevel','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PresentLevel','Statement',3,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--PostSchoolConsider
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolConsider','IEPRefID',1,'varchar','150','1','0','1','IEP','IepRefId','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolConsider','PostSchoolRefID',2,'varchar','150','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolConsider','ProjectedGradDate',3,'datetime','10','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolConsider','CompletionDocType',4,'varchar','50','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolConsider','AgeMajority',5,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolConsider','TransferRights',6,'varchar','1','0','0','0',NULL,NULL,'1',NULL,NULL,NULL,'1',' ''Y'',''N''')
--PostSchoolStatement
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolStatement','PostSchoolRefID',1,'varchar','150','1','1','1','PostSchoolConsider','PostSchoolRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolStatement','PostSchoolArea',2,'varchar','100','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','PostSchoolStatement','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PostSchoolStatement','Statement',3,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--SpecialFactors
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','IEPRefID',1,'varchar','150','1','1','1','IEP','IEPRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','Behavior',2,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','DeafBlind',3,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','DeafHH',4,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','BlindVI',5,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','HealthCarePlan',6,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','LEP',7,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','AssistiveTech',8,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','SpecialFactors','SpecialTrans',9,'varchar','1','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''Y'',''N''')
--AssessAccomm
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AssessAccomm','IEPRefID',1,'varchar','150','1','0','1','IEP','IEPRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AssessAccomm','AssessmentName',2,'varchar','100','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','AssessAccommName','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AssessAccomm','Participation',3,'varchar','25','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','AssessAccommPart','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','AssessAccomm','Statement',4,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--PriorWrittenNotice
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PriorWrittenNotice','IEPRefID',1,'varchar','150','1','0','1','IEP','IEPRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PriorWrittenNotice','OptionsOrFactors',2,'varchar','1','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'1',' ''O'',''F''')
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','PriorWrittenNotice','Statement',3,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--Evaluation
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Evaluation','IEPRefID',1,'varchar','150','1','0','1','IEP','IEPRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Evaluation','EvaluationRefID',2,'varchar','150','1','1','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Evaluation','VisionScreen',3,'varchar','200','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Evaluation','HearingScreen',4,'varchar','200','0','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','Evaluation','EvaluationSummary',5,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--EvaluationAssess
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','EvaluationAssess','EvaluationRefID',1,'varchar','150','1','0','1','Evaluation','EvaluationRefID','0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','EvaluationAssess','Category',2,'varchar','100','1','0','0',NULL,NULL,'1','SelectLists','Legacyspedcode','EvaluationAssess','0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','EvaluationAssess','AsessmentName',3,'varchar','255','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','EvaluationAssess','DateCompleted',4,'datetime','10','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','EvaluationAssess','Evaluators',5,'varchar','100','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
INSERT x_DATAVALIDATION.ValidationRules VALUES  ('x_DATAVALIDATION','EvaluationAssess','Results',6,'varchar','8000','1','0','0',NULL,NULL,'0',NULL,NULL,NULL,'0',NULL)
--SELECT * FROM x_DATAVALIDATION.ValidationRules