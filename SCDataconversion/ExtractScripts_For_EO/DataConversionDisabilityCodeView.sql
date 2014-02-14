/*
-- update icservicetbl set Frequency = 'Three times per week' where IEPComplSeqnum = 13833 and ServSeqNum = 31955

declare @fuzzy varchar(100) ; set @fuzzy = '''Three %W%k%'' or Frequency like ''3%W%k%'''
print @fuzzy
*/

if exists (select 1 from sys.objects where name = 'DataConversionDisabilityCode')
drop table DataConversionDisabilityCode
go

create table DataConversionDisabilityCode (
SDECode	varchar(100) not null,
SDEDesc	varchar(100) not null,
FuzzyDesc varchar(100) not null
)
go

alter table DataConversionDisabilityCode 
	add constraint PK_DataConversionDisabilityCode_Code primary key (SDECode)
go

create index IX_DataConversionDisabilityCode_SDEDesc on DataConversionDisabilityCode (SDEDesc)
go

set nocount on;
insert DataConversionDisabilityCode values ('SDE01', '*Intellectual Disability', '*Intellectual Disability')
insert DataConversionDisabilityCode values ('SDE01A', 'Intellectual Disability (mild)', 'Intellectual Disability (mild)')
insert DataConversionDisabilityCode values ('SDE01B', 'Intellectual Disability (moderate)', 'Intellectual Disability (moderate)')
insert DataConversionDisabilityCode values ('SDE01C', 'Intellectual Disability (severe)', 'Intellectual Disability (severe)')
insert DataConversionDisabilityCode values ('SDE02', 'Deaf and Hard of Hearing', 'Deaf and Hard of Hearing')
insert DataConversionDisabilityCode values ('SDE03', 'Speech or Language Impairment', 'Speech or Language Impairment')
insert DataConversionDisabilityCode values ('SDE04', 'Visual Impairment', 'Visual Impairment')
insert DataConversionDisabilityCode values ('SDE05', 'Emotional Disability', 'Emotional Disability')
insert DataConversionDisabilityCode values ('SDE06', 'Orthopedic Impairment', 'Orthopedic Impairment')
insert DataConversionDisabilityCode values ('SDE07', 'Other Health Impairment', 'Other Health Impairment')
insert DataConversionDisabilityCode values ('SDE10', 'Specific Learning Disability', 'Specific Learning Disability')
insert DataConversionDisabilityCode values ('SDE11', 'Deafblindness', 'Deafblindness')
insert DataConversionDisabilityCode values ('SDE12', 'Multiple Disabilities', 'Multiple Disabilities')
insert DataConversionDisabilityCode values ('SDE13', 'Autism', 'Autism')
insert DataConversionDisabilityCode values ('SDE14', 'Traumatic Brain Injury', 'Traumatic Brain Injury')
insert DataConversionDisabilityCode values ('SDE15', 'Developmental Delay', 'Developmental Delay')
insert DataConversionDisabilityCode values ('SDE21', ' No Disability Currently Specified', ' No Disability Currently Specified')
go

if exists (select 1 from sys.objects where name = 'DataConversionDisabilityCodeView')
drop view DataConversionDisabilityCodeView
go

create view DataConversionDisabilityCodeView
as
/*	
	This code was borrowed from the other DataConversion___CodeViews.  
	Currently there seems to be no need for the CTE, but if it is decided to make the query more complex, we're ready.  
	
*/
with DisabilityCTE as
(
	select 
		StudentRefID = convert(varchar(150), s.GStudentID),
		StudentDisabRecNum = convert(varchar(150), sd.RecNum), 
		DisabilityCode = d.SDECode,
		DisabilityDesc = sd.DisabilityDesc,
		PrimaryDisability = PrimaryDiasb,
		DisabilityOrder = (
			select count(*) 
			from ReportStudDisability 
			where GStudentID = sd.GStudentID 
			and case when PrimaryDiasb = 1 then 1000000 else 2000000 end+ RecNum < case when sd.PrimaryDiasb = 1 then 1000000 else 2000000 end +sd.RecNum
			)
	from DataConvSpedStudentsAndIEPs s
	join ReportStudDisability sd on s.GStudentID = sd.GStudentID -- deleted records already eliminated in this view
	join DataConversionDisabilityCode d on sd.DisabilityID = d.SDECode
)

select 
	d.StudentRefID,
	d.StudentDisabRecNum,
	d.DisabilityCode, 
	d.DisabilityDesc,
	d.PrimaryDisability,
	d.DisabilityOrder
from DataConversionDisabilityCode m
right join DisabilityCTE d on 
	m.SDECode = d.DisabilityCode or
	m.SDEDesc = d.DisabilityDesc --or
	--d.DisabilityDesc like m.FuzzyDesc

union all

select 
	d.StudentRefID,
	d.StudentDisabRecNum,
	d.DisabilityCode, 
	d.DisabilityDesc,
	d.PrimaryDisability,
	d.DisabilityOrder
from DataConversionDisabilityCode m
right join DisabilityCTE d on 
	m.SDECode = d.DisabilityCode or
	m.SDEDesc = d.DisabilityDesc
where m.SDECode is null
go

--select DisabilityCode, DisabilityDesc, count(*) tot
--from DataConversionDisabilityCodeView
--group by DisabilityCode, DisabilityDesc
--order by 1

