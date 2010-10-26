SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BrowseUtility_GetInterventionYearTierSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[BrowseUtility_GetInterventionYearTierSummary]
GO

 /*
<summary>
Gets the number of interventions for a specific school by Year and Tier
</summary>
<param name="schoolId">Id of the School</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.BrowseUtility_GetInterventionYearTierSummary 
	@schoolId uniqueidentifier
AS

	declare @sql varchar(8000),
		@outerSchool varchar(100),
		@innerSchool varchar(100)
	
	select @outerSchool = ' ', @innerSchool = ' '
	
	if ( not @schoolId is null )
	begin
		set @outerSchool = ' where v.SchoolId = ''' + cast(@schoolId as varchar(36)) + ''' '
		set @innerSchool = ' and SchoolId = ''' + cast(@schoolId as varchar(36)) + ''' '
	end
	
	set @sql = 'select v.RosterYearId, '
	
	select @sql = @sql + '[' + t.Name + '] = (select count(*) from InterventionSummaryView where RosterYearId = v.RosterYearId and TierId = ''' + 
		cast(t.Id as varchar(36)) + '''' + @innerSchool + '), '
	from Tier t
	order by t.Sequence
	
	set @sql = @sql + ' count(*) Total from InterventionSummaryView v ' + @outerSchool + ' group by v.RosterYearId'
	
	exec RunSql @sql, 1, 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

