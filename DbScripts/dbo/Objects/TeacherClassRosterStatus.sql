if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TeacherClassRosterStatus]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[TeacherClassRosterStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TeacherClassRosterStatus]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[TeacherClassRosterStatus]
GO

/*
<summary>
Gets content-area statuses for all teacher assignments.
</summary>
<param name="AsOfDate">Status date input by user.</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE  function [dbo].[TeacherClassRosterStatus]
(@AsOfDate datetime)
Returns table 
As
Return 
(
select	
	-- history
	TeacherID, ClassRosterID, CrthStartDate, CrthEndDate,
	-- class roster
	SchoolID, SectionName, ClassName,
	-- content area
	ContentAreaID, ContentAreaName, ContentAreaSubj, LevelRequiredID,
	-- status
	TcaStartDate, TcaEndDate, LevelID,
	-- satisfaction
	SatisfactionID = case
	when LevelRequired = 2 then							'4611EEA6-8EB7-46FF-A7CA-7C5F592F9334' --NA
	when ContentAreaID is null then 					'07D39F19-E4A8-4741-889D-2F433EFF6DE7' --CA Unknown
	when LevelID is null then 							'DE72B250-6345-4B47-B53A-41429A9CD230' --REQ Unknown
	when LevelRequired = 1 and LevelAchieved = 1 then 	'DE353E3B-31A9-4376-8B2A-B81CD4AE92CB' --HQ Met
	when LevelRequired = 1 and LevelAchieved = 0 then 	'D578A0E9-7335-498D-BC69-64193DC891CC' --HQ Partially Met
	when LevelRequired = 1 then 						'3CA8D0FC-6509-47CF-94F0-D7D3F92F8D94' --HQ Not Met
	when LevelRequired = 0 and LevelAchieved = 0 then 	'934BBA75-DD8D-4D25-8084-0772599137F9' --Certified Met
	when LevelRequired = 0 then 						'D8AD9D7B-F2DC-4FA6-8399-7F6D1A8EECC9' --Certified Not Met
	else 												'00000000-0000-0000-0000-000000000000' -- should never fall through
	end
from
	(
		select
			-- history
			A.TeacherID,A.ClassRosterID,A.CrthStartDate,A.CrthEndDate,
			-- class roster
			A.SchoolID,A.SectionName,A.ClassName,
			-- content area
			C.ContentAreaID,C.ContentAreaName,C.ContentAreaSubj,C.LevelRequiredID, C.LevelRequired,
			-- status
			B.TcaStartDate,B.TcaEndDate,B.LevelID,
			-- satisfaction
			LevelAchieved = min(B.LevelAchieved)
		from
			(
				select
					-- history
					crth.TeacherID,	crth.ClassRosterID,	CrthStartDate = crth.StartDate,	CrthEndDate = isnull( crth.EndDate, ry.EndDate ),
					-- class roster
					cr.SchoolID, cr.SectionName, cr.ClassName,
					-- join fields
					cr.ContentAreaID, cr.GradeBitMask
				from
					ClassRosterTeacherHistory crth join
					ClassRoster cr on crth.ClassRosterID = cr.ID join
					RosterYear ry on cr.RosterYearID = ry.ID
				where
					@AsOfDate >= crth.StartDate and @AsOfDate < isnull( crth.EndDate, ry.EndDate )
			) A left join
			(
				select
					-- join fields
					tca.TeacherID, tca.GradeBitMask, tca.ContentAreaID,
					-- status
					TcaStartDate = tca.StartDate, TcaEndDate = tca.EndDate, LevelID = tca.StatusID,
					LevelAchieved = cast( lA.Code as int )
				from
					TeacherContentArea tca join
					ContentArea ca on tca.ContentAreaID = ca.ID join
					EnumValue lA on tca.StatusID = lA.ID join
					EnumValue lR on ca.MaxCertificationLevelID = lR.ID
				where
					@AsOfDate >= tca.StartDate and (tca.EndDate is null or @AsOfDate < tca.EndDate)
			) B on
				A.TeacherID = B.TeacherID and
				A.ContentAreaID = B.ContentAreaID and
				A.GradeBitMask & B.GradeBitMask > 0 left join
			(
				select
					ContentAreaID = ca.ID, ContentAreaName = ca.Name, ContentAreaSubj = ca.SubjectID, LevelRequiredID = ca.MaxCertificationLevelID,
					LevelRequired = cast( lR.Code as int )
				from
					ContentArea ca join
					EnumValue lR on ca.MaxCertificationLevelID = lR.ID
			) C on A.ContentAreaID = C.ContentAreaID
		group by
			-- history
			A.TeacherID,A.ClassRosterID,A.CrthStartDate,A.CrthEndDate,
			-- class roster
			A.SchoolID,A.SectionName,A.ClassName,
			-- content area
			C.ContentAreaID,C.ContentAreaName,C.ContentAreaSubj,C.LevelRequiredID, C.LevelRequired,
			-- status
			B.TcaStartDate,B.TcaEndDate,B.LevelID
	) T	
)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

