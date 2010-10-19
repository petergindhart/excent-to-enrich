
--select * from PrgActivity where ItemId='effde436-9b71-475c-b170-c37917bd350c' 

-- rename "Tool" to "Strategy"
update VC3Reporting.ReportSchemaTable set Name='Intervention Strategies' where Id='BA112066-0473-4F89-864A-BAE635E30EF4'
update VC3Reporting.ReportType set Name='Intervention Strategies', Description='Strategies used on intervention plans.  Can be used to analyze how different strategies impact interventions and student performance.' where Id='N'
update VC3Reporting.ReportTypeTable set Name='Intervention Strategy', ColumnPrefix='Strategy >' where Id='A5C4AE91-7D16-478D-9CA3-90800C456E96'

update SecurityTaskType set Name='Edit Strategy', DisplayName='Edit Strategy' where ID='75397555-AC0A-4470-AD7B-50BF0BEF5D17'
update SecurityTaskType set Name='View Strategy', DisplayName='View Strategy' where ID='DD14F929-54BC-4739-93B4-A44AB60EB8C5'


update SecurityTaskCategory set Name = 'Strategies' where Name = 'Tools'
