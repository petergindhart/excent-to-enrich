IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vw_Goal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.vw_Goal
GO

CREATE VIEW dbo.vw_Goal
AS

SELECT
    --Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),
	GoalRefID = g.GoalSeqNum,
	IepRefID = g.IEPComplSeqNum, 
	Sequence = g.GoalOrder,
--	GoalAreaCode = case when isnull(g.GoalCode,'') in (select Code from CodeDescLook where UsageID = 'Banks') then isnull(g.GoalCode,'') else '' end,
	GoalAreaCode = ISNULL(g.GoalCode,'ZZZ'),
	PSEducation = case when g.Domain1 = 1 then 'Y' else 'N' end,
	PSEmployment = case when g.Domain2 = 1 then 'Y' else 'N' end,
	PSIndependent = case when g.Domain3 = 1 then 'Y' else 'N' end,
	IsESY = 'N',
	UnitOfMeasurement = NULL,
	BaselineDataPoint = NULL,
	EvaluationMethod = NULL,
	GoalStatement = replace(isnull(convert(varchar(8000), g.GoalDesc),''), char(13)+char(10), char(240)+'^')
FROM (select distinct x.IEPSeqNum as IEPRefID, x.GStudentID, IEPComplete = isnull(i.IEPComplete, 'Draft')
from SpecialEdStudentsAndIEPs x 
join IEPTbl i on x.GStudentID = i.GStudentID 
	and	i.iepseqnum = (
		select min(imin.IEPSeqNum)
		from IEPTbl imin 
		where i.GStudentID = imin.GStudentID
		and isnull(imin.del_flag,0)=0
		)
		) i 
join dbo.GoalTbl g on i.gstudentid = g.gstudentid and i.IEPRefID = g.iepcomplseqnum
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
	
GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Goal_src') AND type in (N'U'))
DROP TABLE dbo.Goal_src
GO

SELECT 
Line_No= IDENTITY(INT,1,1),
GoalRefID ,
	IepRefID , 
	Sequence ,
--	GoalAreaCode = case when isnull(g.GoalCode,'') in (select Code from CodeDescLook where UsageID = 'Banks') then isnull(g.GoalCode,'') else '' end,
	GoalAreaCode ,
	PSEducation ,
	PSEmployment ,
	PSIndependent ,
	IsESY ,
	UnitOfMeasurement ,
	BaselineDataPoint ,
	EvaluationMethod ,
	GoalStatement 
INTO dbo.Goal_src
FROM vw_Goal
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Goal_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.Goal_EO
GO

CREATE VIEW dbo.Goal_EO
AS
SELECT 
Line_No,
GoalRefID ,
	IepRefID , 
	Sequence ,
--	GoalAreaCode = case when isnull(g.GoalCode,'') in (select Code from CodeDescLook where UsageID = 'Banks') then isnull(g.GoalCode,'') else '' end,
	GoalAreaCode ,
	PSEducation ,
	PSEmployment ,
	PSIndependent ,
	IsESY ,
	UnitOfMeasurement ,
	BaselineDataPoint ,
	EvaluationMethod ,
	GoalStatement 
FROM dbo.Goal_src

--select * from dbo.Goal_EO