IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GiftedProgramID') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.MAP_GiftedProgramID
GO

create table x_LEGACYGIFT.MAP_GiftedProgramID (
	DestID uniqueidentifier not null, 
	VariantID uniqueidentifier not null, 
	ConvertedEPID uniqueidentifier not null
)

insert x_LEGACYGIFT.MAP_GiftedProgramID values (
	'3B19FAD7-22BF-47CC-8FA6-2E0464EB6DC6', -- Gifted Program
	'934E750F-F4D5-4435-AC29-C0ED29D8C48B', -- VariantID
	'698AB523-C815-4776-A0EA-4CF796A314A9' -- Converted EP
)
go
