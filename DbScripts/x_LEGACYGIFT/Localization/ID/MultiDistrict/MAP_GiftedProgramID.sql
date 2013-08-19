IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GiftedProgramID') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.MAP_GiftedProgramID
GO

create table x_LEGACYGIFT.MAP_GiftedProgramID (
	DestID uniqueidentifier not null, 
	VariantID uniqueidentifier not null, 
	ConvertedEPID uniqueidentifier not null
)

insert x_LEGACYGIFT.MAP_GiftedProgramID values (
	'AD9F855B-E054-46BF-ACA9-1884CBD6C8E1', -- Gifted Program
	'43E1AF01-0A27-41B3-90E1-D7322CE5CD37', -- VariantID
	'C74C9469-D583-43A9-A680-9D6EB697EB33' -- Converted EP
)
go
