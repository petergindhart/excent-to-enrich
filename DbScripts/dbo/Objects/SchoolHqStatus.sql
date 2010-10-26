SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SchoolHqStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SchoolHqStatus]
GO

/*
<summary>
Gets records showing status summarized by school and date.  </summary>
<param name="StartDate">Status date input by user.  Used for comparison.</param>
<param name="EndDate">Status date input by user.</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
<test> SchoolHQStatus '1-1-2002','1-1-2007' </test>
*/
CREATE  PROCEDURE [dbo].[SchoolHqStatus]
(	
	@StartDate datetime,
	@EndDate datetime
)
As
Begin

	set nocount on

	declare @UnknownCA varchar(25),
		@UnknownReq varchar(25),
		@HQ varchar(25),
		@NotHQ varchar(25),
		@Cert varchar(25),
		@NotCert varchar(25)
	
	set @UnknownCA = 'Unknown Content Area'
	set @UnknownReq = 'Unknown Requirements'
	set @HQ = 'Highly Qualified'
	set @NotHQ = 'Not Highly Qualified'
	set @Cert = 'Certified'
	set @NotCert = 'Not Certified'
	
	Declare @Results Table
	(
		SchoolId			uniqueIdentifier,
		SchoolName			varchar(50),
		SchoolAbbreviation	varchar(10),
		[Date]				DateTime,
		Status				varchar(25),
		[Count]				int
	)

	-- gather counts
	insert Into @Results
	select
		School.ID,
		School.Name,
		School.Abbreviation,
		Dates.[Date],
		Status.Status,
		isnull(Counts.[Count], 0)
	from
		School cross join
		(
			select @StartDate [Date] union all
			select @EndDate
		) Dates cross join
		(
			Select @UnknownCA [Status] union all
			Select @UnknownReq union all
			Select @HQ union all
			Select @NotHQ union all
			Select @Cert union all
			Select @NotCert 
		) Status left join
		(
			Select
				SchoolId, @StartDate [Date], Status, count(*) [Count]
			From 
				dbo.GetHqStatusDetail(@StartDate)
			group by
				SchoolId, Status
	
			union all
			
			Select
				SchoolId, @EndDate, Status, count(*)
			From 
				dbo.GetHqStatusDetail(@EndDate)
			group by
				SchoolId, Status
		) Counts on
			Counts.SchoolID	= School.ID and
			Counts.Status	= Status.Status and
			Counts.Date		= Dates.Date

	set nocount off

	-- display school totals and
	-- district totals
	select
		R.SchoolName,
		R.SchoolAbbreviation,
		R.SchoolID,
		R.[Date],
		R.Status,
		R.[Count],
		1 [SortGroup],
		cast(0 as bit) [IsDistrict]
	from
		@Results R union all
	select
		'District',
		null,
		null,
		[Date],
		Status,
		Sum([Count]),
		0,
		cast(1 as bit)
	from
		@Results R
	group by Date, Status
	order by SortGroup, SchoolName, Status

End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

