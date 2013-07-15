set nocount on;
set ansi_warnings off;

declare @gtbl table (IEPRefID int not null primary key, GStudentID uniqueidentifier, IEPComplete varchar(20))
insert @gtbl 
select distinct x.IEPSeqNum, x.GStudentID, IEPComplete = isnull(i.IEPComplete, 'Draft')
from SpecialEdStudentsAndIEPs x 
join IEPTbl i on x.GStudentID = i.GStudentID 
	and	i.iepseqnum = (
		select min(imin.IEPSeqNum)
		from IEPTbl imin 
		where i.GStudentID = imin.GStudentID
		and isnull(imin.del_flag,0)=0
		)

select 
-- i.IEPComplete, g.IEPStatus, g.del_flag,
	GoalRefID = g.GoalSeqNum, 
	IepRefID = g.IEPComplSeqNum, 
	Sequence = isnull(g.GoalOrder,0),
	GAReading = case when g.Domain13 = 1 then 'Y' else '' end,
	GAWriting = case when g.Domain14 = 1 then 'Y' else '' end,	
	GAMath = case when g.Domain15 = 1 then 'Y' else '' end,
-- we were seeing curriculum goals with other and some non-curruiculum goal(s)
	GAOther = case when (g.Domain16 = 1 or (g.Domain1 = 1 and (isnull(g.Domain13,0) = 0 and isnull(g.Domain14,0) = 0 and isnull(g.Domain15,0) = 0))) then 'Y' else '' end, -- if curr&learning = 1 and RWM&O are 0, set to Other
	GAEmotional = case when g.Domain2 = 1 then 'Y' else '' end,
	GAIndependent = case when g.Domain3 = 1 then 'Y' else '' end,
	GAHealth = case when g.Domain4 = 1 then 'Y' else '' end,
	GACommunication = case when g.Domain5 = 1 then 'Y' else '' end,
	PSInstruction = case when g.Domain6 = 1 then 'Y' else '' end,
	PSCommunity = case when g.Domain8 = 1 then 'Y' else '' end,
	PSAdult = case when g.Domain10 = 1 then 'Y' else '' end,
	PSVocational = case when g.Domain12 = 1 then 'Y' else '' end,
	PSRelated = case when g.Domain7 = 1 then 'Y' else '' end,
	PSEmployment = case when g.Domain9 = 1 then 'Y' else '' end,
	PSDailyLiving = case when g.Domain11 = 1 then 'Y' else '' end,
	IsEsy = case when isnull(g.esy,0) = 1 then 'Y' else 'N' end,
	GoalStatement = replace(isnull(convert(varchar(8000), g.GoalDesc),''), char(13)+char(10), char(240)+'^')
from @gtbl i 
join GoalTbl g on i.IEPRefID = g.IEPComplSeqNum
where (
	(i.IEPComplete = 'Draft' and g.IEPStatus = 2 and g.del_flag=1) 
	or
	(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 1 and isnull(g.del_flag,0)=0) 
	)
and g.GoalDesc is not null
order by g.IEPComplSeqNum, g.GoalOrder
GO


/*

--and g.gstudentid = 'A603252D-AFB3-411B-BA0E-C837102631C7'
select * from Student where GStudentID = 'A603252D-AFB3-411B-BA0E-C837102631C7'

select loginpwd, * from staff where loginname = 'admin'


select * from ICGoalTbl where GoalSeqNum = 909300



select t.* 
from IEPTbl t
where t.gstudentid in ('80170370-D016-4E1C-952F-69708CC75083', 'FE7F5B05-ACC5-4723-B361-B6D49ADEA45B') 
and t.iepseqnum = (
	select min(tmin.IEPSeqNum)
	from IEPTbl tmin 
	where t.GStudentID = tmin.GStudentID
	and isnull(tmin.del_flag,0)=0
	)



select i.*
from (
	select GStudentID, count(*) tot from IEPTbl where isnull(del_flag,0)=0 group by gstudentid having count(*) > 1
	) dup
join IEPTbl i on dup.GStudentID = i.GStudentID 
where isnull(i.del_flag,0)=0


select top 10 * from GoalTbl


declare @g uniqueidentifier ; select @g = gstudentid from student where studentid = '3611113333'
select * from goaltbl where gstudentid = @g
and isnull(del_Flag,0)=0


select 
GoalRefID = g.GoalSeqNum, 
IepRefID = g.GStudentID, 
Sequence = g.GoalOrder,
GAReading = case when g.Domain13 = 1 then 'Y' else '' end,
GAWriting = case when g.Domain14 = 1 then 'Y' else '' end,	
GAMath = case when g.Domain15 = 1 then 'Y' else '' end,
GAOther = case when g.Domain16 = 1 then 'Y' else '' end,
GAEmotional = case when g.Domain2 = 1 then 'Y' else '' end,
GAIndependent = case when g.Domain3 = 1 then 'Y' else '' end,
GAHealth = case when g.Domain4 = 1 then 'Y' else '' end,
GACommunication = case when g.Domain5 = 1 then 'Y' else '' end,
PSInstruction = case when g.Domain6 = 1 then 'Y' else '' end,
PSCommunity = case when g.Domain8 = 1 then 'Y' else '' end,
PSAdult = case when g.Domain10 = 1 then 'Y' else '' end,
PSVocational = case when g.Domain12 = 1 then 'Y' else '' end,
PSRelated = case when g.Domain7 = 1 then 'Y' else '' end,
PSEmployment = case when g.Domain9 = 1 then 'Y' else '' end,
PSDailyLiving = case when g.Domain11 = 1 then 'Y' else '' end,
IsEsy = case when isnull(esy,0) = 1 then 'Y' else 'N' end,
GoalStatement = replace(isnull(convert(varchar(8000), g.GoalDesc),''), char(13)+char(10), char(240)+'^')
from GoalTbl g
where gstudentid = @g
and goalorder = 1
and isnull(del_flag,0)=0

select GoalDesc, Domain1 d1 , Domain2 d2, Domain3 d3, Domain4 d4, Domain5 d5, Domain6 d6, Domain7 d7, Domain8 d8, Domain9 d9, Domain10 d10, Domain11 d11, Domain12 d12, Domain13 d13, Domain14 d14, Domain15 d15, Domain16 d16
from GoalTbl where gstudentid = @G and isnull(del_Flag,0)=0
and GoalOrder = 1


*/


