IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_StudentRace_Function'))
DROP FUNCTION LEGACYSPED.Transform_StudentRace_Function
GO

CREATE FUNCTION LEGACYSPED.Transform_StudentRace_Function ()  
	RETURNS @r table(
		StudentID uniqueidentifier not null,
		RaceID	uniqueidentifier not null
	) AS  
	BEGIN 
		insert @r
		select StudentID = s.DestID, 
			   RaceID = r.RaceID
		from (
			  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.StateCode = '01') from LEGACYSPED.Student s where s.IsAmericanIndian = 'Y' -- 01
			  union
			  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.StateCode = '02') from LEGACYSPED.Student s where s.IsAsian = 'Y' -- 02
			  union
			  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.StateCode = '03') from LEGACYSPED.Student s where s.IsBlackAfricanAmerican = 'Y' -- 03
			  union 
			  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.StateCode = '04') from LEGACYSPED.Student s where s.IsHispanic = 'Y' -- 04
			  union
			  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.StateCode = '05') from LEGACYSPED.Student s where s.IsWhite = 'Y' -- 05
			  union
			  select StudentRefID, RaceID = (select v.ID from EnumValue v where v.Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1 and v.StateCode = '06') from LEGACYSPED.Student s where s.IsHawaiianPacIslander = 'Y' -- 06
			  ) r join
		LEGACYSPED.MAP_StudentRefID s on r.StudentRefID = s.StudentRefID  left join
		dbo.StudentRace sr on s.DestID = sr.StudentID and r.RaceID = sr.RaceID 
		where sr.StudentID is null
	return 
	END
GO







