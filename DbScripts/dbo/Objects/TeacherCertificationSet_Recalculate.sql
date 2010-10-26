--#include CertificationSetCertificationView.sql

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TeacherCertificationSet_Recalculate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[TeacherCertificationSet_Recalculate]
GO

/*
<summary>
Recalculates the contents of the TeacherCertificationSet table
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.TeacherCertificationSet_Recalculate
AS

	set nocount on
--##############################################################################
-- populate status and NC variable
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
	
	declare @NC uniqueidentifier
	set	@NC = 'EFCDB5BD-02BC-4615-80A0-45389DDB6FB3'

--##############################################################################
-- clear table
	delete from TeacherCertificationSet

--##############################################################################
	-- RECORDS WITH POTENTIAL
	
	-- Teacher, CertSet, RelDates via Certification	
	insert TeacherCertificationSet ( TeacherID, CertificationSetID, StartDate )
	select
		tc.TeacherID, cv.CertificationSetID, tc.StartDate
	from
		TeacherCertification tc join
		CertificationSetCertificationView cv on tc.CertificationID = cv.CertificationID
	union
	select
		tc.TeacherID, cv.CertificationSetID, tc.EndDate
	from
		TeacherCertification tc join
		CertificationSetCertificationView cv on tc.CertificationID = cv.CertificationID
	where
		tc.EndDate is not null


	-- Mark as 'Not Certified' where they dont have them all for that day
	update TeacherCertificationSet
	set StatusID = @NC
	from TeacherCertificationSet tcs
	where
		(	-- Achieved
			select count(*)
			from
				TeacherCertification a join
				CertificationSetCertificationView b on a.CertificationID = b.CertificationID
			where
				a.TeacherID = tcs.TeacherID and
				b.CertificationSetID = tcs.CertificationSetID and
				datediff( d, a.StartDate, tcs.StartDate ) >= 0 and 
				( a.EndDate is null or datediff( d, tcs.StartDate, a.EndDate ) > 0 )
		) < -- Less Than
		(	-- Required
			select count(*)
			from
				CertificationSetCertificationView a
			where
				a.CertificationSetID = tcs.CertificationSetID	
		)

	-- Calculate the remaining Teacher / CertSet statuses
	update TeacherCertificationSet
	set StatusID = s.StatusID
	from
		TeacherCertificationSet tcs join
		(
			select
				TeacherID, CertificationSetID, StartDate, min( Code ) [Code]
			from
				(
					select
						tcs.TeacherID,
						tcs.CertificationSetID,
						tcs.StartDate,
						isnull( s.Code, 1 ) [Code] -- Endorsements get HQ
					from
						(
							select
								tcs.TeacherID,
								tcs.CertificationSetID,
								tcs.StartDate
							from
								TeacherCertificationSet tcs
							where
								tcs.StatusID is null
						) tcs join
						CertificationSetCertificationView v on tcs.CertificationSetID = v.CertificationSetID join
						(
							select
								tc.TeacherID,
								tc.CertificationID,
								tc.StartDate,
								tc.EndDate,
								tc.LevelID
							from
								TeacherCertification tc
						) tc on tc.CertificationID = v.CertificationID and tc.TeacherID = tcs.TeacherID left join
						@Status s on tc.LevelID = s.StatusID
					where
						datediff( d, tc.StartDate, tcs.StartDate ) >= 0 and 
						( tc.EndDate is null or datediff( d, tcs.StartDate, tc.EndDate ) > 0 )
				) T
			group by TeacherID, CertificationSetID, StartDate
		) T on 
			tcs.TeacherID = T.TeacherID and
			tcs.CertificationSetID = T.CertificationSetID and
			tcs.StartDate = T.StartDate join
		@Status s on T.Code = s.Code

	-- the rest are NC
	update	TeacherCertificationSet
	set	StatusID = @NC
	where	StatusID is null

-- #############################################################################
-- Collapse records by time
-- #############################################################################

	declare	@oldTeach uniqueidentifier,
		@oldSet uniqueidentifier,
		@oldStart datetime,
		@oldStatus uniqueidentifier,
		@Teach uniqueidentifier,
		@Set uniqueidentifier,
		@Start datetime,
		@StatusID uniqueidentifier
	
	declare	collapse cursor for
	select TeacherID, CertificationSetID, StartDate, StatusID
	from TeacherCertificationSet
	
	open collapse
	
	fetch next from collapse into @Teach, @Set, @Start, @StatusID
	
	while @@fetch_status = 0
	begin
		if( @Teach = @oldTeach and @Set = @oldSet )
		begin
	
			-- if same status
			if( @StatusID <> @oldStatus )
			begin
				-- update end date of old
				update	TeacherCertificationSet
				set	EndDate = @Start
				where	TeacherID = @oldTeach and
					CertificationSetID = @oldSet and
					StartDate = @oldStart
				-- save old pos
				set	@oldTeach = @Teach
				set	@oldSet = @Set
				set	@oldStart = @Start
				set	@oldStatus = @StatusID
			end
			else
			begin
				-- mark for deletion using old status
				update	TeacherCertificationSet
				set	StatusID = @NC
				where	TeacherID = @Teach and
					CertificationSetID = @Set and
					StartDate = @Start
			end
		end
		else
		begin
			-- save old pos
			set	@oldTeach = @Teach
			set	@oldSet = @Set
			set	@oldStart = @Start
			set	@oldStatus = @StatusID
		end
	
		fetch next from collapse into @Teach, @Set, @Start, @StatusID
	end
	
	close collapse
	deallocate collapse
	
	-- 4:13
	
	delete from TeacherCertificationSet
	where	StatusID = @NC

--##############################################################################
	set nocount off

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO