
-- Colorado
-- Moffat						copied from Boulder
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'MAP_PrgStatus_ConvertedEP')
drop table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP
go

-- there is no gifted program in Boulder right now....
create table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP (DestID uniqueidentifier not null)
-- insert x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900') -- should eventually coordinate with VC3 how the sequence should be coordinated.  
go

/*
declare @PrgStatusSeq int ;
select @PrgStatusSeq = sequence from PrgStatus where ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and DeletedDate is null and Name = 'Eligible'
If not exists (select 1 from PrgStatus where Name = 'Converted EP')
begin
	update PrgStatus set Sequence = Sequence+1 where ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and DeletedDate is null and Sequence > @PrgStatusSeq

	insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode, Description) 
	values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900', '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E', 3, convert(varchar(50), 'Converted EP'), 0, 0, '85AAB540-503F-4613-9F1F-A14C72764285', NULL, NULL)
end
*/
GO


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


-- since this will evidently always be different from district to district, create this view here with the hard-coded IDs
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.EPDatesPivot') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.EPDatesPivot
GO

create view x_LEGACYGIFT.EPDatesPivot
as
select 
	EPRefID = cast(NULL as varchar(150)), 
	DateValue = cast(NULL as datetime), 
	InputFieldID = cast(NULL as uniqueidentifier),
	InputItemType = cast(NULL as varchar(50)),
	InputItemTypeID = cast(NULL as uniqueidentifier)
go
if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GiftedConversionWrapUp')
drop procedure x_LEGACYGIFT.GiftedConversionWrapUp
go

create procedure x_LEGACYGIFT.GiftedConversionWrapUp
as
-- this should run for all districts in all states
-- update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

select Stat = 'Nothing to do in GiftedConversionWrapUp'


GO
