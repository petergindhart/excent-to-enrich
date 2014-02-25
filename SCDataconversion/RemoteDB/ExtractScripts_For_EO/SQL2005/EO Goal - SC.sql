IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Goal_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.Goal_EO
GO

CREATE VIEW dbo.Goal_EO
AS

SELECT
    Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),
	GoalRefID = g.GoalSeqNum,
	IepRefID = g.IEPComplSeqNum, 
	Sequence = g.GoalOrder,
	GoalAreaCode = isnull(k.Code,'ZZZ'), 
	--GoalAreaDesc = isnull(k.LookDesc,'Not Provided'), ------------ this is new and facilitates using this view for the SelectLists
	SCInstructional = case when g.Domain1 = 1 then 'Y' else 'N' end,
	SCTransition = case when g.Domain2 = 1 then 'Y' else 'N' end,
	SCRelatedService = case when g.Domain3 = 1 then 'Y' else 'N' end,
	IsESY = 'N',
	UnitOfMeasurement = NULL,
	BaselineDataPoint = NULL,
	EvaluationMethod = NULL,
	GoalStatement = replace(isnull(convert(varchar(8000), g.GoalDesc),''), char(13)+char(10), char(240)+'^')
FROM (
	select 
		IEPRefID = x.IEPSeqNum, 
		x.GStudentID, 
		IEPComplete = isnull(i.IEPComplete, 'Draft')
	from SpecialEdStudentsAndIEPs x 
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
left join CodeDescLook k on g.BankDesc = k.LookDesc and k.UsageId like 'Banks' and g.GoalCode = k.code

go
