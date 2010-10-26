if exists (
	select * 
	from dbo.sysobjects 
	where id = object_id(N'[dbo].[GetProcessesBySchool]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetProcessesBySchool]
GO


 /*
<summary>
Returns Process ids for the specified ProcessType and School (optional).  If the associated
ProcessTargetType is not school bound, no filtering by school will occur.  A handling branch
must be added for any ProcessTargetType that is school bound.
</summary>
*/
CREATE FUNCTION dbo.GetProcessesBySchool
(
	@processTypeId uniqueidentifier,
	@schoolId uniqueidentifier
)
RETURNS @processIds table(Id uniqueidentifier) AS
BEGIN
	
	declare
		@targetTypeId uniqueidentifier,
		@isSchoolBound bit
	
	select
		@targetTypeId = ptt.Id,
		@isSchoolBound = ptt.IsSchoolBound
	from
		ProcessType pt join
		ProcessTargetType ptt on pt.TargetTypeId = ptt.Id
	where pt.Id = @processTypeId
	
	-- no school specified, or not school bound
	IF(@schoolId is null or @isSchoolBound = 0)
	BEGIN
		insert @processIds
		select Id
		from Process
		where TypeId = @processTypeId
	END
	-- specific school
	ELSE
	BEGIN
		--########################################################
		-- ProcessTargetType handling branches.
	
		-- AcademicPlan
		IF(@targetTypeId = 'C3BB50DD-22DC-4F3E-8DDC-20EE253506A8')
		BEGIN
			insert @processIds
			select p.Id
			from 
				Process p join
				AcademicPlan a on p.TargetId = a.Id
			where 
				TypeId = @processTypeId and
				a.SchoolId = @schoolId
		END
	
		-- QualificationPlan
		ELSE IF(@targetTypeId = 'CDE24B20-DFDC-4655-A7AB-2F96572F77F0')
		BEGIN
			insert @processIds
			select p.Id
			from 
				Process p join
				QualificationPlan a on p.TargetId = a.Id join
				Teacher t on a.TeacherId = t.Id
			where 
				TypeId = @processTypeId and
				t.CurrentSchoolId = @schoolId
		END
	
		-- ERROR: Unhandled ProcessTargetType
		-- perform invalid cast to raise error
		ELSE
		BEGIN
			insert @processIds
			select 'Unhandled ProcessTargetType in dbo.GetProcessesBySchool, ID=' 
				+ cast(@targetTypeId as varchar(36))
		END
	
		--########################################################
	END
	
	RETURN
END
GO


/*
	BUILD TEST
	A developer may not know that a new ProcessTargetType will require
	a handling section in dbo.GetProcessesBySchool(@targetTypeId, @schoolId).
	The following section executes GetProcessBySchool for each school bound
	ProcessTargetTypea for a random school.
*/
DECLARE 
	@schoolId varchar(36),
	@processTypeId varchar(36),
	@sql varchar(200)

SET @schoolId = (select top 1 cast(Id as varchar(36)) from School)

DECLARE targetTypesCur CURSOR FOR
select
	(select top 1 cast(id as varchar(36)) from ProcessType where TargetTypeId = ptt.Id)
from ProcessTargetType ptt
where ptt.IsSchoolBound = 1

OPEN targetTypesCur

FETCH NEXT FROM targetTypesCur INTO @processTypeId

WHILE @@FETCH_STATUS = 0
BEGIN
	select @sql = 'declare @res int; select @res = count(*) from dbo.GetProcessesBySchool('''+@processTypeId+''','''+@schoolId+''')'
	exec( @sql )
	FETCH NEXT FROM targetTypesCur INTO @processTypeId
END

CLOSE targetTypesCur
DEALLOCATE targetTypesCur