--#assume VC3ETL:26

INSERT INTO VC3ETL.ExtractDatabaseTrigger VALUES ( 
'D082F1FF-BDAE-4412-AC20-480D819207AA',
'A',
'Update Program Item Demographics',
1,
0,
NULL,
'dbo.PrgItem_SynchronizeDemographics',
NULL,
NULL,
NULL)

INSERT INTO VC3ETL.TriggerDatabase
SELECT
	 'D082F1FF-BDAE-4412-AC20-480D819207AA',
	ID
FROM
	vc3etl.ExtractDatabase
WHERE
	ID in
	(
		'2900AF90-D6EA-4173-B5DC-8BA2A8E99C0D',
		'19A65267-D406-4624-852A-BEA3DB449C5C',
		'48F3EB0A-1139-43D5-BDDF-C66DD51642EB',
		'91BED6CC-69D6-4D4E-AAFA-D23E58934369'
	)
	
	
UPDATE VC3Reporting.ReportSchemaColumn
SET Description= '<h6>{reportTypeColumn}</h6><p class=''overview''>The current grade level of the student if the {reportTypeTable} is active. Otherwise, the grade level as of the {reportTypeTable}''s end date.</p>'
WHERE ID='B8B29473-8A6D-4BEB-95AE-0EA1309725B2'

UPDATE VC3Reporting.ReportSchemaColumn
SET Description= '<h6>{reportTypeColumn}</h6><p class=''overview''>The current school of the student if the {reportTypeTable} is active. Otherwise, the school as of the {reportTypeTable}''s end date.</p>'
WHERE ID='0F35373C-3561-49B5-A0D9-EA5C9A1B1218'