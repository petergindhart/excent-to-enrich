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
	ObjectiveRefID = o.ObjSeqNum,
	GoalRefID = g.GoalSeqNum,
	Sequence = o.ObjOrder,
	ObjText = replace(convert(varchar(8000), o.ObjDesc), char(13)+char(10), char(240)+'^')
from (
--	select i.gstudentid, g.GoalSeqNum
--	from @gtbl i 
--	join GoalTbl g on i.gstudentid = g.gstudentid
--	where g.iepstatus = 1 and isnull(g.del_flag,0)=0
	select i.GStudentID, g.GoalSeqNum, i.IEPComplete
	from @gtbl i 
	join GoalTbl g on i.IEPRefID = g.IEPComplSeqNum
	where (
		(i.IEPComplete = 'Draft' and g.IEPStatus = 2 and g.del_flag=1) 
		or
		(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 1 and isnull(g.del_flag,0)=0) 
		)
	) g
join ObjTbl o on g.GoalSeqNum = o.GoalSeqNum 
where (
		(g.IEPComplete = 'Draft' and o.IEPStatus = 2 and o.del_flag=1) 
		or
		(g.IEPComplete = 'IEPComplete' and o.IEPStatus = 1 and isnull(o.del_flag,0)=0) 
		)
-- o.IEPStatus = 1 and isnull(o.del_flag,0)=0
and o.ObjDesc is not null
GO




