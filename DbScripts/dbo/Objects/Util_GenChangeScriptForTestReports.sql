if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Util_GenChangeScriptForTestReports]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Util_GenChangeScriptForTestReports]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 /*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE [dbo].[Util_GenChangeScriptForTestReports] 
	@testdefinition uniqueidentifier
AS

set transaction isolation level read uncommitted

-- ReportSchemaTable
declare @tables table(TableID uniqueidentifier, TestID uniqueidentifier, AdminColumnID uniqueidentifier, GradeLevelColumnID uniqueidentifier, UseGradeParam bit, TypeTableID uniqueidentifier, SchoolColumnID uniqueidentifier)

insert into @tables
select 
	case when ReportTableID is null then newid() else ReportTableID end,
	d.ID,
	newid(),
	newid(),
	0,
	newid(),
	newid()
from TestDefinition d
where d.id=@testdefinition

--#############################################################################
-- ReportSchemaTable
-- add
select	[reportschematable    ] = 
	'insert into VC3Reporting.ReportSchemaTable values ('
	+ '''' + cast(TableId as varchar(36)) + ''', '
	+ '''' + test.Name + ''', '
	+ '''(select * from ' + test.TableName + ' where (AdministrationID={Administration} or {Administration} is null)' + case when UseGradeParam = 0 then '' else ' and (GradeLevelID={Grade Level} or {Grade Level} is null)' end + ')'', '
	+ '''ID''); ' +
	'insert into ReportSchemaTable values(''' + cast(TableId as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where not exists ( select * from VC3Reporting.ReportSchemaTable where id = TableId )
union
-- update
select	'update VC3Reporting.ReportSchemaTable '
	+ 'SET Name =''' + test.Name + ''', '
	+ 'TableExpression =''(select * from ' + test.TableName + ' where (AdministrationID={Administration} or {Administration} is null)' + case when UseGradeParam = 0 then '' else ' and (GradeLevelID={Grade Level} or {Grade Level} is null)' end + ')'', '
	+ 'IdentityExpression=''ID'' '
	+ 'WHERE ID = '''+ cast(TableId as varchar(36)) +''''
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where exists ( select * from VC3Reporting.ReportSchemaTable where id = TableId )

--#############################################################################
-- ReportSchemaColumn
-- Administration column
-- add, no update
select	[admin column         ] = 
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
') values (' +
	'''' + cast(AdminColumnID as varchar(36)) + ''', '+
	'''Administration'', ' +
	'''' + cast(TableID as varchar(36)) + ''', '+
	'''G'', ' +
	'''(select Name from TestAdministration where ID={this}.AdministrationID)'', '+
	'''AdministrationID'', ''(select StartDate from TestAdministration where ID={this}.AdministrationID)'', null, null, 1, 1, 1, 1, 1, 0, ' +
	'''select Id, Name from TestAdministration where TestDefinitionID=''''' + cast(test.ID as varchar(36)) + ''''' order by StartDate desc'', ' +
	'0, null, null ); ' +
'insert into ReportSchemaColumn values(''' + cast(AdminColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where not exists ( select * from VC3Reporting.ReportSchemaColumn where name = 'Administration' and schematable = TableID )

--#############################################################################
-- Grade Level column
-- add, no update
select	[grade level column   ] =
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
') values (' +
	'''' + cast(GradeLevelColumnID as varchar(36)) + ''', '+
	'''Grade Level (when tested)'', ' +
	'''' + cast(TableID as varchar(36)) + ''', '+
	'''G'', ' +
	'''(select ''''Grade '''' + Name from GradeLevel where ID = {this}.GradeLevelID)'', '+
	'''GradeLevelID'', null, null, null, 1, 1, 1, 1, 1, 0, ' +
	'''select Id, ''''Grade '''' + Name from GradeLevel where Active=1 order by Name'', ' +
	'1, null,null ); ' +
'insert into ReportSchemaColumn values(''' + cast(GradeLevelColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where not exists ( select * from VC3Reporting.ReportSchemaColumn where name = 'Grade Level (when tested)' and schematable = TableID )

--#############################################################################
-- School column
-- add, no update
select	[school column        ] =
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
')values (' +
	'''' + cast(SchoolColumnID as varchar(36)) + ''', '+
	'''School (when tested)'', ' +
	'''' + cast(TableID as varchar(36)) + ''', '+
	'''G'', ' +
	'''(select Name from School where ID={this}.SchoolID)'', ' +
	'''SchoolID'', null, null, null, 1, 1, 1, 1, 1, 0, ' +
	'''select Id, Name from School where IsLocalOrg = 1 order by Name'', ' +
	'2, null, null ); ' +
'insert into ReportSchemaColumn values(''' + cast(SchoolColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where not exists ( select * from VC3Reporting.ReportSchemaColumn where name = 'School (when tested)' and schematable = TableID )

--#############################################################################
--- Score columns
declare @columns table(ColumnID uniqueidentifier, ScoreID uniqueidentifier, Sequence int)

insert into @columns
	select case when ResultReportColumnID is null then newid() else ResultReportColumnID end, scr.Id, 100
	from 
		TestSectionDefinition sec join
		TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id left join
		TestSectionDefinition par1 on par1.Id = sec.Parent left join
		TestSectionDefinition par2 on par2.Id = par1.Parent
	where sec.TestDefinitionID = @testdefinition
	order by 
		sec.TestDefinitionID, isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '

--#####################################
-- Numeric columns
-- add
select	[numeric columns      ] =
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
')values ('
	+ '''' + cast(ColumnID as varchar(36)) + ''', '
	+ '''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+ '''' + cast(tbl.TableID as varchar(36)) + ''', '
	+ '''N'', '
	+ 'null, '
	+ '''' + ColumnName + ''', '
	+ 'null, '
	+ 'null, '
	+ 'null, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '0, '
	+ 'null, '
	+ cast(cols.Sequence as varchar(10)) + ', '
	+ 'null, null); ' +
'insert into ReportSchemaColumn values(''' + cast(ColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = '35DD056B-E9DD-4DF7-B9C8-21B289D5588D' and
	not exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

-- update
select	[numeric columns U    ] =
	'update VC3Reporting.ReportSchemaColumn '+
	+'SET Name=''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+'SchemaTable=''' + cast(tbl.TableID as varchar(36)) + ''', '
	+'SchemaDataType=''N'', '
	+'DisplayExpression=null, '
	+'ValueExpression=''' + ColumnName + ''', '
	+'OrderExpression=null, '
	+'LinkExpression=null, '
	+'LinkFormat=null, '
	+'IsSelectColumn=1, '
	+'IsFilterColumn=1, '
	+'IsParameterColumn=1, '
	+'IsGroupColumn=1, '
	+'IsOrderColumn=1, '
	+'IsAggregated=0, '
	+'AllowedValuesExpression=null, '
	+'Sequence='+cast(cols.Sequence as varchar(10)) + ', '
	+'Width=null, '
	+'Description=null '
	+ 'WHERE ID = ''' + cast(ColumnID as varchar(36)) + ''''
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = '35DD056B-E9DD-4DF7-B9C8-21B289D5588D' and
	exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

--#####################################
-- DateTime columns
-- add
select	[datetime columns     ] =
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
')values ('
	+ '''' + cast(ColumnID as varchar(36)) + ''', '
	+ '''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+ '''' + cast(tbl.TableID as varchar(36)) + ''', '
	+ '''D'', '
	+ 'null, '
	+ '''' + ColumnName + ''', '
	+ 'null, '
	+ 'null, '
	+ 'null, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '0, '
	+ 'null, '
	+ cast(cols.Sequence as varchar(10)) + ', '
	+ 'null, null); ' +
'insert into ReportSchemaColumn values(''' + cast(ColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = 'BAD958F8-B314-41C2-AF5A-D39BE608803B' and
	not exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

-- update
select	[datetime columns U   ] =
	'UPDATE VC3Reporting.ReportSchemaColumn '+
	+'SET Name=''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+'SchemaTable=''' + cast(tbl.TableID as varchar(36)) + ''', '
	+'SchemaDataType=''D'', '
	+'DisplayExpression=null, '
	+'ValueExpression=''' + ColumnName + ''', '
	+'OrderExpression=null, '
	+'LinkExpression=null, '
	+'LinkFormat=null, '
	+'IsSelectColumn=1, '
	+'IsFilterColumn=1, '
	+'IsParameterColumn=1, '
	+'IsGroupColumn=1, '
	+'IsOrderColumn=1, '
	+'IsAggregated=0, '
	+'AllowedValuesExpression=null, '
	+'Sequence='+cast(cols.Sequence as varchar(10)) + ', '
	+'Width=null, '
	+'Description=null '
	+ 'WHERE ID = ''' + cast(ColumnID as varchar(36)) + ''''
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = 'BAD958F8-B314-41C2-AF5A-D39BE608803B' and
	exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

--#####################################
-- GradeLevel columns 
-- add
select	[grade columns        ] =
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
')values ('
	+ '''' + cast(ColumnID as varchar(36)) + ''', '
	+ '''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+ '''' + cast(tbl.TableID as varchar(36)) + ''', '
	+ '''G'', '
	+ '''(select ''''Grade '''' + Name from GradeLevel where ID={this}.' + ColumnName + ')'', '
	+ '''' + ColumnName + ''', '
	+ 'null, '
	+ 'null, '
	+ 'null, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '0, '
	+ '''select Id, ''''Grade '''' + Name from GradeLevel where Active=1 order by Name'', ' +
	+ cast(cols.Sequence as varchar(10)) + ', '
	+ 'null,'
	+ 'null); ' +
'insert into ReportSchemaColumn values(''' + cast(ColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = '22D3B947-5C40-4B35-86B0-2BA98D53BD83' and
	not exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

-- update
select	[grade columns U      ] =
	'UPDATE VC3Reporting.ReportSchemaColumn '
	+'SET Name=''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+'SchemaTable=''' + cast(tbl.TableID as varchar(36)) + ''', '
	+'SchemaDataType=''G'', '
	+'DisplayExpression=''(select ''''Grade '''' + Name from GradeLevel where ID={this}.' + ColumnName + ')'', '
	+'ValueExpression=''' + ColumnName + ''', '
	+'OrderExpression=null, '
	+'LinkExpression=null, '
	+'LinkFormat=null, '
	+'IsSelectColumn=1, '
	+'IsFilterColumn=1, '
	+'IsParameterColumn=1, '
	+'IsGroupColumn=1, '
	+'IsOrderColumn=1, '
	+'IsAggregated=0, '
	+'AllowedValuesExpression=''select Id, ''''Grade '''' + Name from GradeLevel where Active=1 order by Name'', ' +
	+'Sequence='+cast(cols.Sequence as varchar(10)) + ', '
	+'Width=null, '
	+'Description=null '+
+'WHERE ID = ''' + cast(ColumnID as varchar(36)) + ''''
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = '22D3B947-5C40-4B35-86B0-2BA98D53BD83' and
	exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

--#####################################
-- Bit columns 64DAD8FF-4408-47F5-AC6A-4CD891B2E581
-- add
select	[bit columns          ] =
'insert into VC3Reporting.ReportSchemaColumn '+
'(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
')values ('
	+ '''' + cast(ColumnID as varchar(36)) + ''', '
	+ '''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+ '''' + cast(tbl.TableID as varchar(36)) + ''', '
	+ '''B'', '
	+ '''case when {this}.' + ColumnName + ' = 1 then ''''Yes'''' else ''''No'''' end'', ' +
	+ '''' + ColumnName + ''', '
	+ 'null, '
	+ 'null, '
	+ 'null, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '0, '
	+ '''select 1 Id, ''''Yes'''' Name union select 0, ''''No'''' order by 1 desc'', ' +
	+ cast(cols.Sequence as varchar(10)) + ', '
	+ 'null, null'
	+ '); ' +
'insert into ReportSchemaColumn values(''' + cast(ColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = '64DAD8FF-4408-47F5-AC6A-4CD891B2E581' and
	not exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

-- update
select	[bit columns U        ] =
	'UPDATE VC3Reporting.ReportSchemaColumn '
	+'SET Name=''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+'SchemaTable=''' + cast(tbl.TableID as varchar(36)) + ''', '
	+'SchemaDataType=''B'', '
	+'DisplayExpression=''case when {this}.' + ColumnName + ' = 1 then ''''Yes'''' else ''''No'''' end'', ' +
	+'ValueExpression=''' + ColumnName + ''', '
	+'OrderExpression=null, '
	+'LinkExpression=null, '
	+'LinkFormat=null, '
	+'IsSelectColumn=1, '
	+'IsFilterColumn=1, '
	+'IsParameterColumn=1, '
	+'IsGroupColumn=1, '
	+'IsOrderColumn=1, '
	+'IsAggregated=0, '
	+'AllowedValuesExpression=''select 1 Id, ''''Yes'''' Name union select 0, ''''No'''' order by 1 desc'', ' +
	+'Sequence='+cast(cols.Sequence as varchar(10)) + ', '
	+'Width=null, '
	+'Description=null '
	+'WHERE ID = ''' + cast(ColumnID as varchar(36)) + ''''
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = '64DAD8FF-4408-47F5-AC6A-4CD891B2E581' and
	exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

--#####################################
-- EnumValue columns F415D55D-D901-46F5-8F64-B86A4DFA3A23
-- add
select	[enum columns         ] =
'insert into VC3Reporting.ReportSchemaColumn  
(Id,'+
'Name,'+
'SchemaTable,'+
'SchemaDataType,'+
'DisplayExpression,'+
'ValueExpression,'+
'OrderExpression,'+
'LinkExpression,'+
'LinkFormat,'+
'IsSelectColumn,'+
'IsFilterColumn,'+
'IsParameterColumn,'+
'IsGroupColumn,'+
'IsOrderColumn,'+
'IsAggregated,'+
'AllowedValuesExpression,'+
'Sequence,'+
'Width,'+
'Description'+
')
values
('
	+ '''' + cast(ColumnID as varchar(36)) + ''', '
	+ '''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+ '''' + cast(tbl.TableID as varchar(36)) + ''', '
	+ '''G'', '
	+ '''(select DisplayValue from EnumValue where Id={this}.' + ColumnName + ')'', ' +
	+ '''' + ColumnName + ''', '
	+ '''(select Code from EnumValue where Id={this}.' + ColumnName + ')'', ' +
	+ 'null, '
	+ 'null, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '1, '
	+ '0, '
	+ '''select Id, DisplayValue from EnumValue where Type=''''' + cast(EnumType as varchar(36)) + ''''' order by Code'', ' +
	+ cast(cols.Sequence as varchar(10)) + ', '
	+ 'null,null '
	+ '); ' +
'insert into ReportSchemaColumn values(''' + cast(ColumnID as varchar(36)) + ''', NULL)'
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = 'F415D55D-D901-46F5-8F64-B86A4DFA3A23' and
	not exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence

-- update
select	[enum columns U       ] =
	'UPDATE VC3Reporting.ReportSchemaColumn  '
	+'SET Name=''' + isnull(par2.Name + ' > ', '') + isnull(par1.Name + ' > ', '') + sec.Name + ' > ' + scr.Name + ''', '
	+'SchemaTable=''' + cast(tbl.TableID as varchar(36)) + ''', '
	+'SchemaDataType=''G'', '
	+'DisplayExpression=''(select DisplayValue from EnumValue where Id={this}.' + ColumnName + ')'', ' +
	+'ValueExpression=''' + ColumnName + ''', '
	+'OrderExpression=''(select Code from EnumValue where Id={this}.' + ColumnName + ')'', ' +
	+'LinkExpression=null, '
	+'LinkFormat=null, '
	+'IsSelectColumn=1, '
	+'IsFilterColumn=1, '
	+'IsParameterColumn=1, '
	+'IsGroupColumn=1, '
	+'IsOrderColumn=1, '
	+'IsAggregated=0, '
	+'AllowedValuesExpression=''select Id, DisplayValue from EnumValue where Type=''''' + cast(EnumType as varchar(36)) + ''''' order by Code'', ' +
	+'Sequence='+cast(cols.Sequence as varchar(10)) + ', '
	+'Width=null, '
	+'Description=null '
	+'WHERE ID = ''' + cast(ColumnID as varchar(36)) + ''''
from @tables tbl join
	TestSectionDefinition sec on sec.TestDefinitionID = tbl.TestID join
	TestScoreDefinition scr on scr.TestSectionDefinitionID = sec.Id join
	@columns cols on cols.ScoreID = scr.Id left join
	TestSectionDefinition par1 on par1.Id = sec.Parent left join
	TestSectionDefinition par2 on par2.Id = par1.Parent
where
	scr.DataTypeID = 'F415D55D-D901-46F5-8F64-B86A4DFA3A23' and
	exists ( select * from VC3Reporting.reportschemacolumn where id = ColumnID )
order by sec.TestDefinitionID, cols.Sequence


--#############################################################################
-- Parameter columns
-- Administration column
-- add, not updated
select	[admin params         ] =
	'insert into VC3Reporting.ReportSchemaTableParameter values (' +
	'''' + cast(newid() as varchar(36)) + ''', '+
	'''Administration'', ' +
	'''' + cast(TableID as varchar(36)) + ''', '+
	'''' + cast(AdminColumnID as varchar(36)) + ''', '+
	'''41BA0544-6400-4E61-B1DD-378743A7D145'', '+ -- IS
	'0, 0)'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where	not exists (select * from VC3Reporting.ReportSchemaTableParameter where name = 'Administration' and schematable = TableID )


--#############################################################################
-- Grade Level column
-- add, not updated
select	[grade params         ] =
	'insert into VC3Reporting.ReportSchemaTableParameter values (' +
	'''' + cast(newid() as varchar(36)) + ''', '+
	'''Grade Level'', ' +
	'''' + cast(TableID as varchar(36)) + ''', '+
	'''' + cast(GradeLevelColumnID as varchar(36)) + ''', '+
	'''41BA0544-6400-4E61-B1DD-378743A7D145'', '+ -- IS
	'0, 1)'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where
	UseGradeParam = 1 and
	not exists (select * from VC3Reporting.ReportSchemaTableParameter where name = 'Grade Level' and schematable = TableID )



--#############################################################################
-- ReportType = Student
-- add, not updated
select	[student type         ] =
'insert into VC3Reporting.ReportTypeTable values(' + 
	'''' + cast(newid() as varchar(36)) + ''', ' +
	'''' + Name + ''', ' +
	'''S'', ' +
	'10, ' +
	'''' + cast(TableID as varchar(36)) + ''', ' +
	'''C0619F4E-EDB7-4152-BF25-7BD3845C1700'', ' +
	'''Z'', ' +
	'''{left}.ID = {right}.StudentID'', ' +
	'''' + Name + '''' +
	 ')'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where	not exists (select * from VC3Reporting.ReportTypeTable where ReportType = 'S' and SchemaTable = TableID)

-- ReportType = AYP
select	[ayp type             ] =
	'insert into VC3Reporting.ReportTypeTable values(' + 
	'''' + cast(newid() as varchar(36)) + ''', ' +
	'''' + Name + ''', ' +
	'''Y'', ' +
	'10, ' +
	'''' + cast(TableID as varchar(36)) + ''', ' +
	'''BA314C08-7D2C-456F-AFBD-AD1E67911618'', ' +
	'''L'', ' +
	'''{left}.StudentID = {right}.StudentID and {left}.AdministrationID = {right}.AdministrationID'', ' +
	'''' + Name + '''' +
	 ')'
from @tables tbl join
	TestDefinition test on test.Id = tbl.TestID
where	not exists (select * from VC3Reporting.ReportTypeTable where ReportType = 'Y' and SchemaTable = TableID)

--#############################################################################
-- Update test definition tables
select	[update def-rep table ] =
	'update TestDefinition set ReportTableID=''' + cast(tables.TableID as varchar(36)) + ''' where Id=''' + cast(ID as varchar(36)) + ''''
from TestDefinition d join 
	@tables tables on tables.TestID = d.Id
where ReportTableID is null 

select	[update def-res column] =
	'update TestScoreDefinition set ResultReportColumnID=''' + cast(cols.ColumnID as varchar(36)) + ''' where Id=''' + cast(ID as varchar(36)) + ''''
from TestScoreDefinition d join 
	@columns cols on cols.ScoreID = d.Id
where ResultReportColumnID is null

--########################################################################################
-- Insert missing enum/bit/grade level ReportTypeColumn records for distribution report 
select 
	[insert enum/bit/gradelevel report type columns for distribution report] = 
	'insert into table VC3Reporting.ReportTypeColumn values(''' + CAST(rsc.Id as VARCHAR(36)) + ''', ''' + CAST(rtt.Id as VARCHAR(36)) + ''', NULL, 100)'
from 
	testdefinition td  join 
	testsectiondefinition tsd on td.id = tsd.testdefinitionid join 
	testscoredefinition tscd on tscd.testsectiondefinitionid = tsd.id join 
	testscoredatatype dt on dt.id = tscd.datatypeid join 
	vc3reporting.reportschemacolumn rsc on rsc.id = tscd.resultreportcolumnid join 
	vc3reporting.reportschematable rst on rst.id = rsc.schematable join 
	vc3reporting.reporttypetable rtt on rtt.schematable = rst.id left outer join 
	vc3reporting.reporttypecolumn rtc on rtc.SchemaColumn = rsc.Id
where td.id = @testdefinition
	and 
		(
			DataTypeID in ('64DAD8FF-4408-47F5-AC6A-4CD891B2E581', '22D3B947-5C40-4B35-86B0-2BA98D53BD83')
				OR
			(
				-- only add enum types with a small number of options
				DataTypeID = 'F415D55D-D901-46F5-8F64-B86A4DFA3A23'
					AND
				EnumType IN (SELECT et.Id FROM EnumType et JOIN EnumValue ev ON ev.Type = et.Id GROUP BY et.Id HAVING COUNT(*) < 10)
			)
				OR 
			(
				-- only add real integer values with a small range of possible values
				DataTypeID = '35DD056B-E9DD-4DF7-B9C8-21B289D5588D'
					AND
				(MaxValue-MinValue) between 1 and 9
			)
		)
	and rtt.ReportType = 'Y'
	and rtc.SchemaColumn is null