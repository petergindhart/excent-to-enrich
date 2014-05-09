if exists (select 1 from sys.objects where name = 'DataConversionGoalAreaCodeCodeView')
drop view DataConversionGoalAreaCodeCodeView
go

create view DataConversionGoalAreaCodeCodeView
as
select 
distinct 
GoalAreaCode = isnull(k.Code,'ZZZ'), 
GoalAreaDesc = isnull(k.LookDesc,'Not Defined')
FROM (
	select 
		IEPRefID = x.IEPSeqNum, 
		x.GStudentID, 
		IEPComplete = isnull(i.IEPComplete, 'Draft')
	from DataConvSpedStudentsAndIEPs x 
	join IEPTbl i on x.GStudentID = i.GStudentID 
	where i.iepseqnum = (
		select min(imin.IEPSeqNum) ------ handles a bug in EO that caused multiple records to be inserted into IEPTbl
		from IEPTbl imin 
		where i.GStudentID = imin.GStudentID
		and isnull(imin.del_flag,0)=0
		)
	) i 
join GoalTbl g on i.gstudentid = g.gstudentid and i.IEPRefID = g.iepcomplseqnum and
	(
		(i.IEPComplete = 'Draft' and g.IEPStatus = 2 and g.del_flag=1) 
		or
		(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 1 and isnull(g.del_flag,0)=0) 
		or
		(i.IEPComplete = 'IEPComplete' and g.IEPStatus = 3 and g.del_flag=1)
	)
left join CodeDescLook k on g.BankDesc = k.LookDesc and k.UsageId like 'Banks'
go
