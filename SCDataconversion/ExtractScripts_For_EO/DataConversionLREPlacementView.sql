if exists (select 1 from sys.objects where name = 'DataConversionLREPlacementView')
drop view DataConversionLREPlacementView
go

create view DataConversionLREPlacementView
as
select p.IEPComplSeqNum, p.IEPLRESeqNum, 
	AgeGroup = case when p2.EdPlacement is not null then 'K12' when p2.PrePlacement is not null then 'PK' else NULL end,
	Placement = 
	cast(case when p2.EdPlacement is not null then 
		case when p2.EdPlacement <> 8 then p2.EdPlacement
		else convert(varchar(2), p2.EdPlacement) + convert(varchar(2), isnull(p2.HomeHosPlace,''))
		end
	when p2.PrePlacement is not null then p2.PrePlacement
	else NULL
	end as varchar(2)),
	PlacementDesc = 
		case when p2.EdPlacement is not null then 
			case when p2.EdPlacement <> 8 then k.PlacementDesc
			else k.PlacementDesc + isnull(' - ' + kh.PlacementDesc, '')
		end
	when p2.PrePlacement is not null then kp.PlacementDesc
	else NULL
	end	
from DataConvSpedStudentsAndIEPs x
join ICIEPLRETbl p on x.IEPSeqNum = p.IEPComplSeqNum
join ICIEPLRETbl_SC p2 on p.IEPComplSeqNum = p2.IEPComplSeqNum and p.IEPLRESeqNum = p2.IEPLRESeqNum
left join LK_LREPlacements k on p2.EdPlacement = k.IEPCode and k.UsageID = 'LREplace' -- and p2.EdPlacement is not null
left join LK_LREPlacements kh on p2.HomeHosPlace = kh.IEPCode and kh.UsageID = 'LREplaceHosp' -- and p2.EdPlacement is not null
left join LK_LREPlacements kp on p2.PrePlacement = kp.IEPCode and kp.UsageID = 'LREPlacePK' -- and p2.PrePlacement is not null
where isnull(p.del_flag,0)!=1
go
