-- CO version
if exists (select 1 from sys.objects where type = 'V' and name = 'GoalAreaExists')
drop view LEGACYSPED.GoalAreaExists
go

create view LEGACYSPED.GoalAreaExists
as
select g.GoalRefID
from LEGACYSPED.Goal g -- view exists to facilitate reuse of code.  where clause required for FL but not for CO
-- where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') like '%Y%'
go
