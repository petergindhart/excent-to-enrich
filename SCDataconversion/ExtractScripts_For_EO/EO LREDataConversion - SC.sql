if exists (select 1 from sys.objects where name = 'LREDataConversion')
drop view LREDataConversion
go

create view LREDataConversion
as
select p.GStudentID, p.IEPComplSeqNum, p.IEPLRESeqNum, AgeGroup = 'K12', Placement = p2.EdPlacement, p2.HomeHosPlace, PlacementDesc = k.PlacementDesc + isnull(' - ' + kh.PlacementDesc, '')
from ICIEPLRETbl p 
join ICIEPLRETbl_SC p2 on p.IEPComplSeqNum = p2.IEPComplSeqNum and p.IEPLRESeqNum = p2.IEPLRESeqNum
left join LK_LREPlacements k on p2.EdPlacement = k.IEPCode and k.UsageID = 'LREplace'
left join LK_LREPlacements kh on p2.HomeHosPlace = kh.IEPCode and kh.UsageID = 'LREplaceHosp'  
where isnull(p.del_flag,0)=0
and p2.EdPlacement is not null
UNION ALL
select p.GStudentID, p.IEPComplSeqNum, p.IEPLRESeqNum, 'PK', p2.PrePlacement, HomeHosPlace = NULL, PlacementDesc = k.PlacementDesc
from ICIEPLRETbl p 
join ICIEPLRETbl_SC p2 on p.IEPComplSeqNum = p2.IEPComplSeqNum and p.IEPLRESeqNum = p2.IEPLRESeqNum
left join LK_LREPlacements k on p2.PrePlacement = k.IEPCode and k.UsageID = 'LREPlacePK'
where isnull(p.del_flag,0)=0
and p2.PrePlacement is not null
UNION ALL
select i.GStudentID, 
	p.IEPComplSeqNum,
	p.IEPLRESeqNum,
	AgeGroup = case when p02.EdPlacement is not null then 'K12' when p02.PrePlacement is not null then 'PK' else NULL end,
	Placement = case when p02.EdPlacement is not null then p02.EdPlacement when p02.PrePlacement is not null then p02.PrePlacement else NULL end,
	HomeHosPlace = p02.HomeHosPlace, 
	PlacementDesc = case 
		when p02.EdPlacement is not null then kk.PlacementDesc + isnull(' - ' + kh.PlacementDesc, '') 
		when p02.PrePlacement is not null then kp.PlacementDesc
		else NULL end
from ICIEPLRETbl p 
join ICIEPLRETbl_SC p2 on p.IEPComplSeqNum = p2.IEPComplSeqNum and p.IEPLRESeqNum = p2.IEPLRESeqNum
join IEPTbl i on p.GStudentID = i.GStudentID
join IEPLRETbl p0 on i.GStudentID = p0.GStudentID 
join IEPLRETbl_SC p02 on p0.IEPLRESeqNum = p02.IEPLRESeqNum
	left join LK_LREPlacements kk on p02.EdPlacement = kk.Code and kk.UsageID = 'LREplace'
	left join LK_LREPlacements kp on p02.PrePlacement = kp.Code and kp.UsageID = 'LREPlacePK'
	left join LK_LREPlacements kh on p02.HomeHosPlace = kh.Code and kh.UsageID = 'LREplaceHosp'
where p2.EdPlacement is null and p2.PrePlacement is null 
and isnull(i.IEPComplete,'Draft') = 'IEPComplete'
go
