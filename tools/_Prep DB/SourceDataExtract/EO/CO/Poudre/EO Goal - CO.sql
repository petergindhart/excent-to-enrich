use ExcentOnline
go
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
	GoalRefID = g.GoalSeqNum,
	IepRefID = g.IEPComplSeqNum, 
	Sequence = g.GoalOrder,
--	GoalAreaCode = case when isnull(g.GoalCode,'') in (select Code from CodeDescLook where UsageID = 'Banks') then isnull(g.GoalCode,'') else '' end,
	GoalAreaCode = isnull(k.Code,''),
	PSEducation = case when g.PostSchAreaEd = 1 then 'Y' else '' end,
	PSEmployment = case when g.PostSchAreaEmp = 1 then 'Y' else '' end,
	PSIndependent = case when g.PostSchAreaInd = 1 then 'Y' else '' end,
	IsESY = 'N',
	GoalStatement = replace(isnull(convert(varchar(8000), g.GoalDesc),''), char(13)+char(10), char(240)+'^')
from @gtbl i 
join GoalTbl g on i.gstudentid = g.gstudentid and i.IEPRefID = g.iepcomplseqnum
left join CodeDescLook k on g.BankDesc = k.LookDesc and k.UsageID = 'Banks'
	and k.Code = (
		select min(mink.Code)
		from CodeDescLook mink 
		where mink.UsageID = k.UsageID
		and k.LookDesc = mink.LookDesc
		)
where (
	(i.IEPComplete = 'Draft' and g.IEPStatus = 2 and g.del_flag=1) 
	or
	(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 1 and isnull(g.del_flag,0)=0) 
	or
	(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 3 and g.del_flag=1)
	)
order by g.GStudentID, g.GoalOrder
GO

