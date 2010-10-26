--#include TeacherCertificationSet_Recalculate.sql
--#include Util_RaiseStatus.sql

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TeacherContentArea_Recalculate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TeacherContentArea_Recalculate]
GO

/*
<summary>
Recalculates the contents of the TeacherContentArea table
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.TeacherContentArea_Recalculate
AS

	--##############################################################################

	set nocount on

	declare
		@debug int,
		@debugStart datetime

	set @debug = 0
	set @debugStart = getdate()

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'begin' end

	-- Ensure TeacherCertificationSet is up to date and clear TeacherContentArea

	exec TeacherCertificationSet_Recalculate

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'calculate TeacherCertificationSet' end

	delete from TeacherContentArea 

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'clear table' end

	--##############################################################################
	
	-- populate status, NC, and NA variables
	declare @Status table
	(
		StatusID uniqueidentifier,
		Name varchar(512),
		Code int
	)
	
	insert @Status
	select ID, DisplayValue, cast( Code as int )
	from EnumValue v
	where v.Type = '1123807C-0AC2-4683-8149-C1EB0F3E03E5'
	
	declare 
		@NC uniqueidentifier,
		@NA uniqueidentifier
	
	set	@NC = 'EFCDB5BD-02BC-4615-80A0-45389DDB6FB3'
	set	@NA = 'CCFB4A0C-43E5-4C94-B7F3-BAAC99A0539D'


	--##############################################################################
	-- RECORDS WITH POTENTIAL
	
	-- Gather Dates
	-- Once a teacher is determined to qualify for a content area in some way, ALL
	-- dates and grades for that area are determined.  This squaring of data between
	-- dates and grades is necessary for clean folding later.
	-- Also notice the query for grabbing grades ensures non overlapping slices.
	insert	TeacherContentArea ( TeacherID, ContentAreaID, StartDate, GradeBitMask )
	select
		dates.TeacherID, dates.ContentAreaID, dates.StartDate, grades.BitMask
	from
		(
			select
				tcs.TeacherID, car.ContentAreaID, tcs.StartDate -- CERT SET START
			from
				TeacherCertificationSet tcs join
				ContentAreaRequirement car on tcs.CertificationSetID = car.CertificationSetID
			where
				dbo.DateRangesOverlap( tcs.StartDate, tcs.EndDate, car.StartDate, car.EndDate, null ) = 1
			union
			select
				tcs.TeacherID, car.ContentAreaID, tcs.EndDate -- CERT SET END
			from
				TeacherCertificationSet tcs join
				ContentAreaRequirement car on tcs.CertificationSetID = car.CertificationSetID
			where
				tcs.EndDate is not null and
				dbo.DateRangesOverlap( tcs.StartDate, tcs.EndDate, car.StartDate, car.EndDate, null ) = 1
			union
			select
				tcs.TeacherID, car.ContentAreaID, car.StartDate -- REQ START
			from
				TeacherCertificationSet tcs join
				ContentAreaRequirement car on tcs.CertificationSetID = car.CertificationSetID
			union
			select
				tcs.TeacherID, car.ContentAreaID, car.EndDate -- REQ END
			from
				TeacherCertificationSet tcs join
				ContentAreaRequirement car on tcs.CertificationSetID = car.CertificationSetID
			where
				car.EndDate is not null
		) dates join
		(
			select
				A.ContentAreaID, A.BitMask
			from
				(
					select
						car.ContentAreaID, grb.BitMask
					from
						ContentAreaRequirement car join
						GradeRangeBitMask grb on grb.BitMask & car.GradeBitMask > 0
					group by car.ContentAreaID, grb.BitMask having sum( grb.BitMask & ~ car.GradeBitMask ) = 0
				) A left join
				(
					select
						car.ContentAreaID, grb.BitMask
					from
						ContentAreaRequirement car join
						GradeRangeBitMask grb on grb.BitMask & car.GradeBitMask > 0
					group by car.ContentAreaID, grb.BitMask having sum( grb.BitMask & ~ car.GradeBitMask ) = 0
				) B on A.ContentAreaID = B.ContentAreaID and A.BitMask <> B.BitMask
			group by A.ContentAreaID, A.BitMask having max( A.BitMask & B.BitMask ) <> A.BitMask
		) grades on dates.ContentAreaID = grades.ContentAreaID

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'chance: dates by cert set and req' end
	
	-- set status to 'NA' where content area has no reqs
	update	TeacherContentArea
	set	StatusID = @NA
	from	TeacherContentArea tca left join
	(
		select	tca.ContentAreaID, tca.StartDate
		from	TeacherContentArea tca join
			ContentAreaRequirement car on car.ContentAreaID = tca.ContentAreaID
		where	datediff( d, car.StartDate, tca.StartDate ) >= 0 and ( car.EndDate is null or datediff( d, tca.StartDate, car.EndDate ) > 0 )
		group by tca.ContentAreaID, tca.StartDate
	) havereq on havereq.ContentAreaID = tca.ContentAreaID and havereq.StartDate = tca.StartDate
	where	havereq.ContentAreaID is null

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'na: no reqs' end

	-- set status = 'NA' where exists an empty req
	update	TeacherContentArea
	set	StatusID = @NA
	from
		TeacherContentArea t join
		(
		select
			r.ContentAreaID, r.StartDate, r.EndDate
		from
			ContentAreaRequirement r left join
			CertificationSetCertificationView v on r.CertificationSetID = v.CertificationSetID
		where
			v.CertificationID is null
		) emptyreq on emptyreq.ContentAreaID = t.ContentAreaID
	where
		datediff( d, emptyreq.StartDate, t.StartDate ) >= 0 and ( emptyreq.EndDate is null or datediff( d, t.StartDate, emptyreq.EndDate ) > 0 ) and
		t.StatusID is null

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'na: empty req' end

	-- calculate status
	update
		TeacherContentArea
	set
		StatusID = case when maxLevel.Code < b.Level then maxLevel.StatusID else tcsLevel.StatusID end
	from
		TeacherContentArea a join
		(
			-- TCA => Req -> Status
			select
				TeacherID, ContentAreaID, StartDate, GradeBitMask, Level = max( Level )
			from
				(
					-- TCA -> Req -> CertSet -> Status
					select
						tca.TeacherID,
						tca.ContentAreaID,
						tca.StartDate,
						tca.GradeBitMask,
						car.CertificationSetID,
						s.Code [Level]
					from
						TeacherContentArea tca join
						ContentAreaRequirement car on
							tca.ContentAreaID = car.ContentAreaID and
							tca.GradeBitMask & car.GradeBitMask > 0 and
							datediff( d, car.StartDate, tca.StartDate ) >= 0 and ( car.EndDate is null or datediff( d, tca.StartDate, car.EndDate ) > 0 ) join
						TeacherCertificationSet tcs on
							car.CertificationSetID = tcs.CertificationSetID and
							tca.TeacherID = tcs.TeacherID and
							datediff( d, tcs.StartDate, tca.StartDate ) >= 0 and ( tcs.EndDate is null or datediff( d, tca.StartDate, tcs.EndDate ) > 0 ) join
						@Status s on s.StatusID = tcs.StatusID
				) T
			group by TeacherID, ContentAreaID, StartDate, GradeBitMask
		) b on
			a.TeacherID = b.TeacherID and
			a.ContentAreaID = b.ContentAreaID and
			a.StartDate = b.StartDate and
			a.GradeBitMask = b.GradeBitMask and
			a.StatusID is null join
		ContentArea ca on ca.ID = a.ContentAreaID join
		@Status maxLevel on maxLevel.StatusID = ca.MaxCertificationLevelID join
		@Status tcsLevel on tcsLevel.Code = b.Level
	
	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'calc status' end

	-- the rest are not certified
	update	TeacherContentArea
	set	StatusID = @NC
	where	StatusID is null

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'rest are nc' end

	--##############################################################################
	-- Calculate NoCredentials status
	--##############################################################################
	delete TeacherContentAreaNoCredentials
	
	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'clear NoCredentials' end

	-- gather content area / date for eventual nochance merge
	insert TeacherContentAreaNoCredentials ( ContentAreaID, GradeBitMask, StartDate )
	select
		dates.ContentAreaID, grades.BitMask, dates.StartDate
	from
	(
		select
			car.ContentAreaID,
			car.StartDate
		from	ContentAreaRequirement car
		union
		select
			car.ContentAreaID,
			car.EndDate
		from	ContentAreaRequirement car
		where	car.EndDate is not null
	) dates join
	(
		select
			A.ContentAreaID, A.BitMask
		from
			(
				select
					car.ContentAreaID, grb.BitMask
				from
					ContentAreaRequirement car join
					GradeRangeBitMask grb on grb.BitMask & car.GradeBitMask > 0
				group by car.ContentAreaID, grb.BitMask having sum( grb.BitMask & ~ car.GradeBitMask ) = 0
			) A left join
			(
				select
					car.ContentAreaID, grb.BitMask
				from
					ContentAreaRequirement car join
					GradeRangeBitMask grb on grb.BitMask & car.GradeBitMask > 0
				group by car.ContentAreaID, grb.BitMask having sum( grb.BitMask & ~ car.GradeBitMask ) = 0
			) B on A.ContentAreaID = B.ContentAreaID and A.BitMask <> B.BitMask
		group by A.ContentAreaID, A.BitMask having max( A.BitMask & B.BitMask ) <> A.BitMask
	) grades on dates.ContentAreaID = grades.ContentAreaID
	
	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'gather area, date, gradelevel' end

	-- set status to 'NA' where content area has no reqs
	update	TeacherContentAreaNoCredentials
	set	StatusID = @NA
	from	TeacherContentAreaNoCredentials tca left join
	(
		select	tca.ContentAreaID, tca.StartDate
		from	TeacherContentAreaNoCredentials tca join
			ContentAreaRequirement car on car.ContentAreaID = tca.ContentAreaID
		where	datediff( d, car.StartDate, tca.StartDate ) >= 0 and ( car.EndDate is null or datediff( d, tca.StartDate, car.EndDate ) > 0 )
		group by tca.ContentAreaID, tca.StartDate
	) havereq on havereq.ContentAreaID = tca.ContentAreaID and havereq.StartDate = tca.StartDate
	where	havereq.ContentAreaID is null and
		tca.StatusID is null
	
	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'na: no reqs' end

	-- set status = 'NA' where exists an empty req
	update	TeacherContentAreaNoCredentials
	set	StatusID = @NA
	from
		TeacherContentAreaNoCredentials t join
		(
		select
			r.ContentAreaID, r.StartDate, r.EndDate
		from
			ContentAreaRequirement r left join
			CertificationSetCertificationView v on r.CertificationSetID = v.CertificationSetID
		where
			v.CertificationID is null
		) emptyreq on emptyreq.ContentAreaID = t.ContentAreaID
	where
		datediff( d, emptyreq.StartDate, t.StartDate ) >= 0 and ( emptyreq.EndDate is null or datediff( d, t.StartDate, emptyreq.EndDate ) > 0 ) and
		t.StatusID is null
	
	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'na: empty req' end

	-- remaining status must be NC
	update	TeacherContentAreaNoCredentials
	set	StatusID = @NC
	where	StatusID is null

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'rest are nc' end
	
	--##############################################################################
	-- Insert records into TeacherContentArea for NoChance teachers
	--##############################################################################

	insert TeacherContentArea ( TeacherID, ContentAreaID, GradeBitMask, StartDate, EndDate, StatusID )
	select
		a.[TeacherID], b.ContentAreaID, b.GradeBitMask, b.StartDate, b.EndDate, b.StatusID
	from
		(
			select
				a.[TeacherID], a.ContentAreaID
			from
				(
				select
					t.ID [TeacherID],
					ca.ID [ContentAreaID]
				from
					Teacher t,
					ContentArea ca 
				) a left join
				TeacherContentArea b on a.[TeacherID] = b.TeacherID and a.[ContentAreaID] = b.ContentAreaID
			where
				b.TeacherID is null
		) a join
		TeacherContentAreaNoCredentials b on a.ContentAreaID = b.ContentAreaID

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'insert no chance records' end

	--##############################################################################
	-- Collapse records to a clean history consisting of NC, C, HQ
	--##############################################################################

	update TeacherContentArea
	set	StatusID = case when exists
			(
				select *
				from TeacherContentArea fa
				where
					fa.TeacherID = tca.TeacherID and
					fa.ContentAreaID = tca.ContentAreaID and
					fa.GradeBitMask = tca.GradeBitMask and
					fa.StartDate < tca.StartDate and
					fa.StatusID = tca.StatusID and
					not exists
						(
							select *
							from TeacherContentArea fb
							where fb.TeacherID = fa.TeacherID and
								fb.ContentAreaID = fa.ContentAreaID and
								fb.GradeBitMask = fb.GradeBitMask and
								fa.StartDate < fb.StartDate and
								fb.StartDate< tca.StartDate
						)
			) then @NA else tca.StatusID end,
		EndDate = 
			(
				select min( seda.StartDate )
				from TeacherContentArea seda
				where
					seda.TeacherID = tca.TeacherID and
					seda.ContentAreaID = tca.ContentAreaID and
					seda.GradeBitMask = tca.GradeBitMask and
					seda.StartDate > tca.StartDate and
					seda.StatusID <> tca.StatusID
			)
	from
		TeacherContentArea tca

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'collapse time' end

	delete from TeacherContentArea
	where	StatusID = @NA

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'del na' end

-- 	--##############################################################################
-- 	-- Collapse records by grade
-- 	--##############################################################################
-- 
-- 	-- merge grades into records with the highest GradeBitMask
-- 	update
-- 		TeacherContentArea
-- 	set	
-- 		GradeBitMask = 
-- 			(
-- 				select
-- 					SUM( DISTINCT( CAST( Bits.bin_val AS int ) ) )
-- 				from
-- 					TeacherContentArea join
-- 					Bits on GradeBitMask & Bits.bin_val = Bits.bin_val
-- 				where
-- 					TeacherID = tca.TeacherID and
-- 					ContentAreaID = tca.ContentAreaID and
-- 					StartDate = tca.StartDate and
-- 					(EndDate is null or EndDate = tca.EndDate) and
-- 					StatusID = tca.StatusID
-- 			)	
-- 	from
-- 		TeacherContentArea tca
-- 	where tca.GradeBitMask =
-- 		(
-- 			select
-- 				max( GradeBitMask )
-- 			from
-- 				TeacherContentArea
-- 			where
-- 				TeacherID = tca.TeacherID and
-- 				ContentAreaID = tca.ContentAreaID and
-- 				StartDate = tca.StartDate and
-- 				(EndDate is null or EndDate = tca.EndDate) and
-- 				StatusID = tca.StatusID
-- 		)
-- 
-- 	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'collapse grade (1)' end
-- 	
-- 	-- delete the records that arent the max GradeBitMask
-- 	delete tca
-- 	from
-- 		TeacherContentArea tca
-- 	where tca.GradeBitMask <>
-- 		(
-- 			select
-- 				max( GradeBitMask )
-- 			from
-- 				TeacherContentArea
-- 			where
-- 				TeacherID = tca.TeacherID and
-- 				ContentAreaID = tca.ContentAreaID and
-- 				StartDate = tca.StartDate and
-- 				(EndDate is null or EndDate = tca.EndDate) and
-- 				StatusID = tca.StatusID
-- 		)
-- 	
-- 	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'collapse grade (2)' end

	--##############################################################################
	-- Populate Min/Max GradeIDs
	--##############################################################################
	update TeacherContentArea
	set
		MinGradeID = g.MinGradeID,
		MaxGradeID = g.MaxGradeID
	from TeacherContentArea tca join
		GradeRangeBitMask g on
			tca.GradeBitMask = g.BitMask

	if @debug = 1 begin exec dbo.Util_RaiseStatus @debugStart, 'populate grade ids' end

	set nocount off

-- ##############################################################################

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
