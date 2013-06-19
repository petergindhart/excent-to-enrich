-- #############################################################################
-- Note:  Separated PrgInvolvement MAP table code from Transform_PrgInvolvement files because EvaluateIncomingItems depends on this MAP, and Transform_PrgInvolvement depends on EvaluateIncomingItems



-- #############################################################################
-- Involvement
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PrgInvolvementID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_PrgInvolvementID
(
	StudentRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE x_LEGACYGIFT.Map_PrgInvolvementID ADD CONSTRAINT
PK_MAP_PrgInvolvementID PRIMARY KEY CLUSTERED
(
	StudentRefID
)
END
if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYGIFT_MAP_PrgInvolvementID_DestID')
CREATE NONCLUSTERED INDEX IX_x_LEGACYGIFT_MAP_PrgInvolvementID_DestID ON x_LEGACYGIFT.MAP_PrgInvolvementID (DestID)
GO
-- 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgInvolvement') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgInvolvement
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgInvolvement
AS
--------------------------- remember that the group by was removed here
	SELECT
		StudentRefID = stu.StudentRefID,
		DestID = coalesce(x.ID, m.DestID),
		StudentID = stu.DestID,
		ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E',   -- Gifted Education
		VariantID = '2FF8B34F-3337-4760-AC09-76F6AE09C610',   -- None
		StartDate = stu.EPMeetingDate,   -- school start for this EP period
		EndDate = NULL,
		EndStatusID = NULL,
		IsManuallyEnded = 0,
		-- PrgInvolvementStatus
		StatusID = (select DestID from x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP)
	FROM
		x_LEGACYGIFT.Transform_GiftedStudent stu LEFT JOIN 
		x_LEGACYGIFT.MAP_PrgInvolvementID m on stu.StudentRefID = m.StudentRefID left join
		dbo.PrgInvolvement x on m.DestID = x.ID and x.ProgramID = '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E' and dbo.DateInRange( stu.EPMeetingDate, x.StartDate, x.EndDate ) = 1 
		-- assuming there are no students that already have a gifted invovlement that will overlap with this involvement
	WHERE 
		stu.EPMeetingDate is not null 
GO
--




