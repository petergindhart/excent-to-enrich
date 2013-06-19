
if not exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_IepEsyID')
begin
create table LEGACYSPED.MAP_IepEsyID (
IepRefID	varchar(150) not null,
DestID uniqueidentifier not null
)
end
go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'Transform_IepESY')
drop view LEGACYSPED.Transform_IepESY
go

create view LEGACYSPED.Transform_IepESY -- select * from LEGACYSPED.Transform_IepESY
as
-- note:  it is possible to insert a stub record in IepEsy, with no data but the ID populated
select 
	m.DestID,
	ts.IepRefID,
	s.EsyElig,
	DecisionID = case 
		when s.EsyTBDDate is not null 
			then 
			case
				when s.EsyElig = 'Y' then '96B38252-7807-47A0-95A5-CC2AE969AD24' 
				when s.EsyElig = 'N' then '2CE2602D-BD8C-418E-852B-18EFB1ABBA85' 
				when s.EsyElig is null then '79B2FA0F-07EB-4DFC-8AA8-DC0EF9056BC3'
			end
			else 
			case
				when s.EsyElig = 'Y' then '96B38252-7807-47A0-95A5-CC2AE969AD24' 
				when s.EsyElig = 'N' then '2CE2602D-BD8C-418E-852B-18EFB1ABBA85' 
				else NULL
			end
		end,
	TbdDate = s.EsyTBDDate,
	iv.DoNotTouch
	-- VersionID = VersionDestID -- This section is pre-configured to be non-versionable
from LEGACYSPED.EvaluateIncomingItems ev join
LEGACYSPED.MAP_IEPStudentRefID ts on ev.StudentRefID = ts.StudentRefID join
LEGACYSPED.Transform_PrgIep iv on ts.IepRefID = iv.IEPRefID join
LEGACYSPED.Student s on ts.StudentRefID = s.StudentRefID and ev.Touched = 0 left join
LEGACYSPED.MAP_PrgSectionID_NonVersioned m on ts.DestID = m.ItemID and m.DefID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA' left join
IepEsy t on m.DestID = t.ID
where not (s.EsyElig is null and s.EsyTBDDate is null) 
go
