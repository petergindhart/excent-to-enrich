IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_Involvement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_Involvement]
GO

CREATE VIEW [AURORAX].[Transform_Involvement]
AS  
 SELECT
  StudentRefID = stu.StudentRefID, --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
  DestID = m.DestID,   
  StudentID = stu.DestID,   
  ProgramID = '9F5E8A89-D027-4076-9759-FFED1B107E94',   -- Special Education
  VariantID = '6DD95EA1-A265-4E04-8EE9-78AE04B5DB9A',   -- Special Education
  StartDate = min(iep.IEPMeetingDate),   -- school start for this IEP period
  EndDate = case when dateadd(yy, 1, max(iep.IEPMeetingDate)) > getdate() then NULL else max(dateadd(yy, 1, iep.IEPMeetingDate)) end   -- school end for this IEP period.  MAX so we don't have to add to group by :-)
 FROM
  AURORAX.MAP_StudentRefID stu JOIN
  AURORAX.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
  StudentSchoolHistory sh on stu.DestID = sh.StudentID AND (iep.IEPMeetingDate < sh.EndDate AND dateadd(yy, 1, iep.IEPMeetingDate) > sh.StartDate)  LEFT JOIN -- will be full joins once the studentschoolhistory and studentgradelevelhistory data is inserted
  StudentGradeLevelHistory gh on stu.DestID = gh.StudentID AND (iep.IEPMeetingDate < gh.EndDate AND dateadd(yy, 1, iep.IEPMeetingDate) > gh.StartDate) LEFT JOIN
  AURORAX.MAP_InvolvementID m on iep.StudentRefID = m.StudentRefID --  stu.StudentID will change to stu.StudentRefID when the data based the new spec arrives.
 WHERE 
  iep.IEPMeetingDate is not null
 GROUP BY stu.StudentRefID, m.DestID, stu.DestID
GO
--