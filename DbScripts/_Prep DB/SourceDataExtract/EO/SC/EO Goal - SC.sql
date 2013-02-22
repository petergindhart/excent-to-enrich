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
	GoalAreaCode = isnull(g.GoalCode,''),
	PSEducation = case when g.Domain1 = 1 then 'Y' else 'N' end,
	PSEmployment = case when g.Domain2 = 1 then 'Y' else 'N' end,
	PSIndependent = case when g.Domain3 = 1 then 'Y' else 'N' end,
	IsESY = 'N',
	UnitOfMeasurement = '',
	BaselineDataPoint = '',
	EvaluationMethod = '',
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


--select * from GoalTbl
--select * from CodeDescLook where code = 'MATH1'
--select * from GoalTbl
--select * from dbo.Goals ---k.UsageID = 'Banks' instead of this we can use this
--select * from dbo.ICGoalTbl
