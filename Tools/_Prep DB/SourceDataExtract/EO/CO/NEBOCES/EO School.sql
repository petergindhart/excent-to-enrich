set nocount on;
set ansi_warnings off;

set nocount on;
set ansi_warnings off;


declare @md table (EODistrictCode varchar(4), StateDistrictCode varchar(4))
insert @md values ('1000', '2862')


declare @ms table (EOSchoolCode varchar(4), StateSchoolCode varchar(4))

insert @ms values ('1001', '4369')
insert @ms values ('5223', '5221')
insert @ms values ('9790', '9791')
insert @ms values ('9794', '9795')
insert @ms values ('9798', '9799')
insert @ms values ('9724', '9725')
insert @ms values ('9728', '9729')
insert @ms values ('9732', '9733')

--SELECT distinct StaffEmail = s.Email, OrigSchoolCode = ss.SchoolID, StateSchoolCode = isnull(ms.StateSchoolCode, ss.SchoolID)
--FROM dbo.StaffSchool ss 
--JOIN dbo.Staff s ON s.StaffGID = ss.StaffGID 
--left join @ms ms on ss.SchoolID = ms.EOSchoolCode
--WHERE ss.DeleteID is NULL 


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
	SchoolCode = isnull(ms.StateSchoolCode, sch.SchoolID),
	SchoolName = sch.SchoolName, 
	DistrictCode =isnull( cast(md.StateDistrictCode as varchar(10)), st.DistCode) , 
	MinutesPerWeek = cast (0 as int)
from @stdistinct h2
join SchoolTbl st on h2.RecNum = st.RecNum
join School sch on st.SchoolID = sch.SchoolID
left join @ms ms on sch.SchoolID = ms.EOSchoolCode
left join @md md on sch.DistrictID = md.EODistrictCode
--left join @md md on st.DistCode = md.EODistrictCode
order by SchoolCode

GO

--select * from SchoolTbl
--select * from ReportStudentSchoolTypes






--declare @stdistinct table (gstudentid uniqueidentifier, recnum int)
--insert @stdistinct 
--	  select h.gstudentid, max(h.recnum) recnum     
--	  from SpecialEdStudentsAndIEPs x
--		join schooltbl h on x.gstudentid = h.gstudentid
--	  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (1, 3)  
--	  where isnull(h.del_flag,0) = 0    
--	  group by h.gstudentid    

--insert @stdistinct 
--	  select h.gstudentid, max(h.recnum) recnum     
--	  from SpecialEdStudentsAndIEPs x
--		join schooltbl h on x.gstudentid = h.gstudentid
--	  join ReportStudentSchoolTypes t on h.schtype = t.schtype and t.schtypeorder in (2, 3)  
--	left join @stdistinct d on h.recnum = d.recnum
--	  where isnull(h.del_flag,0) = 0    
--	and d.gstudentid is null
--	  group by h.gstudentid  

--select distinct 
--	SchoolCode = sch.SchoolID,
--	SchoolName = sch.SchoolName, 
--	DistrictCode = st.DistCode, 
--	MinutesPerWeek = cast (0 as int)
--from @stdistinct h2
--join SchoolTbl st on h2.RecNum = st.RecNum
--join School sch on st.SchoolID = sch.SchoolID
--GO

----select * from SchoolTbl
--select * from ReportStudentSchoolTypes




