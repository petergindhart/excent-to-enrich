UPDATE VC3Reporting.ReportSchemaColumn
SET SchemaDataType = 'I'
WHERE Id IN 
(
	'EF898E28-A49B-4CF6-8613-BCC366DFB979',	--Attendance Change - Days In Time Range
	'AB4757B8-FCB6-46DA-85C2-70E3F3447E7B',	--Attendance Change - Days In Time Range (Max)
	'568464C9-0C47-4943-90E2-776ACC67FC05',	--Attendance Change - Days In Time Range (Min)
	'A73CB7DB-30FF-4C46-BCC9-098388D08482',	--Discipline Referral Change - Days In Time Range
	'27309E0D-580A-48D5-9DB7-6FE3A1FAE801',	--Discipline Referral Change - Days In Time Range (Max)
	'6DA16B00-C706-4E01-A0D5-710D814C74B4',	--Discipline Referral Change - Days In Time Range (Min)
	'2C2CC7FF-F5E3-481F-8AD6-4C34A08DA7E2',	--Plan - Days Until Planned End
	'4784D544-73D5-45AD-AACC-8F2745655B52',	--Plan - Days Until Planned End (Max)
	'C6AF67B0-157B-4F31-9FAE-3D3E99C2F37E',	--Plan - Days Until Planned End (Min)
	'D113E740-51AF-41E8-87CC-2C270A43BA4A',	--Program Item - Count
	'4712B1FA-E58E-4A89-964C-7F8309BBB95E',	--Program Item - Duration (Days)
	'C4A10207-188D-4DC2-AB74-BF15BE7E9A5B',	--Program Item - Duration (Days) (Max)
	'D46E0FD9-2438-489C-A4A9-FD94199495AF',	--Program Item - Duration (Days) (Min)
	'229A2D95-8C74-4AB3-A9DA-39E6A361F902'	--Student - Count
)

UPDATE VC3Reporting.ReportSchemaColumn
SET SchemaDataType = 'N',
	ValueExpression = REPLACE(SUBSTRING(ValueExpression,1,LEN(ValueExpression)-1),'AVG(','AVG(CAST(') + ' AS FLOAT))'
WHERE Id IN
(
	'2A1D6A52-2E78-431E-A0C2-9C135FC6997C',	--Attendance Change - Absences After Time Range (Average)
	'2D96C893-B988-4B19-9C74-EB1EA463B7F5',	--Attendance Change - Absences Before Time Range (Average)
	'9A83F011-70C1-4ED9-A975-9AECC3FC54DA',	--Attendance Change - Absences In Time Range (Average)
	'EC25DB29-3427-4B33-9751-7BB977392132',	--Attendance Change - Absences Per Day After Time Range (Average)
	'982B573E-C61F-4F12-89C7-330168FAE368',	--Attendance Change - Absences Per Day Before Time Range (Average)
	'4105DD16-A5EC-43DE-9486-5B57F532FAE7',	--Attendance Change - Absences Per Day In Time Range (Average)
	'C955FEDE-238A-468E-904C-E339E74123E3',	--Attendance Change - Absences Per Week After Time Range (Average)
	'3118BF9A-F0AC-4C50-BEFC-56E15E9007F5',	--Attendance Change - Absences Per Week Before Time Range (Average)
	'482601C8-5C71-456C-BC43-E48570BEE80D',	--Attendance Change - Absences Per Week In Time Range (Average)
	'81BDD005-9D76-434E-8BE0-2BBBC14E7899',	--Attendance Change - Change (%) (Average)
	'0EBAEEE2-3C14-4064-8FC9-2818CEF87EE1',	--Attendance Change - Change (Average)
	'10057843-41DE-4923-A140-1C4B1AD13177',	--Attendance Change - Change Per Day (%) (Average)
	'3535839E-AE7F-4978-A1F1-A8E4EE7619BC',	--Attendance Change - Change Per Day (Average)
	'65FAEEC9-A01F-4F90-82D9-C2A68CE7AC85',	--Attendance Change - Change Per Week (%) (Average)
	'604F553E-6F35-4217-B4E0-E529D191F5D4',	--Attendance Change - Change Per Week (Average)
	'94FC5556-3A55-4B01-AFDB-9C2E1EAEDD2E',	--Attendance Change - Days In Time Range (Average)
	'74FAF321-E393-4E43-9F24-654061F73CF0',	--Attendance Change - Weeks In Time Range (Average)
	'71D5AA7B-2D6D-4CE1-85B6-38BCE149E0AA',	--Discipline Referral Change - Change (%) (Average)
	'7A633400-D9B8-4342-A63D-73AB1528C8AB',	--Discipline Referral Change - Change (Average)
	'4FF24502-FFD3-45D8-8C8A-269F5B5FCD2E',	--Discipline Referral Change - Change Per Day (%) (Average)
	'92127CFE-3DAA-4782-A20F-55D754B6388C',	--Discipline Referral Change - Change Per Day (Average)
	'1D159B5A-1F9C-4F1B-A7FD-01F43E5DE0EA',	--Discipline Referral Change - Change Per Week (%) (Average)
	'986186FC-1727-4C77-9E09-C899EB25D00E',	--Discipline Referral Change - Change Per Week (Average)
	'DBFBD578-D084-4B84-96A7-C6F89B2C58B6',	--Discipline Referral Change - Days In Time Range (Average)
	'985F95E7-3296-46F7-AC81-3EF001A12EEF',	--Discipline Referral Change - Referrals After Time Range (Average)
	'D456DC1B-B071-4633-B718-867FE83FD624',	--Discipline Referral Change - Referrals Before Time Range (Average)
	'4500CA59-944C-4202-916D-ADA405119EFB',	--Discipline Referral Change - Referrals In Time Range (Average)
	'576062B3-BA13-43C9-9E1D-4731E146ABF0',	--Discipline Referral Change - Referrals Per Day After Time Range (Average)
	'56B01E35-2B4F-410C-B33F-5B350530A3BC',	--Discipline Referral Change - Referrals Per Day Before Time Range (Average)
	'1DB8A6F3-5069-4178-91D2-8028F80C5E4B',	--Discipline Referral Change - Referrals Per Day In Time Range (Average)
	'8F9094E9-FCBD-4CFF-8665-358E510A97F2',	--Discipline Referral Change - Referrals Per Week After Time Range (Average)
	'1B758FC2-918D-4BF4-BC8D-2E9336431AE8',	--Discipline Referral Change - Referrals Per Week Before Time Range (Average)
	'BB1FB874-C4A5-4006-BDA5-48D0A54438FF',	--Discipline Referral Change - Referrals Per Week In Time Range (Average)
	'3732844C-7D38-4694-A446-9FE375C4ED21',	--Discipline Referral Change - Weeks In Time Range (Average)
	'A770EBF2-ED08-4BD4-9FDE-FC53C043E7FA',	--Intervention Tool - Minutes Per Session (Average)
	'7868005E-F479-4505-9E35-CE6CD69AB404',	--Intervention Tool - Number Of Weeks (Average)
	'2FFD8BC1-67BB-4A28-B338-5BEBD0B8AA52',	--Intervention Tool - Sessions Per Week (Average)
	'26C22B3C-A095-40FF-86B6-1FFFB1863CE9',	--Plan - Days Until Planned End (Average)
	'3A8BE52D-626C-4AC2-9AA8-DA01D2DAC0CC',	--Plan - Planned Duration (Days) (Average)
	'DCFEFC82-805A-4339-9A48-CD5482318596',	--Plan - Planned Duration (Weeks) (Average)
	'9287B4C9-3669-4FD4-941F-680457D2D2E0',	--Plan - Weeks Until Planned End (Average)
	'3334FC3D-9827-4105-B9DF-0445354A4B99',	--Probe Score Change - Change (%) (Average)
	'BFE569CE-B26C-41EC-98FC-B8CE740F4FCA',	--Probe Score Change - Change (Average)
	'31737C41-F22C-4B82-838E-6DB412873241',	--Probe Score Change - Change Per Day (%) (Average)
	'5B3A1698-27FD-42EA-B7CB-319383F3788E',	--Probe Score Change - Change Per Day (Average)
	'0D3E35C4-A0AB-4A3C-87FC-EF7EA5C4075A',	--Probe Score Change - Change Per Week (%) (Average)
	'4DA9AEA1-4FD4-4767-BDFB-EA6E2CA0B036',	--Probe Score Change - Change Per Week (Average)
	'E986EBA8-EA36-42CC-AA27-8F369F964B06',	--Probe Score Change - Days Between End Point And Score (Average)
	'2FB52ADB-C8D7-4933-93F2-A05FF2777581',	--Probe Score Change - Days Between Scores (Average)
	'166F2BD3-49BA-42FB-B212-BC609D36E70E',	--Probe Score Change - Days Between Start Point And Score (Average)
	'8B9E345D-736F-4145-A035-54FC9220908F',	--Probe Score Change - End Score Value (Average)
	'9F53FC09-B370-479D-B241-25F15E935CCF',	--Probe Score Change - Start Score Value (Average)
	'09612CB4-B42D-4200-B365-F17019287A08',	--Probe Score Change - Weeks Between Scores (Average)
	'3CA7A339-A289-49FA-BDDA-92D37286591E',	--Program Item - Duration (Days) (Average)
	'7A8B2260-BD9E-4116-A6B4-C19C9E49FAEB'	--Program Item - Duration (Weeks) (Average)
)

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES('EE836D2E-EA16-49BD-89DA-1D34097D63F5', 'Name', 'F210EF27-1FBA-4518-B3F3-41DD8AFB4615', 'T', NULL, '{this}.LastName + '', '' + {this}.FirstName', NULL, '{this}.Id','~~/Students/Profile.aspx?s={0}',1,0,0,1,1,0,NULL,0,NULL,NULL)

INSERT INTO ReportSchemaColumn
VALUES('EE836D2E-EA16-49BD-89DA-1D34097D63F5', NULL)