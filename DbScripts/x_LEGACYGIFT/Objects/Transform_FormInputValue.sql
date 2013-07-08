
-- #############################################################################
-- FormInputValue
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_FormInputValueID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_FormInputValueID -- intervalID, inputFieldID
	(
	IntervalID	uniqueidentifier not null, -- since this depends on FormInstanceInterval, we are not going to put a legacy field in this map
	InputFieldID uniqueidentifier NOT NULL,
	DestID	uniqueidentifier not null
	)

ALTER TABLE x_LEGACYGIFT.MAP_FormInputValueID ADD CONSTRAINT
	PK_MAP_FormInputValueID PRIMARY KEY CLUSTERED
	(
	IntervalID, InputFieldID
	)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_FormInputValueID_DestID')
create index IX_x_LEGACYGIFT_MAP_FormInputValueID_DestID on x_LEGACYGIFT.MAP_FormInputValueID (DestID)
GO

------------ transform

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_FormInputValue') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_FormInputValue
GO

create view x_LEGACYGIFT.Transform_FormInputValue
as
select 
	IntervalID = i.FormInstanceIntervalID, 
	f.InputFieldID,
	m.DestID,
	Sequence = cast (0 as int) -- this is not for multi select values or repeatable input areas
from x_LEGACYGIFT.Transform_PrgSectionFormInstance i join 
x_LEGACYGIFT.FormInputValueFields f on i.TemplateID = f.FormTemplateID left join
x_LEGACYGIFT.MAP_FormInputValueID m on i.FormInstanceIntervalID = m.IntervalID and f.InputFieldID = m.InputFieldID left join 
FormInputValue v on m.DestID = v.Id
go
