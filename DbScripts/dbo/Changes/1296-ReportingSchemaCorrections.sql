DELETE FROM VC3Reporting.ReportSchemaColumn
WHERE Id IN 
(
	'88B01F6B-81AB-43B1-9471-C33A8356D188',
	'154D7652-1B25-4F7B-91B1-64D9F65C8D90',
	'07AEE627-9983-4E82-B728-EC38D4348635',
	'AFB8382F-3E7A-4ADC-9B7C-CFC3E8F29F8D',
	'685F34FD-149F-4DF7-AEDA-860F5C25F962',
	'1BF868B3-197A-476F-ABA8-BA0E93416622'
)

UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression = '(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1))'
WHERE Id = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('06ECE633-CA6E-468D-83E0-999549B063FA', 'Active?', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'B', '(CASE WHEN {this}.IsActive = 1 THEN ''Yes'' ELSE ''No'' END)', 'IsActive', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT 1 Id, ''Yes'' Name UNION SELECT 0, ''No'' ORDER BY 1 DESC', 0, NULL, NULL)
INSERT INTO ReportSchemaColumn
VALUES ('06ECE633-CA6E-468D-83E0-999549B063FA', NULL)

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES ('4A924CEC-9B7B-4596-9D65-6ACF13408AF1', 'Team Leader', 'CA58AA53-C0AB-4326-AA35-6D74695596A7', 'G', '(SELECT p.LastName + '', '' + p.FirstName + ISNULL('' (Inactive as of '' + CONVERT(VARCHAR(MAX),u.Deleted,101) + '')'','''') FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = {this}.TeamLeaderID)', 'TeamLeaderID', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, 'SELECT DISTINCT u.ID, p.LastName + '', '' + p.FirstName + ISNULL('' (Inactive as of '' + CONVERT(VARCHAR(MAX),u.Deleted,101) + '')'','''') AS Name, ISNULL(s.Name, ''District'') AS Location FROM PrgItemTeamMember m JOIN UserProfile u ON (u.ID = m.PersonID AND m.IsPrimary = 1) JOIN Person p ON u.ID = p.ID LEFT JOIN School s ON s.ID = U.SchoolID ORDER BY Location, Name', 0, NULL, NULL)
INSERT INTO ReportSchemaColumn
VALUES ('4A924CEC-9B7B-4596-9D65-6ACF13408AF1', NULL)

UPDATE VC3Reporting.ReportSchemaColumn
SET ValueExpression = 'COUNT({this}.ID)'
WHERE Id IN
(
	'D113E740-51AF-41E8-87CC-2C270A43BA4A',
	'229A2D95-8C74-4AB3-A9DA-39E6A361F902'
)

UPDATE VC3Reporting.ReportSchemaColumn
SET ValueExpression = 'DefinitionID',
DisplayExpression = '(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM IntvToolDef WHERE ID={this}.DefinitionID)'
WHERE Id ='79497EA4-7AE2-4589-AAA5-9E1711EB7D93'