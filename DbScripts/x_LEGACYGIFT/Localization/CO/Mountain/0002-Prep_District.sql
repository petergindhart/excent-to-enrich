
-- Colorado
-- Mountain
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'MAP_PrgStatus_ConvertedEP')
drop table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP
go

-- there is no gifted program in Mountain BOCES right now....
create table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP (DestID uniqueidentifier not null)
-- insert x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900') -- should eventually coordinate with VC3 how the sequence should be coordinated.  
go


-- ImportPrgSections
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.ImportPrgSections') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.ImportPrgSections
GO

CREATE TABLE x_LEGACYGIFT.ImportPrgSections (
Enabled	bit	not null,
Sequence	int	not null,
SectionType		varchar(100)	not null,
SectionDefID	uniqueidentifier not null,
FooterFormTemplateID	uniqueidentifier null,
HeaderFormTemplateID	uniqueidentifier null
)

ALTER TABLE x_LEGACYGIFT.ImportPrgSections
	ADD CONSTRAINT PK_ImportPrgSectionss PRIMARY KEY CLUSTERED
(
	SectionDefID
)
GO




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.FormInputValueFields') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.FormInputValueFields
GO

create table x_LEGACYGIFT.FormInputValueFields (
FormTemplateID	uniqueidentifier	not null,
InputFieldID	uniqueidentifier	not null
)


ALTER TABLE x_LEGACYGIFT.FormInputValueFields
	ADD CONSTRAINT PK_FormInputValueFields PRIMARY KEY CLUSTERED
(
	InputFieldID
)

create index IX_x_LEGACYGIFT_FormInputValueFields_FormTemplateID on x_LEGACYGIFT.FormInputValueFields (FormTemplateID)
GO




