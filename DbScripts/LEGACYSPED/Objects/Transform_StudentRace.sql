-- note:  the hard-coded values below need to be replaced with values in a lookup table in the LOCALIZATION file: 0002-Prep_District.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_StudentRace') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_StudentRace  
GO

CREATE VIEW LEGACYSPED.Transform_StudentRace  
AS

select StudentID = s.DestID, 
	   RaceID = r.RaceID
from (
      select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.ID = 'E1611EE9-7FC3-4CEF-80D6-D67EE6EE1F6F')  from LEGACYSPED.Student s where s.IsAmericanIndian = 'Y'
      union
      select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.ID ='953025B8-4102-4C8F-B8AB-766068ACC978')  from LEGACYSPED.Student s where s.IsAsian = 'Y'
      union
      select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.ID = '628814D0-09B4-4B77-A1A7-A9CEEC360C2B')  from LEGACYSPED.Student s where s.IsBlackAfricanAmerican = 'Y'
      union
      select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.ID = '80034B85-658B-497E-8793-E2382CB6AF51')  from LEGACYSPED.Student s where s.IsHawaiianPacIslander = 'Y'
      union
      select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.Id ='3A074939-80D2-4138-97E9-149345528E9F')  from LEGACYSPED.Student s where s.IsWhite = 'Y'
	  union 
	  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.ID = '68F95480-110E-45EB-84DC-566A930E8C67')  from LEGACYSPED.Student s where s.IsHispanic = 'Y'
      ) r join
LEGACYSPED.MAP_StudentRefID s on r.StudentRefID = s.StudentRefID  left join
dbo.StudentRace sr on s.DestID = sr.StudentID and r.RaceID = sr.RaceID 
go



