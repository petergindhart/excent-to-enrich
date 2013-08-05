IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GiftedProgramID') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.MAP_GiftedProgramID
GO

create table x_LEGACYGIFT.MAP_GiftedProgramID (
	DestID uniqueidentifier not null, 
	VariantID uniqueidentifier not null, 
	ConvertedEPID uniqueidentifier not null
)

insert x_LEGACYGIFT.MAP_GiftedProgramID values (
	'89D28523-577A-4CC7-AFC6-2BF571830637', -- Gifted Program
	'64FD6D61-01D5-4204-8483-9D5810F86BB4', -- VariantID
	'E4451105-E64F-4491-BFB1-85FA5F2C0588' -- Converted EP
)
go
