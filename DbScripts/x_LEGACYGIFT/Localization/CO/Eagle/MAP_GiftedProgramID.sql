IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.MAP_GiftedProgramID') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.MAP_GiftedProgramID
GO

create table x_LEGACYGIFT.MAP_GiftedProgramID (
	DestID uniqueidentifier not null, 
	VariantID uniqueidentifier not null, 
	ConvertedEPID uniqueidentifier not null
)
--insert x_LEGACYGIFT.MAP_GiftedProgramID values (
--	NULL, -- Gifted Program
--	NULL, -- VariantID
--	NULL -- Converted EP
--)
--go

/*

select * from Program
select * from PrgVariant where ProgramID = ''
select * from PrgItemDef where ProgramID = ''

*/
