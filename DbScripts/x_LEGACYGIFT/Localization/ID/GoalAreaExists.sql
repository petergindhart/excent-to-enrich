-- FL version
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.Name = 'x_LEGACYGIFT' and o.type = 'V' and o.name = 'GoalAreaExists')
drop view x_LEGACYGIFT.GoalAreaExists
go

create view x_LEGACYGIFT.GoalAreaExists
as
select g.GoalRefID
from x_LEGACYGIFT.GiftedGoal g -- view exists to facilitate reuse of code.  where clause required for FL but not for CO
--where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') like '%Y%'
go
--