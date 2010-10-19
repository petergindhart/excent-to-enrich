BEGIN TRAN

-------------------------------------------------------------

-- Delete and recreate template reports
-- current reports
delete from VC3Reporting.Report where id='308B46BC-1812-4CF1-9A2C-42DA7E965DC2'
delete from VC3Reporting.Report where id='01CB5B6A-F0D3-4313-9B3E-A9D5367A9393'
delete from VC3Reporting.Report where id='5B3CCD6D-9342-4F95-B076-BDCC219DFCDB'
delete from VC3Reporting.Report where id='22af8f11-96eb-4044-819b-a0de21bbe411'
delete from VC3Reporting.Report where id='ed81bca7-cb68-4b75-b1b8-30e98eaa86ce'
delete from VC3Reporting.Report where id='D80EBE64-97F4-487F-989D-8A55ED00204D'
delete from VC3Reporting.Report where id='CA73F156-FC5A-491D-A4F1-413F371C624F'
delete from VC3Reporting.Report where id='d7999f84-54f0-4da6-b196-2e19c0337cd7'
delete from VC3Reporting.Report where id='5ef6d38b-0937-4c11-af76-0ccc4a251ea4'
delete from VC3Reporting.Report where id='e2ac9ecf-c11c-4d9d-8eb4-858702a0703e'
delete from VC3Reporting.Report where id='65dadb9f-7eb9-49a5-99bf-ff21b406130d'
delete from VC3Reporting.Report where id='a7e4b22f-587f-49aa-a91d-ab6eeea54315'
delete from VC3Reporting.Report where id='EEDF57C4-E290-46ED-AAF5-D4C5E4AD8EC6'
delete from VC3Reporting.Report where id='465f560a-cf09-45c2-911d-c9470c46ed10'
delete from VC3Reporting.Report where id='832B1FFF-E8DB-42B2-A8D7-6A819A4B0E1D'
delete from VC3Reporting.Report where id='6bb3d688-48bc-407d-bdf9-98d477556987'
delete from VC3Reporting.Report where id='75fc9c73-8810-477f-a271-2438a04c06c3'
delete from VC3Reporting.Report where id='8242f808-25d9-4fd3-8c36-b4e4699a017e'
delete from VC3Reporting.Report where id='45c279e0-b0c3-4624-94ef-beb074d93212'
delete from VC3Reporting.Report where id='44b198dc-ca15-4e10-828e-8ce8896d0ccc'
delete from VC3Reporting.Report where id='86bfac1e-6594-45a8-9ca7-bd0e127dcd26'
delete from VC3Reporting.Report where id='23859535-596c-415a-b98c-03ab914c0a5e'
delete from VC3Reporting.Report where id='4C3DDEAB-39CD-494D-9C36-DA0796C9A7CC'


-- obsolete reports
delete vc3reporting.report where id in (
'0C5E24F8-01E5-4481-9CF4-7BA3089551DA',
'3E4A9C0E-B8F5-4571-9F20-3AAE414AE1B6',
'0BF9728C-8A06-4273-B353-714EDF4F4C98',
'CBA5D684-EFDE-4D4C-A8F4-5A07092FAFBD',
'CA73F156-FC5A-491D-A4F1-413F371C624F'
)

-- recreate report areas
delete from ReportAreaReport
delete from ReportArea

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_Report TABLE (Id uniqueidentifier, Title varchar(200), Query text, Type char(1), Path varchar(300), Description text, Format char(1))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_Report VALUES ('23859535-596c-415a-b98c-03ab914c0a5e', 'Discipline referral improvement rates by team leader', '-- Generated at 6/30/2010 2:34:29 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) drc_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	(SELECT p.LastName + '', '' + p.FirstName + ISNULL('' (Inactive as of '' + CONVERT(VARCHAR(MAX),u.Deleted,101) + '')'','''') FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = ii.TeamLeaderID) ii_TeamLeader,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_DisciplineReferralChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) drc_ItemStart_ItemEnd_30_ on i.ID = drc_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	ii.DefID, ii.TeamLeaderID
order by
	ii_Name ASC, ii_TeamLeader ASC
', 'N', '~/S-e7d179ae-0ead-4018-a6d3-78cca0b3b48c', 'Listing of all team leaders/interventionists with discipline referral improvement rate for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('5ef6d38b-0937-4c11-af76-0ccc4a251ea4', 'Probe score improvement rates by grade level', '-- Generated at 6/29/2010 11:54:44 AM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekAverage,
	MAX(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMax,
	(SELECT ''Grade '' + Name FROM GradeLevel WHERE ID=ii.GradeLevelID) ii_GradeLevel,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_ProbeScoreChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', ''43b058d0-85c9-4dba-8872-3fb76717154c'')) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute on i.ID = psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	ii.GradeLevelID, ii.DefID
order by
	(SELECT Sequence FROM GradeLevel WHERE ID=ii.GradeLevelID) ASC, ii_Name ASC
', 'N', '~/S-f2466d4d-0ae5-4abb-95af-ec42d4f03751', 'Listing of all grade levels with probe score improvement rate for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('f228b8a5-1962-4d31-b83f-1de4251c4683', 'Overdue intervention plans', '-- Generated at 7/2/2010 8:51:55 AM
declare @now DateTime
set @now = GetDate()

select
	p.PlannedEndDate p_PlannedEndDate,
	(SELECT p.LastName + '', '' + p.FirstName + ISNULL('' (Inactive as of '' + CONVERT(VARCHAR(MAX),u.Deleted,101) + '')'','''') FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = i.TeamLeaderID) i_TeamLeader,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	s.LastName + '', '' + s.FirstName s_Name,
	s.Id s_Name1
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				p.DaysUntilPlannedEnd<=0
			) and (
				i.IsActive=1
			) and (
				i.ProgramID=''7de3b3d7-b60f-48ac-9681-78d46a5e74d4''
			)
			
	)
	
)
order by
	p_PlannedEndDate DESC
', 'P', '~/S-ff9cdd08-9db1-4e6e-982f-611ca327905a', 'Listing of all active interventions whose planned end date has passed, and that have not been ended', 'X')
INSERT INTO @vc3reporting_Report VALUES ('75fc9c73-8810-477f-a271-2438a04c06c3', 'Attendance improvement rates by team leader', '-- Generated at 6/30/2010 1:53:59 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) ac_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	(SELECT p.LastName + '', '' + p.FirstName + ISNULL('' (Inactive as of '' + CONVERT(VARCHAR(MAX),u.Deleted,101) + '')'','''') FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = i.TeamLeaderID) i_TeamLeader,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_AttendanceChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) ac_ItemStart_ItemEnd_30_ on p.ID = ac_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	i.DefID, i.TeamLeaderID
order by
	i_Name ASC, i_TeamLeader ASC
', 'P', '~/S-e11d7c83-26ef-49a8-b15f-e09e483c9eb5', 'Listing of all team leaders/interventionists with attendance improvement rate for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('d7999f84-54f0-4da6-b196-2e19c0337cd7', 'Probe score improvement rates by school', '-- Generated at 7/1/2010 3:00:39 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekAverage,
	MAX(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	(SELECT Name FROM School WHERE ID=ii.SchoolID) ii_School,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_ProbeScoreChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', ''43b058d0-85c9-4dba-8872-3fb76717154c'')) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute on i.ID = psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	ii.DefID, ii.SchoolID
order by
	ii_Name ASC, ii_School ASC
', 'N', '~/S-db7c4063-8770-414d-a686-7afb75d6d29c', 'Listing of all schools with probe score improvement rate for each.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', 'Intervention plan outcomes by ethnicity', '-- Generated at 7/1/2010 4:20:37 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	(SELECT Text FROM PrgItemOutcome WHERE ID = i.ItemOutcomeID) i_Outcome,
	COUNT(i.ID) i_Count,
	(select DisplayValue + '' ('' + Code + '')'' from EnumValue where Id=s.EthnicityID) s_Ethnicity,
	COUNT(s.ID) s_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				i.IsActive=0
			) and (
				i.ProgramID=''7de3b3d7-b60f-48ac-9681-78d46a5e74d4''
			)
			
	)
	
)
group by
	i.DefID, i.ItemOutcomeID, s.EthnicityID
order by
	i_Name ASC, s_Ethnicity ASC, i_Outcome ASC
', 'P', '~/S-0da8df9f-6ce4-4766-b6b2-a6e8ac4d0a35', 'Can be used to determine number of intervention outcomes broken down by ethnicity.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('308b46bc-1812-4cf1-9a2c-42da7e965dc2', 'Past intervention plans', '-- Generated at 7/1/2010 12:04:02 PM
declare @now DateTime
set @now = GetDate()

select
	i.EndDate i_EndDate,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	(SELECT Text FROM PrgItemOutcome WHERE ID = i.ItemOutcomeID) i_Outcome,
	s.LastName s_LastName,
	s.FirstName s_FirstName,
	s.Id s_LastName1
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				i.ProgramID=''7de3b3d7-b60f-48ac-9681-78d46a5e74d4''
			) and (
				i.IsActive=0
			) and (
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			)
			
	)
	
)
order by
	s_LastName ASC, s_FirstName ASC, i_EndDate ASC, i_Name ASC
', 'P', '~/S-c65284af-8a9e-4c67-a609-3dd1e46cd58f', 'Listing of all inactive intervention plans within a date range.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', 'Attendance improvement rates by tool', '-- Generated at 6/30/2010 1:57:44 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM IntvToolDef WHERE ID=it.DefinitionID) it_Name,
	MIN(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) ac_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_AttendanceChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) ac_ItemStart_ItemEnd_30_ on i.ID = ac_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	it.DefinitionID, ii.DefID
order by
	ii_Name ASC, it_Name ASC
', 'N', '~/S-d2b44b75-6dea-4e18-8538-c108bbfe3e2d', 'See how student attendance improvement rates vary when different intervention tools are used', 'X')
INSERT INTO @vc3reporting_Report VALUES ('e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', 'Probe score improvement rates by tool', '-- Generated at 6/30/2010 2:01:56 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM IntvToolDef WHERE ID=it.DefinitionID) it_Name,
	MIN(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekAverage,
	MAX(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_ProbeScoreChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', ''43b058d0-85c9-4dba-8872-3fb76717154c'')) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute on i.ID = psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	it.DefinitionID, ii.DefID
order by
	ii_Name ASC, it_Name ASC
', 'N', '~/S-091198dc-f626-4da6-ac1a-5990dbf9bbfe', 'See how probe score improvement rates change when different intervention tools are used', 'X')
INSERT INTO @vc3reporting_Report VALUES ('d80ebe64-97f4-487f-989d-8a55ed00204d', 'Upcoming meeting dates', '-- Generated at 7/1/2010 2:45:04 PM
declare @now DateTime
set @now = GetDate()

select
	m.StartTime m_StartTime,
	m.EndTime m_EndTime,
	i.StartDate i_StartDate,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	s.LastName + '', '' + s.FirstName s_Name,
	s.Id s_Name1
from
		(SELECT m.*, i.StartDate AS StartTime, i.EndDate AS EndTime,
		(SELECT TOP 1 bi.ID
		FROM PrgMeeting bm JOIN
			PrgItem bi ON bi.ID = bm.ID JOIN
			PrgItemDef bd ON bd.ID = bi.DefID
		WHERE bi.StudentID = i.StudentID AND
			bi.ID <> i.ID AND
			NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
			bi.EndDate IS NOT NULL AND
			bi.EndDate <= i.StartDate
		ORDER BY bi.EndDate DESC,
			CASE
				WHEN bi.DefID = i.DefID THEN 1
				WHEN bd.ProgramID = d.ProgramID THEN 2
				ELSE 3
			END ASC) AS MeetingBeforeID,
	
		(SELECT TOP 1 ai.ID
		FROM PrgMeeting am JOIN
			PrgItem ai ON ai.ID = am.ID JOIN
			PrgItemDef ad ON ad.ID = ai.DefID
		WHERE ai.StudentID = i.StudentID AND
			ai.ID <> i.ID AND
			NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
			i.EndDate IS NOT NULL AND
			ai.StartDate >= i.EndDate
		ORDER BY ai.StartDate ASC,
			CASE
				WHEN ai.DefID = i.DefID THEN 1
				WHEN ad.ProgramID = d.ProgramID THEN 2
				ELSE 3
			END ASC) AS MeetingAfterID	
	FROM PrgMeeting m JOIN 
		PrgItem i ON i.ID = m.ID JOIN
		PrgItemDef d ON d.ID = i.DefID) m join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on m.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				i.IsActive=1
			)
			
	)
	
)
order by
	i_StartDate ASC, m_StartTime ASC
', 'M', '~/S-d58f46d5-dbf5-4d69-96a4-9cd38289f39d', 'Listing of all upcoming RTI-related meeting dates and times.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('44b198dc-ca15-4e10-828e-8ce8896d0ccc', 'Discipline referral improvement rates by tool', '-- Generated at 6/30/2010 2:12:45 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM IntvToolDef WHERE ID=it.DefinitionID) it_Name,
	MIN(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) drc_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_DisciplineReferralChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) drc_ItemStart_ItemEnd_30_ on i.ID = drc_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	it.DefinitionID, ii.DefID
order by
	ii_Name ASC, it_Name ASC
', 'N', '~/S-8579e84d-1896-45c8-bcde-2c05c42b5b72', 'See how discipline referal improvement rates vary when different intervention tools are used', 'X')
INSERT INTO @vc3reporting_Report VALUES ('6bb3d688-48bc-407d-bdf9-98d477556987', 'Attendance improvement rates by plan duration', '-- Generated at 6/30/2010 1:49:55 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) ac_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMax,
	DATEDIFF(WEEK, StartDate, EndDate) i_DurationWeeks,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_AttendanceChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) ac_ItemStart_ItemEnd_30_ on p.ID = ac_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	DATEDIFF(WEEK, StartDate, EndDate)
order by
	i_DurationWeeks ASC
', 'P', '~/S-f83e6cfd-6975-4404-9803-7da4e7c0d046', 'See how attendance improvement rates vary for different plan durations', 'X')
INSERT INTO @vc3reporting_Report VALUES ('22af8f11-96eb-4044-819b-a0de21bbe411', 'Action counts by ethnicity', '-- Generated at 7/1/2010 12:13:50 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	COUNT(i.ID) i_Count,
	(select DisplayValue + '' ('' + Code + '')'' from EnumValue where Id=s.EthnicityID) s_Ethnicity,
	COUNT(s.ID) s_Count
from
		(SELECT a.*,
		(SELECT TOP 1 bi.ID
		FROM PrgActivity ba JOIN
			PrgItem bi ON bi.ID = ba.ID JOIN
			PrgItemDef bd ON bd.ID = bi.DefID
		WHERE bi.StudentID = i.StudentID AND
			bi.ID <> i.ID AND
			NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
			bi.EndDate IS NOT NULL AND
			bi.EndDate <= i.StartDate
		ORDER BY bi.EndDate DESC,
			CASE
				WHEN bi.DefID = i.DefID THEN 1
				WHEN bd.ProgramID = d.ProgramID THEN 2
				ELSE 3
			END ASC) AS ActionBeforeID,
	
		(SELECT TOP 1 ai.ID
		FROM PrgActivity aa JOIN
			PrgItem ai ON ai.ID = aa.ID JOIN
			PrgItemDef ad ON ad.ID = ai.DefID
		WHERE ai.StudentID = i.StudentID AND
			ai.ID <> i.ID AND
			NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
			i.EndDate IS NOT NULL AND
			ai.StartDate >= i.EndDate
		ORDER BY ai.StartDate ASC,
			CASE
				WHEN ai.DefID = i.DefID THEN 1
				WHEN ad.ProgramID = d.ProgramID THEN 2
				ELSE 3
			END ASC) AS ActionAfterID	
	FROM PrgActivity a JOIN 
		PrgItem i ON i.ID = a.ID JOIN
		PrgItemDef d ON d.ID = i.DefID) a join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on a.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.StartDate<=''1/1/2100''
			) and (
				i.ProgramID=''7de3b3d7-b60f-48ac-9681-78d46a5e74d4''
			)
			
	)
	
)
group by
	i.DefID, s.EthnicityID
order by
	i_Name ASC, s_Ethnicity ASC
', 'T', '~/S-23eaf2e0-958e-46da-a0f4-e29ce6a72c5f', 'Can be used to determine number of actions, such as referrals, broken down by ethnicity.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', 'Summary of intervention outcomes', '-- Generated at 7/1/2010 12:05:58 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	(SELECT Text FROM PrgItemOutcome WHERE ID = i.ItemOutcomeID) i_Outcome,
	COUNT(i.ID) i_Count,
	COUNT(s.ID) s_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				i.ProgramID=''7de3b3d7-b60f-48ac-9681-78d46a5e74d4''
			) and (
				i.IsActive=0
			) and (
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	i.DefID, i.ItemOutcomeID
order by
	i_Name ASC, i_Outcome ASC
', 'P', '~/S-7bd2c8d2-65c6-4a55-97a5-9cb1f2c92a3a', 'Number of interventions that have been closed for each outcome.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('a7e4b22f-587f-49aa-a91d-ab6eeea54315', 'Probe score improvement rates by team leader', '-- Generated at 6/29/2010 12:28:15 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekAverage,
	MAX(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	(SELECT p.LastName + '', '' + p.FirstName + ISNULL('' (Inactive as of '' + CONVERT(VARCHAR(MAX),u.Deleted,101) + '')'','''') FROM UserProfile u JOIN Person p ON u.ID = p.ID WHERE u.ID = ii.TeamLeaderID) ii_TeamLeader,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_ProbeScoreChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', ''43b058d0-85c9-4dba-8872-3fb76717154c'')) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute on i.ID = psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	ii.DefID, ii.TeamLeaderID
order by
	ii_Name ASC, ii_TeamLeader ASC
', 'N', '~/S-6155b0cb-caae-4802-8e82-dbdfc8793e6c', 'Listing of all team leaders/interventionists with probe score improvement rate for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('8242f808-25d9-4fd3-8c36-b4e4699a017e', 'Discipline referral improvement rates by school', '-- Generated at 6/30/2010 2:24:24 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) drc_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	(SELECT Name FROM School WHERE ID=i.SchoolID) i_School,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_DisciplineReferralChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) drc_ItemStart_ItemEnd_30_ on p.ID = drc_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	i.DefID, i.SchoolID
order by
	i_Name ASC, i_School ASC
', 'P', '~/S-5ce18177-6683-4eeb-b9c8-a5d224607ff7', 'Listing of all schools with discipline improvement rate (discipline referrals per week) for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('86bfac1e-6594-45a8-9ca7-bd0e127dcd26', 'Discipline referral improvement rates by plan duration', '-- Generated at 6/30/2010 2:12:06 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) drc_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMax,
	DATEDIFF(WEEK, StartDate, EndDate) i_DurationWeeks,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_DisciplineReferralChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) drc_ItemStart_ItemEnd_30_ on p.ID = drc_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	DATEDIFF(WEEK, StartDate, EndDate)
order by
	i_DurationWeeks ASC
', 'P', '~/S-edd9735d-d5fb-492f-be3a-69749103471f', 'See how discipline referral improvement rates vary for different plan durations', 'X')
INSERT INTO @vc3reporting_Report VALUES ('5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', 'Intervention plan outcomes by tool and tier', '-- Generated at 7/1/2010 12:09:38 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM IntvToolDef WHERE ID=it.DefinitionID) it_Name,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=ii.DefID) ii_Name,
	(SELECT Text FROM PrgItemOutcome WHERE ID = ii.ItemOutcomeID) ii_Outcome,
	COUNT(ii.ID) ii_Count,
	COUNT(s.ID) s_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID join
		Student s on ii.StudentID = s.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	it.DefinitionID, ii.DefID, ii.ItemOutcomeID
order by
	ii_Name ASC, it_Name ASC, ii_Outcome ASC
', 'N', '~/S-b969ff71-9216-4481-b040-dfae65460ffb', 'Number of interventions for each outcome, broken down by tool and tier.', 'X')
INSERT INTO @vc3reporting_Report VALUES ('45c279e0-b0c3-4624-94ef-beb074d93212', 'Discipline referral improvement rates by grade level', '-- Generated at 6/30/2010 2:29:38 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) drc_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) drc_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ''Grade '' + Name FROM GradeLevel WHERE ID=i.GradeLevelID) i_GradeLevel,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_DisciplineReferralChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) drc_ItemStart_ItemEnd_30_ on p.ID = drc_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	i.GradeLevelID, i.DefID
order by
	(SELECT Sequence FROM GradeLevel WHERE ID=i.GradeLevelID) ASC, i_Name ASC
', 'P', '~/S-401f4f76-2d6d-4601-898e-b5b1f0f98b8e', 'Listing of all grade levels with discipline improvement rate (discipline referrals per week) for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('465f560a-cf09-45c2-911d-c9470c46ed10', 'Attendance improvement rates by grade level', '-- Generated at 6/30/2010 1:51:28 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) ac_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ''Grade '' + Name FROM GradeLevel WHERE ID=i.GradeLevelID) i_GradeLevel,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_AttendanceChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) ac_ItemStart_ItemEnd_30_ on p.ID = ac_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	i.GradeLevelID, i.DefID
order by
	(SELECT Sequence FROM GradeLevel WHERE ID=i.GradeLevelID) ASC, i_Name ASC
', 'P', '~/S-0d5df8ce-2547-4cde-af6a-d53e4f512b68', 'Listing of all grade levels with attendance improvement rate (absences per week) for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', 'Attendance improvement rates by school', '-- Generated at 6/30/2010 1:40:39 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) ac_ItemStart_ItemEnd_30__ChangePerWeekAverage,
	MAX(ChangePerWeek) ac_ItemStart_ItemEnd_30__ChangePerWeekMax,
	(SELECT ISNULL(Name + '' (Inactive as of '' + CONVERT(VARCHAR(MAX),DeletedDate,101) + '')'', Name) FROM PrgItemDef WHERE ID=i.DefID) i_Name,
	(SELECT Name FROM School WHERE ID=i.SchoolID) i_School,
	COUNT(i.ID) i_Count
from
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) p join
		(SELECT *
			FROM PrgItem_AttendanceChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', 30, null)) ac_ItemStart_ItemEnd_30_ on p.ID = ac_ItemStart_ItemEnd_30_.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on p.ID = i.ID
	where
(

	(
		
			(
				i.StartDate>=''1/1/1900''
			) and (
				i.EndDate<=''1/1/2100''
			) and (
				i.IsActive=0
			)
			
	)
	
)
group by
	i.DefID, i.SchoolID
order by
	i_Name ASC, i_School ASC
', 'P', '~/S-afc43593-d440-4aa0-9e6a-48dc396350fd', 'Listing of all schools with attendance improvement rate (absences per week) for each ', 'X')
INSERT INTO @vc3reporting_Report VALUES ('4c3ddeab-39cd-494d-9c36-da0796c9a7cc', 'Referral outcomes list', '-- Generated at 6/8/2010 5:36:30 PM
declare @now DateTime
set @now = GetDate()

select
	(SELECT Text FROM PrgItemOutcome WHERE ID = i.ItemOutcomeID) i_Outcome,
	i.EndDate i_EndDate,
	s.LastName s_LastName,
	s.FirstName s_FirstName,
	s.Id s_LastName1
from
		(SELECT a.*,
		(SELECT TOP 1 bi.ID
		FROM PrgActivity ba JOIN
			PrgItem bi ON bi.ID = ba.ID JOIN
			PrgItemDef bd ON bd.ID = bi.DefID
		WHERE bi.StudentID = i.StudentID AND
			bi.ID <> i.ID AND
			NOT(bi.StartDate = i.StartDate AND bi.EndDate = i.EndDate) AND
			bi.EndDate IS NOT NULL AND
			bi.EndDate <= i.StartDate
		ORDER BY bi.EndDate DESC,
			CASE
				WHEN bi.DefID = i.DefID THEN 1
				WHEN bd.ProgramID = d.ProgramID THEN 2
				ELSE 3
			END ASC) AS ActionBeforeID,
	
		(SELECT TOP 1 ai.ID
		FROM PrgActivity aa JOIN
			PrgItem ai ON ai.ID = aa.ID JOIN
			PrgItemDef ad ON ad.ID = ai.DefID
		WHERE ai.StudentID = i.StudentID AND
			ai.ID <> i.ID AND
			NOT(ai.StartDate = i.StartDate AND ai.EndDate = i.EndDate) AND
			i.EndDate IS NOT NULL AND
			ai.StartDate >= i.EndDate
		ORDER BY ai.StartDate ASC,
			CASE
				WHEN ai.DefID = i.DefID THEN 1
				WHEN ad.ProgramID = d.ProgramID THEN 2
				ELSE 3
			END ASC) AS ActionAfterID	
	FROM PrgActivity a JOIN 
		PrgItem i ON i.ID = a.ID JOIN
		PrgItemDef d ON d.ID = i.DefID) a join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) i on a.ID = i.ID join
		Student s on i.StudentID = s.ID
	where
(

	(
		
			(
				i.EndDate>=@EndDate
			)
			
	)
	
)
order by
	i_Outcome ASC
', 'T', '~/S-a206ece5-9971-445f-9412-9ae36873972d', 'Listing of all referral outcomes', 'X')
INSERT INTO @vc3reporting_Report VALUES ('65dadb9f-7eb9-49a5-99bf-ff21b406130d', 'Probe score improvement rates by plan duration', '-- Generated at 6/29/2010 12:00:03 PM
declare @now DateTime
set @now = GetDate()

select
	MIN(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMin,
	AVG(CAST(ChangePerWeek AS FLOAT)) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekAverage,
	MAX(ChangePerWeek) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute_ChangePerWeekMax,
	DATEDIFF(WEEK, StartDate, EndDate) ii_DurationWeeks,
	COUNT(ii.ID) ii_Count
from
		(SELECT *
			FROM IntvTool) it join
		(SELECT p.*, p.DaysUntilPlannedEnd/7 AS WeeksUntilPlannedEnd
				FROM
					(SELECT i.ID, i.PlannedEndDate,
						CASE
							WHEN EndDate IS NOT NULL OR PlannedEndDate IS NULL THEN NULL
							ELSE CAST(DATEDIFF(DAY,GETDATE(),PlannedEndDate) AS FLOAT)
						END AS DaysUntilPlannedEnd,
						DATEDIFF(DAY,StartDate,EndDate) AS PlannedDurationDays,
						DATEDIFF(WEEK,StartDate,EndDate) AS PlannedDurationWeeks,
						
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
				) i on it.InterventionID = i.ID join
		(SELECT *
			FROM PrgItem_ProbeScoreChange(''e5bf3494-3a29-4c56-96a9-c2ea81bcbb70'', ''e9ef6ac7-e839-464e-9044-a658e9b2d12b'', ''43b058d0-85c9-4dba-8872-3fb76717154c'')) psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute on i.ID = psc_ItemStart_ItemEnd_WordsReadCorrectlyPerMinute.ItemID join
		(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, CASE WHEN EndDate IS NULL OR EndDate >= GETDATE() THEN 1 ELSE 0 END AS IsActive FROM PrgItem i JOIN PrgItemDef d ON d.ID = i.DefID LEFT JOIN PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)) ii on i.ID = ii.ID
	where
(

	(
		
			(
				ii.IsActive=0
			) and (
				ii.StartDate>=''1/1/1900''
			) and (
				ii.EndDate<=''1/1/2100''
			)
			
	)
	
)
group by
	DATEDIFF(WEEK, StartDate, EndDate)
order by
	ii_DurationWeeks ASC
', 'N', '~/S-e15e27fc-4d75-4a4a-8e02-f54fb995a639', 'See how probe score improvement rates vary for different plan durations', 'X')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @Report TABLE (Id uniqueidentifier, Owner uniqueidentifier, IsPublished bit, SecurityZone uniqueidentifier, IsSharingEnabled bit, IsSharedWithEveryone bit, RunAsOwner bit, IsHidden bit, OmitNulls bit, DateCreated datetime)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @Report VALUES ('23859535-596c-415a-b98c-03ab914c0a5e', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 2:32:16 PM')
INSERT INTO @Report VALUES ('5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/29/2010 11:54:43 AM')
INSERT INTO @Report VALUES ('f228b8a5-1962-4d31-b83f-1de4251c4683', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '7/2/2010 8:51:55 AM')
INSERT INTO @Report VALUES ('75fc9c73-8810-477f-a271-2438a04c06c3', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 1:53:19 PM')
INSERT INTO @Report VALUES ('d7999f84-54f0-4da6-b196-2e19c0337cd7', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/29/2010 12:03:17 PM')
INSERT INTO @Report VALUES ('ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'b46252c8-fe46-423a-acb7-13a1753c04ce', 1, 1, 0, 0, 1, '7/1/2010 11:56:47 AM')
INSERT INTO @Report VALUES ('308b46bc-1812-4cf1-9a2c-42da7e965dc2', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/7/2010 10:27:19 AM')
INSERT INTO @Report VALUES ('832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 1:57:44 PM')
INSERT INTO @Report VALUES ('e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/29/2010 11:40:50 AM')
INSERT INTO @Report VALUES ('d80ebe64-97f4-487f-989d-8a55ed00204d', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/16/2010 9:41:58 AM')
INSERT INTO @Report VALUES ('44b198dc-ca15-4e10-828e-8ce8896d0ccc', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 2:03:55 PM')
INSERT INTO @Report VALUES ('6bb3d688-48bc-407d-bdf9-98d477556987', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 1:49:55 PM')
INSERT INTO @Report VALUES ('22af8f11-96eb-4044-819b-a0de21bbe411', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/29/2010 12:18:10 PM')
INSERT INTO @Report VALUES ('01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/3/2010 2:12:29 PM')
INSERT INTO @Report VALUES ('a7e4b22f-587f-49aa-a91d-ab6eeea54315', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/29/2010 12:28:14 PM')
INSERT INTO @Report VALUES ('8242f808-25d9-4fd3-8c36-b4e4699a017e', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 2:21:37 PM')
INSERT INTO @Report VALUES ('86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 2:07:33 PM')
INSERT INTO @Report VALUES ('5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/3/2010 2:20:51 PM')
INSERT INTO @Report VALUES ('45c279e0-b0c3-4624-94ef-beb074d93212', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 2:27:21 PM')
INSERT INTO @Report VALUES ('465f560a-cf09-45c2-911d-c9470c46ed10', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 1:42:45 PM')
INSERT INTO @Report VALUES ('eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/30/2010 1:39:03 PM')
INSERT INTO @Report VALUES ('4c3ddeab-39cd-494d-9c36-da0796c9a7cc', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/8/2010 10:01:12 AM')
INSERT INTO @Report VALUES ('65dadb9f-7eb9-49a5-99bf-ff21b406130d', '45d80567-55f6-4c2a-b431-d4b7a1f6d6c7', 0, 'cac5d55a-794f-4fbe-9d91-8b9e2ce13dd2', 1, 1, 0, 0, 1, '6/29/2010 12:00:03 PM')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportColumn TABLE (Id uniqueidentifier, Type char(1), Report uniqueidentifier, ReportTypeTable uniqueidentifier, SchemaColumn uniqueidentifier, Sequence int)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_ReportColumn VALUES ('87823273-81cc-4c6a-91fa-0029d2db7576', 'S', '8242f808-25d9-4fd3-8c36-b4e4699a017e', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', '986186fc-1727-4c77-9e09-c899eb25d00e', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2a03f1e2-f792-47a8-bff8-0094e2c86880', 'F', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'df3187aa-320e-4bfa-a2fe-6159adea9522', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('dd92d2fd-e5e0-4397-a220-027d9449c4f5', 'S', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('0c87a966-fe50-43c8-ad50-03ace5a02802', 'O', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('291b38e0-045b-40be-9957-04ba6aafb4d6', 'O', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('f7453f59-ea03-4f69-8d65-052c28a73ac0', 'F', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('dfa41d57-25ea-40b5-bd9b-053102c75889', 'F', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5e58c6e2-6fbf-46d4-88ed-05b2e6fde96c', 'O', 'f228b8a5-1962-4d31-b83f-1de4251c4683', 'defa9577-3303-41d9-b2bb-6534c26ff6f1', '7ad2107d-5256-4efe-acdc-52a128a1685f', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('67d5e6f7-3130-4556-bfba-06abb2b71f68', 'S', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '8d007416-d37c-4f07-9893-154c31ade2e4', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a4003ae5-1057-4104-adf0-081a7e2659fc', 'F', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7d79e253-a359-4a7f-92c6-09d812839f60', 'S', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7d7ffd92-f2a4-4887-b06d-09f042089474', 'S', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '0f35373c-3561-49b5-a0d9-ea5c9a1b1218', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('013e6718-722c-44de-9185-0a9bf1029084', 'F', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('55b2dc2e-09cd-451f-8f0c-0aaec9bf1015', 'O', 'd80ebe64-97f4-487f-989d-8a55ed00204d', '7551be83-f8c5-4849-b8cb-7a1d56e2efff', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9786f901-7635-4915-a087-0b5a28df1fc1', 'O', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2860ff01-68eb-427d-93dc-0b71b79ced31', 'O', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('19579856-c405-48cc-a4f5-0cd641af2a72', 'S', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7e5d4006-d17b-456b-bf6d-0dc38d73860e', 'S', '465f560a-cf09-45c2-911d-c9470c46ed10', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '5474eea8-3dbc-481a-a80e-7d5f960a463c', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('09e85424-61de-464c-b8b9-0f404cbbc302', 'F', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e01ec701-e30f-49ae-8c01-0fc9697550cd', 'S', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('cae717e1-88c3-476b-8d8f-1157a8d09392', 'O', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '32428bd8-171e-469f-be69-681207279c33', '214aff6a-37dd-46b8-bd24-41b3ed858b5c', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('781b417b-5628-4242-8dd1-12767d803445', 'S', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '8d007416-d37c-4f07-9893-154c31ade2e4', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('54149325-203e-43a3-80a9-12ebb4024b03', 'F', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9cb187dc-f051-478f-8c30-140e3a5f2ccc', 'S', '8242f808-25d9-4fd3-8c36-b4e4699a017e', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', '23c6cb4f-7fe1-4c79-9798-4d3c06e070e0', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('d2d9b736-daa9-4b22-b669-15a2efe8ff65', 'S', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('cbed2bf9-ae32-44a5-9422-15bf98ffc028', 'S', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('61532ab1-470e-4301-9589-16722851202d', 'O', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('87aa2ab0-c622-4645-bb28-16775ec0e6cf', 'S', '465f560a-cf09-45c2-911d-c9470c46ed10', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '604f553e-6f35-4217-b4e0-e529d191f5d4', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('05da33b2-447e-46f3-843c-1742be1d1310', 'F', 'd80ebe64-97f4-487f-989d-8a55ed00204d', '7551be83-f8c5-4849-b8cb-7a1d56e2efff', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4e2b4675-77db-4162-8755-17a7cfc30553', 'S', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('dff6e96e-0a9b-4260-869a-17bc8235a0ed', 'S', 'f228b8a5-1962-4d31-b83f-1de4251c4683', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c260713c-d42d-454d-b628-1a3e8b71979d', 'O', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '2d43238f-7326-4f44-8639-abdb91c134b9', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('79055387-e1c1-4f5e-bc03-1bbff57c9d8e', 'S', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e82d5309-6992-4e09-9bcf-1f991073e2d1', 'S', '45c279e0-b0c3-4624-94ef-beb074d93212', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', '986186fc-1727-4c77-9e09-c899eb25d00e', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7ae0f5cd-0fe1-451c-8c5d-225780444259', 'O', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'b8b29473-8a6d-4beb-95ae-0ea1309725b2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c12b69a5-7dab-4bfe-a0c1-24169597cf35', 'S', '75fc9c73-8810-477f-a271-2438a04c06c3', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '604f553e-6f35-4217-b4e0-e529d191f5d4', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('011aa6de-99f0-4081-ad61-2458cb73513d', 'S', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('0f5579ac-68e6-4629-bbe6-248f0ba0ef9e', 'S', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2a28c3f1-cd41-4fc8-881e-26e89599d0d2', 'O', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('25cf6ec8-3d79-4323-b90b-275e0f7379f9', 'S', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a180a96b-f8a9-4bc1-8bc4-27b1940fce7a', 'S', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4890d9c5-b9a0-4348-9396-27c08338a03f', 'F', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('447b5956-30de-4af9-8337-28d1a4278c69', 'O', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6c67e88e-be44-4871-b5dc-292aaf12cfb6', 'O', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a937d22b-adfa-4d87-a1df-29590427b516', 'S', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', '23c6cb4f-7fe1-4c79-9798-4d3c06e070e0', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4407acb1-997b-4261-bf50-2a86186b63eb', 'F', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4b526589-56b2-4b03-8770-2b92ab1537c8', 'S', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('171bf6e9-d035-44d8-a917-2bdd4fbff861', 'S', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('0f08660e-b505-4a74-82ba-2cb230b5a98b', 'S', '6bb3d688-48bc-407d-bdf9-98d477556987', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '5474eea8-3dbc-481a-a80e-7d5f960a463c', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('eec07d50-afc2-4dfd-b012-2de33a084668', 'S', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', '8d007416-d37c-4f07-9893-154c31ade2e4', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('afa3f20d-ed19-4205-b100-2f2f73489856', 'S', '23859535-596c-415a-b98c-03ab914c0a5e', '1b3a53f5-54d7-4fbf-b514-a15c3943f357', '986186fc-1727-4c77-9e09-c899eb25d00e', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('dfe54b62-b480-47d8-88f5-2f975fb1f4c4', 'O', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b892cba4-1296-4397-86a7-31893be19d1d', 'S', '465f560a-cf09-45c2-911d-c9470c46ed10', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '820af260-3d0a-449e-96a9-3d2b558c5e6e', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5124b7d4-6fb8-44e1-a0fc-32e6ac1509b2', 'S', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('20123234-fab8-4b04-98e3-34f1ab285107', 'S', '6bb3d688-48bc-407d-bdf9-98d477556987', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '604f553e-6f35-4217-b4e0-e529d191f5d4', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6b66360d-abe1-4b88-860f-34fc6179ab0c', 'S', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', 'b538b557-8896-41b4-8451-04e046c0f4a2', '77e28f7e-e682-4700-b6b1-823e5a9fe064', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('077526e4-0479-4bf5-ab61-377a957373c2', 'S', '75fc9c73-8810-477f-a271-2438a04c06c3', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '820af260-3d0a-449e-96a9-3d2b558c5e6e', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('87fda43b-a11c-4fe7-bc48-38d657464ef5', 'F', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('13b86368-d53a-4895-96af-393a0e7814d7', 'F', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('726cd776-5dd7-443d-9795-3af0487119bf', 'S', 'd80ebe64-97f4-487f-989d-8a55ed00204d', 'b42ff3dd-baaf-40d0-b604-700ff1e17c5d', '68bab34b-1efb-4b7f-b86a-b857d2bc7582', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3d758df1-c15c-4f70-9b10-3db350427623', 'O', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('722ccf90-1c41-4c7e-844e-3ecf05a93f3b', 'S', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a4dea1e8-bb7a-4775-86f1-429b38813521', 'S', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4092570f-5fd2-4035-9e37-1a9ce0383db0', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('59560f14-1c35-4822-991f-43a0d5afd60a', 'F', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c28d38b8-bdb8-49bf-b770-471c3e6982f0', 'S', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', 'c4fd789a-ddea-4154-9168-62f979399cde', '820af260-3d0a-449e-96a9-3d2b558c5e6e', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('623b97c3-c7cc-4393-9d1c-47a1529c7fc6', 'F', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b8945bdc-4055-4ebf-bf9e-483c5a72d8e8', 'F', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e53e17b2-d102-4f56-a0a9-49d2ec3f5b00', 'O', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('294b4a8e-3deb-486e-9934-4a5ac83498a5', 'F', '6bb3d688-48bc-407d-bdf9-98d477556987', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('bb8bbd00-2110-4a7f-b093-4a6e8156d5a0', 'S', '22af8f11-96eb-4044-819b-a0de21bbe411', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c7afd21e-b54c-4d4c-af67-4bcf43384270', 'F', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6841fcfb-2b0c-48ea-b143-4c05aeb5aa17', 'S', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4619651d-ba34-4150-8ee8-4c7f7073a71e', 'S', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b896b7d6-e5ad-42a1-ae4d-4f0fd4b5bfb3', 'S', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '32428bd8-171e-469f-be69-681207279c33', '229a2d95-8c74-4ab3-a9da-39e6a361f902', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2534c2ad-c4db-49d9-b581-4f241e103cff', 'S', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'b8b29473-8a6d-4beb-95ae-0ea1309725b2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4fcecfc7-b54b-4a82-924c-4feba80d0364', 'S', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', 'b538b557-8896-41b4-8451-04e046c0f4a2', '77e28f7e-e682-4700-b6b1-823e5a9fe064', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ce5b71bb-fc7b-4893-998c-52227ff6d983', 'S', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '2d43238f-7326-4f44-8639-abdb91c134b9', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a0d9d9de-e2fd-4c2f-864f-52442a958926', 'F', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('f766b396-6808-489f-886d-527669f25e75', 'S', '75fc9c73-8810-477f-a271-2438a04c06c3', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '5474eea8-3dbc-481a-a80e-7d5f960a463c', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ef879c25-9968-4cc2-ae36-53f6b2cc19aa', 'O', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('181d4287-a600-4c6a-9cb2-553aa28ac6e0', 'S', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4092570f-5fd2-4035-9e37-1a9ce0383db0', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7a10c266-aa99-491b-8d89-56201b45b250', 'S', '6bb3d688-48bc-407d-bdf9-98d477556987', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '2d43238f-7326-4f44-8639-abdb91c134b9', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('aac9d38e-b70e-4bc4-9d7a-5895e999a8e5', 'F', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a3414f4d-b203-4c32-b015-5a049bd1baa8', 'S', '22af8f11-96eb-4044-819b-a0de21bbe411', 'eb0fdca4-36df-481a-a205-cfb0043a40e0', '99000460-0b79-45a2-97dd-07ea1a8a9900', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7eb48bf7-c6b4-44de-b9c2-5b2aa2e77161', 'S', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('cfee461f-4b71-400a-aece-5c8658d3bb62', 'S', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '604f553e-6f35-4217-b4e0-e529d191f5d4', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('09efb65b-1287-4ab7-9edf-5f0e0b8f5208', 'S', 'd80ebe64-97f4-487f-989d-8a55ed00204d', '7551be83-f8c5-4849-b8cb-7a1d56e2efff', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('629f22eb-0dcf-41c0-9048-5f4c350180a0', 'O', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6b65dd3b-718e-4e0e-8066-6099d47a3ab0', 'F', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('51d16621-0839-4dcb-82f2-60eafdc32d59', 'F', 'f228b8a5-1962-4d31-b83f-1de4251c4683', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'df3187aa-320e-4bfa-a2fe-6159adea9522', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('19812137-ed39-4093-87af-617c4717b16f', 'S', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4092570f-5fd2-4035-9e37-1a9ce0383db0', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('640f3856-8fa4-4bde-83c5-628194275242', 'F', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('fffae2af-b9bd-4ccc-8e49-644b4479675e', 'O', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '2d43238f-7326-4f44-8639-abdb91c134b9', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5223648f-0de1-4411-b969-646e36b63641', 'F', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('8b05e823-0d1b-43fc-954d-64db4abfad60', 'S', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('07c842d5-abe3-46fc-a517-6599a0fb530a', 'S', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2a191fc1-c27d-4547-9af2-66c40969bffa', 'S', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('37b4cca9-c0e2-46f6-84ee-68238310325b', 'O', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('df69d2eb-b81e-4c2b-b9cc-698611ce50d4', 'F', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7252134a-1916-41b0-80bb-6bfe8229758d', 'O', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7b9d27e7-31a0-462e-8c69-6c199a5dbbcd', 'S', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '0f35373c-3561-49b5-a0d9-ea5c9a1b1218', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('074be88e-61c4-494f-8eff-6d87d5eb41bf', 'S', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '5474eea8-3dbc-481a-a80e-7d5f960a463c', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('bbe9f7ee-94d5-4dd2-85f1-6e9384d7f8bb', 'F', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('21685920-ab76-48e6-9292-6ec725c309a3', 'O', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '8d007416-d37c-4f07-9893-154c31ade2e4', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('46addc53-b373-4465-a9e7-6fb1e48c0546', 'S', 'd80ebe64-97f4-487f-989d-8a55ed00204d', 'b42ff3dd-baaf-40d0-b604-700ff1e17c5d', '7c0a4cf0-78ab-416d-8061-b6f16f12f02a', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6a44b149-a8f5-4470-ba39-7155c92e7493', 'S', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b74dcc8f-8399-44a0-85af-72a8590f21c8', 'O', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '8d007416-d37c-4f07-9893-154c31ade2e4', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('30221871-1362-4605-89d7-72d1848abd0a', 'S', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'b8b29473-8a6d-4beb-95ae-0ea1309725b2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a2e084cb-584f-4149-88e1-72f946ae7a0e', 'F', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6d8d7119-4ff5-4010-838f-74dfa727b5fc', 'S', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', 'c4fd789a-ddea-4154-9168-62f979399cde', '5474eea8-3dbc-481a-a80e-7d5f960a463c', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('abfe02ea-fce2-4108-b2b6-75ff706ec3e2', 'S', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '8d007416-d37c-4f07-9893-154c31ade2e4', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('da6910a6-4874-461a-b43a-773701d96ad1', 'O', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '0f35373c-3561-49b5-a0d9-ea5c9a1b1218', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('d93077ae-69e9-49a7-9eb2-783ec9135c1e', 'S', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '820af260-3d0a-449e-96a9-3d2b558c5e6e', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5b63244a-a6aa-45a6-a67d-78b9d04dea5a', 'S', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('1a86f12a-f130-41bd-9455-7966fec4d6f7', 'S', '22af8f11-96eb-4044-819b-a0de21bbe411', 'eb0fdca4-36df-481a-a205-cfb0043a40e0', '229a2d95-8c74-4ab3-a9da-39e6a361f902', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a1da3483-3285-4f92-8a08-7a2bcde1778f', 'S', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '8d007416-d37c-4f07-9893-154c31ade2e4', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5abcfeb7-cbdf-4617-aa8b-7bf5b02af661', 'S', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('d24d254e-4b3f-41ea-988a-7c864e98c190', 'S', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4da9aea1-4fd4-4767-bdfb-ea6e2ca0b036', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c9f1cc27-2d7c-4a21-8780-7db648fc1261', 'S', 'd80ebe64-97f4-487f-989d-8a55ed00204d', '9dca7df2-09cf-4f95-9f08-13bb381609bb', 'ee836d2e-ea16-49bd-89da-1d34097d63f5', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('1a23e6fd-65f3-469a-b890-7f369a3b3186', 'F', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('bbe5ab11-3d20-4502-aa0c-7f43b56e7ca4', 'S', '6bb3d688-48bc-407d-bdf9-98d477556987', '77eba24f-fc3c-42e7-a1c1-843b28f47f9e', '820af260-3d0a-449e-96a9-3d2b558c5e6e', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3fb257df-a692-4986-86aa-816f827a2f4f', 'S', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('df004c6e-d9d7-4ab9-9c7e-827cb1735ab9', 'S', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4da9aea1-4fd4-4767-bdfb-ea6e2ca0b036', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4b51f9e8-878c-4fe0-9b04-830d5cbc5630', 'S', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5ee1feec-9942-4763-8beb-83661db104b9', 'S', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4da9aea1-4fd4-4767-bdfb-ea6e2ca0b036', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('f8cd2d6c-754f-4f6d-a886-83a9504fa8de', 'S', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '32428bd8-171e-469f-be69-681207279c33', 'fecb71b8-911a-4399-9884-4b87efbf7f0e', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a715c5ba-8199-4b33-8b4c-857d53233d85', 'S', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', 'b538b557-8896-41b4-8451-04e046c0f4a2', '77e28f7e-e682-4700-b6b1-823e5a9fe064', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('1ad8fff6-3c06-4a95-bc12-863a26d875bd', 'O', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('42d133d9-2f70-4ab2-ac0e-8a27e9c5c443', 'O', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('32043e9e-db58-4b5d-b849-8dbd96431209', 'S', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2b8956b6-207a-486f-9790-8e99dd08bfbd', 'S', '23859535-596c-415a-b98c-03ab914c0a5e', '1b3a53f5-54d7-4fbf-b514-a15c3943f357', '23c6cb4f-7fe1-4c79-9798-4d3c06e070e0', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6d447ebe-f9a9-4605-8543-8f62795a6874', 'F', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('eb3d0133-4764-4883-98ed-92235be1e331', 'S', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', 'df168178-e245-4b62-9c0e-f2152ccb60a7', '229a2d95-8c74-4ab3-a9da-39e6a361f902', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4cbc33e9-a360-4816-af47-923046a623ea', 'S', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('815b4f0b-aa94-43c6-9607-92a270600608', 'F', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3292491a-31d1-4365-b8d4-9323526a6aff', 'F', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('896b95a5-8cf8-49cb-b62d-93d086056609', 'O', '6bb3d688-48bc-407d-bdf9-98d477556987', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '2d43238f-7326-4f44-8639-abdb91c134b9', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ed7f0b42-a8f0-4e35-ab29-946a63c4b53e', 'S', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1b3a53f5-54d7-4fbf-b514-a15c3943f357', '23c6cb4f-7fe1-4c79-9798-4d3c06e070e0', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('20e01bd1-e0f4-47b3-9746-94cc8c688621', 'F', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9d67b42c-ddbe-4046-a2f2-95d6ec2e4d49', 'O', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '32428bd8-171e-469f-be69-681207279c33', 'fecb71b8-911a-4399-9884-4b87efbf7f0e', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e672cb65-f2c7-4f46-89dd-9655f5a5969a', 'S', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ac22bcb0-733c-4c9c-9cb6-976051a82546', 'S', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c220e86d-b3e3-431e-95cc-9859cdebf52f', 'F', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('42099c3e-67fd-4f72-ae42-98754fbdf212', 'F', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('08948757-c6cf-45f6-911a-9a6fca8d5b5a', 'O', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '32428bd8-171e-469f-be69-681207279c33', '99000460-0b79-45a2-97dd-07ea1a8a9900', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('291151cf-5c2b-47f0-b4e2-9aefb3a446cd', 'O', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('58db83a1-c7ec-4bb5-b7b2-9c55859d057a', 'S', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', '986186fc-1727-4c77-9e09-c899eb25d00e', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('647e6c3b-00b0-4ae1-85a1-9d5dc4d5bc5d', 'F', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4784623b-3298-499a-abbf-9e3dea77cafb', 'O', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '0f35373c-3561-49b5-a0d9-ea5c9a1b1218', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5ac32e8d-7a27-4389-9c36-9e858105bdf2', 'F', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a31f9e18-2252-4b92-9ece-a1de9a6e8a1e', 'S', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '0f35373c-3561-49b5-a0d9-ea5c9a1b1218', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5e97135e-a50d-4081-be5d-a2585fd23426', 'F', '6bb3d688-48bc-407d-bdf9-98d477556987', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5a5d7acf-b82c-45c7-afa7-a3b76c3d2fba', 'S', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('357ea342-3c72-4565-8aa3-a4a5ab90cf79', 'S', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4092570f-5fd2-4035-9e37-1a9ce0383db0', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ede53a21-f585-4251-a509-a5fac124298b', 'S', '8242f808-25d9-4fd3-8c36-b4e4699a017e', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', 'fe555a3f-900d-4c0b-8da3-570574958ddc', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5e409305-2e1f-4768-aa11-a6f36fa2d303', 'F', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('d4a63a16-cee7-40d4-9a20-a77dfea69586', 'S', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('dddee212-d248-4fa0-910b-a958900c2aa3', 'S', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '2d43238f-7326-4f44-8639-abdb91c134b9', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('51aea8d5-fb41-41a4-a708-aa9b745508ad', 'S', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', 'b538b557-8896-41b4-8451-04e046c0f4a2', '77e28f7e-e682-4700-b6b1-823e5a9fe064', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('dd492e6e-3abf-4417-8f99-aafa4f37530e', 'F', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('34defb1d-aca5-4481-90c7-af7c1a6c1e05', 'O', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', '8d007416-d37c-4f07-9893-154c31ade2e4', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ad351291-8ae2-4863-ac58-af98d0dd7deb', 'O', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('cdd1c9f0-8184-4825-8bd8-b3cd8ec626d3', 'O', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '0f35373c-3561-49b5-a0d9-ea5c9a1b1218', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('8d9319b6-983f-412f-b13e-b45046fe69c7', 'S', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4da9aea1-4fd4-4767-bdfb-ea6e2ca0b036', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b19e882b-6d06-499f-a7a7-b67760fe870c', 'P', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', '92fd154c-93a0-497b-ba69-2822ad9ae051', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('16020587-abef-427e-b024-b7b8b9267323', 'F', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('60a13a22-dfd0-4eb7-859a-b88d62ff2ebe', 'F', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('06228bf3-cb3f-4a42-8447-b93d6fa5216f', 'S', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', '92fd154c-93a0-497b-ba69-2822ad9ae051', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('09d5fdee-7075-428b-8d0f-b9b55f489f34', 'S', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4da9aea1-4fd4-4767-bdfb-ea6e2ca0b036', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c9013d89-7d2a-4e09-8e5d-ba6d26414e49', 'S', 'f228b8a5-1962-4d31-b83f-1de4251c4683', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b8d16fa3-6126-4248-9d66-baf946237c0c', 'F', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('1e32bcfa-6435-444c-b496-bc09e780781d', 'S', '45c279e0-b0c3-4624-94ef-beb074d93212', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', '23c6cb4f-7fe1-4c79-9798-4d3c06e070e0', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('75f258d6-f960-4af1-9459-bc1c1db716e7', 'O', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b8b6253a-1abb-41f3-b1e7-bcaf17dcdd21', 'S', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '32428bd8-171e-469f-be69-681207279c33', '229a2d95-8c74-4ab3-a9da-39e6a361f902', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('cfe92e73-716d-4145-971d-bcba4ad10e0a', 'S', 'f228b8a5-1962-4d31-b83f-1de4251c4683', 'defa9577-3303-41d9-b2bb-6534c26ff6f1', '7ad2107d-5256-4efe-acdc-52a128a1685f', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('d818cf72-317a-48d1-b4fb-bf082d5e1b01', 'O', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('af39a912-84fb-420d-895d-c0e33b81636c', 'O', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'b8b29473-8a6d-4beb-95ae-0ea1309725b2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3e72fe2c-92a9-43f0-bfb6-c16545f0e6c7', 'S', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '32428bd8-171e-469f-be69-681207279c33', '99000460-0b79-45a2-97dd-07ea1a8a9900', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('aeea2986-7c89-4420-ad7c-c182bf3d24d0', 'F', '465f560a-cf09-45c2-911d-c9470c46ed10', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5d613151-7232-45a3-ab78-c21ad067a373', 'S', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e3385e66-1e24-4776-964e-c286ce003d83', 'S', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('79b7ccc5-c2a2-427b-9e00-c37e412eb8dc', 'F', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a55af7a5-a96b-4d55-a168-c679207d35ad', 'S', '6bb3d688-48bc-407d-bdf9-98d477556987', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3b5a6fdc-0d61-40a5-bec7-c7875bf1c281', 'F', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ffdcb814-f1fa-4c74-a84e-ca7e86d15f41', 'S', '23859535-596c-415a-b98c-03ab914c0a5e', '1b3a53f5-54d7-4fbf-b514-a15c3943f357', 'fe555a3f-900d-4c0b-8da3-570574958ddc', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9c1728f0-67e9-4a7d-a2a2-ca96efa228f2', 'F', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'df3187aa-320e-4bfa-a2fe-6159adea9522', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5f5333b0-92ef-402d-8ded-cab94e072fa0', 'S', 'd80ebe64-97f4-487f-989d-8a55ed00204d', '7551be83-f8c5-4849-b8cb-7a1d56e2efff', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a344dd3a-0a0a-4e41-96fe-cb4b638415c7', 'F', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('08b521ac-769c-4aa7-93ff-cca6904e30ad', 'F', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a7d7f6ee-86e4-4f13-a430-ce9de9c0d3f3', 'O', 'd80ebe64-97f4-487f-989d-8a55ed00204d', 'b42ff3dd-baaf-40d0-b604-700ff1e17c5d', '68bab34b-1efb-4b7f-b86a-b857d2bc7582', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('83c506e3-9cd4-4cec-9920-cf0fda5ee4cd', 'F', '22af8f11-96eb-4044-819b-a0de21bbe411', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('011e2eff-216f-4eb0-a00a-d0d4f358c94a', 'F', '8242f808-25d9-4fd3-8c36-b4e4699a017e', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('6b798f2e-a1b9-4af8-8a39-d0e4165ccb44', 'F', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e74f867a-3744-4c2b-ba0f-d32f4b82a2a5', 'O', '22af8f11-96eb-4044-819b-a0de21bbe411', 'eb0fdca4-36df-481a-a205-cfb0043a40e0', '99000460-0b79-45a2-97dd-07ea1a8a9900', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9e2b5261-a7c9-4719-bc30-d3325cade8bb', 'S', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '32428bd8-171e-469f-be69-681207279c33', '214aff6a-37dd-46b8-bd24-41b3ed858b5c', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c0609e33-10c6-40cc-bd4c-d6b6c3873555', 'F', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('beb72a33-2073-4bcb-a9bc-d75bb47d8a25', 'F', 'f228b8a5-1962-4d31-b83f-1de4251c4683', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('66743a42-7e88-482e-9d98-d8db8f2ef9a0', 'F', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9e7ff106-848c-4008-ab88-d8f9be547144', 'S', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc', 'eb0fdca4-36df-481a-a205-cfb0043a40e0', 'fecb71b8-911a-4399-9884-4b87efbf7f0e', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('43ad78c9-58ad-4c88-b5ff-d93cdfbc58f8', 'S', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2ca7ca44-bd9c-4066-9bc6-da23c7f41d88', 'F', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('fc71f241-bd1f-462b-a638-db09cb9f4cb3', 'F', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('122cb185-3368-4249-b017-db1caefd8c24', 'O', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'b8b29473-8a6d-4beb-95ae-0ea1309725b2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('2d62114c-7e19-4171-9e99-ddc8ccaace93', 'S', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d', 'c4fd789a-ddea-4154-9168-62f979399cde', '604f553e-6f35-4217-b4e0-e529d191f5d4', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('764a1746-2055-4e92-b0a3-ddfc8c56241e', 'O', '75fc9c73-8810-477f-a271-2438a04c06c3', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '4a924cec-9b7b-4596-9d65-6acf13408af1', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('aa6a5b27-acaf-4ca3-902a-de2b20281a85', 'F', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('8d60cf7a-d81d-4b86-b7ef-de6a171fcef9', 'S', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 5)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4567237f-8dcd-4b12-bd9b-df3ab5395b25', 'F', '6bb3d688-48bc-407d-bdf9-98d477556987', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('8266b449-2341-4420-80b2-dfae2bc4c2cb', 'F', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '92fd154c-93a0-497b-ba69-2822ad9ae051', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('ccb80e70-391c-4ba1-a7c5-e04955b6717e', 'F', '308b46bc-1812-4cf1-9a2c-42da7e965dc2', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e1c858cb-ad5c-4b3e-8038-e3db2fc5833c', 'S', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a628ea6d-0943-470a-a623-e4af58d02f3b', 'F', '22af8f11-96eb-4044-819b-a0de21bbe411', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', 'df3187aa-320e-4bfa-a2fe-6159adea9522', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('9d35a386-7682-4e96-9f5c-e55f1277d67b', 'S', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4', 'b538b557-8896-41b4-8451-04e046c0f4a2', '4092570f-5fd2-4035-9e37-1a9ce0383db0', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('4099f3f7-f1ef-4f13-b92e-e7edb3412b98', 'S', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1b3a53f5-54d7-4fbf-b514-a15c3943f357', '986186fc-1727-4c77-9e09-c899eb25d00e', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3465b646-3f35-403c-95f1-e807376335ee', 'S', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc', 'eb0fdca4-36df-481a-a205-cfb0043a40e0', '214aff6a-37dd-46b8-bd24-41b3ed858b5c', 2)
INSERT INTO @vc3reporting_ReportColumn VALUES ('72a2eb03-c2b2-4261-82dd-e81e680e8440', 'F', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('11991619-e808-4fbe-9d93-e889196fa83a', 'F', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'df3187aa-320e-4bfa-a2fe-6159adea9522', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('eea0f03c-3479-4db6-90a9-e8d1cf101fa4', 'O', '22af8f11-96eb-4044-819b-a0de21bbe411', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('b3f1c4c4-8370-42b8-b24d-eb35da4fa172', 'O', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb', 'a5c4ae91-7d16-478d-9ca3-90800c456e96', '79497ea4-7ae2-4589-aaa5-9e1711eb7d93', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('80a3074d-1ff7-457f-be91-eb49e9d6a43f', 'S', '45c279e0-b0c3-4624-94ef-beb074d93212', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'b8b29473-8a6d-4beb-95ae-0ea1309725b2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('73146597-5d25-4a20-80c4-ebfd98080fe1', 'S', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', 'fe555a3f-900d-4c0b-8da3-570574958ddc', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('7a143d65-4595-4177-a502-ec282f6f65f6', 'S', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1b3a53f5-54d7-4fbf-b514-a15c3943f357', 'fe555a3f-900d-4c0b-8da3-570574958ddc', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('8cb2ef45-5c15-448f-a6bc-ed0dab97fc8c', 'S', '45c279e0-b0c3-4624-94ef-beb074d93212', 'd5cb9f35-884d-408b-aec8-7bbeda38d2bb', 'fe555a3f-900d-4c0b-8da3-570574958ddc', 4)
INSERT INTO @vc3reporting_ReportColumn VALUES ('f8417c52-296e-4f4d-bcfa-eed4fd731d67', 'F', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '92fd154c-93a0-497b-ba69-2822ad9ae051', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('a68b01dc-24a9-4e23-b5a0-eeecbe4adc67', 'S', '65dadb9f-7eb9-49a5-99bf-ff21b406130d', 'b538b557-8896-41b4-8451-04e046c0f4a2', '77e28f7e-e682-4700-b6b1-823e5a9fe064', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('e07943cc-2382-4f26-a4e2-ef07b49fcad3', 'S', '22af8f11-96eb-4044-819b-a0de21bbe411', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('47287684-c365-40d2-8a77-f10bcd6f84e1', 'F', '44b198dc-ca15-4e10-828e-8ce8896d0ccc', '1586d5ff-0292-4cd1-b1bf-67987e83170f', '06ece633-ca6e-468d-83e0-999549b063fa', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('bd52e230-d5d7-49ba-b4e4-f2c0939ade0b', 'S', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('70724862-6494-4881-9a79-f30524e7cdb3', 'O', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '8d007416-d37c-4f07-9893-154c31ade2e4', 1)
INSERT INTO @vc3reporting_ReportColumn VALUES ('85b16c17-aa67-4094-9045-f3982a02a932', 'F', 'f228b8a5-1962-4d31-b83f-1de4251c4683', 'defa9577-3303-41d9-b2bb-6534c26ff6f1', '2c2cc7ff-f5e3-481f-8ad6-4c34a08da7e2', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('cb1c6a39-bed4-498d-bb63-f685d995c14a', 'F', '22af8f11-96eb-4044-819b-a0de21bbe411', '7a7aec95-3cfa-4401-9a59-6599d4d4b108', '6db3e68b-ecd0-4102-9782-52f5267a8e51', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('c35c5f41-dca1-4de7-89a4-f8b9c72b12b6', 'S', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', 'd113e740-51af-41e8-87cc-2c270a43ba4a', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('45ec94b0-1f96-45ee-916f-fa7afdb09022', 'O', 'd7999f84-54f0-4da6-b196-2e19c0337cd7', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('eeda604d-6587-426d-80b0-faf5d8cacd81', 'S', 'f228b8a5-1962-4d31-b83f-1de4251c4683', '32428bd8-171e-469f-be69-681207279c33', 'ee836d2e-ea16-49bd-89da-1d34097d63f5', 3)
INSERT INTO @vc3reporting_ReportColumn VALUES ('5b924281-5a09-4bfd-b256-fdfdb8608a6f', 'S', '23859535-596c-415a-b98c-03ab914c0a5e', '1586d5ff-0292-4cd1-b1bf-67987e83170f', 'd3df497e-e9bb-4860-a6d2-d19049bcecc6', 0)
INSERT INTO @vc3reporting_ReportColumn VALUES ('3959f359-3b62-4676-9d76-ffbf126daf64', 'F', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26', '21824b3e-ee9a-4af4-ba43-276cf7aabd4d', '06ece633-ca6e-468d-83e0-999549b063fa', 2)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportFilterColumn TABLE (Id uniqueidentifier, SchemaOperator uniqueidentifier, Nullable bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('2a03f1e2-f792-47a8-bff8-0094e2c86880', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('f7453f59-ea03-4f69-8d65-052c28a73ac0', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('dfa41d57-25ea-40b5-bd9b-053102c75889', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('a4003ae5-1057-4104-adf0-081a7e2659fc', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('013e6718-722c-44de-9185-0a9bf1029084', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('09e85424-61de-464c-b8b9-0f404cbbc302', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('54149325-203e-43a3-80a9-12ebb4024b03', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('05da33b2-447e-46f3-843c-1742be1d1310', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('4890d9c5-b9a0-4348-9396-27c08338a03f', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('4407acb1-997b-4261-bf50-2a86186b63eb', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('87fda43b-a11c-4fe7-bc48-38d657464ef5', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('13b86368-d53a-4895-96af-393a0e7814d7', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('59560f14-1c35-4822-991f-43a0d5afd60a', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('623b97c3-c7cc-4393-9d1c-47a1529c7fc6', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('b8945bdc-4055-4ebf-bf9e-483c5a72d8e8', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('294b4a8e-3deb-486e-9934-4a5ac83498a5', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('c7afd21e-b54c-4d4c-af67-4bcf43384270', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('a0d9d9de-e2fd-4c2f-864f-52442a958926', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('aac9d38e-b70e-4bc4-9d7a-5895e999a8e5', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('6b65dd3b-718e-4e0e-8066-6099d47a3ab0', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('51d16621-0839-4dcb-82f2-60eafdc32d59', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('640f3856-8fa4-4bde-83c5-628194275242', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('5223648f-0de1-4411-b969-646e36b63641', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('df69d2eb-b81e-4c2b-b9cc-698611ce50d4', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('bbe9f7ee-94d5-4dd2-85f1-6e9384d7f8bb', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('a2e084cb-584f-4149-88e1-72f946ae7a0e', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('1a23e6fd-65f3-469a-b890-7f369a3b3186', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('6d447ebe-f9a9-4605-8543-8f62795a6874', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('815b4f0b-aa94-43c6-9607-92a270600608', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('3292491a-31d1-4365-b8d4-9323526a6aff', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('20e01bd1-e0f4-47b3-9746-94cc8c688621', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('c220e86d-b3e3-431e-95cc-9859cdebf52f', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('42099c3e-67fd-4f72-ae42-98754fbdf212', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('647e6c3b-00b0-4ae1-85a1-9d5dc4d5bc5d', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('5ac32e8d-7a27-4389-9c36-9e858105bdf2', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('5e97135e-a50d-4081-be5d-a2585fd23426', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('5e409305-2e1f-4768-aa11-a6f36fa2d303', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('dd492e6e-3abf-4417-8f99-aafa4f37530e', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('b19e882b-6d06-499f-a7a7-b67760fe870c', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('16020587-abef-427e-b024-b7b8b9267323', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('60a13a22-dfd0-4eb7-859a-b88d62ff2ebe', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('b8d16fa3-6126-4248-9d66-baf946237c0c', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('aeea2986-7c89-4420-ad7c-c182bf3d24d0', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('79b7ccc5-c2a2-427b-9e00-c37e412eb8dc', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('3b5a6fdc-0d61-40a5-bec7-c7875bf1c281', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('9c1728f0-67e9-4a7d-a2a2-ca96efa228f2', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('a344dd3a-0a0a-4e41-96fe-cb4b638415c7', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('08b521ac-769c-4aa7-93ff-cca6904e30ad', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('83c506e3-9cd4-4cec-9920-cf0fda5ee4cd', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('011e2eff-216f-4eb0-a00a-d0d4f358c94a', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('6b798f2e-a1b9-4af8-8a39-d0e4165ccb44', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('c0609e33-10c6-40cc-bd4c-d6b6c3873555', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('beb72a33-2073-4bcb-a9bc-d75bb47d8a25', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('66743a42-7e88-482e-9d98-d8db8f2ef9a0', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('2ca7ca44-bd9c-4066-9bc6-da23c7f41d88', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('fc71f241-bd1f-462b-a638-db09cb9f4cb3', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('aa6a5b27-acaf-4ca3-902a-de2b20281a85', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('4567237f-8dcd-4b12-bd9b-df3ab5395b25', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('8266b449-2341-4420-80b2-dfae2bc4c2cb', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('ccb80e70-391c-4ba1-a7c5-e04955b6717e', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('a628ea6d-0943-470a-a623-e4af58d02f3b', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('72a2eb03-c2b2-4261-82dd-e81e680e8440', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('11991619-e808-4fbe-9d93-e889196fa83a', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('f8417c52-296e-4f4d-bcfa-eed4fd731d67', '444cfcb0-55b3-4d4a-8f8c-046b7270b444', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('47287684-c365-40d2-8a77-f10bcd6f84e1', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('85b16c17-aa67-4094-9045-f3982a02a932', '0df5fa46-4967-4d08-90b4-29bced34859d', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('cb1c6a39-bed4-498d-bb63-f685d995c14a', '333cfcb0-55b3-4d4a-8f8c-046b7270b333', 0)
INSERT INTO @vc3reporting_ReportFilterColumn VALUES ('3959f359-3b62-4676-9d76-ffbf126daf64', '41ba0544-6400-4e61-b1dd-378743a7d145', 0)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportSelectColumn TABLE (Id uniqueidentifier, Label varchar(50), SchemaSummaryFunction char(1))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('87823273-81cc-4c6a-91fa-0029d2db7576', 'Referrals Per Week Change (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('dd92d2fd-e5e0-4397-a220-027d9449c4f5', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('67d5e6f7-3130-4556-bfba-06abb2b71f68', 'Outcome', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7d79e253-a359-4a7f-92c6-09d812839f60', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7d7ffd92-f2a4-4887-b06d-09f042089474', 'School', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('19579856-c405-48cc-a4f5-0cd641af2a72', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7e5d4006-d17b-456b-bf6d-0dc38d73860e', 'Days Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('e01ec701-e30f-49ae-8c01-0fc9697550cd', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('781b417b-5628-4242-8dd1-12767d803445', 'Outcome', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('9cb187dc-f051-478f-8c30-140e3a5f2ccc', 'Referrals Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('d2d9b736-daa9-4b22-b669-15a2efe8ff65', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('cbed2bf9-ae32-44a5-9422-15bf98ffc028', 'Tool', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('87aa2ab0-c622-4645-bb28-16775ec0e6cf', 'Days Per Week Change (Average)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4e2b4675-77db-4162-8755-17a7cfc30553', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('dff6e96e-0a9b-4260-869a-17bc8235a0ed', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('79055387-e1c1-4f5e-bc03-1bbff57c9d8e', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('e82d5309-6992-4e09-9bcf-1f991073e2d1', 'Referrals Per Week Change (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('c12b69a5-7dab-4bfe-a0c1-24169597cf35', 'Days Per Week Change (Average)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('011aa6de-99f0-4081-ad61-2458cb73513d', 'Tool', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('0f5579ac-68e6-4629-bbe6-248f0ba0ef9e', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('25cf6ec8-3d79-4323-b90b-275e0f7379f9', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a180a96b-f8a9-4bc1-8bc4-27b1940fce7a', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a937d22b-adfa-4d87-a1df-29590427b516', 'Referrals Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4b526589-56b2-4b03-8770-2b92ab1537c8', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('171bf6e9-d035-44d8-a917-2bdd4fbff861', 'End Date', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('0f08660e-b505-4a74-82ba-2cb230b5a98b', 'Days Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('eec07d50-afc2-4dfd-b012-2de33a084668', 'Item Outcome', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('afa3f20d-ed19-4205-b100-2f2f73489856', 'Referrals Per Week Change (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('b892cba4-1296-4397-86a7-31893be19d1d', 'Days Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5124b7d4-6fb8-44e1-a0fc-32e6ac1509b2', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('20123234-fab8-4b04-98e3-34f1ab285107', 'Days Per Week Change (Average)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('6b66360d-abe1-4b88-860f-34fc6179ab0c', 'Change Per Week (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('077526e4-0479-4bf5-ab61-377a957373c2', 'Days Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('726cd776-5dd7-443d-9795-3af0487119bf', 'Start Time', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('722ccf90-1c41-4c7e-844e-3ecf05a93f3b', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a4dea1e8-bb7a-4775-86f1-429b38813521', 'Change Per Week (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('c28d38b8-bdb8-49bf-b770-471c3e6982f0', 'Days Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('bb8bbd00-2110-4a7f-b093-4a6e8156d5a0', '# of Actions', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('6841fcfb-2b0c-48ea-b143-4c05aeb5aa17', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4619651d-ba34-4150-8ee8-4c7f7073a71e', 'Tool', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('b896b7d6-e5ad-42a1-ae4d-4f0fd4b5bfb3', '# of Students', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('2534c2ad-c4db-49d9-b581-4f241e103cff', 'Grade Level', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4fcecfc7-b54b-4a82-924c-4feba80d0364', 'Change Per Week (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('ce5b71bb-fc7b-4893-998c-52227ff6d983', 'Plan Duration (Weeks)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('f766b396-6808-489f-886d-527669f25e75', 'Days Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('181d4287-a600-4c6a-9cb2-553aa28ac6e0', 'Change Per Week (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7a10c266-aa99-491b-8d89-56201b45b250', 'Plan Duration (Weeks)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a3414f4d-b203-4c32-b015-5a049bd1baa8', 'Ethnicity', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7eb48bf7-c6b4-44de-b9c2-5b2aa2e77161', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('cfee461f-4b71-400a-aece-5c8658d3bb62', 'Days Per Week Change (Average)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('09efb65b-1287-4ab7-9edf-5f0e0b8f5208', 'Type', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('19812137-ed39-4093-87af-617c4717b16f', 'Change Per Week (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('8b05e823-0d1b-43fc-954d-64db4abfad60', 'Team Leader', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('07c842d5-abe3-46fc-a517-6599a0fb530a', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('2a191fc1-c27d-4547-9af2-66c40969bffa', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7b9d27e7-31a0-462e-8c69-6c199a5dbbcd', 'School', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('074be88e-61c4-494f-8eff-6d87d5eb41bf', 'Days Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('46addc53-b373-4465-a9e7-6fb1e48c0546', 'End Time', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('6a44b149-a8f5-4470-ba39-7155c92e7493', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('30221871-1362-4605-89d7-72d1848abd0a', 'Grade Level', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('6d8d7119-4ff5-4010-838f-74dfa727b5fc', 'Days Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('abfe02ea-fce2-4108-b2b6-75ff706ec3e2', 'Outcome', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('d93077ae-69e9-49a7-9eb2-783ec9135c1e', 'Days Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5b63244a-a6aa-45a6-a67d-78b9d04dea5a', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('1a86f12a-f130-41bd-9455-7966fec4d6f7', '# of Students', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a1da3483-3285-4f92-8a08-7a2bcde1778f', 'Outcome', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5abcfeb7-cbdf-4617-aa8b-7bf5b02af661', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('d24d254e-4b3f-41ea-988a-7c864e98c190', 'Change Per Week (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('c9f1cc27-2d7c-4a21-8780-7db648fc1261', 'Student', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('bbe5ab11-3d20-4502-aa0c-7f43b56e7ca4', 'Days Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('3fb257df-a692-4986-86aa-816f827a2f4f', 'Team Leader', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('df004c6e-d9d7-4ab9-9c7e-827cb1735ab9', 'Change Per Week (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4b51f9e8-878c-4fe0-9b04-830d5cbc5630', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5ee1feec-9942-4763-8beb-83661db104b9', 'Change Per Week (Average)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('f8cd2d6c-754f-4f6d-a886-83a9504fa8de', 'Last Name', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a715c5ba-8199-4b33-8b4c-857d53233d85', 'Change Per Week (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('32043e9e-db58-4b5d-b849-8dbd96431209', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('2b8956b6-207a-486f-9790-8e99dd08bfbd', 'Referrals Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('eb3d0133-4764-4883-98ed-92235be1e331', '# of Students', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4cbc33e9-a360-4816-af47-923046a623ea', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('ed7f0b42-a8f0-4e35-ab29-946a63c4b53e', 'Referrals Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('e672cb65-f2c7-4f46-89dd-9655f5a5969a', 'Tool', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('ac22bcb0-733c-4c9c-9cb6-976051a82546', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('58db83a1-c7ec-4bb5-b7b2-9c55859d057a', 'Referrals Per Week Change (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a31f9e18-2252-4b92-9ece-a1de9a6e8a1e', 'School', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5a5d7acf-b82c-45c7-afa7-a3b76c3d2fba', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('357ea342-3c72-4565-8aa3-a4a5ab90cf79', 'Change Per Week (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('ede53a21-f585-4251-a509-a5fac124298b', 'Referrals Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('d4a63a16-cee7-40d4-9a20-a77dfea69586', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('dddee212-d248-4fa0-910b-a958900c2aa3', 'Plan Duration (Weeks)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('51aea8d5-fb41-41a4-a708-aa9b745508ad', 'Change Per Week (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('8d9319b6-983f-412f-b13e-b45046fe69c7', 'Change Per Week (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('06228bf3-cb3f-4a42-8447-b93d6fa5216f', 'Action > End Date', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('09d5fdee-7075-428b-8d0f-b9b55f489f34', 'Change Per Week (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('c9013d89-7d2a-4e09-8e5d-ba6d26414e49', 'Team Leader', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('1e32bcfa-6435-444c-b496-bc09e780781d', 'Referrals Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('b8b6253a-1abb-41f3-b1e7-bcaf17dcdd21', '# of Students', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('cfe92e73-716d-4145-971d-bcba4ad10e0a', 'Planned End Date', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('3e72fe2c-92a9-43f0-bfb6-c16545f0e6c7', 'Ethnicity', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5d613151-7232-45a3-ab78-c21ad067a373', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('e3385e66-1e24-4776-964e-c286ce003d83', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a55af7a5-a96b-4d55-a168-c679207d35ad', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('ffdcb814-f1fa-4c74-a84e-ca7e86d15f41', 'Referrals Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5f5333b0-92ef-402d-8ded-cab94e072fa0', 'Date', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('9e2b5261-a7c9-4719-bc30-d3325cade8bb', 'First Name', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('9e7ff106-848c-4008-ab88-d8f9be547144', 'Student > Last Name', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('43ad78c9-58ad-4c88-b5ff-d93cdfbc58f8', 'Team Leader', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('2d62114c-7e19-4171-9e99-ddc8ccaace93', 'Days Per Week Change (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('8d60cf7a-d81d-4b86-b7ef-de6a171fcef9', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('e1c858cb-ad5c-4b3e-8038-e3db2fc5833c', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('9d35a386-7682-4e96-9f5c-e55f1277d67b', 'Change Per Week (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('4099f3f7-f1ef-4f13-b92e-e7edb3412b98', 'Referrals Per Week Change (Avg)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('3465b646-3f35-403c-95f1-e807376335ee', 'Student > First Name', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('80a3074d-1ff7-457f-be91-eb49e9d6a43f', 'Grade Level', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('73146597-5d25-4a20-80c4-ebfd98080fe1', 'Referrals Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('7a143d65-4595-4177-a502-ec282f6f65f6', 'Referrals Per Week Change (Min)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('8cb2ef45-5c15-448f-a6bc-ed0dab97fc8c', 'Referrals Per Week Change (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('a68b01dc-24a9-4e23-b5a0-eeecbe4adc67', 'Change Per Week (Max)', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('e07943cc-2382-4f26-a4e2-ef07b49fcad3', 'Action', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('bd52e230-d5d7-49ba-b4e4-f2c0939ade0b', 'Plan', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('c35c5f41-dca1-4de7-89a4-f8b9c72b12b6', '# of Plans', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('eeda604d-6587-426d-80b0-faf5d8cacd81', 'Student', NULL)
INSERT INTO @vc3reporting_ReportSelectColumn VALUES ('5b924281-5a09-4bfd-b256-fdfdb8608a6f', 'Plan', NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportOrderColumn TABLE (Id uniqueidentifier, IsAscending bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('0c87a966-fe50-43c8-ad50-03ace5a02802', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('291b38e0-045b-40be-9957-04ba6aafb4d6', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('5e58c6e2-6fbf-46d4-88ed-05b2e6fde96c', 0)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('55b2dc2e-09cd-451f-8f0c-0aaec9bf1015', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('9786f901-7635-4915-a087-0b5a28df1fc1', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('2860ff01-68eb-427d-93dc-0b71b79ced31', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('cae717e1-88c3-476b-8d8f-1157a8d09392', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('61532ab1-470e-4301-9589-16722851202d', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('c260713c-d42d-454d-b628-1a3e8b71979d', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('7ae0f5cd-0fe1-451c-8c5d-225780444259', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('2a28c3f1-cd41-4fc8-881e-26e89599d0d2', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('447b5956-30de-4af9-8337-28d1a4278c69', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('6c67e88e-be44-4871-b5dc-292aaf12cfb6', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('dfe54b62-b480-47d8-88f5-2f975fb1f4c4', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('3d758df1-c15c-4f70-9b10-3db350427623', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('e53e17b2-d102-4f56-a0a9-49d2ec3f5b00', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('ef879c25-9968-4cc2-ae36-53f6b2cc19aa', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('629f22eb-0dcf-41c0-9048-5f4c350180a0', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('fffae2af-b9bd-4ccc-8e49-644b4479675e', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('37b4cca9-c0e2-46f6-84ee-68238310325b', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('7252134a-1916-41b0-80bb-6bfe8229758d', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('21685920-ab76-48e6-9292-6ec725c309a3', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('b74dcc8f-8399-44a0-85af-72a8590f21c8', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('da6910a6-4874-461a-b43a-773701d96ad1', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('1ad8fff6-3c06-4a95-bc12-863a26d875bd', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('42d133d9-2f70-4ab2-ac0e-8a27e9c5c443', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('896b95a5-8cf8-49cb-b62d-93d086056609', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('9d67b42c-ddbe-4046-a2f2-95d6ec2e4d49', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('08948757-c6cf-45f6-911a-9a6fca8d5b5a', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('291151cf-5c2b-47f0-b4e2-9aefb3a446cd', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('4784623b-3298-499a-abbf-9e3dea77cafb', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('34defb1d-aca5-4481-90c7-af7c1a6c1e05', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('ad351291-8ae2-4863-ac58-af98d0dd7deb', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('cdd1c9f0-8184-4825-8bd8-b3cd8ec626d3', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('75f258d6-f960-4af1-9459-bc1c1db716e7', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('d818cf72-317a-48d1-b4fb-bf082d5e1b01', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('af39a912-84fb-420d-895d-c0e33b81636c', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('a7d7f6ee-86e4-4f13-a430-ce9de9c0d3f3', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('e74f867a-3744-4c2b-ba0f-d32f4b82a2a5', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('122cb185-3368-4249-b017-db1caefd8c24', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('764a1746-2055-4e92-b0a3-ddfc8c56241e', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('eea0f03c-3479-4db6-90a9-e8d1cf101fa4', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('b3f1c4c4-8370-42b8-b24d-eb35da4fa172', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('70724862-6494-4881-9a79-f30524e7cdb3', 1)
INSERT INTO @vc3reporting_ReportOrderColumn VALUES ('45ec94b0-1f96-45ee-916f-fa7afdb09022', 1)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportColumnParameterValue TABLE (Id uniqueidentifier, ReportColumn uniqueidentifier, SchemaTableParameter uniqueidentifier, ValueExpression varchar(100))

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e1b034b6-65dc-482f-b481-05ebcf1b1d8b', '2b8956b6-207a-486f-9790-8e99dd08bfbd', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('86048e43-58b7-43e9-8494-0b3a964eb0c8', '4099f3f7-f1ef-4f13-b92e-e7edb3412b98', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('0ec0df9e-befb-4ef6-8771-0b5156e336f6', 'afa3f20d-ed19-4205-b100-2f2f73489856', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('57b18950-3ed6-426b-829b-0b769a9d2660', 'f766b396-6808-489f-886d-527669f25e75', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('7f3c8148-1a00-4841-8ec5-0c3f4b089dec', 'b892cba4-1296-4397-86a7-31893be19d1d', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('25d23640-5ed6-43d2-a017-0ca366189714', 'b892cba4-1296-4397-86a7-31893be19d1d', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f2c74975-0f09-4ab4-aca1-0d1a272875b2', '181d4287-a600-4c6a-9cb2-553aa28ac6e0', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('0961b426-01e3-446d-b2a4-0d439ea4be7f', '0f08660e-b505-4a74-82ba-2cb230b5a98b', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('43328723-31b6-40d8-b994-0f72e6318ba9', 'f766b396-6808-489f-886d-527669f25e75', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e2485622-c395-415f-a92f-1104c080ee0a', 'a4dea1e8-bb7a-4775-86f1-429b38813521', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('6d45d5df-3fe1-4807-8661-15503ec167b8', 'df004c6e-d9d7-4ab9-9c7e-827cb1735ab9', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('778e147d-b360-45f2-971a-15b2276c27e8', '9cb187dc-f051-478f-8c30-140e3a5f2ccc', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('cafad7d1-2b47-413d-abc7-1ce5f8ce8cca', '2d62114c-7e19-4171-9e99-ddc8ccaace93', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('1c122b63-b38b-437e-a017-210b4844e05d', '2d62114c-7e19-4171-9e99-ddc8ccaace93', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('73499095-d994-4cee-97d2-2173ebc6d3c7', '87aa2ab0-c622-4645-bb28-16775ec0e6cf', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('30e76a26-b48e-4d60-9263-23dd8cc6b042', '19812137-ed39-4093-87af-617c4717b16f', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f12df078-8a66-47f3-8a14-24dce4b16b7d', 'bbe5ab11-3d20-4502-aa0c-7f43b56e7ca4', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('a30f49ab-bd8b-459c-ade5-292f790678fa', 'c12b69a5-7dab-4bfe-a0c1-24169597cf35', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('19a53668-5a74-4690-8dbc-2ce559028292', '4fcecfc7-b54b-4a82-924c-4feba80d0364', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bc93f81c-bb24-423c-95c4-2e4bfdec3151', '58db83a1-c7ec-4bb5-b7b2-9c55859d057a', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ce2cd253-93bf-4b2d-831b-2e8632e259af', 'ede53a21-f585-4251-a509-a5fac124298b', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('75d7bac6-12ee-4b5c-b5a0-2eea9d66b392', '9d35a386-7682-4e96-9f5c-e55f1277d67b', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c5869f7e-85e3-4816-9ac7-3149622cc967', 'a68b01dc-24a9-4e23-b5a0-eeecbe4adc67', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('85778d74-c371-4cb1-9a15-31e532a1881c', '074be88e-61c4-494f-8eff-6d87d5eb41bf', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('2c0e6fe6-6495-49bb-a29b-31e86e73746c', '6d8d7119-4ff5-4010-838f-74dfa727b5fc', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('60b1dcef-97df-4577-a80f-32e787b2d12c', 'd93077ae-69e9-49a7-9eb2-783ec9135c1e', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c4774d79-9bf4-4dd9-b53c-33120c18d3bf', '6b66360d-abe1-4b88-860f-34fc6179ab0c', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('37a4b829-ea59-4381-bda9-33a84b6afdad', '1e32bcfa-6435-444c-b496-bc09e780781d', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bdd70958-d10e-4bea-8969-341c81d27ebc', 'e82d5309-6992-4e09-9bcf-1f991073e2d1', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f420c21f-5597-4839-891c-356da1fbfc35', 'ffdcb814-f1fa-4c74-a84e-ca7e86d15f41', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('fb9d0617-2695-4311-90b6-37ae0cf7a1c2', '58db83a1-c7ec-4bb5-b7b2-9c55859d057a', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ebe3058c-e512-4662-a6a7-387dbdd92acf', 'ede53a21-f585-4251-a509-a5fac124298b', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('34b95d03-02dd-4870-a882-3987a5eba6de', 'cfee461f-4b71-400a-aece-5c8658d3bb62', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f955d655-2c27-4e43-a7a5-3ab80e09e592', '8cb2ef45-5c15-448f-a6bc-ed0dab97fc8c', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('3334c839-684d-46c7-a1e9-3b4bdc7aef2c', '4fcecfc7-b54b-4a82-924c-4feba80d0364', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('6c9ce8d4-aaf0-4546-9423-3cea4880b48a', 'ed7f0b42-a8f0-4e35-ab29-946a63c4b53e', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('73f0741c-c08f-4463-8c74-3e2511da189c', 'a4dea1e8-bb7a-4775-86f1-429b38813521', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('92871df2-bb69-4a82-897d-416cefb3e708', '0f08660e-b505-4a74-82ba-2cb230b5a98b', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('42d81d14-db26-4964-a2be-43d2007a8ba3', '58db83a1-c7ec-4bb5-b7b2-9c55859d057a', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bf022149-9890-4ce9-bd9d-43d464eeb8a0', 'c28d38b8-bdb8-49bf-b770-471c3e6982f0', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('57138a30-005f-463a-8654-465f56858a19', 'a937d22b-adfa-4d87-a1df-29590427b516', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('585ff2c9-149f-4e69-b0cb-471cb80938b8', '87823273-81cc-4c6a-91fa-0029d2db7576', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8bc28826-d8ad-4ad3-9556-475f5b6dbb08', '73146597-5d25-4a20-80c4-ebfd98080fe1', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('a3a2ba31-6551-4668-aede-47ed41789e91', '5ee1feec-9942-4763-8beb-83661db104b9', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('1dd963e7-3b9a-4da2-9265-48472e38e36b', 'ede53a21-f585-4251-a509-a5fac124298b', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('70650491-07e6-427c-a043-4894d1680066', '1e32bcfa-6435-444c-b496-bc09e780781d', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('0fe790fc-4485-48e8-9d88-4a176eaae822', '58db83a1-c7ec-4bb5-b7b2-9c55859d057a', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bdc79903-d812-4d39-bc32-4a178a3281fe', 'ffdcb814-f1fa-4c74-a84e-ca7e86d15f41', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('df7f5712-c2fa-4ef8-b67c-4a69af7b3d65', 'e82d5309-6992-4e09-9bcf-1f991073e2d1', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bc400ad3-0862-4040-b30b-4cb4779cee42', '8cb2ef45-5c15-448f-a6bc-ed0dab97fc8c', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('b90312a1-fec0-4089-9f0b-4d3f82ded1d8', 'e82d5309-6992-4e09-9bcf-1f991073e2d1', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('356182ce-d6bb-482b-9578-4fe3f1ee1d70', '9cb187dc-f051-478f-8c30-140e3a5f2ccc', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('831a5c72-cd84-4094-bb1c-50505824986c', '357ea342-3c72-4565-8aa3-a4a5ab90cf79', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('0d45d1b3-c3eb-4407-b2c1-50e096b4f4b3', '7a143d65-4595-4177-a502-ec282f6f65f6', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('4392ae90-6bb0-4d68-84f4-513ed82be389', '2b8956b6-207a-486f-9790-8e99dd08bfbd', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('04023cac-4f3c-4948-acff-565142951dca', 'cfee461f-4b71-400a-aece-5c8658d3bb62', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('cbaae23a-cc76-4017-915d-58eab260a4b0', 'd93077ae-69e9-49a7-9eb2-783ec9135c1e', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('52384f3b-eadc-4e54-b8b6-5bd9cd6148bf', '7a143d65-4595-4177-a502-ec282f6f65f6', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('cf286b3c-5804-4121-9f1d-5f5cf9415299', 'cfee461f-4b71-400a-aece-5c8658d3bb62', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('50482bb8-d006-4d1d-b23e-60a5be15fbfc', 'a937d22b-adfa-4d87-a1df-29590427b516', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f348d665-d14a-48ab-8bce-63b335456235', '0f08660e-b505-4a74-82ba-2cb230b5a98b', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e800dab3-9c6d-4e41-90bf-6544c31f8062', '074be88e-61c4-494f-8eff-6d87d5eb41bf', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('5c02c2db-316c-43ee-b740-668ac32734ba', '87aa2ab0-c622-4645-bb28-16775ec0e6cf', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('9eefaab4-9023-461d-b3a9-6734d4b6ccf0', 'ed7f0b42-a8f0-4e35-ab29-946a63c4b53e', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('482ad8a0-3f23-4cc1-928a-68d8e953791c', '1e32bcfa-6435-444c-b496-bc09e780781d', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ab25eae0-b69e-458e-959f-696b79240001', '6d8d7119-4ff5-4010-838f-74dfa727b5fc', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('08181310-689a-4abf-a8f2-69d1d881be65', 'a4dea1e8-bb7a-4775-86f1-429b38813521', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e6a5863e-cce0-4e07-a04a-6d98394b1508', 'c28d38b8-bdb8-49bf-b770-471c3e6982f0', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('0ad584a6-a340-4fc8-ac3e-6db1927510fe', '73146597-5d25-4a20-80c4-ebfd98080fe1', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('178384e4-fa07-4c76-8533-6e3ee9fd5622', 'c28d38b8-bdb8-49bf-b770-471c3e6982f0', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ffe664dd-1423-4f2c-b8ab-71f50f0ff2f9', '87823273-81cc-4c6a-91fa-0029d2db7576', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('7b69cf3b-bb0e-4d93-b306-721a85023434', 'df004c6e-d9d7-4ab9-9c7e-827cb1735ab9', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('cf580a68-aca8-4b61-9a6c-7a180255d3af', '7e5d4006-d17b-456b-bf6d-0dc38d73860e', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c5d4bef9-7bee-459e-8ed9-7a85b550e1ec', '181d4287-a600-4c6a-9cb2-553aa28ac6e0', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('b60b0c10-0fc3-4931-963d-7aa31d5cec13', '2d62114c-7e19-4171-9e99-ddc8ccaace93', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('78faee69-3739-461c-8457-7af0ae61d795', '09d5fdee-7075-428b-8d0f-b9b55f489f34', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('332b5459-e792-45d0-b152-7ba73b33b851', '8cb2ef45-5c15-448f-a6bc-ed0dab97fc8c', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e55ccb1f-94f0-4bcc-964d-7c5ff1f30f6a', '6b66360d-abe1-4b88-860f-34fc6179ab0c', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('81dd76a0-518c-4f17-a7fa-7f3c4e7ca61a', '87aa2ab0-c622-4645-bb28-16775ec0e6cf', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c4f1a989-3a1a-4678-aef9-83371eeb528d', '87aa2ab0-c622-4645-bb28-16775ec0e6cf', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e430278d-a711-4e37-b10c-852e0ffa3773', 'ed7f0b42-a8f0-4e35-ab29-946a63c4b53e', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bee7766b-3829-4cba-abe4-87102fe7c68c', '51aea8d5-fb41-41a4-a708-aa9b745508ad', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('98021032-a76a-4605-9e2c-8b0bf3d3ab71', '6d8d7119-4ff5-4010-838f-74dfa727b5fc', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('b4774b78-aa28-435f-89bf-8b6425a26ac2', '2b8956b6-207a-486f-9790-8e99dd08bfbd', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('30dee716-5a6f-4ca2-aa4b-8c10f3a205b3', '9cb187dc-f051-478f-8c30-140e3a5f2ccc', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c90c5457-af90-4e48-9817-8d033523b99b', '077526e4-0479-4bf5-ab61-377a957373c2', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f828e2e7-7436-4fa6-a971-8dd9000be28e', '7a143d65-4595-4177-a502-ec282f6f65f6', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('3d49aa81-6ecb-48ba-a850-8e33ee46c4b1', '077526e4-0479-4bf5-ab61-377a957373c2', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('2fa01fe3-3c03-4e3a-a8de-8e7fa9c038d5', '7e5d4006-d17b-456b-bf6d-0dc38d73860e', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('b0283438-d6e0-4377-9675-906cd925def0', 'd93077ae-69e9-49a7-9eb2-783ec9135c1e', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bbd645be-9eb2-498a-94dd-92975b026446', '7e5d4006-d17b-456b-bf6d-0dc38d73860e', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('62e6bd09-6395-4d74-9a11-973fb08ce886', 'b892cba4-1296-4397-86a7-31893be19d1d', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f9789dfb-2afe-4fae-a998-977e082c891d', '20123234-fab8-4b04-98e3-34f1ab285107', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('fd892424-717d-4460-bd4c-9788008c5f59', '8cb2ef45-5c15-448f-a6bc-ed0dab97fc8c', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('2bee0c81-400c-4b55-b4b3-98130e72d645', '4099f3f7-f1ef-4f13-b92e-e7edb3412b98', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('7a825886-5b25-4a05-8ae0-982f1da39da3', 'afa3f20d-ed19-4205-b100-2f2f73489856', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('96049693-7819-4c31-bfbc-9a0e324b189a', 'bbe5ab11-3d20-4502-aa0c-7f43b56e7ca4', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('7ebdc2b8-4dbd-43c4-b530-9bbef5ab2902', '4099f3f7-f1ef-4f13-b92e-e7edb3412b98', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('9d5573b2-92eb-408d-9e12-9c3058857f07', 'bbe5ab11-3d20-4502-aa0c-7f43b56e7ca4', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('e84b09e5-7c52-44a1-b734-9e14f4224a10', '87823273-81cc-4c6a-91fa-0029d2db7576', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('3fe5d5da-c84a-4446-8867-9e5392986089', 'cfee461f-4b71-400a-aece-5c8658d3bb62', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('eca01e82-ab05-4670-bb5c-9e90e50c82c6', '357ea342-3c72-4565-8aa3-a4a5ab90cf79', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('79f94f9f-54a1-4ebd-aee6-a05a3dbf6d73', '9d35a386-7682-4e96-9f5c-e55f1277d67b', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('696cf209-53c7-4ad6-bd57-a2d4afb1bb43', '077526e4-0479-4bf5-ab61-377a957373c2', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('33997960-68b8-4579-908a-a67a370a2138', '9cb187dc-f051-478f-8c30-140e3a5f2ccc', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8aa228fe-ba40-4c0c-861d-a83b44535d06', '357ea342-3c72-4565-8aa3-a4a5ab90cf79', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('34fcbc10-ae68-4ed1-b44b-a8f94d32e06e', 'f766b396-6808-489f-886d-527669f25e75', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('17d212be-7f0f-4d51-be75-aa58301d6345', '7a143d65-4595-4177-a502-ec282f6f65f6', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8c2a318b-357f-4eb6-ac70-af28a8d6fe2e', 'b892cba4-1296-4397-86a7-31893be19d1d', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8d9fe9a4-17d7-4a59-8ae6-b036b153967c', '0f08660e-b505-4a74-82ba-2cb230b5a98b', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('370a06e8-b8ee-436f-b5c6-b6e69bfeab8c', 'a937d22b-adfa-4d87-a1df-29590427b516', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('821600c1-4083-433d-8a3d-b71eee9b6395', 'bbe5ab11-3d20-4502-aa0c-7f43b56e7ca4', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('03f8f630-b475-4d08-9360-b747f23e6d83', '19812137-ed39-4093-87af-617c4717b16f', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('584a0ddd-1b62-4707-bb81-b97f92c582c2', '7e5d4006-d17b-456b-bf6d-0dc38d73860e', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('6984e938-5c2c-45d8-a927-b9faaad821d7', 'f766b396-6808-489f-886d-527669f25e75', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('7bd2d5e7-c7c1-4b7c-b1ac-ba9bf31f7a98', '4099f3f7-f1ef-4f13-b92e-e7edb3412b98', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('929ac51d-bb52-4706-a67f-bb64173c19fc', 'a937d22b-adfa-4d87-a1df-29590427b516', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('4cc5f189-36ae-40d0-bb26-bba9139e3eb9', 'afa3f20d-ed19-4205-b100-2f2f73489856', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('5e69e2d0-bd8a-467c-9450-bbc75d9427d1', '5ee1feec-9942-4763-8beb-83661db104b9', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('36d48a9b-d4f4-4845-ab93-bd3bd08ec38d', 'ffdcb814-f1fa-4c74-a84e-ca7e86d15f41', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('083eb174-25b6-43b2-a619-bd47d4396eb8', 'a715c5ba-8199-4b33-8b4c-857d53233d85', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8caa7c86-e6b1-4903-9810-c1229dd9b340', 'a68b01dc-24a9-4e23-b5a0-eeecbe4adc67', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('312aabb4-3f67-49ec-b3fd-c1cea0e51241', 'ede53a21-f585-4251-a509-a5fac124298b', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('87a9bbfa-e432-4d0b-8d18-c23c6d38d77b', 'afa3f20d-ed19-4205-b100-2f2f73489856', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('2d0bb2b2-9813-4616-939b-c4addaab38f6', '09d5fdee-7075-428b-8d0f-b9b55f489f34', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('2b022b7b-ac5d-4c4e-ba4d-c4c81407ca5d', 'df004c6e-d9d7-4ab9-9c7e-827cb1735ab9', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('719dc2af-d678-40d6-8264-c510c58ec42e', 'd24d254e-4b3f-41ea-988a-7c864e98c190', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('43185589-f965-417b-8665-c712722a6ae6', '2d62114c-7e19-4171-9e99-ddc8ccaace93', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('d13d7f68-47e2-4d65-adbc-c82aab0d4a19', '73146597-5d25-4a20-80c4-ebfd98080fe1', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('d46cc0d9-06d5-4a7d-bc38-c856bef472ad', '2b8956b6-207a-486f-9790-8e99dd08bfbd', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('4f9748a0-d1fc-4492-9a9e-cb875ab4d1de', '8d9319b6-983f-412f-b13e-b45046fe69c7', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('faf14e8c-836e-41f7-b4e4-cc72c2ff3089', '51aea8d5-fb41-41a4-a708-aa9b745508ad', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('a904c508-b113-4535-882c-cd828795f968', '09d5fdee-7075-428b-8d0f-b9b55f489f34', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('657aa41b-475f-4b0d-a22f-cf02e876374b', '20123234-fab8-4b04-98e3-34f1ab285107', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('643ee307-319d-426b-bc06-cf45a071c4a9', '181d4287-a600-4c6a-9cb2-553aa28ac6e0', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('9a1b0448-612e-44a8-aa76-cf478f1bb81b', 'a715c5ba-8199-4b33-8b4c-857d53233d85', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('4471c064-8ac5-4fb9-a89f-d46e877472e2', '8d9319b6-983f-412f-b13e-b45046fe69c7', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ca79aebf-a391-4ac5-a703-d64033aa62ce', 'd24d254e-4b3f-41ea-988a-7c864e98c190', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ad4ec3bf-1350-494d-8b2f-d76a6ef18803', '8d9319b6-983f-412f-b13e-b45046fe69c7', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('5911e01d-06aa-4734-950f-d788636f4f98', 'a715c5ba-8199-4b33-8b4c-857d53233d85', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('b9fdf942-8211-466e-aa69-d9be98322067', '20123234-fab8-4b04-98e3-34f1ab285107', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('ab3a1b03-e7c2-4872-bbeb-dc17a8edd06e', 'c12b69a5-7dab-4bfe-a0c1-24169597cf35', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c11edf3f-48c6-42f3-8448-dc1f066f215f', 'ed7f0b42-a8f0-4e35-ab29-946a63c4b53e', '590a45e8-e3fa-422e-ad71-b043e9992edc', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8fba4ecd-b42b-4c72-b3a6-dd8700be60f7', '19812137-ed39-4093-87af-617c4717b16f', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('0767d62c-96af-414e-a25e-ddb6660b45cf', '87823273-81cc-4c6a-91fa-0029d2db7576', '79afc59a-c42d-489a-9664-ffe4bb08854b', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('37295918-61a3-4816-8d86-de7d30f10fcc', 'ffdcb814-f1fa-4c74-a84e-ca7e86d15f41', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('12cab013-dfdf-48dc-86eb-e295d3884dcb', '6d8d7119-4ff5-4010-838f-74dfa727b5fc', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('d278c894-c434-4e8c-a197-e2a3fc47865c', 'd24d254e-4b3f-41ea-988a-7c864e98c190', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('96e6f1cb-ba78-4824-b1d5-e310c514addf', 'c28d38b8-bdb8-49bf-b770-471c3e6982f0', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('2bbf8658-568c-438c-aecb-e6a5d55ea95b', '074be88e-61c4-494f-8eff-6d87d5eb41bf', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('cb249b99-6f76-48d6-957b-e74f8c6cf095', 'd93077ae-69e9-49a7-9eb2-783ec9135c1e', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('952c22f7-3b72-4348-b6d2-e7a5868cb8f8', '20123234-fab8-4b04-98e3-34f1ab285107', 'eee21943-ca97-41f0-8ee0-d8b6af9e4819', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('aa3810fa-9442-4679-8942-e7d430420b2e', 'e82d5309-6992-4e09-9bcf-1f991073e2d1', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('4dcccc4d-f7be-4081-bd3e-e8768a88d1a9', '1e32bcfa-6435-444c-b496-bc09e780781d', '062f2742-5e3a-49ae-a1e6-04600a622bc7', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('1f2e8feb-0f38-4703-ba15-e8d611ae22c5', '077526e4-0479-4bf5-ab61-377a957373c2', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('f412a80d-a88e-41af-ad17-ea19f96b2d71', 'c12b69a5-7dab-4bfe-a0c1-24169597cf35', '5783da6b-01ce-481f-9a91-854e56c936b1', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('bb591b4e-50b9-4662-b522-ea9f08e8331a', '9d35a386-7682-4e96-9f5c-e55f1277d67b', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('6b6be3c3-53f4-47dd-b358-eb23e0aebcd8', 'c12b69a5-7dab-4bfe-a0c1-24169597cf35', '34fbe3ed-8edb-4a7c-bedc-ccf3c8590d50', '30')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('a3bb1178-44aa-47f1-9e92-eb712e3e1803', 'a68b01dc-24a9-4e23-b5a0-eeecbe4adc67', 'cbc3487a-5092-461c-ab62-deb6033ba0e4', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('8741557c-545f-4bf9-b40d-f2d8addc7c0e', '51aea8d5-fb41-41a4-a708-aa9b745508ad', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('42aeb8ce-c215-496f-90a4-f3891f29c933', '73146597-5d25-4a20-80c4-ebfd98080fe1', 'b735d516-111d-4180-9919-9a9458fa4a5e', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('747d0ab9-4408-4945-9936-f4d0ff3027a5', '074be88e-61c4-494f-8eff-6d87d5eb41bf', '72978757-055d-457e-84e2-ca1ef93c618b', 'e5bf3494-3a29-4c56-96a9-c2ea81bcbb70')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('1139a78a-8fbb-4fa6-97c9-f59873b873c0', '6b66360d-abe1-4b88-860f-34fc6179ab0c', '73048b89-0aa2-47a7-97d4-3ca86d87ac33', NULL)
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('c4625177-8f68-48b2-8121-fb541ff22b52', '4fcecfc7-b54b-4a82-924c-4feba80d0364', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')
INSERT INTO @vc3reporting_ReportColumnParameterValue VALUES ('9a7f7287-8c24-4c13-a0fb-fd9697c950b9', '5ee1feec-9942-4763-8beb-83661db104b9', '7907ee07-b089-4d56-b5fb-365ac0c6bd3f', 'e9ef6ac7-e839-464e-9044-a658e9b2d12b')

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportFilterValue TABLE (Id uniqueidentifier, FilterColumn uniqueidentifier, ValueExpression varchar(100), IsDynamic bit)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('09f19b05-73f1-435f-aba8-88efb2b959e8', '2a03f1e2-f792-47a8-bff8-0094e2c86880', '7de3b3d7-b60f-48ac-9681-78d46a5e74d4', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('a6727fea-bd33-4c02-8f84-e1602d00fc8b', 'f7453f59-ea03-4f69-8d65-052c28a73ac0', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('6223d112-7c9d-459b-9671-9d6d02d7c475', 'a4003ae5-1057-4104-adf0-081a7e2659fc', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('e277d004-3ac1-4925-acb5-a36e3eda9ca0', '05da33b2-447e-46f3-843c-1742be1d1310', '1', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('a464b1b7-9c05-4bd2-b5ef-7e5cd47dc08f', '87fda43b-a11c-4fe7-bc48-38d657464ef5', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('1f9c9d1a-1bbc-4503-8c6b-c1211b8ff521', '59560f14-1c35-4822-991f-43a0d5afd60a', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('b9ad277c-3226-4d08-91d3-a95598002dc6', '294b4a8e-3deb-486e-9934-4a5ac83498a5', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('a7125576-f876-4a67-aa8b-de846426c149', 'c7afd21e-b54c-4d4c-af67-4bcf43384270', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('e937d625-9910-42b7-9a71-1b9734ab037f', '51d16621-0839-4dcb-82f2-60eafdc32d59', '7de3b3d7-b60f-48ac-9681-78d46a5e74d4', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('55a02625-6d7c-49df-83d2-d51ee42d6411', 'df69d2eb-b81e-4c2b-b9cc-698611ce50d4', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('f1d99627-b843-46d0-b0b4-872616bba54b', 'a2e084cb-584f-4149-88e1-72f946ae7a0e', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('ec495859-ac63-4be6-855f-a0205e6348ba', '3292491a-31d1-4365-b8d4-9323526a6aff', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('723ae20d-d994-42cd-900d-8b7bc4652a31', 'c220e86d-b3e3-431e-95cc-9859cdebf52f', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('6ae881c1-365d-47a2-94c0-e7f44c7aaa17', '5ac32e8d-7a27-4389-9c36-9e858105bdf2', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('2239fa6a-6f1f-4fa7-b2c6-67b3644542db', 'dd492e6e-3abf-4417-8f99-aafa4f37530e', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('69935673-852c-4a75-aeae-d75096795b12', '16020587-abef-427e-b024-b7b8b9267323', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('5c27bb71-be1f-4626-b561-505609f2a7e5', '9c1728f0-67e9-4a7d-a2a2-ca96efa228f2', '7de3b3d7-b60f-48ac-9681-78d46a5e74d4', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('4d5b3526-6e5a-42ee-8999-061977e7b76e', '6b798f2e-a1b9-4af8-8a39-d0e4165ccb44', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('7780e008-61fa-49b2-bded-4b8e606cf7e6', 'beb72a33-2073-4bcb-a9bc-d75bb47d8a25', '1', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('283292fb-0e2c-4abc-a999-0a0c2927dce2', '66743a42-7e88-482e-9d98-d8db8f2ef9a0', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('443abf76-cb34-4eb8-b3bb-273f41a355a1', '2ca7ca44-bd9c-4066-9bc6-da23c7f41d88', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('d2384582-121f-42bd-8307-640f493b8964', 'aa6a5b27-acaf-4ca3-902a-de2b20281a85', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('991c1344-32ab-4d94-991a-3c817fcc2eb8', 'a628ea6d-0943-470a-a623-e4af58d02f3b', '7de3b3d7-b60f-48ac-9681-78d46a5e74d4', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('214a24d7-bf79-4915-bc31-58c2ca9686dd', '11991619-e808-4fbe-9d93-e889196fa83a', '7de3b3d7-b60f-48ac-9681-78d46a5e74d4', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('45bc9b30-0e90-4165-99df-4253c41846d2', '47287684-c365-40d2-8a77-f10bcd6f84e1', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('eb1f7e6c-ecf4-4441-97a6-c4364b5ce898', '85b16c17-aa67-4094-9045-f3982a02a932', '0', 0)
INSERT INTO @vc3reporting_ReportFilterValue VALUES ('67bd1a9b-ab88-4248-8f55-76fc34cbbc41', '3959f359-3b62-4676-9d76-ffbf126daf64', '0', 0)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @vc3reporting_ReportSelectColumnSummaryFunction TABLE (SelectColumn uniqueidentifier, SummaryFunction char(1))

-- Insert the data to be synchronized into the temporary table

-- Declare a temporary table to hold the data to be synchronized
DECLARE @ReportArea TABLE (ID uniqueidentifier, Name varchar(50), Description text)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @ReportArea VALUES ('b269fb8b-e67b-4de4-a796-2e6f8b0a94d3', 'RTI Progress Monitoring', NULL)
INSERT INTO @ReportArea VALUES ('66474355-2dd2-4515-81a8-7e890e188adf', 'RTI Program History', NULL)
INSERT INTO @ReportArea VALUES ('1a5e2b3e-d3e3-4c1b-b502-81120ce5f878', 'RTI Scheduling and Mgmt', NULL)
INSERT INTO @ReportArea VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', 'RTI Strategy Effectiveness', NULL)
INSERT INTO @ReportArea VALUES ('808d7789-2b13-4a82-992b-c949d68eb1d1', 'Special Ed Program History', NULL)

-- Declare a temporary table to hold the data to be synchronized
DECLARE @ReportAreaReport TABLE (ReportAreaID uniqueidentifier, ReportID uniqueidentifier)

-- Insert the data to be synchronized into the temporary table
INSERT INTO @ReportAreaReport VALUES ('66474355-2dd2-4515-81a8-7e890e188adf', 'ed81bca7-cb68-4b75-b1b8-30e98eaa86ce')
INSERT INTO @ReportAreaReport VALUES ('66474355-2dd2-4515-81a8-7e890e188adf', '308b46bc-1812-4cf1-9a2c-42da7e965dc2')
INSERT INTO @ReportAreaReport VALUES ('66474355-2dd2-4515-81a8-7e890e188adf', '22af8f11-96eb-4044-819b-a0de21bbe411')
INSERT INTO @ReportAreaReport VALUES ('66474355-2dd2-4515-81a8-7e890e188adf', '01cb5b6a-f0d3-4313-9b3e-a9d5367a9393')
INSERT INTO @ReportAreaReport VALUES ('66474355-2dd2-4515-81a8-7e890e188adf', '5b3ccd6d-9342-4f95-b076-bdcc219dfcdb')
INSERT INTO @ReportAreaReport VALUES ('1a5e2b3e-d3e3-4c1b-b502-81120ce5f878', 'f228b8a5-1962-4d31-b83f-1de4251c4683')
INSERT INTO @ReportAreaReport VALUES ('1a5e2b3e-d3e3-4c1b-b502-81120ce5f878', 'd80ebe64-97f4-487f-989d-8a55ed00204d')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '23859535-596c-415a-b98c-03ab914c0a5e')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '5ef6d38b-0937-4c11-af76-0ccc4a251ea4')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '75fc9c73-8810-477f-a271-2438a04c06c3')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', 'd7999f84-54f0-4da6-b196-2e19c0337cd7')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '832b1fff-e8db-42b2-a8d7-6a819a4b0e1d')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', 'e2ac9ecf-c11c-4d9d-8eb4-858702a0703e')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '44b198dc-ca15-4e10-828e-8ce8896d0ccc')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '6bb3d688-48bc-407d-bdf9-98d477556987')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', 'a7e4b22f-587f-49aa-a91d-ab6eeea54315')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '8242f808-25d9-4fd3-8c36-b4e4699a017e')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '86bfac1e-6594-45a8-9ca7-bd0e127dcd26')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '45c279e0-b0c3-4624-94ef-beb074d93212')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '465f560a-cf09-45c2-911d-c9470c46ed10')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', 'eedf57c4-e290-46ed-aaf5-d4c5e4ad8ec6')
INSERT INTO @ReportAreaReport VALUES ('0609c598-0466-4e9f-8413-9dec50cfd8e9', '65dadb9f-7eb9-49a5-99bf-ff21b406130d')
INSERT INTO @ReportAreaReport VALUES ('808d7789-2b13-4a82-992b-c949d68eb1d1', '4c3ddeab-39cd-494d-9c36-da0796c9a7cc')

-- Insert records in the destination tables that do not already exist
INSERT INTO vc3reporting.Report SELECT Source.* FROM @vc3reporting_Report Source LEFT JOIN vc3reporting.Report Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO Report SELECT Source.* FROM @Report Source LEFT JOIN Report Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportColumn SELECT Source.* FROM @vc3reporting_ReportColumn Source LEFT JOIN vc3reporting.ReportColumn Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportFilterColumn SELECT Source.* FROM @vc3reporting_ReportFilterColumn Source LEFT JOIN vc3reporting.ReportFilterColumn Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportSelectColumn SELECT Source.* FROM @vc3reporting_ReportSelectColumn Source LEFT JOIN vc3reporting.ReportSelectColumn Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportOrderColumn SELECT Source.* FROM @vc3reporting_ReportOrderColumn Source LEFT JOIN vc3reporting.ReportOrderColumn Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportColumnParameterValue SELECT Source.* FROM @vc3reporting_ReportColumnParameterValue Source LEFT JOIN vc3reporting.ReportColumnParameterValue Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportFilterValue SELECT Source.* FROM @vc3reporting_ReportFilterValue Source LEFT JOIN vc3reporting.ReportFilterValue Destination ON Source.Id = Destination.Id WHERE Destination.Id IS NULL
INSERT INTO vc3reporting.ReportSelectColumnSummaryFunction SELECT Source.* FROM @vc3reporting_ReportSelectColumnSummaryFunction Source LEFT JOIN vc3reporting.ReportSelectColumnSummaryFunction Destination ON Source.SelectColumn = Destination.SelectColumn AND Source.SummaryFunction = Destination.SummaryFunction WHERE Destination.SelectColumn IS NULL
INSERT INTO ReportArea SELECT Source.* FROM @ReportArea Source LEFT JOIN ReportArea Destination ON Source.ID = Destination.ID WHERE Destination.ID IS NULL
INSERT INTO ReportAreaReport SELECT Source.* FROM @ReportAreaReport Source LEFT JOIN ReportAreaReport Destination ON Source.ReportAreaID = Destination.ReportAreaID AND Source.ReportID = Destination.ReportID WHERE Destination.ReportAreaID IS NULL

-- Update records in the destination table that already exist
UPDATE Destination SET Destination.Title = Source.Title, Destination.Query = Source.Query, Destination.Type = Source.Type, Destination.Path = Source.Path, Destination.Description = Source.Description, Destination.Format = Source.Format FROM @vc3reporting_Report Source JOIN vc3reporting.Report Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.Owner = Source.Owner, Destination.IsPublished = Source.IsPublished, Destination.SecurityZone = Source.SecurityZone, Destination.IsSharingEnabled = Source.IsSharingEnabled, Destination.IsSharedWithEveryone = Source.IsSharedWithEveryone, Destination.RunAsOwner = Source.RunAsOwner, Destination.IsHidden = Source.IsHidden, Destination.OmitNulls = Source.OmitNulls, Destination.DateCreated = Source.DateCreated FROM @Report Source JOIN Report Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.Type = Source.Type, Destination.Report = Source.Report, Destination.ReportTypeTable = Source.ReportTypeTable, Destination.SchemaColumn = Source.SchemaColumn, Destination.Sequence = Source.Sequence FROM @vc3reporting_ReportColumn Source JOIN vc3reporting.ReportColumn Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.SchemaOperator = Source.SchemaOperator, Destination.Nullable = Source.Nullable FROM @vc3reporting_ReportFilterColumn Source JOIN vc3reporting.ReportFilterColumn Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.Label = Source.Label, Destination.SchemaSummaryFunction = Source.SchemaSummaryFunction FROM @vc3reporting_ReportSelectColumn Source JOIN vc3reporting.ReportSelectColumn Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.IsAscending = Source.IsAscending FROM @vc3reporting_ReportOrderColumn Source JOIN vc3reporting.ReportOrderColumn Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.ReportColumn = Source.ReportColumn, Destination.SchemaTableParameter = Source.SchemaTableParameter, Destination.ValueExpression = Source.ValueExpression FROM @vc3reporting_ReportColumnParameterValue Source JOIN vc3reporting.ReportColumnParameterValue Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.FilterColumn = Source.FilterColumn, Destination.ValueExpression = Source.ValueExpression, Destination.IsDynamic = Source.IsDynamic FROM @vc3reporting_ReportFilterValue Source JOIN vc3reporting.ReportFilterValue Destination ON Source.Id = Destination.Id
UPDATE Destination SET Destination.Name = Source.Name, Destination.Description = Source.Description FROM @ReportArea Source JOIN ReportArea Destination ON Source.ID = Destination.ID

commit tran