IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GiftedProgramID') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.MAP_GiftedProgramID
GO

create table x_LEGACYGIFT.MAP_GiftedProgramID (DestID uniqueidentifier not null)
-- insert x_LEGACYGIFT.MAP_GiftedProgramID values ('2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E') -- this is a dummy record for Boulder.  No gifted here
go

