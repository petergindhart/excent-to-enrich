
set nocount off;
begin tran
insert LEGACYSPED.MAP_PrgSectionID 
select DefID, VersionID, newid() from (
-- PrgSection
SELECT
	DestID = case when d.IsVersioned = 1 then s.DestID else nvm.DestID end, -- when versioned, use the version map, when non-versioned use that map
	ItemID = i.DestID,
	DefID = d.ID,
	VersionID = CASE WHEN d.IsVersioned = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
	FormInstanceID = case when d.ID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' then tsvc.FormInstanceID else NULL end,
	HeaderFormInstanceID =  CAST (NULL as UNIQUEIDENTIFIER),
	OnLatestVersion = cast(1 as bit),
	i.DoNotTouch
FROM
	LEGACYSPED.Transform_PrgIep i CROSS JOIN
	PrgSectionDef d JOIN
	PrgSectionType t on d.TypeID = t.ID JOIN
	LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 0 LEFT JOIN
	LEGACYSPED.MAP_PrgSectionID s ON
		isnull(s.VersionID,'00000000-0000-0000-0000-000000000000') = isnull(i.VersionDestID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') AND
		s.DefID = d.ID LEFT JOIN
	LEGACYSPED.MAP_PrgSectionID_NonVersioned nvm ON
		nvm.ItemID = i.DestID AND
		nvm.DefID = d.ID left join 
	LEGACYSPED.Transform_IepServices tsvc on i.DestID = tsvc.ItemID
) t 
-- (1442 row(s) affected)

-- select * from PrgSection 
insert PrgSection (ID, DefID, ItemID, VersionID, OnLatestVersion)
SELECT
	DestID = case when d.IsVersioned = 1 then s.DestID else nvm.DestID end, -- when versioned, use the version map, when non-versioned use that map
	DefID = d.ID,
	ItemID = i.DestID,
	VersionID = CASE WHEN d.IsVersioned = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
	--FormInstanceID = case when d.ID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' then tsvc.FormInstanceID else NULL end,
	--HeaderFormInstanceID =  CAST (NULL as UNIQUEIDENTIFIER),
	OnLatestVersion = cast(1 as bit)
	--,	i.DoNotTouch
FROM
	LEGACYSPED.Transform_PrgIep i CROSS JOIN
	PrgSectionDef d JOIN
	PrgSectionType t on d.TypeID = t.ID JOIN
	LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 0 LEFT JOIN
	LEGACYSPED.MAP_PrgSectionID s ON
		isnull(s.VersionID,'00000000-0000-0000-0000-000000000000') = isnull(i.VersionDestID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') AND
		s.DefID = d.ID LEFT JOIN
	LEGACYSPED.MAP_PrgSectionID_NonVersioned nvm ON
		nvm.ItemID = i.DestID AND
		nvm.DefID = d.ID left join 
	LEGACYSPED.Transform_IepServices tsvc on i.DestID = tsvc.ItemID
--




--select * from PrgGoals
--LEGACYSPED.Transform_PrgGoals
--AS
insert PrgGoals (ID, ReportFrequencyID, UseProgressReporting)
SELECT
--	iep.IepRefId,
	DestID = sec.ID,
	ReportFrequencyID = isnull(pf.ID, 'A3FF9417-0899-42BE-8090-D1855D50612F'), -- if PrgGoals.ReportFrequencyID exists, we MUST keep it
	UseProgressReporting = cast (1 as BIT)
	--,
	--iep.DoNotTouch
FROM
LEGACYSPED.Transform_PrgIep iep JOIN -- 10721
PrgSection sec ON
	sec.VersionID = iep.VersionDestID AND -- our map of PrgSection is using ItemID instead of VersionID.  Does that matter?
	sec.DefID = '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A' left join --IEP Goals
dbo.School h on iep.SchoolID = h.ID left join
LEGACYSPED.SchoolProgressFrequency sf on h.Number = sf.SchoolCode left join 
PrgGoalProgressFreq pf on sf.FrequencyName = pf.Name 
GO


--select * from IepServices
--LEGACYSPED.Transform_IepServices
--AS
insert IepServices (ID, DeliveryStatement)
SELECT
	--IEP.IepRefId,
	m.DestID,
	DeliveryStatement = iep.ServiceDeliveryStatement
FROM
	LEGACYSPED.Transform_PrgIep iep JOIN 
	LEGACYSPED.MAP_PrgSectionID m on 
		m.DefID = '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F' and 
		m.VersionID = iep.VersionDestID left join 
	LEGACYSPED.MAP_FormInstance_Services mfi on iep.IepRefID = mfi.IEPRefID left join 
	LEGACYSPED.MAP_FormInstanceInterval_Services mfii on iep.IepRefID = mfii.IepRefID left join 
	LEGACYSPED.MAP_FormInputValue_Services mfiv on iep.IepRefID = mfiv.IepRefID 
WHERE iep.DoNotTouch = 0
GO
--











------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ forms insert
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------         OBJECTS           ---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------



IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_DATATEAM.MAP_FormInstanceID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_DATATEAM.MAP_FormInstanceID
	(
	IEPRefID nvarchar(150) NOT NULL,
	SectionDefID	uniqueidentifier	not null,
	FormInstanceID uniqueidentifier NOT NULL
	)

ALTER TABLE x_DATATEAM.MAP_FormInstanceID ADD CONSTRAINT
	PK_MAP_FormInstanceID PRIMARY KEY CLUSTERED
	(
	IEPRefID, SectionDefID
	)
END


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_DATATEAM.MAP_FormInstanceIntervalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_DATATEAM.MAP_FormInstanceIntervalID -- drop table x_DATATEAM.MAP_FormInstanceIntervalID
	(
	IEPRefID nvarchar(150) NOT NULL,
	SectionDefID	uniqueidentifier not null,
	FormInstanceIntervalID uniqueidentifier NOT NULL
	)

ALTER TABLE x_DATATEAM.MAP_FormInstanceIntervalID ADD CONSTRAINT
	PK_MAP_FormInstanceIntervalID PRIMARY KEY CLUSTERED
	(
	IEPRefID, SectionDefID
	)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_DATATEAM_MAP_FormInstanceIntervalID_FormInstanceIntervalID')
create index IX_x_DATATEAM_MAP_FormInstanceIntervalID_FormInstanceIntervalID on x_DATATEAM.MAP_FormInstanceIntervalID (FormInstanceIntervalID)
GO


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_DATATEAM.MAP_FormInputValueID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_DATATEAM.MAP_FormInputValueID -- intervalID, inputFieldID
	(
	IntervalID	uniqueidentifier not null, -- since this depends on FormInstanceInterval, we are not going to put a legacy field in this map
	InputFieldID uniqueidentifier NOT NULL,
	DestID	uniqueidentifier not null
	)

ALTER TABLE x_DATATEAM.MAP_FormInputValueID ADD CONSTRAINT
	PK_MAP_FormInputValueID PRIMARY KEY CLUSTERED
	(
	IntervalID, InputFieldID
	)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_DATATEAM_MAP_FormInputValueID_DestID')
create index IX_x_DATATEAM_MAP_FormInputValueID_DestID on x_DATATEAM.MAP_FormInputValueID (DestID)
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Transform_PrgSectionFormInstance') AND type in (N'V'))
drop view x_DATATEAM.Transform_PrgSectionFormInstance
go

create view x_DATATEAM.Transform_PrgSectionFormInstance
AS
with CTE_Formlets
as (
	select 
		iep.IEPRefID,
		ItemID = iep.DestID,
		-- sd.IsVersioned, -- is this needed?  
		sec.FormPlace,
		sec.SectionDefID,
	-- FormInstance
		mfi.FormInstanceID, -- DestID / FormInstanceID
		sec.TemplateID,
	-- PrgItemForm 
		CreatedDate = GETDATE(),
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		AssociationTypeID = 'DE0AFD97-84C8-488E-94DC-E17CAAA62082', -- Section
	-- FormInstanceInterval 
		mfii.FormInstanceIntervalID,
		-- InstanceID = FormInstanceID (above)
		IntervalID = 'FBE8314C-E0A0-4C5A-9361-7201081BD47D', -- Value (should this be hard-coded?)
		CompletedDate = GETDATE(),
		CompletedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB' -- BuiltIn: Support
	FROM 
		LEGACYSPED.Transform_PrgIep iep JOIN 
		dbo.PrgSectionDef sd on iep.DefID = sd.ItemDefID and not (sd.FormTemplateID is null and sd.HeaderFormTemplateID is null) join (
			select FormPlace = 'Footer', SectionDefID = d.ID, TemplateID = d.FormTemplateID from PrgSectionDef d where d.FormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- select * from prgitemdef where name like '%conver%'
			union all 
			select FormPlace = 'Header', SectionDefID = d.ID, TemplateID = d.HeaderFormTemplateID from PrgSectionDef d where d.HeaderFormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
			) sec on sd.ID = sec.SectionDefID left join
		x_DATATEAM.MAP_FormInstanceID mfi on iep.IEPRefID = mfi.IEPRefID and sd.id = mfi.SectionDefID left join 
		x_DATATEAM.MAP_FormInstanceIntervalID mfii on iep.IEPRefID = mfii.IEPRefID and sd.ID = mfii.SectionDefID -- select * from x_DATATEAM.MAP_FormInstanceIntervalID
	) 
select 
	Template = fft.Name, 
	c.* 
from CTE_Formlets c left join dbo.FormTemplate fft on c.TemplateID = fft.Id 
go


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.FormInputValueFields') AND type in (N'U'))
DROP TABLE x_DATATEAM.FormInputValueFields
GO

create table x_DATATEAM.FormInputValueFields (
FormTemplateID	uniqueidentifier	not null,
InputFieldID	uniqueidentifier	not null
)


ALTER TABLE x_DATATEAM.FormInputValueFields
	ADD CONSTRAINT PK_FormInputValueFields PRIMARY KEY CLUSTERED
(
	InputFieldID
)

create index IX_x_DATATEAM_FormInputValueFields_FormTemplateID on x_DATATEAM.FormInputValueFields (FormTemplateID)
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_DATATEAM.Transform_FormInputValue') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_DATATEAM.Transform_FormInputValue
GO

create view x_DATATEAM.Transform_FormInputValue
as
select 
	IntervalID = i.FormInstanceIntervalID, 
	f.InputFieldID,
	m.DestID,
	Sequence = cast (0 as int) -- this is not for multi select values or repeatable input areas
from x_DATATEAM.Transform_PrgSectionFormInstance i join 
x_DATATEAM.FormInputValueFields f on i.TemplateID = f.FormTemplateID left join
x_DATATEAM.MAP_FormInputValueID m on i.FormInstanceIntervalID = m.IntervalID and f.InputFieldID = m.InputFieldID left join 
FormInputValue v on m.DestID = v.Id
go




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Tranform_FormInputValueMaster') AND type in (N'V'))
drop view x_DATATEAM.Tranform_FormInputValueMaster
go

create view x_DATATEAM.Tranform_FormInputValueMaster
as
select f.IEPRefID, 
	v.FormTemplateID,
	v.InputFieldID,
	ftii.Sequence, 
	ftii.Code, 
	ftii.Label, 
	InputItemType = iit.Name, 
	f.FormInstanceID, 
	mv.DestID
	-- select f.Template, f.ItemID, f.SectionDefID, v.*, ftii.Code, ftii.Label, ftii.Sequence, iit.Name
from x_DATATEAM.Transform_PrgSectionFormInstance f join 
	x_DATATEAM.FormInputValueFields v on f.TemplateID = v.FormTemplateID join
	dbo.FormTemplateInputItem ftii on v.InputFieldID = ftii.Id join 
	dbo.FormTemplateInputItemType iit on ftii.TypeId = iit.Id left join 
	x_DATATEAM.MAP_FormInputValueID mv on v.InputFieldID = mv.InputFieldID and f.FormInstanceIntervalID = mv.IntervalID left join 
	dbo.FormInputTextValue tv on mv.DestID = tv.Id
go
-- 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Transform_FormInputTextValue') AND type in (N'V'))
drop view x_DATATEAM.Transform_FormInputTextValue
go

create view x_DATATEAM.Transform_FormInputTextValue
as
select DestID, Value = cast(NULL as varchar(max))
from x_DATATEAM.Tranform_FormInputValueMaster
where InputItemType = 'Text'
go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Transform_FormInputFlagValue') AND type in (N'V'))
drop view x_DATATEAM.Transform_FormInputFlagValue
go

create view x_DATATEAM.Transform_FormInputFlagValue
as
select DestID, Value = cast(NULL as bit)
from x_DATATEAM.Tranform_FormInputValueMaster
where InputItemType = 'Flag'
go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Transform_FormInputSingleSelectValue') AND type in (N'V'))
drop view x_DATATEAM.Transform_FormInputSingleSelectValue
go

create view x_DATATEAM.Transform_FormInputSingleSelectValue
as
select DestID, Value = cast(NULL as uniqueidentifier)
from x_DATATEAM.Tranform_FormInputValueMaster
where InputItemType = 'SingleSelect'
go


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Transform_FormInputUserValue') AND type in (N'V'))
drop view x_DATATEAM.Transform_FormInputUserValue
go

create view x_DATATEAM.Transform_FormInputUserValue
as
select DestID, Value = cast(NULL as uniqueidentifier)
from x_DATATEAM.Tranform_FormInputValueMaster
where InputItemType = 'User'
go


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.Transform_FormInputDateValue') AND type in (N'V'))
drop view x_DATATEAM.Transform_FormInputDateValue
go

create view x_DATATEAM.Transform_FormInputDateValue
as
select DestID, Value = cast(NULL as Datetime)
from x_DATATEAM.Tranform_FormInputValueMaster
where InputItemType = 'Date'
go


-- select * from x_DATATEAM.Transform_PrgSectionFormInstance


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_DATATEAM.Transform_PrgSection') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_DATATEAM.Transform_PrgSection
GO

CREATE VIEW x_DATATEAM.Transform_PrgSection
AS
	SELECT
		DestID = case when d.IsVersioned = 1 then s.DestID else nvm.DestID end, -- when versioned, use the version map, when non-versioned use that map
		DefID = d.ID,
		ItemID = i.DestID,
		VersionID = CASE WHEN d.IsVersioned = 1 THEN i.VersionDestID ELSE CAST(NULL as uniqueidentifier) END,
		FormInstanceID = fs.FormInstanceID,
		HeaderFormInstanceID =  hs.FormInstanceID,
		OnLatestVersion = cast(1 as bit),
		i.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep i CROSS JOIN
		PrgSectionDef d JOIN
--		PrgSectionType t on d.TypeID = t.ID JOIN
		(select SectionDefID = sd.ID from PrgSectionDef sd where sd.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3') p on d.id = p.SectionDefID LEFT JOIN 
-- 		LEGACYSPED.ImportPrgSections p on d.ID = p.SectionDefID and p.Enabled = 1 LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID s ON
			isnull(s.VersionID,'00000000-0000-0000-0000-000000000000') = isnull(i.VersionDestID,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') AND
			s.DefID = d.ID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID_NonVersioned nvm ON
			nvm.ItemID = i.DestID AND
			nvm.DefID = d.ID left join 
		x_DATATEAM.Transform_PrgSectionFormInstance fs on i.DestID = fs.ItemID and p.SectionDefID = fs.SectionDefID and fs.FormPlace = 'Footer' left join
		x_DATATEAM.Transform_PrgSectionFormInstance hs on i.DestID = hs.ItemID and p.SectionDefID = hs.SectionDefID and hs.FormPlace = 'Header' 
GO

-- select * from x_DATATEAM.Transform_PrgSectionFormInstance where FormPlace = 'Footer'


------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------         INSERTS           ---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


-- select * from VC3ETL.LoadTable where SourceTable like 'x_LEGACYGIFT%' order by Sequence



insert x_DATATEAM.FormInputValueFields
select ftl.TemplateID, ftii.ID
-- select ft.Name, ftii.InputAreaID, ftc.IsRepeatable, ftii.Sequence, ftii.Label, ftl.TemplateID, FormTemplateInputItemID = ftii.ID, insertline = 'insert x_DATATEAM.FormInputValueFields values ('''+convert(varchar(36), ftl.TemplateID)+''', '''+convert(varchar(36), ftii.ID)+''') -- '+ftii.Label+''
from dbo.FormTemplate ft 
join dbo.FormTemplateLayout ftl on ft.ID = ftl.TemplateID
join dbo.FormTemplateControl ftc on ftl.ControlID = ftc.ID
join dbo.FormTemplateControlType ftct on ftc.TypeID = ftct.ID
join dbo.FormTemplateInputItem ftii on ftc.ID = ftii.InputAreaID 
join (
	select TemplateID = d.FormTemplateID from PrgSectionDef d where d.FormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- select * from prgitemdef where name like '%conver%'
	union all 
	select TemplateID = d.HeaderFormTemplateID from PrgSectionDef d where d.HeaderFormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
	) s on ftl.TemplateID = s.TemplateID
where ftct.Name = 'Input Area'
and ftii.ID not in (select InputFieldID from x_DATATEAM.FormInputValueFields)
order by ft.Name, ftii.Sequence



-- select * from x_DATATEAM.MAP_FormInstanceID
insert x_DATATEAM.MAP_FormInstanceID (IEPRefID, SectionDefID, FormInstanceID)
select s.IEPRefID, s.SectionDefID, FormInstanceID = newid() from x_DATATEAM.Transform_PrgSectionFormInstance s left join x_DATATEAM.MAP_FormInstanceID d on s.IEPRefID = d.IEPRefID and s.SectionDefID = d.SectionDefID where d.IEPRefID is null
go

-- select * from FormInstance
insert FormInstance (Id, TemplateId)
select s.FormInstanceID, s.TemplateID from x_DATATEAM.Transform_PrgSectionFormInstance s left join FormInstance d on s.FormInstanceID = d.Id where d.Id is null

-- select * from prgitemForm
insert PrgItemForm (ID, ItemID, CreatedDate, CreatedBy, AssociationTypeID)
select s.FormInstanceID, s.ItemID, s.CreatedDate, s.CreatedBy, s.AssociationTypeID from x_DATATEAM.Transform_PrgSectionFormInstance s left join PrgItemForm d on s.FormInstanceID = d.ID where d.id is null

-- select * from x_DATATEAM.MAP_FormInstanceIntervalID 
insert x_DATATEAM.MAP_FormInstanceIntervalID (IEPRefID, SectionDefID, FormInstanceIntervalID)
select s.IEPRefID, s.SectionDefID, FormInstanceIntervalID = newID() from x_DATATEAM.Transform_PrgSectionFormInstance s left join x_DATATEAM.MAP_FormInstanceIntervalID d on s.IEPRefID = d.IEPRefID and s.SectionDefID = d.SectionDefID where d.IEPRefID is null

-- select * from FormInstanceInterval
insert FormInstanceInterval (ID, InstanceId, IntervalId) -- try w/o completed date, completed by
select s.FormInstanceIntervalID, s.FormInstanceID, s.IntervalID from x_DATATEAM.Transform_PrgSectionFormInstance s left join FormInstanceInterval d on s.FormInstanceIntervalID = d.Id where d.id is null


-- select * from x_DATATEAM.MAP_FormInputValueID
insert x_DATATEAM.MAP_FormInputValueID (IntervalID, InputFieldID, DestID)
select s.IntervalID, s.InputFieldID, DestOD = newid() from x_DATATEAM.Transform_FormInputValue s left join x_DATATEAM.MAP_FormInputValueID d on s.IntervalID = d.IntervalID and s.InputFieldID = d.InputFieldID where d.DestID is null


insert ForminputValue (ID, IntervalId, InputFieldId, Sequence)
select s.DestID, s.IntervalId, s.InputFieldId, s.Sequence from x_DATATEAM.Transform_FormInputValue s left join ForminputValue d on s.DestID = d.Id where d.id is null

insert FormInputTextValue
select s.* from x_DATATEAM.Transform_FormInputTextValue s left join FormInputTextValue d on s.DestID = d.Id where d.id is null

insert FormInputFlagValue
select s.* from x_DATATEAM.Transform_FormInputFlagValue s left join FormInputFlagValue d on s.DestID = d.Id where d.id is null

insert FormInputSingleSelectValue
select s.* from x_DATATEAM.Transform_FormInputSingleSelectValue s left join FormInputSingleSelectValue d on s.DestID = d.Id where d.id is null

insert FormInputUserValue
select s.* from x_DATATEAM.Transform_FormInputUserValue s left join FormInputUserValue d on s.DestID = d.Id where d.id is null

insert FormInputDateValue
select s.* from x_DATATEAM.Transform_FormInputDateValue s left join FormInputDateValue d on s.DestID = d.Id where d.id is null


declare @x_DATATEAM_Transform_PrgSection table ( ------------------- doing this for speed
DestID	uniqueidentifier not null primary key,
DefID	uniqueidentifier	NOT NULL,
ItemID	uniqueidentifier,
VersionID	uniqueidentifier,
FormInstanceID	uniqueidentifier,
HeaderFormInstanceID	uniqueidentifier,
OnLatestVersion	bit,
DoNotTouch	bigint
)

insert @x_DATATEAM_Transform_PrgSection
select s.* from x_DATATEAM.Transform_PrgSection s where DestID is not null

update d set HeaderFormInstanceID = s.HeaderFormInstanceID
-- select s.*
from @x_DATATEAM_Transform_PrgSection s 
left join PrgSection d on s.DestID = d.id
where d.id is not null and s.HeaderFormInstanceID is not null -- only have headers in this case.  taking a shortcut

insert LEGACYSPED.MAP_PrgSectionID 
select DefID, VersionID, newid() from x_DATATEAM.Transform_PrgSection where DestID is null -- shortcut, rather than left join to dest table

insert PrgSection (ID, DefID, ItemID, VersionID, FormInstanceID, HeaderFormInstanceID, OnLatestVersion)
select s.DestID, s.DefID, s.ItemID, s.VersionID, s.ForminstanceID, s.HeaderFormInstanceID, s.OnLatestVersion  from x_DATATEAM.Transform_PrgSection s left join PrgSection d on s.DestID = d.id where d.id is null

go









rollback

commit















----select * from prgitemdef where name like '%convert%'

--select ips.Enabled, st.name, sd.* 
--from PrgSectionDef sd 
--join PrgSectionType st on sd.TypeID = st.ID
--left join LEGACYSPED.ImportPrgSections ips on sd.id = ips.SectionDefID
--where sd.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
--order by Sequence

--exec x_DATATEAM.FormletViewBuilder '8F403A0B-0336-46BC-96F3-136DFB742A71', 1, 'Accommodations
--Modifications
--NeedAccommodations
--NeedModifications'

--select * from VC3ETL.LoadTable where SourceTable like 'x_LEGACYGIFT%' order by Sequence






















--x_DATATEAM.findGUID '1BBED70B-5FD3-479B-A54E-0A3C7D459313'


--select * from x_DATATEAM.FormInputValueFields where InputFieldID = '1BBED70B-5FD3-479B-A54E-0A3C7D459313'
--select * from dbo.FormInputValue where InputFieldId = '1BBED70B-5FD3-479B-A54E-0A3C7D459313'
--select * from dbo.FormTemplateInputItem where Id = '1BBED70B-5FD3-479B-A54E-0A3C7D459313'

--x_DATATEAM.findGUID '7F437BDE-91CE-4304-AD03-0CB2097CE62A'
--select * from dbo.FormTemplateInputItemType where Id = '7F437BDE-91CE-4304-AD03-0CB2097CE62A' -- user
---- select * from dbo.FormTemplateInputItem where TypeId = '7F437BDE-91CE-4304-AD03-0CB2097CE62A'

--select * 
--from x_DATATEAM.FormInputValueFields 


-- select * from VC3ETL.LoadTable where SourceTable like 'x_LEGACYGIFT%' order by Sequence

--select * from FormTemplate where ID in ('427C86E1-AB95-482A-B8A5-9801F309481A', 'BA493AA8-B4CC-4B94-894D-39E25CF7F5D3', '29693CB4-F504-4E8D-9412-D2BACFBC5104', '355EA8B0-BE09-4BFB-9B52-9BF51A30173E')



	--select TemplateID = d.FormTemplateID from PrgSectionDef d where d.FormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- select * from prgitemdef where name like '%conver%'
	--union all 
	--select TemplateID = d.HeaderFormTemplateID from PrgSectionDef d where d.HeaderFormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

-- 8F403A0B-0336-46BC-96F3-136DFB742A71
-- 427C86E1-AB95-482A-B8A5-9801F309481A
-- BA493AA8-B4CC-4B94-894D-39E25CF7F5D3
-- 29693CB4-F504-4E8D-9412-D2BACFBC5104
-- 355EA8B0-BE09-4BFB-9B52-9BF51A30173E




-- select * from FormInputTextValue
-- select * from FormInputSingleSelectValue
-- select * from FormInputFlagValue
-- select * from FormInputUserValue




----create view x_LEGACYGIFT.EPPresentLevelsPivot
----as
--select u.*, InputItemType =  iit.Name, InputItemTypeID = iit.ID
--from (
--	select PresentLevelType = 'pl1Contribute', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '4F8DA6FB-9CF6-4056-9D06-534A675E7380' -- pl1Contribute 
--	union all
--	select PresentLevelType = 'pl2Strengths', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '2E21A087-BDA2-435E-8D70-2701D27C9C96' -- pl2Strengths 
--	union all
--	select PresentLevelType = 'pl3Beyond', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '019D9A47-60B0-405C-B585-7C0616F18FAA' -- pl3Beyond 
--	union all
--	select PresentLevelType = 'pl4Results', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '33A9E439-CD8C-4E3C-B334-9F8B37185695' -- pl4Results
--	union all
--	select PresentLevelType = 'pl5Language', PresentLevel = cast(NULL as varchar(max)), InputFieldID = '04E73B63-654F-4B20-88A1-BFF9D214E9F5' -- pl5Language 
--	) u join
--FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join
--FormTemplateInputItemType iit on ftii.TypeId = iit.Id
--go




--select * from VC3ETL.LoadTable where SourceTable like 'x_LEGACYGIFT%' order by Sequence

---- create view x_DATATEAM.Transform_FormInput_EP_Present_Levels_Text
----as




--select InputItemType = ftiit.name, Template = ft.name, InputItemCode = ftii.Code, Inputitemlabel = ftii.Label, ftii.Sequence, ftl.TemplateId, InputFieldID = ftii.ID, 
--	FlagNULL = cast(NULL as bit), 
--	TextNULL = cast(NULL as varchar(max)),
--	UserNULL = cast(NULL as uniqueidentifier),
--	SingleSelectNULL = cast(NULL as uniqueidentifier)
--from FormTemplate ft
--join FormTemplateLayout ftl on ft.Id = ftl.TemplateId
--join FormTemplateControl ftc on ftl.ControlId = ftc.Id -- and ftc.TypeId = 'DB9713CF-24D9-4097-9E00-757E8630B14A' -- input area (join to ftii makes this unnecessary?
--join FormTemplateInputItem ftii on ftl.ControlId = ftii.InputAreaId
--join FormTemplateInputItemType ftiit on ftii.TypeId = ftiit.Id
--join (
--	select TemplateID = d.FormTemplateID from PrgSectionDef d where d.FormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' -- select * from prgitemdef where name like '%conver%'
--	union all 
--	select TemplateID = d.HeaderFormTemplateID from PrgSectionDef d where d.HeaderFormTemplateID is not null and d.ItemDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
--	) t on ft.Id = t.TemplateID
--order by template, ftii.Sequence







--x_DATATEAM.FindGUID 'D1F9D037-CE38-42EE-9056-2BC5378F2065'

--select * from dbo.FormTemplateControl where Id = 'D1F9D037-CE38-42EE-9056-2BC5378F2065'
--select * from dbo.FormTemplateControlProperty where ControlId = 'D1F9D037-CE38-42EE-9056-2BC5378F2065'
--select * from dbo.FormTemplateInputItem where InputAreaId = 'D1F9D037-CE38-42EE-9056-2BC5378F2065'
--select * from dbo.FormTemplateLayout where ControlId = 'D1F9D037-CE38-42EE-9056-2BC5378F2065'









--exec x_DATATEAM.FormletViewBuilder '427C86E1-AB95-482A-B8A5-9801F309481A', 1, 'Provider
--StuSer'
--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'x_FormletView' and o.name = 'IEP_Section_13_Services')
--drop view x_FormletView.IEP_Section_13_Services
--go

--create view x_FormletView.IEP_Section_13_Services
--as
--select
--	ItemID = itm.ID,
--	i.InstanceID,
--	StudentID = stu.ID,
--	stu.Number,
--	StudentFirstname = stu.Firstname,
--	StudentLastname = stu.Lastname,
--	--

--	Provider = lft_0_0.Firstname+' '+lft_0_0.Lastname,
--	StuSer = vv_2_0.Value

--from
--	Student stu JOIN
--	PrgItem itm on stu.ID = itm.StudentID JOIN
--	PrgItemDef id on itm.DefID = id.ID JOIN
--	PrgItemForm f on f.ItemID = itm.ID JOIN
--	FormInstanceInterval i on i.InstanceId = f.ID JOIN
	
--	--	Primary Service Provider     < Provider >    (User)
--	FormInputValue v_0_0 on
--		v_0_0.InputFieldId = '1BBED70B-5FD3-479B-A54E-0A3C7D459313' AND
--		v_0_0.Intervalid = i.ID JOIN
--	FormInputUserValue vv_0_0 on vv_0_0.ID = v_0_0.ID JOIN

--	--	Statement of types and anticipated location of services to be provided to and on behalf of the student:     < StuSer >    (Text)
--	FormInputValue v_2_0 on
--		v_2_0.InputFieldId = '49DCF86E-FE6C-47DC-A8FD-D561FA564148' AND
--		v_2_0.Intervalid = i.ID JOIN
--	FormInputTextValue vv_2_0 on vv_2_0.ID = v_2_0.ID LEFT JOIN

--	--### LEFT join actual value tables where needed ###

--	Person lft_0_0 on vv_0_0.ValueID = lft_0_0.ID
--go


--exec x_DATATEAM.FormletViewBuilder 'BA493AA8-B4CC-4B94-894D-39E25CF7F5D3', 1, 'PlaceDesc
--PlacementOpts
--SelectedOpt'
--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'x_FormletView' and o.name = 'IEP_Section_14_LRE_Options')
--drop view x_FormletView.IEP_Section_14_LRE_Options
--go

--create view x_FormletView.IEP_Section_14_LRE_Options
--as
--select
--	ItemID = itm.ID,
--	i.InstanceID,
--	StudentID = stu.ID,
--	stu.Number,
--	StudentFirstname = stu.Firstname,
--	StudentLastname = stu.Lastname,
--	--

--	PlaceDesc = vv_0_0.Value,
--	PlacementOpts = lft_0_1.Label,
--	SelectedOpt = vv_0_2.Value

--from
--	Student stu JOIN
--	PrgItem itm on stu.ID = itm.StudentID JOIN
--	PrgItemDef id on itm.DefID = id.ID JOIN
--	PrgItemForm f on f.ItemID = itm.ID JOIN
--	FormInstanceInterval i on i.InstanceId = f.ID JOIN
	
--	--	Document the discussion regarding each placement option considered, including any advantages or potential harmful effects on the student or on the quality of services needed.     < PlaceDesc >    (Text)
--	FormInputValue v_0_0 on
--		v_0_0.InputFieldId = 'A0FDED97-C0DD-49A0-9C08-45147D3A96BF' AND
--		v_0_0.Intervalid = i.ID JOIN
--	FormInputTextValue vv_0_0 on vv_0_0.ID = v_0_0.ID JOIN

--	--	Placement Options Considered     < PlacementOpts >    (SingleSelect)
--	FormInputValue v_0_1 on
--		v_0_1.InputFieldId = '7E4403A0-F3C5-4B6B-8AE0-A5C259A784F5' AND
--		v_0_1.Intervalid = i.ID JOIN
--	FormInputSingleSelectValue vv_0_1 on vv_0_1.ID = v_0_1.ID JOIN

--	--	Was this option selected?     < SelectedOpt >    (Flag)
--	FormInputValue v_0_2 on
--		v_0_2.InputFieldId = 'CAEBDB76-BC6E-488C-84E2-A142384393A5' AND
--		v_0_2.Intervalid = i.ID JOIN
--	FormInputFlagValue vv_0_2 on vv_0_2.ID = v_0_2.ID LEFT JOIN

--	--### LEFT join actual value tables where needed ###

--	FormTemplateInputSelectFieldOption lft_0_1 on vv_0_1.SelectedOptionID = lft_0_1.ID
--go


--exec x_DATATEAM.FormletViewBuilder '29693CB4-F504-4E8D-9412-D2BACFBC5104', 1, 'LongTimeToRelearn
--PredFactors
--SevereRegression'

--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'x_FormletView' and o.name = 'ESY_Criteria')
--drop view x_FormletView.ESY_Criteria
--go

--create view x_FormletView.ESY_Criteria
--as
--select
--	ItemID = itm.ID,
--	i.InstanceID,
--	StudentID = stu.ID,
--	stu.Number,
--	StudentFirstname = stu.Firstname,
--	StudentLastname = stu.Lastname,
--	--

--	LongTimeToRelearn = vv_1_0.Value,
--	PredFactors = vv_1_1.Value,
--	SevereRegression = vv_1_2.Value

--from
--	Student stu JOIN
--	PrgItem itm on stu.ID = itm.StudentID JOIN
--	PrgItemDef id on itm.DefID = id.ID JOIN
--	PrgItemForm f on f.ItemID = itm.ID JOIN
--	FormInstanceInterval i on i.InstanceId = f.ID JOIN

--	--	Did the student require an unreasonably long period of time to relearn previously learned skills?     < LongTimeToRelearn >    (Flag)
--	FormInputValue v_1_0 on
--		v_1_0.InputFieldId = '43BF1316-68BE-42B9-86B6-D07605B429D7' AND
--		v_1_0.Intervalid = i.ID JOIN
--	FormInputFlagValue vv_1_0 on vv_1_0.ID = v_1_0.ID JOIN

--	--	Do predictive factors indicate the need for ESY services?     < PredFactors >    (Flag)
--	FormInputValue v_1_1 on
--		v_1_1.InputFieldId = '86837E42-8A2A-48E4-885E-09AF01177258' AND
--		v_1_1.Intervalid = i.ID JOIN
--	FormInputFlagValue vv_1_1 on vv_1_1.ID = v_1_1.ID JOIN

--	--	Did the student experience severe regression on his/her IEP goals and objectives?     < SevereRegression >    (Flag)
--	FormInputValue v_1_2 on
--		v_1_2.InputFieldId = 'F4E1EF47-11E3-4571-AD64-764271DBBFC2' AND
--		v_1_2.Intervalid = i.ID JOIN
--	FormInputFlagValue vv_1_2 on vv_1_2.ID = v_1_2.ID

 
--go

--exec x_DATATEAM.FormletViewBuilder '355EA8B0-BE09-4BFB-9B52-9BF51A30173E', 1, 'StuProgress'

--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'x_FormletView' and o.name = 'Progress_Reporting')
--drop view x_FormletView.Progress_Reporting
--go

--create view x_FormletView.Progress_Reporting
--as
--select
--	ItemID = itm.ID,
--	i.InstanceID,
--	StudentID = stu.ID,
--	stu.Number,
--	StudentFirstname = stu.Firstname,
--	StudentLastname = stu.Lastname,
--	--

--	StuProgress = vv_0_0.Value

--from
--	Student stu JOIN
--	PrgItem itm on stu.ID = itm.StudentID JOIN
--	PrgItemDef id on itm.DefID = id.ID JOIN
--	PrgItemForm f on f.ItemID = itm.ID JOIN
--	FormInstanceInterval i on i.InstanceId = f.ID JOIN
	
--	--	Progress Report (Describe how parents will be informed of the student's progress towards goals and how frequently this will occur.)     < StuProgress >    (Text)
--	FormInputValue v_0_0 on
--		v_0_0.InputFieldId = '2A07547E-922E-4285-9B54-19C534A0C960' AND
--		v_0_0.Intervalid = i.ID JOIN
--	FormInputTextValue vv_0_0 on vv_0_0.ID = v_0_0.ID

 
--go



--exec x_DATATEAM.FormletViewBuilder '8F403A0B-0336-46BC-96F3-136DFB742A71', 0

--if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = 'x_FormletView' and o.name = 'Accommodations_and_Modifications')
--drop view x_FormletView.Accommodations_and_Modifications
--go

--create view x_FormletView.Accommodations_and_Modifications
--as
--select
--	ItemID = itm.ID,
--	i.InstanceID,
--	StudentID = stu.ID,
--	stu.Number,
--	StudentFirstname = stu.Firstname,
--	StudentLastname = stu.Lastname,
--	--

--	Modifications = vv_0_0.Value,
--	NeedModifications = vv_0_1.Value,
--	Accommodations = vv_2_0.Value,
--	NeedAccommodations = vv_2_1.Value

--from
--	Student stu JOIN
--	PrgItem itm on stu.ID = itm.StudentID JOIN
--	PrgItemDef id on itm.DefID = id.ID JOIN
--	PrgItemForm f on f.ItemID = itm.ID JOIN
--	FormInstanceInterval i on i.InstanceId = f.ID JOIN
	
--	--	What standards, if any, need to be modified, expanded, and/or prioritized for the student to access the general curriculum and/or appropriate activities to make effective progress?     < Modifications >    (Text)
--	FormInputValue v_0_0 on
--		v_0_0.InputFieldId = 'EB13DB91-6278-4AB9-ABA9-6DC75E0DA566' AND
--		v_0_0.Intervalid = i.ID JOIN
--	FormInputTextValue vv_0_0 on vv_0_0.ID = v_0_0.ID JOIN

--	--	Are there any modifications?     < NeedModifications >    (Flag)
--	FormInputValue v_0_1 on
--		v_0_1.InputFieldId = '7C29608F-C1F0-4D6B-8824-314F6CE50ED3' AND
--		v_0_1.Intervalid = i.ID JOIN
--	FormInputFlagValue vv_0_1 on vv_0_1.ID = v_0_1.ID JOIN

--	--	What type(s) of accommodations is (are) necessary for the student to access the general curriculum and/or appropriate activities to make effective progress?     < Accommodations >    (Text)
--	FormInputValue v_2_0 on
--		v_2_0.InputFieldId = 'D73125C3-B98D-4714-81B8-502B715B737C' AND
--		v_2_0.Intervalid = i.ID JOIN
--	FormInputTextValue vv_2_0 on vv_2_0.ID = v_2_0.ID JOIN

--	--	Are there any accommodations?     < NeedAccommodations >    (Flag)
--	FormInputValue v_2_1 on
--		v_2_1.InputFieldId = '68B82E93-4958-407D-B8CA-AC6A781B840B' AND
--		v_2_1.Intervalid = i.ID JOIN
--	FormInputFlagValue vv_2_1 on vv_2_1.ID = v_2_1.ID

 
--go








