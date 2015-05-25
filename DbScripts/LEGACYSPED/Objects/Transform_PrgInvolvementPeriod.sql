
-- #############################################################################
-- InvolvementPeriod
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgInvolvementPeriodID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgInvolvementPeriodID
(
	StudentRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgInvolvementPeriodID ADD CONSTRAINT
PK_MAP_PrgInvolvementPeriodID  PRIMARY KEY CLUSTERED
(
	StudentRefID
)
END
if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_MAP_PrgInvolvementPeriodID_DestID')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_MAP_PrgInvolvementPeriodID_DestID ON LEGACYSPED.MAP_PrgInvolvementPeriodID (DestID)
GO
-- 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgInvolvementPeriod') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgInvolvementPeriod
GO

CREATE VIEW LEGACYSPED.Transform_PrgInvolvementPeriod
AS
	SELECT
		StudentRefID = stu.StudentRefID,
		DestID = ISNULL(invp.ID, mpinvp.DestID),
		-- x = x.ID, t = t.ID, m = m.DestID, ev = ev.ExistingInvolvementID,
		InvolvementID  = coalesce(x.ID, t.ID, m.DestID, ev.ExistingInvolvementID),
		StartDate = iep.IEPStartDate,   -- school start for this IEP period
		EndDate = isnull(t.EndDate, 
			case when stu.SpecialEdStatus = 'E' then 
				case when iep.IEPEndDate > getdate() then NULL else iep.IEPEndDate end 
				else
				case when t.EndDate > getdate() then NULL else t.EndDate end
			end),
		EndStatusID = case when stu.SpecialEdStatus = 'E' then '75489662-F5C9-4EFB-AEF3-02E943EEC6F5' else t.EndStatus end--'12086FE0-B509-4F9F-ABD0-569681C59EE2'
	FROM
		LEGACYSPED.EvaluateIncomingItems ev join 
		LEGACYSPED.Transform_Student stu on ev.StudentRefID = stu.StudentRefID JOIN 
		LEGACYSPED.IEP iep on stu.StudentRefID = iep.StudentRefID LEFT JOIN 
		dbo.PrgInvolvement x on stu.DestID = x.StudentID and x.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' /* and dbo.DateInRange( iep.IEPStartDate, x.StartDate, x.EndDate ) = 1 */ ------- this resulted in odd behavior for Brevard's import
			and x.StartDate = (
				select max(mxdt.startdate)
				from dbo.PrgInvolvement mxdt 
				where x.StudentID = mxdt.StudentID
				) left join 
		LEGACYSPED.MAP_PrgInvolvementID m on iep.StudentRefID = m.StudentRefID LEFT JOIN
		-- identify students that already have a sped invovlement that will overlap with this involvement
		dbo.PrgInvolvement t on m.DestID = t.ID LEFT JOIN 
		LEGACYSPED.MAP_PrgInvolvementPeriodID mpinvp ON mpinvp.StudentRefID = iep.StudentRefID LEFT JOIN 
		PrgInvolvementPeriod invp ON invp.ID = mpinvp.DestID
WHERE iep.IEPStartDate is not null 
GO
--