-- FL version
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.type = 'V' and o.name = 'GoalAreaExists')
drop view LEGACYSPED.GoalAreaExists
go

create view LEGACYSPED.GoalAreaExists
as
select g.GoalRefID
from LEGACYSPED.Goal g -- view exists to facilitate reuse of code.  where clause required for FL but not for CO
where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') like '%Y%'
-- where g.GoalAreaCode is not null --  we defaulted goal area ID to ZZZ elsewhere.  need to resolve issue of goal error
go
