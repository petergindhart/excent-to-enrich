IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgInvolvement_Status') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop proc LEGACYSPED.Transform_PrgInvolvement_Status
go

create proc LEGACYSPED.Transform_PrgInvolvement_Status 
as

declare @StatusID uniqueidentifier ; select @StatusID = DestID from LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan

declare @Transform_PrgInvolvement table (
StudentRefID	varchar(150)	NOT NULL,
DestID	uniqueidentifier primary key,
StudentID	uniqueidentifier,
ProgramID	varchar(36)	NOT NULL,
VariantID	varchar(36)	NOT NULL,
StartDate	datetime	NOT NULL,
EndDate	datetime,
EndStatusID	uniqueidentifier,
IsManuallyEnded	tinyint,
Touched	int	NOT NULL,
SpecialEdStatus	char(1)	NOT NULL,
StatusID	uniqueidentifier
)

insert @Transform_PrgInvolvement
select * from LEGACYSPED.Transform_PrgInvolvement

insert PrgInvolvementStatus
SELECT NEWID(), s.DestID, s.StatusID, s.StartDate, s.EndDate
FROM (select * from @Transform_PrgInvolvement where DestID not in (select InvolvementID from PrgInvolvementStatus where StatusID = @StatusID)) s
-- WHERE NOT EXISTS (SELECT * FROM PrgInvolvementStatus d WHERE NEWID()=d.ID) -- this came from the LoadTable_Run proc when we used the Transform View instead of this proc.
left join PrgInvolvementStatus t on s.DestID = t.InvolvementID 
where t.id is null
go
