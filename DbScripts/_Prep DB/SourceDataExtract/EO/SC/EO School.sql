use EO_SC
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.School_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.School_EO
GO

CREATE VIEW dbo.School_EO
AS
SELECT   
Line_No=Row_Number() OVER (ORDER BY (SELECT 1))
,school.Schoolcode
,School.SchoolName
,school.DistrictCode
,school.MinutesPerWeek
FROM (
   SELECT Distinct sch.SchoolID as Schoolcode,
sch.SchoolName as SchoolName,
st.DistCode as DistrictCode,
MinutesPerWeek = cast (0 as int)
FROM  
         (
      SELECT h.gstudentid, max(h.recnum) recnum
	  FROM SpecialEdStudentsAndIEPs x
	  JOIN schooltbl h ON x.gstudentid = h.gstudentid
	  JOIN ReportStudentSchoolTypes t ON h.schtype = t.schtype AND t.schtypeorder IN (1, 3)  
	  WHERE isnull(h.del_flag,0) = 0    
	  GROUP BY h.gstudentid
UNION 
      SELECT h.gstudentid, max(h.recnum) recnum
	  FROM SpecialEdStudentsAndIEPs x
	  JOIN schooltbl h on x.gstudentid = h.gstudentid
	  JOIN ReportStudentSchoolTypes t ON h.schtype = t.schtype AND t.schtypeorder IN (2, 3)  
	  WHERE isnull(h.del_flag,0) = 0    
	  GROUP BY h.gstudentid  
	      ) stdistinct  
JOIN dbo.SchoolTbl st ON stdistinct.RecNum = st.RecNum
JOIN dbo.School sch ON st.SchoolID = sch.SchoolID
      ) school