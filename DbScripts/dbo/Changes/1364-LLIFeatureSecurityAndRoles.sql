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
set @testFamilyID = '2bdc6395-1e50-4344-8c4f-06caa51f32d8'
set @testDefinitionID = '9afe80ba-730f-4099-b126-9c6a9aafadfe'
-- Get these values from the Management System
set @feature = '4ba47776-6eae-49c7-a219-dfbc0d314968'
set @featureName = 'Test.LLI'
-- Get the class path in VC3.TestView.Tests 
-- (Ex. 'VC3.TestView.Tests.National.LLI.LLIScoreCalculator, VC3.TestView.Tests')
-- NOTE: ", VC3.TestView.Tests" is required
set @testDefinitionScoreCalculator = 'VC3.TestView.Tests.CO.LLI.LLIScoreCalculator, VC3.TestView.Tests' -- set to null if no calculator
set @testImportHandlerType = Null -- set to null if no handler 
-- Decide on display name for file format 
-- (Ex. Fall (2010))
set @testImportHandlerName = Null -- set to null if no handler
-- Generate this once : select NEWID()
set @testImportHandlerID = Null -- set to null if no handler


-- Code to generate @tasks table
/*
select 'insert into @tasks(TaskID, TaskCategoryID, Name) values(''' + cast(NEWID() as varchar(36)) + ''', ''' + cast(NEWID() as varchar(36)) + ''', ''' + Task + ''')'
from
	(select Task='Add' union all select 'Edit' union all select 'View' union all select 'Delete') n
*/
insert into @tasks(TaskID, TaskCategoryID, Name) values('AB9DF168-40C6-46F5-A63D-64091449DCFE', '742AF34B-5FAA-409E-A1EF-EF9E65064415', 'Add')
insert into @tasks(TaskID, TaskCategoryID, Name) values('3B338C1E-B872-4DF2-A075-199F85586450', 'A6BDA9F6-9D81-461A-8FB8-D22B691AA96A', 'Edit')
insert into @tasks(TaskID, TaskCategoryID, Name) values('1195A1EA-CFC4-4496-8544-9E07733D2BC2', 'A34FFDEB-69F5-41D4-950E-253E27CDE15A', 'View')
insert into @tasks(TaskID, TaskCategoryID, Name) values('9501DB84-EB72-42E8-B722-1B9C8A48005C', '2D23AEF7-53E7-466D-AAD7-E0CD01ACDFD6', 'Delete')

-- Code to generate TestAdministrationType inserts
/*
declare @admins varchar(100);
declare @testDefs varchar(100);

-- UPDATE THESE VALUES:
set @admins = 'Ongoing'
set @testDefs = '9afe80ba-730f-4099-b126-9c6a9aafadfe'   -- comma seperated for multiple
---

select 'INSERT TestAdministrationType(ID, TestDefinitionID, Name, Sequence) VALUES (''' + cast(NEWID() as varchar(36)) + ''',  ''' + test.Item + ''', ''' + admin.Item + ''',0)'
from
	dbo.Split(@admins, ',') admin cross join
	dbo.Split(@testDefs, ',') test
*/
INSERT TestAdministrationType(ID, TestDefinitionID, Name, Sequence) VALUES ('C58D0CC9-F48F-49F6-BA84-FE2AFE9EC428',  '9afe80ba-730f-4099-b126-9c6a9aafadfe', 'Ongoing',0)



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
