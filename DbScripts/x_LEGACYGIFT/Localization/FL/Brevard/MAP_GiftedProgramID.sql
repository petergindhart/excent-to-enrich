IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GiftedProgramID') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.MAP_GiftedProgramID
GO

create table x_LEGACYGIFT.MAP_GiftedProgramID (
	DestID uniqueidentifier not null, 
	VariantID uniqueidentifier not null, 
	ConvertedEPID uniqueidentifier not null
)

insert x_LEGACYGIFT.MAP_GiftedProgramID values (
	'BBB09563-0211-488E-83C5-0C503B0951C3', -- Gifted Program
	'88ABC2D2-D21E-4C9B-AD32-3F1F34538266', -- VariantID
	'3961E0D4-9DD3-44E6-82D8-91345B4D2170' -- Converted EP
)
go
