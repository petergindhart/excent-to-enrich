

update 	VC3Reporting.Report
set Title = REPLACE(Title, 'tool', 'strategy')
where id in ( '832B1FFF-E8DB-42B2-A8D7-6A819A4B0E1D', 'E2AC9ECF-C11C-4D9D-8EB4-858702A0703E', '44B198DC-CA15-4E10-828E-8CE8896D0CCC', '5B3CCD6D-9342-4F95-B076-BDCC219DFCDB')

update 	VC3Reporting.Report
set Description = REPLACE(cast(Description as varchar(8000)), 'tools', 'strategies')
where id in ( '832B1FFF-E8DB-42B2-A8D7-6A819A4B0E1D', 'E2AC9ECF-C11C-4D9D-8EB4-858702A0703E', '44B198DC-CA15-4E10-828E-8CE8896D0CCC', '5B3CCD6D-9342-4F95-B076-BDCC219DFCDB')

update 	VC3Reporting.Report
set Description = REPLACE(cast(Description as varchar(8000)), 'intervention tools', 'strategies')
where id in ( '832B1FFF-E8DB-42B2-A8D7-6A819A4B0E1D', 'E2AC9ECF-C11C-4D9D-8EB4-858702A0703E', '44B198DC-CA15-4E10-828E-8CE8896D0CCC', '5B3CCD6D-9342-4F95-B076-BDCC219DFCDB')

update 	VC3Reporting.Report
set Description = REPLACE(cast(Description as varchar(8000)), 'intervention tool', 'strategy')
where id in ( '832B1FFF-E8DB-42B2-A8D7-6A819A4B0E1D', 'E2AC9ECF-C11C-4D9D-8EB4-858702A0703E', '44B198DC-CA15-4E10-828E-8CE8896D0CCC', '5B3CCD6D-9342-4F95-B076-BDCC219DFCDB')

update 	VC3Reporting.Report
set Description = REPLACE(cast(Description as varchar(8000)), 'tool', 'strategy')
where id in ( '832B1FFF-E8DB-42B2-A8D7-6A819A4B0E1D', 'E2AC9ECF-C11C-4D9D-8EB4-858702A0703E', '44B198DC-CA15-4E10-828E-8CE8896D0CCC', '5B3CCD6D-9342-4F95-B076-BDCC219DFCDB')


-- fix 'APY' typo
update VC3Reporting.ReportType
set Description = 'Frequency distribution of student test scores.  Can be used to analyzed student achievement in aggregate.  Data can also be disaggregated into more specific groupings, such as ethnicity and gender, which is useful for AYP reporting.'
where Id='Y'

