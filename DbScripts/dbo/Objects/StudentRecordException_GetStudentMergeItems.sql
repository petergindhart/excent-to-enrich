IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentRecordException_GetStudentMergeItems]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentRecordException_GetStudentMergeItems]
GO

CREATE PROCEDURE [dbo].[StudentRecordException_GetStudentMergeItems]
(
	@studentRecordExceptionID uniqueidentifier
)
AS

DECLARE @results table (
	Name varchar(50),
	ColumnName varchar(50),
	TableName varchar(100),
	Student1Val varchar(100),
	Student2Val varchar(100),
	IsConflict bit,
	IsConflictReason varchar(1000),
	ResolutionCode char(1)	
)

DECLARE @stu1 uniqueidentifier
DECLARE @stu2 uniqueidentifier

SELECT
	@stu1 = Student1ID,
	@stu2 = Student2ID
FROM
	StudentRecordException
WHERE
	ID = @studentRecordExceptionID

INSERT @results select Name = 'First Name', ColumnName = 'FirstName', TableName = 'Student', Student1Val = stu1.FirstName, Student2Val = stu2.FirstName, IsConflict = case when IsNull(stu1.FirstName,'') = IsNull(stu2.FirstName,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.FirstName is not null and stu2.FirstName is not null then 1 when stu1.FirstName is not null and stu2.FirstName is null then 1  when stu1.FirstName is null and stu2.FirstName is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'Middle Name', ColumnName = 'MiddleName', TableName = 'Student', Student1Val = stu1.MiddleName, Student2Val = stu2.MiddleName, IsConflict = case when IsNull(stu1.MiddleName,'') = IsNull(stu2.MiddleName,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.MiddleName is not null and stu2.MiddleName is not null then 1 when stu1.MiddleName is not null and stu2.MiddleName is null then 1  when stu1.MiddleName is null and stu2.MiddleName is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'Last Name', ColumnName = 'LastName', TableName = 'Student', Student1Val = stu1.LastName, Student2Val = stu2.LastName, IsConflict = case when IsNull(stu1.LastName,'') = IsNull(stu2.LastName,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.LastName is not null and stu2.LastName is not null then 1 when stu1.LastName is not null and stu2.LastName is null then 1  when stu1.LastName is null and stu2.LastName is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'Student Number', ColumnName = 'Number', TableName = 'Student', Student1Val = stu1.Number, Student2Val = stu2.Number, IsConflict = case when IsNull(stu1.Number,'') = IsNull(stu2.Number,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.Number is not null and stu2.Number is not null then 1 when stu1.Number is not null and stu2.Number is null then 1  when stu1.Number is null and stu2.Number is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'SSN', ColumnName = 'SSN', TableName = 'Student', Student1Val = stu1.SSN, Student2Val = stu2.SSN, IsConflict = case when IsNull(stu1.SSN,'') = IsNull(stu2.SSN,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.SSN is not null and stu2.SSN is not null then 1 when stu1.SSN is not null and stu2.SSN is null then 1  when stu1.SSN is null and stu2.SSN is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'DOB', ColumnName = 'DOB', TableName = 'Student', Student1Val = stu1.DOB, Student2Val = stu2.DOB, IsConflict = case when IsNull(stu1.DOB,'') = IsNull(stu2.DOB,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.DOB is not null and stu2.DOB is not null then 1 when stu1.DOB is not null and stu2.DOB is null then 1  when stu1.DOB is null and stu2.DOB is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'Street', ColumnName = 'Street', TableName = 'Student', Student1Val = stu1.Street, Student2Val = stu2.Street, IsConflict = case when IsNull(stu1.Street,'') = IsNull(stu2.Street,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.Street is not null and stu2.Street is not null then 1 when stu1.Street is not null and stu2.Street is null then 1  when stu1.Street is null and stu2.Street is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'City', ColumnName = 'City', TableName = 'Student', Student1Val = stu1.City, Student2Val = stu2.City, IsConflict = case when IsNull(stu1.City,'') = IsNull(stu2.City,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.City is not null and stu2.City is not null then 1 when stu1.City is not null and stu2.City is null then 1  when stu1.City is null and stu2.City is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'State', ColumnName = 'State', TableName = 'Student', Student1Val = stu1.State, Student2Val = stu2.State, IsConflict = case when IsNull(stu1.State,'') = IsNull(stu2.State,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.State is not null and stu2.State is not null then 1 when stu1.State is not null and stu2.State is null then 1  when stu1.State is null and stu2.State is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'ZipCode', ColumnName = 'ZipCode', TableName = 'Student', Student1Val = stu1.ZipCode, Student2Val = stu2.ZipCode, IsConflict = case when IsNull(stu1.ZipCode,'') = IsNull(stu2.ZipCode,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.ZipCode is not null and stu2.ZipCode is not null then 1 when stu1.ZipCode is not null and stu2.ZipCode is null then 1  when stu1.ZipCode is null and stu2.ZipCode is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2
INSERT @results select Name = 'Phone Number', ColumnName = 'PhoneNumber', TableName = 'Student', Student1Val = stu1.PhoneNumber, Student2Val = stu2.PhoneNumber, IsConflict = case when IsNull(stu1.PhoneNumber,'') = IsNull(stu2.PhoneNumber,'') then 0 else 1 end, IsConflictReason = 'D', ResolutionCode = case when stu1.PhoneNumber is not null and stu2.PhoneNumber is not null then 1 when stu1.PhoneNumber is not null and stu2.PhoneNumber is null then 1  when stu1.PhoneNumber is null and stu2.PhoneNumber is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2

select * From @results 



/***********************************
**** GENERATOR FOR MERGE ITEMS *****
***********************************/

--DECLARE @mergeFields table (Name varchar(50), ColumnName varchar(50), TableName varchar(100))
--INSERT @mergeFields  VALUES ('First Name', 'FirstName','Student')
--INSERT @mergeFields  VALUES ('Middle Name', 'MiddleName','Student')
--INSERT @mergeFields  VALUES ('Last Name', 'LastName','Student')
--INSERT @mergeFields  VALUES ('Student Number',			'Number','Student')
--INSERT @mergeFields  VALUES ('SSN',				'SSN','Student')
--INSERT @mergeFields  VALUES ('DOB',				'DOB','Student')
--INSERT @mergeFields  VALUES ('Street',			'Street','Student')
--INSERT @mergeFields  VALUES ('City',			'City','Student')
--INSERT @mergeFields  VALUES ('State',			'State','Student')
--INSERT @mergeFields  VALUES ('ZipCode',			'ZipCode','Student')
--INSERT @mergeFields  VALUES ('Phone Number',		'PhoneNumber','Student')

--DECLARE @sql varchar(8000)
--SET @sql = ''

--select 
--@sql = @sql + char(13) + char(10) + 
--'INSERT @results select Name = ''' + mf.Name + ''', ColumnName = ''' + mf.ColumnName + ''', TableName = ''' + mf.TableName + ''', Student1Val = stu1.' +mf.ColumnName +', Student2Val = stu2.' + mf.ColumnName + ', IsConflict = case when IsNull(stu1.' + mf.ColumnName + ','''') = IsNull(stu2.'+ mf.ColumnName+ ','''') then 0 else 1 end, IsConflictReason = ''D'', ResolutionCode = case when stu1.' + mf.ColumnName + ' is not null and stu2.' + mf.ColumnName + ' is not null then 1 when stu1.' + mf.ColumnName + ' is not null and stu2.' + mf.ColumnName + ' is null then 1  when stu1.' + mf.ColumnName + ' is null and stu2.' + mf.ColumnName + ' is not null then 2 else  1 end  FROM Student stu1 join Student stu2 on stu1.ID = @stu1 and stu2.ID = @stu2'	
----INSERT @results select Name = ''' + mf.Name + ''', Student1Val = stu1.' +mf.ColumnName +', Student2Val = stu2.' + mf.ColumnName + ', IsConflict = case when IsNull(stu1.' + mf.ColumnName + ',''left'') = IsNull(stu2.'+ mf.ColumnName+ ',''right'') then 0 else 1 end, IsConflictReason = ''D'', ValueToUse = stu1.' + mf.ColumnName + ' FROM Student stu1 join Student stu2 on stu1.ID = ''F17FC4F6-E5B1-4411-BC1D-4554BE1BC153'' and stu2.ID = ''FB7E2746-7DE5-4305-BFAA-638950F036EF'''	
--FROM
--	Student stu1 join
--	Student stu2 on stu1.ID = 'F17FC4F6-E5B1-4411-BC1D-4554BE1BC153' and stu2.ID = 'F17FC4F6-E5B1-4411-BC1D-4554BE1BC153' cross join
--	@mergeFields mf
	
--print @sql
----exec(@sql)
