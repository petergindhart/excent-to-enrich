-- INSTRUCTIONS:
-- Copy/Paste this code into the end of the SQL change script that adds the test.
-- Modify the variables at the top of the script to refer to the specific test that was added.
-- Note that some of the statements can be generated using the comment SQL above them.

declare @testFamilyID uniqueidentifier
declare @testDefinitionID uniqueidentifier
declare @testDefinitionScoreCalculator varchar(150)
declare @feature uniqueidentifier
declare @featureName varchar(100)
declare @tasks table(TaskID uniqueidentifier, TaskCategoryID uniqueidentifier, Name varchar(100))
declare @testImportHandlerID uniqueidentifier
declare @testImportHandlerName varchar(100)
declare @testImportHandlerType varchar(150)
--------------------------------------------------------------------------------------------------------------
-- Update these with test-specific values
-- Get these values from test designer generated file
set @testFamilyID = '3D574708-03CE-431C-BA50-33FF9A78617B'
set @testDefinitionID = 'C8E87F83-392B-44E3-9A37-742CFE45708F'
-- Get these values from the Management System
set @feature = '8FF300E1-5DB3-4A66-89E5-BCC906E3A13D'
set @featureName = 'Test.National.ACT'
-- Get the class path in VC3.TestView.Tests 
-- (Ex. 'VC3.TestView.Tests.National.LLI.LLIScoreCalculator, VC3.TestView.Tests')
-- NOTE: ", VC3.TestView.Tests" is required
set @testDefinitionScoreCalculator = Null -- set to null if no calculator
set @testImportHandlerType = 'VC3.TestView.Tests.National.ACT.FileFormat_2010, VC3.TestView.Tests' -- set to null if no handler 
-- Decide on display name for file format 
-- (Ex. Fall (2010))
set @testImportHandlerName = 'ACT (Fall 2010 - Present)' -- set to null if no handler
-- Generate this once : select NEWID()
set @testImportHandlerID = 'A8458E5D-CBE9-4FF2-9C71-A5532C4FE6B4' -- set to null if no handler


-- Code to generate @tasks table
/*
select 'insert into @tasks(TaskID, TaskCategoryID, Name) values(''' + cast(NEWID() as varchar(36)) + ''', ''' + cast(NEWID() as varchar(36)) + ''', ''' + Task + ''')'
from
	(select Task='Add' union all select 'Edit' union all select 'View' union all select 'Delete') n
*/
insert into @tasks(TaskID, TaskCategoryID, Name) values('64ABB587-B4C0-4CFD-AB57-D00270019BAF', 'F57120D7-48B1-4E05-ADE7-1888CC133835', 'Add')
insert into @tasks(TaskID, TaskCategoryID, Name) values('5BF10BE5-CC9E-4D93-8FAE-AF4E4681FB9D', '9168BE61-AB73-48DF-AB1F-E3005CF2444D', 'Edit')
insert into @tasks(TaskID, TaskCategoryID, Name) values('D4F5D7C4-333A-4CC8-AA9A-CA5A3C039677', 'FF0DCC34-D200-4701-8108-198F979B273D', 'View')
insert into @tasks(TaskID, TaskCategoryID, Name) values('7A89703A-1096-4F12-AECA-562B96BFA540', 'C7E1BF23-8D32-435A-8AC0-3C05482C8B2A', 'Delete')

-- Code to generate TestAdministrationType inserts
/*
declare @admins varchar(100);
declare @testDefs varchar(100);

-- UPDATE THESE VALUES:
set @admins = 'Spring,Fall'
set @testDefs = 'CF135B7D-2F4C-4636-B4C4-B91651C62648'   -- comma seperated for multiple
---

select 'INSERT TestAdministrationType(ID, TestDefinitionID, Name, Sequence) VALUES (''' + cast(NEWID() as varchar(36)) + ''',  ''' + test.Item + ''', ''' + admin.Item + ''',0)'
from
	dbo.Split(@admins, ',') admin cross join
	dbo.Split(@testDefs, ',') test
*/


--------------------------------------------------------------------------------------------------------------
--- no need to change this stuff below --
UPDATE TestDefinitionFamily
SET  status='C'
WHERE ID = @testFamilyID

UPDATE TestDefinition
SET ScoreCalculatorClassName = @testDefinitionScoreCalculator
WHERE ID = @testDefinitionID

IF @testImportHandlerType is not null and @testImportHandlerName is not null and @testImportHandlerID is not null 
begin
	insert into TestImportHandler (ID,Name,TypeName) values(@testImportHandlerID,@testImportHandlerName,@testImportHandlerType)
	insert into TestImportHandlerTestDefinitionFamily (FamilyID,HandlerID) values (@testFamilyID, @testImportHandlerID) 
end

insert Feature values(@feature, @featureName)

insert SecurityTaskCategory(ID, Name, ParentID, Sequence, FeatureID)
select
	TaskCategoryID,
	Name,
	case Name
		when 'Add' then 'EF0DBDC9-E79F-431F-AFA8-FF870677D890'
		when 'Edit' then '2DD374FC-6DAE-4045-AE0E-923A865FD930'
		when 'View' then '03EB1A8F-27D7-4969-9464-6F848DE26D50'
		when 'Delete' then '2DE1A9B0-1480-46E6-AA0B-DC411F5EC495'
		else null
	end,
	0,
	@feature
from @tasks

insert SecurityTask(ID, CategoryID, SecurityTaskTypeID, ContextTypeID, TargetID, Sequence)
select
	TaskID,
	TaskCategoryID,
	case Name
		when 'Add'		then '11E647DA-1D7E-40E3-8E28-CD6081E71810'
		when 'Edit'		then '559A77A8-17BE-4B34-AD92-60CAADD7ADE0'
		when 'View'		then 'B8C1F0B5-BF4E-426A-AA42-31EF12A13025'
		when 'Delete'	then 'CF8EB5B5-5E56-4DE5-B8CC-4DED08D7964B'
		else null
	end,
	'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4',
	@testFamilyID,
	0
from @tasks

insert into SecurityRoleSecurityTask(TaskID, RoleID)
select t.TaskID, grants.RoleID
from
	@tasks t join
	(
		-- roles that have access to all tasks in the Add, Edit, View or Delete category
		select
			RoleID = sr.ID,
			Name =	case existingTask.SecurityTaskTypeID
						when '11E647DA-1D7E-40E3-8E28-CD6081E71810'	then 'Add'		
						when '559A77A8-17BE-4B34-AD92-60CAADD7ADE0'	then 'Edit'		
						when 'B8C1F0B5-BF4E-426A-AA42-31EF12A13025'	then 'View'		
						when 'CF8EB5B5-5E56-4DE5-B8CC-4DED08D7964B'	then 'Delete'	
						else null
					end
		from
			SecurityTask existingTask cross join
			SecurityRole sr left join
			SecurityRoleSecurityTask granted on granted.RoleID = sr.ID and granted.TaskID = existingTask.ID
		where
			existingTask.SecurityTaskTypeID in(
				'11E647DA-1D7E-40E3-8E28-CD6081E71810',
				'559A77A8-17BE-4B34-AD92-60CAADD7ADE0',
				'B8C1F0B5-BF4E-426A-AA42-31EF12A13025',
				'CF8EB5B5-5E56-4DE5-B8CC-4DED08D7964B'			
			) and
			existingTask.ID not in (select TaskID from @tasks)
		group by
			sr.ID, existingTask.SecurityTaskTypeID
		having
			sum(case when granted.TaskID is null then 0 else 1 end) = COUNT(*)
		
		-- Or, if the role can edit users then grant all tasks
		union
		select
			granted.RoleID,
			task.Name
		from
			SecurityRoleSecurityTask granted cross join
			(select Name from @tasks) task
		where
			granted.TaskID = '4CA7CCC3-798C-44D2-B1A5-C1BBCC6B8448' -- edit user
		
	) grants on grants.Name = t.Name join
	SecurityRole sr on grants.RoleID = sr.ID


-- Added to change names to reflect new naming convention for test features
 
update feature set name='Test.SC.TABE'where name ='Test.TABE'
update feature set name='Test.SC.Abacus'where name ='Test.Abacus'
update feature set name='Test.National.AEPS'where name ='Test.AEPS'
update feature set name='Test.National.DRA'where name ='Test.DRA'
update feature set name='Test.National.RAVEN'where name ='Test.RAVEN'
update feature set name='Test.National.ELSA'where name ='Test.ELSA'
update feature set name='Test.National.DIBELS'where name ='Test.DIBELS'
update feature set name='Test.National.DOMINIE'where name ='Test.DOMINIE'
update feature set name='Test.MI.MEAP'where name ='Test.MEAP'
update feature set name='Test.CO.MONDO'where name ='Test.MONDO'
update feature set name='Test.SC.Lex4Benchmark'where name ='Test.Lex4Benchmark'
update feature set name='Test.CO.LLI'where name ='Test.LLI'
update feature set name='Test.SC.Reading3D'where name ='Test.Reading3D'