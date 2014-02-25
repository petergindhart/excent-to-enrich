-- create and populate table in the district's Enrich database
if exists (select 1 from sys.objects where name = 'ParamValues')
drop table  x_DATAVALIDATION.ParamValues 
go

create table x_DATAVALIDATION.ParamValues (
RowNumber	int not null identity(1,1),
ParamName	varchar(50)	not null,
ParamValue	varchar(255) not null
)

alter table x_DATAVALIDATION.ParamValues 
	add constraint PK_ParamValues_ParamName primary key (ParamName)
go


-- create this proc in a common area, not in 0001-prep_district.sql
-- this needs to be compiled after the ParamValues table is created
if exists (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'usp_GetParam')
drop proc x_DATAVALIDATION.usp_GetParam 
go

create proc x_DATAVALIDATION.usp_GetParam
 (
 @paramName varchar(50)
 )
as
set nocount on;
select ParamValue from x_DATAVALIDATION.ParamValues where ParamName = coalesce(@paramName,'')
go
