IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_InvolvementStatus]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_InvolvementStatus]
GO

create view AURORAX.Transform_InvolvementStatus
as
select 
	DestID = isnull(s.ID, newid()),
	InvolvementID = i.InvolvementID,
	StatusID = '796C212F-6003-4CD3-878D-53BEBE087E9A',
	StartDate = i.StartDate,
	EndDate = i.EndDate
from AURORAX.Transform_IEP i left join
	PrgInvolvementStatus s on i.InvolvementID = s.InvolvementID
go
