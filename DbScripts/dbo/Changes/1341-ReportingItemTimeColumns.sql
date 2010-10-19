--Plan Expression : Add Columns
UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression = 
	'(SELECT p.*, p.TimeUntilPlannedEndDays/7 AS TimeUntilPlannedEndWeeks
	FROM
		(SELECT i.ID, i.PlannedEndDate,
			CASE
				WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
				ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
			END AS TimeUntilPlannedEndDays,
			DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
			DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
			DATEDIFF(DAY,PlannedEndDate,EndDate) AS TimeBetweenPlannedAndActualEndDateDays,
			DATEDIFF(WEEK,PlannedEndDate,EndDate) AS TimeBetweenPlannedAndActualEndDateWeeks,
			
			(SELECT TOP 1 bi.ID
			FROM PrgItem bi JOIN
				PrgItemDef bd on bd.ID = bi.DefID
			WHERE bi.StudentID = i.StudentID AND
				bi.ID <> i.ID AND
				NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
				bd.TypeID IN (''D7B183D8-5BBD-4471-8829-3C8D82A92478'',''03670605-58B2-40B2-99D5-4A1A70156C73'',''A5990B5E-AFAD-4EF0-9CCA-DC3685296870'') AND
				bi.EndDate IS NOT NULL AND
				bi.EndDate <= i.StartDate
			ORDER BY bi.EndDate DESC,
				CASE
					WHEN bi.DefID = i.DefID THEN 1
					WHEN bd.ProgramID = d.ProgramID THEN 2
					ELSE 3
				END ASC) AS PlanBeforeID,
			
			(SELECT TOP 1 ai.ID
			FROM PrgItem ai JOIN
				PrgItemDef ad on ad.ID = ai.DefID
			WHERE ai.StudentID = i.StudentID AND
				ai.ID <> i.ID AND
				NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
				ad.TypeID IN (''D7B183D8-5BBD-4471-8829-3C8D82A92478'',''03670605-58B2-40B2-99D5-4A1A70156C73'',''A5990B5E-AFAD-4EF0-9CCA-DC3685296870'') AND
				i.EndDate IS NOT NULL AND
				ai.StartDate >= i.EndDate
			ORDER BY ai.StartDate ASC,
				CASE
					WHEN ai.DefID = i.DefID THEN 1
					WHEN ad.ProgramID = d.ProgramID THEN 2
					ELSE 3
				END ASC) AS PlanAfterID	
		FROM PrgItem i JOIN
			PrgItemDef d ON d.ID = i.DefID
		WHERE d.TypeID IN (''D7B183D8-5BBD-4471-8829-3C8D82A92478'',''03670605-58B2-40B2-99D5-4A1A70156C73'',''A5990B5E-AFAD-4EF0-9CCA-DC3685296870'') ) p
	)'
WHERE Id = 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F'

--Existing Column Rename
UPDATE VC3Reporting.ReportSchemaColumn
SET Name = REPLACE(Name,'Days Until Planned End', 'Time Until Planned End (Days)'),
	ValueExpression = REPLACE(ValueExpression,'DaysUntilPlannedEnd','TimeUntilPlannedEndDays')
WHERE Id IN
(
	'2C2CC7FF-F5E3-481F-8AD6-4C34A08DA7E2',
	'26C22B3C-A095-40FF-86B6-1FFFB1863CE9',
	'4784D544-73D5-45AD-AACC-8F2745655B52',
	'C6AF67B0-157B-4F31-9FAE-3D3E99C2F37E'
)

UPDATE VC3Reporting.ReportSchemaColumn
SET Name = REPLACE(Name,'Weeks Until Planned End', 'Time Until Planned End (Weeks)'),
	ValueExpression = REPLACE(ValueExpression,'WeeksUntilPlannedEnd','TimeUntilPlannedEndWeeks')
WHERE Id IN
(
	'3666EFAF-5B1B-441D-A7FC-902DB6D7EAD7',
	'9287B4C9-3669-4FD4-941F-680457D2D2E0',
	'9C8C3AF5-35D6-4299-A0A0-DAD8639A7429',
	'C93DDAF0-D6E7-45F2-8674-E7227F6B3040'
)

--Plan Schema Columns
----Plan-------------------------------------------------------------------------------
DECLARE @planSchemaTableID uniqueidentifier
SET @planSchemaTableID = 'B1AA13A5-75E1-402A-8170-20B8E18FDF3F'

--Time Between Planned And Actual End Date (Days)
DECLARE @pTimeBetweenPlannedAndActualEndDateDaysColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateDaysColumnID = '29E31475-BFAB-485E-A10D-222BE3029903'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysColumnID, 'Time Between Planned And Actual End Date (Days)', @planSchemaTableID, 'I', NULL, 'TimeBetweenPlannedAndActualEndDateDays', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysColumnID, NULL)

--Time Between Planned And Actual End Date (Days) (Average)
DECLARE @pTimeBetweenPlannedAndActualEndDateDaysAverageColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateDaysAverageColumnID = '7BAC318B-571D-4435-8B54-BB9CFF0DE9A6'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysAverageColumnID, 'Time Between Planned And Actual End Date (Days) (Average)', @planSchemaTableID, 'N', NULL, 'AVG(CAST(TimeBetweenPlannedAndActualEndDateDays AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysAverageColumnID, NULL)

--Time Between Planned And Actual End Date (Days) (Max)
DECLARE @pTimeBetweenPlannedAndActualEndDateDaysMaxColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateDaysMaxColumnID = '383D039C-866C-458A-9F34-9663BCD562CD'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysMaxColumnID, 'Time Between Planned And Actual End Date (Days) (Max)', @planSchemaTableID, 'I', NULL, 'MAX(TimeBetweenPlannedAndActualEndDateDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysMaxColumnID, NULL)

--Time Between Planned And Actual End Date (Days) (Min)
DECLARE @pTimeBetweenPlannedAndActualEndDateDaysMinColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateDaysMinColumnID = 'F088A1CD-AFF1-4F9B-810A-23423643D72B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysMinColumnID, 'Time Between Planned And Actual End Date (Days) (Min)', @planSchemaTableID, 'I', NULL, 'MIN(TimeBetweenPlannedAndActualEndDateDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateDaysMinColumnID, NULL)

--Time Between Planned And Actual End Date (Weeks)
DECLARE @pTimeBetweenPlannedAndActualEndDateWeeksColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateWeeksColumnID = 'A068826F-3DA8-4780-BD53-5D415D490C1D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksColumnID, 'Time Between Planned And Actual End Date (Weeks)', @planSchemaTableID, 'I', NULL, 'TimeBetweenPlannedAndActualEndDateWeeks', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksColumnID, NULL)

--Time Between Planned And Actual End Date (Weeks) (Average)
DECLARE @pTimeBetweenPlannedAndActualEndDateWeeksAverageColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateWeeksAverageColumnID = 'D2B7DCF1-31CB-4D95-8326-357B0110F01C'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksAverageColumnID, 'Time Between Planned And Actual End Date (Weeks) (Average)', @planSchemaTableID, 'N', NULL, 'AVG(CAST(TimeBetweenPlannedAndActualEndDateWeeks AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksAverageColumnID, NULL)

--Time Between Planned And Actual End Date (Weeks) (Max)
DECLARE @pTimeBetweenPlannedAndActualEndDateWeeksMaxColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateWeeksMaxColumnID = '68368E29-9AE1-4FA2-8A53-544F3D314A2F'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksMaxColumnID, 'Time Between Planned And Actual End Date (Weeks) (Max)', @planSchemaTableID, 'I', NULL, 'MAX(TimeBetweenPlannedAndActualEndDateWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksMaxColumnID, NULL)

--Time Between Planned And Actual End Date (Weeks) (Min)
DECLARE @pTimeBetweenPlannedAndActualEndDateWeeksMinColumnID uniqueidentifier
SET @pTimeBetweenPlannedAndActualEndDateWeeksMinColumnID = '5D34D5DF-01AF-4A15-BAED-E9CA0F9E29B4'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksMinColumnID, 'Time Between Planned And Actual End Date (Weeks) (Min)', @planSchemaTableID, 'I', NULL, 'MIN(TimeBetweenPlannedAndActualEndDateWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@pTimeBetweenPlannedAndActualEndDateWeeksMinColumnID, NULL)

--Item Expression : Add Columns
UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression =
		'(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, 
			CASE 
				WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 
				ELSE 0 
			END AS IsActive,
			DATEDIFF(DAY,GETDATE(),StartDate) AS TimeUntilStartDays,
			DATEDIFF(WEEK,GETDATE(),StartDate) AS TimeUntilStartWeeks,
			DATEDIFF(DAY,EndDate,GETDATE()) AS TimeSinceEndDays,
			DATEDIFF(WEEK,EndDate,GETDATE()) AS TimeSinceEndWeeks
		FROM PrgItem i JOIN 
			PrgItemDef d ON d.ID = i.DefID LEFT JOIN 
			PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)
		)'
WHERE Id = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

----ProgramItem-------------------------------------------------------------------------------
DECLARE @programItemSchemaTableID uniqueidentifier
SET @programItemSchemaTableID = 'CA58AA53-C0AB-4326-AA35-6D74695596A7'

--Time Since End (Days)
DECLARE @piTimeSinceEndDaysColumnID uniqueidentifier
SET @piTimeSinceEndDaysColumnID = '2B623A8B-F3AC-46FC-A87E-9E293B009295'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndDaysColumnID, 'Time Since End (Days)', @programItemSchemaTableID, 'I', NULL, 'TimeSinceEndDays', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndDaysColumnID, NULL)

--Time Since End (Days) (Average)
DECLARE @piTimeSinceEndDaysAverageColumnID uniqueidentifier
SET @piTimeSinceEndDaysAverageColumnID = 'FC4D196A-26EF-4552-BFC6-DFA193757715'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndDaysAverageColumnID, 'Time Since End (Days) (Average)', @programItemSchemaTableID, 'N', NULL, 'AVG(CAST(TimeSinceEndDays AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndDaysAverageColumnID, NULL)

--Time Since End (Days) (Max)
DECLARE @piTimeSinceEndDaysMaxColumnID uniqueidentifier
SET @piTimeSinceEndDaysMaxColumnID = 'F168B741-5B13-4483-99D6-0329A68709FA'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndDaysMaxColumnID, 'Time Since End (Days) (Max)', @programItemSchemaTableID, 'I', NULL, 'MAX(TimeSinceEndDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndDaysMaxColumnID, NULL)

--Time Since End (Days) (Min)
DECLARE @piTimeSinceEndDaysMinColumnID uniqueidentifier
SET @piTimeSinceEndDaysMinColumnID = '18CCAD60-DBF4-4690-8435-4960038C2098'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndDaysMinColumnID, 'Time Since End (Days) (Min)', @programItemSchemaTableID, 'I', NULL, 'MIN(TimeSinceEndDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndDaysMinColumnID, NULL)

--Time Since End (Weeks)
DECLARE @piTimeSinceEndWeeksColumnID uniqueidentifier
SET @piTimeSinceEndWeeksColumnID = '631C8ED4-B64A-4B8F-8C16-61728E377829'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksColumnID, 'Time Since End (Weeks)', @programItemSchemaTableID, 'I', NULL, 'TimeSinceEndWeeks', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksColumnID, NULL)

--Time Since End (Weeks) (Average)
DECLARE @piTimeSinceEndWeeksAverageColumnID uniqueidentifier
SET @piTimeSinceEndWeeksAverageColumnID = 'AFFAB8BD-9E16-440B-9274-F4EC75A10E7D'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksAverageColumnID, 'Time Since End (Weeks) (Average)', @programItemSchemaTableID, 'N', NULL, 'AVG(CAST(TimeSinceEndWeeks AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksAverageColumnID, NULL)

--Time Since End (Weeks) (Max)
DECLARE @piTimeSinceEndWeeksMaxColumnID uniqueidentifier
SET @piTimeSinceEndWeeksMaxColumnID = 'A0794200-9B00-43C1-AEB4-F85281CFC2AD'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksMaxColumnID, 'Time Since End (Weeks) (Max)', @programItemSchemaTableID, 'I', NULL, 'MAX(TimeSinceEndWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksMaxColumnID, NULL)

--Time Since End (Weeks) (Min)
DECLARE @piTimeSinceEndWeeksMinColumnID uniqueidentifier
SET @piTimeSinceEndWeeksMinColumnID = 'F2CE90D8-F6B3-4C25-8615-D51F1160DFB9'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksMinColumnID, 'Time Since End (Weeks) (Min)', @programItemSchemaTableID, 'I', NULL, 'MIN(TimeSinceEndWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeSinceEndWeeksMinColumnID, NULL)

--Time Until Start (Days)
DECLARE @piTimeUntilStartDaysColumnID uniqueidentifier
SET @piTimeUntilStartDaysColumnID = '3E0475EC-6CBB-4B18-9EED-F15C3E658DD8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartDaysColumnID, 'Time Until Start (Days)', @programItemSchemaTableID, 'I', NULL, 'TimeUntilStartDays', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartDaysColumnID, NULL)

--Time Until Start (Days) (Average)
DECLARE @piTimeUntilStartDaysAverageColumnID uniqueidentifier
SET @piTimeUntilStartDaysAverageColumnID = 'F2785007-DD42-481E-8C6B-081037DB0554'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartDaysAverageColumnID, 'Time Until Start (Days) (Average)', @programItemSchemaTableID, 'N', NULL, 'AVG(CAST(TimeUntilStartDays AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartDaysAverageColumnID, NULL)

--Time Until Start (Days) (Max)
DECLARE @piTimeUntilStartDaysMaxColumnID uniqueidentifier
SET @piTimeUntilStartDaysMaxColumnID = 'DD02E23A-0C8F-44B5-9588-C9CF29BA041A'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartDaysMaxColumnID, 'Time Until Start (Days) (Max)', @programItemSchemaTableID, 'I', NULL, 'MAX(TimeUntilStartDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartDaysMaxColumnID, NULL)

--Time Until Start (Days) (Min)
DECLARE @piTimeUntilStartDaysMinColumnID uniqueidentifier
SET @piTimeUntilStartDaysMinColumnID = '24C6CA0B-ABFE-477F-AF22-ADECD43F09EA'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartDaysMinColumnID, 'Time Until Start (Days) (Min)', @programItemSchemaTableID, 'I', NULL, 'MIN(TimeUntilStartDays)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartDaysMinColumnID, NULL)

--Time Until Start (Weeks)
DECLARE @piTimeUntilStartWeeksColumnID uniqueidentifier
SET @piTimeUntilStartWeeksColumnID = '5B8B24B5-9217-4D04-96CB-047CB134D5D5'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksColumnID, 'Time Until Start (Weeks)', @programItemSchemaTableID, 'I', NULL, 'TimeUntilStartWeeks', NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksColumnID, NULL)

--Time Until Start (Weeks) (Average)
DECLARE @piTimeUntilStartWeeksAverageColumnID uniqueidentifier
SET @piTimeUntilStartWeeksAverageColumnID = '447D8B7C-0CD0-4BB7-B954-CC9CF296BFA0'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksAverageColumnID, 'Time Until Start (Weeks) (Average)', @programItemSchemaTableID, 'N', NULL, 'AVG(CAST(TimeUntilStartWeeks AS FLOAT))', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksAverageColumnID, NULL)

--Time Until Start (Weeks) (Max)
DECLARE @piTimeUntilStartWeeksMaxColumnID uniqueidentifier
SET @piTimeUntilStartWeeksMaxColumnID = 'AE57EA05-923D-43DA-9A2C-F3204AE03512'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksMaxColumnID, 'Time Until Start (Weeks) (Max)', @programItemSchemaTableID, 'I', NULL, 'MAX(TimeUntilStartWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksMaxColumnID, NULL)

--Time Until Start (Weeks) (Min)
DECLARE @piTimeUntilStartWeeksMinColumnID uniqueidentifier
SET @piTimeUntilStartWeeksMinColumnID = '4CD90EEC-5D5E-489B-9478-DC92AECBD45B'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksMinColumnID, 'Time Until Start (Weeks) (Min)', @programItemSchemaTableID, 'I', NULL, 'MIN(TimeUntilStartWeeks)', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, NULL, 0, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@piTimeUntilStartWeeksMinColumnID, NULL)

--Rename (Weeks) and (Days)-----------------------------------------------------------------

UPDATE VC3Reporting.ReportSchemaColumn
SET Name = REPLACE(Name,'(Days)','in Days')
WHERE Id IN
(
	'4712B1FA-E58E-4A89-964C-7F8309BBB95E',
	'3CA7A339-A289-49FA-BDDA-92D37286591E',
	'C4A10207-188D-4DC2-AB74-BF15BE7E9A5B',
	'D46E0FD9-2438-489C-A4A9-FD94199495AF',
	'36897EE1-9584-4165-9442-145830F1B94A',
	'3A8BE52D-626C-4AC2-9AA8-DA01D2DAC0CC',
	'07FE0153-BC60-4CE1-9F78-C6856B3A34F3',
	'6922C0D3-6CC4-48DF-BC54-9510E915ACC1',
	'29E31475-BFAB-485E-A10D-222BE3029903',
	'7BAC318B-571D-4435-8B54-BB9CFF0DE9A6',
	'383D039C-866C-458A-9F34-9663BCD562CD',
	'F088A1CD-AFF1-4F9B-810A-23423643D72B',
	'2B623A8B-F3AC-46FC-A87E-9E293B009295',
	'FC4D196A-26EF-4552-BFC6-DFA193757715',
	'F168B741-5B13-4483-99D6-0329A68709FA',
	'18CCAD60-DBF4-4690-8435-4960038C2098',
	'2C2CC7FF-F5E3-481F-8AD6-4C34A08DA7E2',
	'26C22B3C-A095-40FF-86B6-1FFFB1863CE9',
	'4784D544-73D5-45AD-AACC-8F2745655B52',
	'C6AF67B0-157B-4F31-9FAE-3D3E99C2F37E',
	'3E0475EC-6CBB-4B18-9EED-F15C3E658DD8',
	'F2785007-DD42-481E-8C6B-081037DB0554',
	'DD02E23A-0C8F-44B5-9588-C9CF29BA041A',
	'24C6CA0B-ABFE-477F-AF22-ADECD43F09EA'
)

UPDATE VC3Reporting.ReportSchemaColumn
SET Name = REPLACE(Name,'(Weeks)','in Weeks')
WHERE Id IN
(
	'2D43238F-7326-4F44-8639-ABDB91C134B9',
	'7A8B2260-BD9E-4116-A6B4-C19C9E49FAEB',
	'95904374-E1FC-4997-84AE-A6A0F9C551AF',
	'A9A7F270-1CD3-4C60-9C4F-ED14FBB7AA8E',
	'9E4CF7A6-EC61-44EA-9034-55BE205152FA',
	'DCFEFC82-805A-4339-9A48-CD5482318596',
	'84FD9532-6314-4898-99C8-C08BF598734E',
	'12782F42-FDEF-4259-A98D-987DD917800C',
	'A068826F-3DA8-4780-BD53-5D415D490C1D',
	'D2B7DCF1-31CB-4D95-8326-357B0110F01C',
	'68368E29-9AE1-4FA2-8A53-544F3D314A2F',
	'5D34D5DF-01AF-4A15-BAED-E9CA0F9E29B4',
	'631C8ED4-B64A-4B8F-8C16-61728E377829',
	'AFFAB8BD-9E16-440B-9274-F4EC75A10E7D',
	'A0794200-9B00-43C1-AEB4-F85281CFC2AD',
	'F2CE90D8-F6B3-4C25-8615-D51F1160DFB9',
	'3666EFAF-5B1B-441D-A7FC-902DB6D7EAD7',
	'9287B4C9-3669-4FD4-941F-680457D2D2E0',
	'9C8C3AF5-35D6-4299-A0A0-DAD8639A7429',
	'C93DDAF0-D6E7-45F2-8674-E7227F6B3040',
	'5B8B24B5-9217-4D04-96CB-047CB134D5D5',
	'447D8B7C-0CD0-4BB7-B954-CC9CF296BFA0',
	'AE57EA05-923D-43DA-9A2C-F3204AE03512',
	'4CD90EEC-5D5E-489B-9478-DC92AECBD45B'
)

UPDATE ReportArea
SET Name = 'Assessments'
WHERE ID = '0ABA081F-98BD-48CF-B0F4-AB6CC7BA07B9'