set nocount on;
set ansi_warnings off;
declare @stdistinct table (gstudentid uniqueidentifier, recnum int)
insert @stdistinct 
	  select h.gstudentid, max(h.recnum) recnum     
	  from SpecialEdStudentsAndIEPs x
		join schooltbl h on x.gstudentid = h.gstudentid
	  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (1, 3)  
	  where isnull(h.del_flag,0) = 0    
	  group by h.gstudentid    

insert @stdistinct 
	  select h.gstudentid, max(h.recnum) recnum     
	  from SpecialEdStudentsAndIEPs x
		join schooltbl h on x.gstudentid = h.gstudentid
	  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (2, 3)  
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
join SchoolTbl st on h2.RecNum = st.RecNum
-- join SpecialEdStudentsAndIEPs i on st.GStudentID = i.GStudentID -- select *  from SpecialEdStudentsAndIEPs -- 11251
join School sch on st.SchoolID = sch.SchoolID
GO

--select * from SchoolTbl
--select * from ReportStudentSchoolTypes




