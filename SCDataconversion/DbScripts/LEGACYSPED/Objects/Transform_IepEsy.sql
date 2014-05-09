-- select * from LEGACYSPED.IEP where IEPRefID = '84787' -- select * from LEGACYSPED.Student where StudentRefID = '8937'

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepESY') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepESY
GO

CREATE VIEW LEGACYSPED.Transform_IepESY -- select * from LEGACYSPED.Transform_IepESY
as
-- note:  It is possible to insert a stub record in IepEsy, with no data but the ID populated
/*
	20130811 - There were PrgItems at Brevard that did not have a IepEsy record from the previous import (it was not impemented yet at the time of that import).
	and ev.Touched = 0 was commented out in order to be able to import the section for these records.
*/
select 
	m.DestID,
	ts.IepRefID,
	ItemID = iv.DestID,
	SectionDefID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA',
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
	iv.DoNotTouch,
	ev.Touched
	-- VersionID = VersionDestID -- This section is pre-configured to be non-versionable --- select ev.StudentRefID
from LEGACYSPED.EvaluateIncomingItems ev join
LEGACYSPED.MAP_IEPStudentRefID ts on ev.StudentRefID = ts.StudentRefID join
LEGACYSPED.Transform_PrgIep iv on ts.IepRefID = iv.IEPRefID join
LEGACYSPED.Student s on ts.StudentRefID = s.StudentRefID  /* and ev.Touched = 0 */ left join
LEGACYSPED.MAP_PrgSectionID_NonVersioned m on ts.DestID = m.ItemID and m.DefID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA' left join
IepEsy t on m.DestID = t.ID
--where  s.EsyTBDDate is not null

