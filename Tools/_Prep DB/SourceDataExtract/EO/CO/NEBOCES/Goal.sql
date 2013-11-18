
declare @g uniqueidentifier ; select @g = GSTudentID from Student where StudentID = '1170699031'
select g.*
from IEPCompleteTbl i 
join GoalTbl g on i.IEPSeqNum = g.IEPComplSeqNum
where i.ReviewMeet > getdate()
and g.IEPStatus = 1
and isnull(g.del_flag,0)!=1
and i.GStudentID = @g
order by g.GoalOrder



