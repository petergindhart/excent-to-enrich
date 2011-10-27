-- FL version
if exists (select 1 from sys.objects where type = 'V' and name = 'GoalAreaExists')
drop view LEGACYSPED.GoalAreaExists
go

create view LEGACYSPED.GoalAreaExists
as
select g.GoalRefID
from LEGACYSPED.Goal g
where isnull(g.GACommunication,'')+isnull(g.GAEmotional,'')+isnull(g.GAHealth,'')+isnull(g.GAIndependent,'')+isnull(g.GAMath,'')+isnull(g.GAOther,'')+isnull(g.GAReading,'')+isnull(g.GAWriting,'') like '%Y%'
go
