--#assume VC3ETL:25
GO

INSERT INTO VC3ETL.ExtractDatabaseTrigger VALUES (
'78237598-E4D6-4E47-808C-82E555BD0381','L','Synchronize School Organizational Hierarchy',1,
0,'School', null,'VC3.TestView.Business.SchoolOrgSyncTask, VC3.TestView', null, null)

INSERT INTO VC3ETL.TriggerDatabase 
select
	'78237598-E4D6-4E47-808C-82E555BD0381', 
	ed.ID
FROM
	VC3ETL.ExtractDatabase ed
WHERE
	id in 
	(
		'2900AF90-D6EA-4173-B5DC-8BA2A8E99C0D',
		'19A65267-D406-4624-852A-BEA3DB449C5C',
		'48F3EB0A-1139-43D5-BDDF-C66DD51642EB',
		'91BED6CC-69D6-4D4E-AAFA-D23E58934369'
	)