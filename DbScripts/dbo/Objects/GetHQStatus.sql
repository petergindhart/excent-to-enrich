--#include GetHQStatusDetail.sql

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[HQSatisfactionStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [HQSatisfactionStatus]
GO

CREATE TABLE [HQSatisfactionStatus] (
	[Id] [int] NULL ,
	[StatusName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StatusGroup] [int] NULL ,
	[StatusOrder] [int] NULL 
) ON [PRIMARY]
GO

insert HQSatisfactionStatus values( 0,'HQ Met',0,0 )
insert HQSatisfactionStatus values( 1,'HQ Partially Met',0,1 )
insert HQSatisfactionStatus values( 2,'HQ Not Met',0,2 )
insert HQSatisfactionStatus values( 3,'Certified Met',1,3 )
insert HQSatisfactionStatus values( 4,'Certified Not Met',1,4 )
insert HQSatisfactionStatus values( 5,'Content Area Unknown',2,5 )
insert HQSatisfactionStatus values( 6,'Requirements Unknown',3,6 )
insert HQSatisfactionStatus values( 7,'NA',4,7 )
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetHqStatus]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetHqStatus]
GO


CREATE  function [dbo].[GetHqStatus]
(
	@FirstDate datetime,
	@SecondDate datetime
)
returns table 
as
	

Return 
(

	select
		A.[SchoolID], A.[SchoolName], A.[SchoolAbbreviation], A.[SchoolOrder],
		A.[Status], A.StatusName, A.StatusGroup, A.[StatusOrder], 
		sum( A.[FirstTotal] ) [FirstTotal],
		sum( A.[SecondTotal] ) [SecondTotal]
	from
		(
			select
				A.[SchoolID], A.[SchoolName], A.[SchoolAbbreviation], A.[SchoolOrder],
				A.[Status], A.StatusName, A.StatusGroup, A.[StatusOrder], 
				isnull(B.[FirstTotal],0) [FirstTotal], isnull(B.[SecondTotal],0) [SecondTotal]
			from
				(	-- School x Status
					select
						SchoolID, SchoolName, SchoolAbbreviation, SchoolOrder, Status, StatusName, StatusGroup, StatusOrder
					from
						(
							select
								ID [SchoolID], Name [SchoolName], 
								case when Abbreviation is null or len(Abbreviation) = 0 then Name else Abbreviation end [SchoolAbbreviation],
								1 [SchoolOrder]
							from
								School union
							select Null, 'District', 'District', 0
						) a cross join
						(
							select
								Id [Status], StatusName, StatusGroup, StatusOrder
							from
								HQSatisfactionStatus
						) b 
				) A left join
				(	-- HQ Status Detail Before and After
					select
						[SchoolID]	= isnull( s1.SchoolID, s2.SchoolID ), 
						[Status]	= isnull( s1.Status, s2.Status ), 
						[FirstTotal]	= isnull( s1.[Count], 0 ), 
						[SecondTotal]		= isnull( s2.[Count], 0 )
					from
						(
							select
								s1.SchoolID, s1.Status, count(*) [Count]
							from
								dbo.GetHQStatusDetail( @FirstDate ) s1
							group by s1.SchoolID, s1.Status
						) s1 full join
						(
							select
								s2.SchoolID, s2.Status, count(*) [Count]
							from
								dbo.GetHQStatusDetail( @SecondDate ) s2
							group by s2.SchoolID, s2.Status
						) s2 on
							s1.SchoolID = s2.SchoolID and
							s1.Status = s2.Status
				) B on
					(A.SchoolID is null or A.SchoolID = B.[SchoolID]) and
					A.Status = B.[Status]
		) A
	group by A.[SchoolID], A.[SchoolName], A.[SchoolAbbreviation], A.[SchoolOrder],
		A.[Status], A.StatusName, A.StatusGroup, A.[StatusOrder]

)



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

