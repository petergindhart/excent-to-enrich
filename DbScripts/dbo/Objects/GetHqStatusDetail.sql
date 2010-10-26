if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetHqStatusDetail]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetHqStatusDetail]
GO
/*
<summary>
Gets content-area statuses for all teacher assignments. </summary>
<param name="Date">Status date input by user. </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE  function [dbo].[GetHqStatusDetail]
(@Date datetime)
Returns table 
As 

Return 
(

-- 0	HQ Met
-- 1	HQ Partially Met
-- 2	HQ Not Met
-- 3	Certified Met
-- 4	Certified Not Met
-- 5	Content Area Unknown
-- 6	Requirements Unknown
-- 7	NA

-- CCFB4A0C-43E5-4C94-B7F3-BAAC99A0539D	Unknown
-- 114786EF-0EE7-46AC-9677-D5540172F4DE	Highly Qualified
-- AE29B08D-C72F-413E-9723-921541D65AA0	Certified
-- EFCDB5BD-02BC-4615-80A0-45389DDB6FB3	Not Certified

select
	cr.ContentAreaID,
	crth.TeacherID,
	cr.SchoolID,
	crth.ClassRosterID,
	Status = case
		when cr.ContentAreaID is null then					5 -- UKAREA
	
		when ca.MaxCertificationLevelID =
			'CCFB4A0C-43E5-4C94-B7F3-BAAC99A0539D' then		7 -- NA
	
		when min( cast( ach.Code as int ) ) is null then	6 -- UKREQ
	
		when req.Code = '1' then case
			when min( cast( ach.Code as int ) ) = 1 then	0 -- HQ Good
			when min( cast( ach.Code as int ) ) = 0 then	1 -- HQ Part
			else											2 -- HQ Not
			end
	
		when req.Code = '0' and 
			min( cast( ach.Code as int ) ) = 0 then			3 -- Cert
		else												4 -- Cert Not
		end

from
	ClassRosterTeacherHistory crth join
	ClassRoster cr on crth.ClassRosterID = cr.ID left join
	ContentArea ca on cr.ContentAreaID = ca.ID left join
	TeacherContentArea tca on
		tca.ContentAreaID = ca.ID and
		tca.TeacherID = crth.TeacherID and
		( cr.GradeBitMask is null or cr.GradeBitMask & tca.GradeBitMask > 0 ) and
		tca.StartDate <= @Date and ( tca.EndDate is null or @Date < tca.EndDate ) left join
	EnumValue ach on tca.StatusID = ach.ID left join
	EnumValue req on ca.MaxCertificationLevelID = req.ID
where
	crth.StartDate <= @Date and ( crth.EndDate is null or @Date < crth.EndDate )
group by
	cr.SchoolID,
	crth.TeacherID,
	crth.ClassRosterID,
	cr.ContentAreaID,
	ca.MaxCertificationLevelID,
	req.Code
	
)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

