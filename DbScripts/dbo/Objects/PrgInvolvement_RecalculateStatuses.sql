SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgInvolvement_RecalculateStatuses]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgInvolvement_RecalculateStatuses]
GO

/*
<summary>
Recalculates the contents of the PrgInvolvementStatus table for the
specified involvement
</summary>

<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.PrgInvolvement_RecalculateStatuses
	@involvementID uniqueidentifier
AS

set nocount on

	declare @rawEvents table (
		InvolvementID uniqueidentifier,
		StartDate datetime,
		StatusID uniqueidentifier,
		StatusSequence int
		)
	
	-- #############################################################################
	-- all StartDate/StartStatus, EndDate/EndStatus
	-- of rootItemTypes
	insert @rawEvents
	select i.InvolvementID, i.StartDate, i.StartStatusID, s.Sequence
	from
		PrgItem i join
		PrgItemDef d on i.DefID = d.ID join
		PrgStatus s on i.StartStatusID = s.ID
	where ( @involvementID is null or i.InvolvementID = @involvementID )
	union
	select i.InvolvementID, i.EndDate, i.EndStatusID, s.Sequence
	from
		PrgItem i join
		PrgItemDef d on i.DefID = d.ID join
		PrgStatus s on i.EndStatusID = s.ID
	where ( @involvementID is null or i.InvolvementID = @involvementID )
	
	-- #############################################################################
	-- clear involvement statuses
	delete PrgInvolvementStatus
	where ( @involvementID is null or InvolvementID = @involvementID )
	
	-- #############################################################################
	-- insert distinct status events
	insert PrgInvolvementStatus
	select
		ID = newid(),
		InvolvementID = r.InvolvementID,
		StatusID = r.StatusID,
		StartDate = r.StartDate,
		EndDate = null
	from
		@rawEvents r join
		(
			-- group status events in case two events occur at
			-- at same instant, take status with highest seq
			select InvolvementID, StartDate, max(StatusSequence) [MaxSequence]
			from @rawEvents
			group by InvolvementID, StartDate
		) m on
			r.InvolvementID = m.InvolvementID and
			r.StartDate = m.StartDate and
			r.StatusSequence = m.MaxSequence
	order by r.InvolvementID, r.StartDate
	
	-- #############################################################################
	-- remove events where the one before it is the same status
	delete PrgInvolvementStatus
	where ID in
		(
			select
				this.ID
			from
				PrgInvolvementStatus this join
				-- events occuring before this
				PrgInvolvementStatus previous on
					previous.InvolvementID = this.InvolvementID and
					previous.ID != this.ID and
					previous.StartDate < this.StartDate left join
				-- events occuring between previous and this
				PrgInvolvementStatus morePrevious on
					morePrevious.InvolvementID = this.InvolvementID and
					morePrevious.ID != this.ID and
					morePrevious.StartDate < this.StartDate and
					morePrevious.StartDate > previous.StartDate
			where
				( @involvementID is null or this.InvolvementID = @involvementID ) and
				morePrevious.ID is null and -- ensures previous is immediate previous
				this.StatusID = previous.StatusID -- and previous status was the same
		)
	
	
	
	-- #############################################################################
	-- update EndDate to be the next StartDate
	update this
	set EndDate = later.StartDate
	from
		PrgInvolvementStatus this join
		-- events occuring after this
		PrgInvolvementStatus later on
			later.InvolvementID = this.InvolvementID and
			later.ID != this.ID and
			later.StartDate > this.StartDate left join
		-- events occuring between later and this
		PrgInvolvementStatus lessLater on
			lessLater.InvolvementID = this.InvolvementID and
			lessLater.ID != this.ID and
			lessLater.StartDate > this.StartDate and
			lessLater.StartDate < later.StartDate
	where
		( @involvementID is null or this.InvolvementID = @involvementID ) and
		lessLater.ID is null -- ensures later is immediate next one
	
	-- #############################################################################
	-- update last EndDate for closed Involvements
	update s
	set EndDate = i.EndDate
	from
		PrgInvolvementStatus s join
		PrgInvolvement i on s.InvolvementID = i.ID
	where
		( @involvementID is null or s.InvolvementID = @involvementID ) and
		s.EndDate is null and
		i.EndDate is not null


	-- #############################################################################
	-- remove any involvements that aren't associated with any items
--#deadlocktolerance-begin 5 0
	delete v
	from PrgInvolvement v
	where not exists (
		select InvolvementID
		from PrgItem
		where InvolvementID = v.ID 
		group by InvolvementID ) and
		( @involvementID is null or v.ID = @involvementID )
--#deadlocktolerance-end
set nocount off

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
	BUILD TEST
	
	FK_PrgItem#Involvement#Items was intentionally changed to not cascade delete
	to avoid acquiring a large number of Intent Exclusive Locks throughout a
	large portion of the PrgItem graph.  This was causing deadlocks between 
	concurrent executions of dbo.PrgInvolvement_RecalculateStatuses.
	
	Raise an error if cascade delete is added between PrgItem and PrgInvolvement
	so we know to address this.
*/

-- don't enforce until after script 1406-DontCascadeDelPrgInvolvement.sql
IF EXISTS(SELECT * FROM VC3Deployment.Version WHERE Module = 'dbo' AND Script = 1406)
BEGIN
	-- check for cascade delete
	IF EXISTS(
		select * from sysforeignkeys fk
		where
			fk.fkeyid = OBJECT_ID('[dbo].[PrgItem]') and -- from PrgItem
			fk.rkeyid = OBJECT_ID('[dbo].[PrgInvolvement]') and -- to PrgInvolvement
			OBJECTPROPERTY(fk.constid, 'CnstIsDeleteCascade') = 1
	)
	BEGIN
		-- perform invalid cast to fail build
		SELECT * FROM Student WHERE ID = 'Cascade delete between PrgItem and PrgInvolvement raises potential for deadlock in PrgInvolvement_RecalculateStatuses'
	END
END
GO
