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
