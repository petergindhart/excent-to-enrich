SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TestScoreDefinitionFlattened]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[TestScoreDefinitionFlattened]
GO


/*
Flattens a test score hierarchy.
Arguments:
@testDefinition - optional. If specified, retricts the flattening to a single test
*/
CREATE FUNCTION dbo.TestScoreDefinitionFlattened(@testDefinition uniqueidentifier)
RETURNS @ret TABLE (
	ID uniqueidentifier primary key,
	TestDefinitionID uniqueidentifier,
	FullName varchar(2000),
	Sequence float
	)
AS
BEGIN

declare @seperator varchar(10);		set @seperator = ' > '
declare @seqDigitsPerTier int;		set @seqDigitsPerTier = 3

-- Process the sections in tiers
declare @depth int; set @depth = 0
declare @sections table(ID uniqueidentifier primary key, FullName varchar(2000), Depth int, TestDefinitionID uniqueidentifier, Sequence bigint)


-- Get root sections
insert into @sections
select Id, Name, @depth, TestDefinitionID, Sequence
from TestSectionDefinition
where Parent is null and (@testDefinition is null or TestDefinitionID = @testDefinition)

-- Iterate over each tier until no more remain
while @depth = 0 or exists(select ID from @sections where Depth = @depth)
begin
	set @depth = @depth + 1

	-- Allocate digits in the sequence number for the new sections
	update @sections
	set Sequence = Sequence * power(10, @seqDigitsPerTier)

	-- Get next set of sections
	insert into @sections
	select
		child.Id, parent.FullName + @seperator + child.Name, @depth, child.TestDefinitionID, parent.Sequence + child.Sequence
	from
		TestSectionDefinition child join
		@sections parent on child.Parent = parent.Id
	where
		parent.Depth = @depth-1
end

-- Now that the sections are flattened, build the final, flattened, score table
insert into @ret
select
	scr.Id, sec.TestDefinitionID, sec.FullName + @seperator + scr.Name, sec.Sequence + scr.Sequence
from
	TestScoreDefinition scr join
	@sections sec on scr.TestSectionDefinitionID = sec.Id


RETURN 
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

