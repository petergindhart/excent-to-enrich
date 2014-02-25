-- If and when a specific disabilities file is imported from APS, we will use this file for the LOCAL table definition.
-- Until then, the disability information is in the Student.csv file

IF  EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'LEGACYSPED' and o.name = 'StudentDisability' and o.type = 'V') -- select * from LEGACYSPED.StudentDisability
	DROP VIEW LEGACYSPED.StudentDisability
GO

create view LEGACYSPED.StudentDisability
as
select s.StudentRefId, i.IepRefId, s.Disability1Code DisabilityCode, cast(0 as int) DisabilitySequence
from LEGACYSPED.Student s JOIN
	LEGACYSPED.IEP i on s.StudentRefId = i.StudentRefId
union
select s.StudentRefId, i.IepRefId, s.Disability2Code, cast(1 as int)
from LEGACYSPED.Student s JOIN
	LEGACYSPED.IEP i on s.StudentRefId = i.StudentRefId
where Disability2Code is not null
GO
