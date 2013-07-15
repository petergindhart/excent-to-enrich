
-- create schema x_DATATEAM


;
CREATE view [x_DATATEAM].[FormLayoutSequence]
as

WITH TemplateLayoutCTE AS (
select lop.id, lop.TemplateId, lop.ControlId, lop.Sequence, lop.ParentID, Lvl = 0 
from FormTemplateLayout lop
where lop.ParentID is null 
--and lop.TemplateId = 'C12648E5-7678-4358-B936-2A2F6FDF1B4B' -- hard coded for the Waukegan Data Sheet at this time.  
union all
select loc.id, loc.TemplateId, loc.ControlId, loc.Sequence, loc.ParentID, Lvl = loclvl.lvl + 1
from FormTemplateLayout loc
join TemplateLayoutCTE loclvl on loc.ParentId = loclvl.Id
where loc.ParentID is not null 
-- and loc.TemplateId = 'C12648E5-7678-4358-B936-2A2F6FDF1B4B' -- hard coded for the Waukegan Data Sheet at this time.  
)
--/ *
--	Currently the query assumes that there will be no more than 2 child levels after the placeholder level. 
--	To handle more, we will use 1 sequence column that taks the max level and multiplies the different child levels by 10 ^ [total levels]-1
--* /
-- select t1.TemplateId, t1.ID, t1.ParentId, t1.ControlId, tct.Name, t1.Lvl, t1.Sequence, ChildSequence = 0

select t1.TemplateId, t1.ID, t1.ParentId, t1.ControlId, tct.Name, t1.Lvl, t1.Sequence, ParentSequencePWR = t1.Sequence*power(10, MaxLvl), ChildSequence = 0, SumSequence = t1.Sequence*power(10, MaxLvl) + t1.Sequence + 1, SumSequence2 = t1.Sequence*power(10, MaxLvl) + t1.Sequence + 1
from TemplateLayoutCTE t1
join dbo.FormTemplateControl tc on t1.ControlId = tc.Id
join dbo.FormTemplateControlType tct on tc.TypeId = tct.Id
cross join (select MaxLvl = max(ml.Lvl)-1 from TemplateLayoutCTE ml) maxLevel
where Lvl = 1
union all
select t1.TemplateId, t2.ID, t2.ParentId, t2.ControlId, tct.Name, t1.Lvl, ParentSequence = t1.Sequence, ParentSequencePWR = t1.Sequence*power(10, MaxLvl), ChildSequence = t2.Sequence + 1, SumSequence = t1.Sequence*power(10, MaxLvl) + t2.Sequence + 1, SumSequence2 = t1.Sequence*power(10, MaxLvl) + t2.Sequence + 1 + (t2.Sequence + 1)*t1.Lvl*100
from TemplateLayoutCTE t1
join TemplateLayoutCTE t2 on t1.id = t2.ParentId 
join dbo.FormTemplateControl tc on t1.ControlId = tc.Id
join dbo.FormTemplateControlType tct on tc.TypeId = tct.Id
cross join (select MaxLvl = max(ml.Lvl)-1 from TemplateLayoutCTE ml) maxLevel
where t1.ParentId is not null

GO



CREATE view [x_DATATEAM].[FormLayoutSequence2]
as 
select TemplateID, ID, ParentID, ControlID, Name, Sequence = (select count(*) from x_DATATEAM.FormLayoutSequence where s.TemplateID = TemplateID and s.Sumsequence2 < SumSequence2)
from x_DATATEAM.FormLayoutSequence s

GO

