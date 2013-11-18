-- bogus - I cannot get this change to work.  Tried reverting and other stuff.  nothing works.
create proc x_DATATEAM.FormletViewBuilder
 @formTemplateID uniqueidentifier,
 @createview bit,
 @requiredcolumns varchar(max) = NULL
as


-- return form instance ID, user ID (careful with column names) - |, *, # ?

-- multi select, reference to II, ???
-- repeatable input areas -- input value w/sequence




set nocount on;
-- select * from FormTemplate where name like '%Data%Sheet%'

--declare @formTemplateID uniqueidentifier, @createview bit, @requiredcolumns varchar(max), @rcount int ; select @formTemplateID = 'C12648E5-7678-4358-B936-2A2F6FDF1B4B', @createview = 0, @requiredcolumns = 'CurMan
--CurCoor
--ProjMan
--ProjGrade
--ProjCoor'

declare @rcount int 

set @requiredcolumns = rtrim(replace(@requiredcolumns, char(13)+char(10), ','))+','

select @rcount = (len(@requiredcolumns)-len(replace(@requiredcolumns, ',', '')))+1

declare @rc table (col varchar(100))

while @rcount > 1 
begin

insert @rc values (left(@requiredcolumns, PATINDEX('%,%',@requiredcolumns)-1))

set @requiredcolumns = right(@requiredcolumns, len(@requiredcolumns)-PATINDEX('%,%', @requiredcolumns))
set @rcount	= @rcount - 1
end

declare @templateName varchar(255) ; select @templateName = Name from dbo.FormTemplate where ID = @formTemplateID

declare @query table (
ID int not null identity(1,1), 
InputItemType varchar(50) null,
InputItemCode	varchar(50) null,
ControlIsRepeatable bit null,
InputItemLabel varchar(500) null,
InputItemID	varchar(36) null,
SelectColumn	varchar(500)	null,
FromTable	varchar(500)	null,
LeftTable	varchar(500)	null,
AliasSuffix	varchar(50)	null,
Sequence	int	null
)

set nocount on;
declare @scolumns varchar(max); set @scolumns = 'select
	ItemID = itm.ID,
	i.InstanceID,
	StudentID = stu.ID,
	stu.Number,
	StudentFirstname = stu.Firstname,
	StudentLastname = stu.Lastname,
	--'

declare @flist varchar(max) ; set @flist = 'from
	Student stu JOIN
	PrgItem itm on stu.ID = itm.StudentID JOIN
	PrgItemDef id on itm.DefID = id.ID JOIN
	PrgItemForm f on f.ItemID = itm.ID JOIN
	FormInstanceInterval i on i.InstanceId = f.ID JOIN
	'

declare @fijoin varchar(max) ; set @fijoin = '
	FormInputValue v0 on
		v0.InputFieldId = '''

declare @vt varchar(100),
		@lt varchar(100),
		@lefttables varchar(max),
		@newline varchar(5) 
select @lefttables = '', @newline = '
'
declare @lefties varchar(max); set @lefties = ''

declare @valuetbl table (vType varchar(100), valTable varchar(100), idColumn varchar(100), leftTable varchar(100)); 
insert @valuetbl values ('Date', 'FormInputDateValue', 'Value', NULL)
insert @valuetbl values ('Flag', 'FormInputFlagValue', 'Value', NULL) -- could be NULL
insert @valuetbl values ('Text', 'FormInputTextValue', 'Value', NULL)
-- 
insert @valuetbl values ('Enum', 'FormInputEnumValue', 'Value', 'EnumValue')
insert @valuetbl values ('Person', 'FormInputPersonValue', 'ValueID', 'Person')
insert @valuetbl values ('Selection', 'FormInputSelection', 'OptionID', 'FormTemplateInputSelectFieldOption')
insert @valuetbl values ('SingleSelect', 'FormInputSingleSelectValue', 'SelectedOptionID', 'FormTemplateInputSelectFieldOption')
insert @valuetbl values ('User', 'FormInputUserValue', 'ValueID', 'Person') -- acutally the FK references UserProfile, but...
-- insert @valuetbl values ('MultiSelect', 'FormInputSingleSelectValue', 'SelectedOptionID', 'FormTemplateInputSelectFieldOption')

/*
--x_DATATEAM.FindVarchar 'MultiSelect'
----FormTemplateInputItemType DFA147B7-C16D-4422-86DA-F2F2D43E9A24

--x_DATATEAM.FindGUID 'DFA147B7-C16D-4422-86DA-F2F2D43E9A24'
--select * from dbo.FormTemplateInputItemType where Id = 'DFA147B7-C16D-4422-86DA-F2F2D43E9A24'
--select * from dbo.FormTemplateInputItem where TypeId = 'DFA147B7-C16D-4422-86DA-F2F2D43E9A24' order by Label ----------------------- identifies MultiSelect

--select * from FormTemplateInputItem where ID = '55DFEEB3-D0D2-40FB-AFBB-F827D87CDDC6'  order by Sequence
--select * from FormTemplateInputItem where ID = '6E01D073-31A8-4E34-8753-7B0699BDE34E'  order by Sequence

--select * from FormTemplateInputItem where InputAreaId = '3C48D398-B33F-4001-820C-1E306BC36E34' order by Sequence
--select * from FormTemplateInputItem where ShowIfInputItemId = '6E01D073-31A8-4E34-8753-7B0699BDE34E' order by Sequence

x_DATATEAM.FindGUID '55DFEEB3-D0D2-40FB-AFBB-F827D87CDDC6'
select * from dbo.FormInputValue where InputFieldId = '55DFEEB3-D0D2-40FB-AFBB-F827D87CDDC6'

x_DATATEAM.FindGUID '382843C5-DB5B-4C18-AC9E-F78662710EBB' -- just one of the rows from forminputvalue
select * from dbo.FormInputFlagValue where Id = '382843C5-DB5B-4C18-AC9E-F78662710EBB' -- apparently they can be any of the other types (this one is flag)

-- interval
x_DATATEAM.FindGUID '6692719D-793A-4BDE-BD95-00036CE345A4'
select * from dbo.FormInstanceInterval where Id = '6692719D-793A-4BDE-BD95-00036CE345A4'

select * from FormInstance where id = '35F0F91C-86E4-4456-9F25-E1791BAA4FC1' -- shows template id



select * 
from dbo.FormInputValue where InputFieldId = '55DFEEB3-D0D2-40FB-AFBB-F827D87CDDC6'

x_DATATEAM.FindGUID '7F50B9AC-D07E-4060-A7E0-625503794A5E'


select * from dbo.FormTemplateControl where Id = '7F50B9AC-D07E-4060-A7E0-625503794A5E'
select * from dbo.FormTemplateLayout where ControlId = '7F50B9AC-D07E-4060-A7E0-625503794A5E'
select * from dbo.FormTemplateControlProperty where ControlId = '7F50B9AC-D07E-4060-A7E0-625503794A5E'
select * from dbo.FormTemplateInputItem where InputAreaId = '7F50B9AC-D07E-4060-A7E0-625503794A5E' order by Sequence

-- single select from multi select?
x_DATATEAM.FindGUID '5E0ABD0C-DF05-4582-9D5E-92F1C87C6C52'
select * from dbo.FormTemplateInputItem where TypeId = '5E0ABD0C-DF05-4582-9D5E-92F1C87C6C52'
select * from dbo.FormTemplateInputItemType where Id = '5E0ABD0C-DF05-4582-9D5E-92F1C87C6C52' -- flag

*/




-- code, type, label, id, SelectColumn, FromTable, LeftTable, AliasSuffix
insert @query (InputItemType, InputItemCode, ControlIsRepeatable, InputItemLabel, InputItemID, SelectColumn, FromTable, LeftTable, AliasSuffix)
select InputItemType, InputItemCode, ControlIsRepeatable, InputItemLabel, InputItemID, 
	SelectColumn = InputItemCode+ 
		case 
			when t.leftTable is null then '' 
			else 
			case 
				when t.leftTable not in ('FormTemplateInputSelectFieldOption', 'Person') then 'ID' 
				else '' 
			end 
		end+
		' = '+
		case 
			when t.leftTable = 'FormTemplateInputSelectFieldOption' then 'lft_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.Label,'
			when t.leftTable = 'FormInputTextValue' then 'Value,'
			when t.leftTable = 'Person' then 'lft_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.Firstname+'' ''+lft_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.Lastname,'
			else 'vv_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.'+idColumn+','
		end,
		FromTable = '	--	'+InputItemLabel+'     < '+t.InputItemCode+' >    ('+InputItemType+')
	FormInputValue v_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+' on
		v_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.InputFieldId = '''
		+InputItemID+''' AND
		v_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.Intervalid = i.ID JOIN
	'+valTable+' vv_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+' on vv_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.ID = v_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.ID JOIN'+@newline+@newline,
		LeftTable = case when t.leftTable is null then '' else '
	'+ t.leftTable+' lft_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+' on vv_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.'+idColumn+' = lft_'+convert(varchar(10), x.Sequence)+'_'+SeqChar+'.ID LEFT JOIN' end,
		AliasSuffix = convert(varchar(10), x.Sequence)+'_'+SeqChar
from (
	select 
		ftl.ControlID,
		ControlIsRepeatable = ftc.IsRepeatable,
		InputItemCode = ftii.Code, 
		InputItemLabel = ftii.Label,
		InputItemType = ftiit.Name,  
		InputItemID = convert(varchar(36), ftii.id), 
		vt.valTable, 
		vt.idColumn,
		vt.leftTable, 
		SeqChar = cast((select count(*) from FormTemplateInputItem ftiict where ftiict.InputAreaId = ftii.InputAreaId and ftiict.Code < ftii.Code ) as varchar(10)),
		SeqInt = (select count(*) from FormTemplateInputItem ftiict where ftiict.InputAreaId = ftii.InputAreaId and ftiict.Code < ftii.Code ), -- select * 
		IsMultiSelect = cast(case when ftii.TypeId = 'DFA147B7-C16D-4422-86DA-F2F2D43E9A24' then 1 else 0 end as bit)
	from dbo.FormTemplate ft 
	join dbo.FormTemplateLayout ftl on ft.ID = ftl.TemplateId
	join dbo.FormTemplateControl ftc on ftl.ControlId = ftc.Id
	join dbo.FormTemplateInputItem ftii on ftl.ControlId = ftii.InputAreaId
	join dbo.FormTemplateInputItemType ftiit on ftii.TypeId = ftiit.Id
	join @valuetbl vt on ftiit.Name = vt.vType 
	where ftl.TemplateID = @formTemplateID 
) t
join x_DATATEAM.FormLayoutSequence2 x on t.ControlId = x.ControlId
order by x.Sequence, SeqInt 

if (@createview = 1)
begin

-- new
delete @query where InputItemCode not in (select col from @rc)

update q set SelectColumn = replace(SelectColumn, ',', ''), 
	FromTable = case when exists (select 1 from @query where LeftTable <> '') then left(FromTable, len(FromTable)-9)+' LEFT JOIN' else left(FromTable, len(FromTable)-9) end
	--replace(
	--	FromTable, 
	--	' JOIN', 
	--	case when exists (select 1 from @query where LeftTable <> '') then ' LEFT JOIN' else '' end
	--	)  -- cannot use replace since there are 2+ joins
-- select * 
from @query q
where ID = (select max(id) from @query )

--update q set SelectColumn = replace(SelectColumn, ',', ''), FromTable = replace(FromTable, ' JOIN', ' LEFT JOIN') 
---- select * 
--from @query q
--where ID = (select max(id) from @query )

update q set LeftTable = replace(lefttable, ' LEFT JOIN', '')
-- select * 
from @query q
where ID = (select max(id) from @query where LeftTable <> '')

select @lefttables = @lefttables+ q.LeftTable
from @query q
where q.LeftTable <> ''
order by ID

if @lefties <> ''
set @lefttables = replace(@lefttables, 'LEFT JOIN'+char(13)+char(10)+char(13)+char(10), 'LEFT JOIN'+char(13)+char(10))


print 'if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id and s.name = ''x_FormletView'' and o.name = '''+replace(@templateName,' ', '_')+''')
drop view x_FormletView.'+replace(@templateName,' ', '_')+'
go'+@newline+@newline+'create view x_FormletView.'+replace(@templateName,' ', '_')+@newline+'as'+@newline


print @scolumns 

select '	'+q.SelectColumn
from @query q
order by ID

print @flist

select q.FromTable
from @query q
order by ID

if exists (select 1 from @query where LeftTable <> '')
print '	--### LEFT join actual value tables where needed ###' 

print @lefttables

print 'go'
end
else
select * from @query q order by q.InputItemCode
GO



/*

select * from FormInputValue


select o.name
from sys.schemas s 
join sys.objects o on s.schema_id = o.schema_id 
join sys.columns c on o.object_id = c.object_id
where s.name = 'dbo'
and c.name = 'IsRepeatable'

select * from FormTemplateControl order by IsRepeatable desc


select * from FormTemplateControl where ID = 'FC0BE28C-38D6-445E-9366-04CA1F04F90F'

x_DATATEAM.FindGUID 'FC0BE28C-38D6-445E-9366-04CA1F04F90F'

-- the entire input area is repeatable

select * from FormTemplate where ID = 'C318316F-FB7D-40AF-A92D-E6A57C0BAC0F'
select * from dbo.FormTemplateControl where Id = 'FC0BE28C-38D6-445E-9366-04CA1F04F90F' ----------------------------------------- isrepeatable = 1
	select * from FormTemplateControlType where ID = 'DB9713CF-24D9-4097-9E00-757E8630B14A' -- input area
select * from dbo.FormTemplateControlProperty where ControlId = 'FC0BE28C-38D6-445E-9366-04CA1F04F90F'
select * from dbo.FormTemplateLayout where ControlId = 'FC0BE28C-38D6-445E-9366-04CA1F04F90F'
select * from dbo.FormTemplateInputItem where InputAreaId = 'FC0BE28C-38D6-445E-9366-04CA1F04F90F' order by sequence



*/





