set ANSI_NULLS on
go
set ANSI_WARNINGS on
go

--select top 1 * from excent9710a.ExcentOnlineFL.dbo.SpecialEdStudentsAndIEPs

set nocount on;
-- set ansi_warnings off;
declare @stdistinct table (gstudentid uniqueidentifier, recnum int)
insert @stdistinct 
	  select h.gstudentid, max(h.recnum) recnum     
	  from excent9710a.ExcentOnlineFL.dbo.SpecialEdStudentsAndIEPs x
		join excent9710a.ExcentOnlineFL.dbo.schooltbl h on x.gstudentid = h.gstudentid
	  join excent9710a.ExcentOnlineFL.dbo.ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (1, 3)  
	  where isnull(h.del_flag,0) = 0    
	  group by h.gstudentid    

insert @stdistinct 
	  select h.gstudentid, max(h.recnum) recnum     
	  from excent9710a.ExcentOnlineFL.dbo.SpecialEdStudentsAndIEPs x
		join excent9710a.ExcentOnlineFL.dbo.schooltbl h on x.gstudentid = h.gstudentid
	  join excent9710a.ExcentOnlineFL.dbo.ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (2, 3)  
	left join @stdistinct d on h.recnum = d.recnum
	  where isnull(h.del_flag,0) = 0    
	and d.gstudentid is null
	  group by h.gstudentid  

select distinct 
	SchoolCode = sch.SchoolID,
	SchoolName = sch.SchoolName, 
	DistrictCode = st.DistCode, 
	MinutesPerWeek = cast (0 as int)
from @stdistinct h2
join excent9710a.ExcentOnlineFL.dbo.SchoolTbl st on h2.RecNum = st.RecNum
-- join SpecialEdStudentsAndIEPs i on st.GStudentID = i.GStudentID -- select *  from SpecialEdStudentsAndIEPs -- 11251
join excent9710a.ExcentOnlineFL.dbo.School sch on st.SchoolID = sch.SchoolID
GO

--select * from SchoolTbl
--select * from ReportStudentSchoolTypes




