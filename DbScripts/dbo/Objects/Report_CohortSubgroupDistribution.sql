IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Report_CohortSubgroupDistribution' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Report_CohortSubgroupDistribution
GO

create procedure dbo.Report_CohortSubgroupDistribution
	@schoolIds varchar(8000),
	@startDate datetime,
	@endDate datetime,
	@cohorts varchar(100),
	@subset varchar(100),
	@subgroup varchar(100)
as	

declare @status uniqueidentifier
declare @variant uniqueidentifier

declare @schools table (ID uniqueidentifier primary key)
insert into @schools 
select Id
from dbo.GetUniqueIdentifiers(@schoolIds)

-- determine baseline students
declare @dataset table (StudentID uniqueidentifier primary key, InSubset int, School varchar(100), Subgroup varchar(100))

if @cohorts = 'enrolled'
	insert into @dataset
	select ssh.StudentID, 0, max(sch.Name), null
	from
		School sch join
		StudentSchoolHistory ssh on sch.ID = ssh.SchoolID join
		@schools filter on filter.ID = ssh.SchoolID
	where
		dbo.DateRangesOverlap(@startDate, @endDate, ssh.StartDate, ssh.EndDate, GETDATE()) = 1
	group by ssh.StudentID

if @cohorts like 'prgstatus:%'
begin
	set @status = cast(substring(@cohorts, len('prgstatus:')+1, 36) as uniqueidentifier)
	set @variant = case when @cohorts like '%variant:%' then cast(right(@cohorts, 36) as uniqueidentifier) else null end
	
	insert into @dataset
	select distinct ssh.StudentID, 0, sch.Name, null
	from
		School sch join
		StudentSchoolHistory ssh on sch.ID = ssh.SchoolID join
		@schools filter on filter.ID = ssh.SchoolID join
		PrgInvolvement inv on inv.StudentID = ssh.StudentID join
		PrgInvolvementStatus invstat on invstat.InvolvementID = inv.ID
	where
		dbo.DateRangesOverlap(@startDate, @endDate, ssh.StartDate, ssh.EndDate, GETDATE()) = 1 and
		dbo.DateRangesOverlap(@startDate, @endDate, invstat.StartDate, invstat.EndDate, GETDATE()) = 1 and
		invstat.StatusID = @status and
		(@variant is null or inv.VariantID = @variant)
end


-- determine which students match comparision condition
if @subset like 'prgstatus:%'
begin
	set @status = cast(substring(@subset, len('prgstatus:')+1, 36) as uniqueidentifier)
	set @variant = case when @subset like '%variant:%' then cast(right(@subset, 36) as uniqueidentifier) else null end

	update ds
	set
		InSubset = 1
	from
		@dataset ds join
		PrgInvolvement inv on inv.StudentID = ds.StudentID join
		PrgInvolvementStatus invstat on invstat.InvolvementID = inv.ID
	where
		invstat.StatusID = @status and
		(@variant is null or inv.VariantID = @variant) and
		dbo.DateRangesOverlap(@startDate, @endDate, invstat.StartDate, invstat.EndDate, GETDATE()) = 1
end

if @subset = 'iep'
	-- IEP flag from SIS
	update ds
	set
		InSubset = case when rand(cast(newid() as varbinary)) < .15 then 1 else 0 end --x_SpecialEd  TODO: need to make this dynamic
	from
		@dataset ds join
		Student s on s.ID = ds.StudentID


-- determine group
if @subgroup = 'ethnicity'
	update ds
	set
		Subgroup = eth.DisplayValue
	from
		@dataset ds join
		Student s on s.ID = ds.StudentID join
		EnumValue eth on eth.ID = s.EthnicityID

if @subgroup = 'gender'
	update ds
	set
		Subgroup = gen.DisplayValue
	from
		@dataset ds join
		Student s on s.ID = ds.StudentID join
		EnumValue gen on gen.ID = s.GenderID

		select
			School,
			Subgroup,
			SubgroupCohortCount = COUNT(*),
			SubgroupSubsetCount = SUM(InSubset)
		from
			@dataset result
		group by
			School,
			Subgroup
GO

/*
exec Report_CohortSubgroupDistribution	
	@schoolIds = 'BD4F5CB3-2378-46A0-BED3-14BA2F8A320B|9557B45F-72F0-431C-B123-1DC7C9505BF3',
	@startDate = '1/1/2010',
	@endDate = '3/1/2010',
	@subset = 'iep',
	@cohorts = 'enrolled',
	@subgroup = 'ethnicity'
	

exec Report_CohortSubgroupDistribution	
	@schoolIds = 'BD4F5CB3-2378-46A0-BED3-14BA2F8A320B|9557B45F-72F0-431C-B123-1DC7C9505BF3',
	@startDate = '1/1/2010',
	@endDate = '3/1/2010',
	@subset = 'prgstatus:F888BA81-7B57-BF4E-9444-6F01C5ECE1FB',
	@cohorts = 'prgstatus:A2316C5C-1B
	05-BD4E-8BFC-C2012B908A90',
	@subgroup = 'ethnicity'
*/
	
	