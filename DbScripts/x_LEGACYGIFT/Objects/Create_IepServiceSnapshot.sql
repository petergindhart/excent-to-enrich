IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Create_IepService_Snapshot'))
DROP PROC x_LEGACYGIFT.Create_IepService_Snapshot
GO

create proc x_LEGACYGIFT.Create_IepService_Snapshot
as
set ansi_warnings off;
	begin
	IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_IepService_Snapshot') AND OBJECTPROPERTY(id, N'IsTable') = 1)
	DROP TABLE x_LEGACYGIFT.Transform_IepService_Snapshot


	select *
	into x_LEGACYGIFT.Transform_IepService_Snapshot
	from x_LEGACYGIFT.Transform_IepService

end
set ansi_warnings on;

go




