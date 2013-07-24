set nocount on
go
set ansi_warnings on
go


ObjectiveRefID|GoalRefID|Sequence|ObjText
OLE DB provider "SQLNCLI10" for linked server "excent9710a" returned message "Query timeout expired".
Msg 7399, Level 16, State 1, Line 15
The OLE DB provider "SQLNCLI10" for linked server "excent9710a" reported an error. Execution terminated by the provider because a resource limit was reached.
Msg 7421, Level 16, State 2, Line 15
Cannot fetch the rowset from OLE DB provider "SQLNCLI10" for linked server "excent9710a". .



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
	from excent9710a.ExcentOnlineFL.dbo.ExtractGoalIEPStatus i 
	join excent9710a.ExcentOnlineFL.dbo.GoalTbl g on i.IEPRefID = g.IEPComplSeqNum
	where (
		(i.IEPComplete = 'Draft' and g.IEPStatus = 2 and g.del_flag=1) 
		or
		(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 1 and isnull(g.del_flag,0)=0) 
		)
	) g
join excent9710a.ExcentOnlineFL.dbo.ObjTbl o on g.GoalSeqNum = o.GoalSeqNum 
where (
		(g.IEPComplete = 'Draft' and o.IEPStatus = 2 and o.del_flag=1) 
		or
		(g.IEPComplete = 'IEPComplete' and o.IEPStatus = 1 and isnull(o.del_flag,0)=0) 
		)
-- o.IEPStatus = 1 and isnull(o.del_flag,0)=0
and o.ObjDesc is not null
GO




