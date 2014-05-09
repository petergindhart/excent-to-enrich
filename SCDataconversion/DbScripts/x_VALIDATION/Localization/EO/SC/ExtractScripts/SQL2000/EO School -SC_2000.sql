IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'stdistinctsch') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW stdistinctsch
GO
CREATE VIEW stdistinctsch
AS
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
	  
	  
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'schooltbl_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW schooltbl_EO
GO

CREATE VIEW schooltbl_EO
AS
SELECT Distinct sch.SchoolID as Schoolcode,
sch.SchoolName as SchoolName,
st.DistCode as DistrictCode,
MinutesPerWeek = cast (0 as int)
FROM  
stdistinctsch  std
JOIN dbo.SchoolTbl st ON std.RecNum = st.RecNum
JOIN dbo.School sch ON st.SchoolID = sch.SchoolID

GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'School_src') AND type in (N'U'))
DROP TABLE dbo.School_src
GO

SELECT 	
	Line_No= IDENTITY(INT,1,1),  
	Schoolcode,
	SchoolName,
	DistrictCode,
	MinutesPerWeek
	INTO dbo.School_src
FROM schooltbl_EO

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.School_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.School_EO
GO

CREATE VIEW dbo.School_EO
AS
SELECT   
Line_No,
	Schoolcode,
	SchoolName,
	DistrictCode,
	MinutesPerWeek
FROM  dbo.School_src

--SELECT * FROM dbo.School_EO