set nocount on
go
set ansi_warnings on
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
where x.SpedOrGifted = 'SpEd'

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






