IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Create_IepService_Snapshot'))
DROP PROC LEGACYSPED.Create_IepService_Snapshot
GO

create proc LEGACYSPED.Create_IepService_Snapshot
as
set ansi_warnings off;
	begin
	IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepService_Snapshot') AND OBJECTPROPERTY(id, N'IsTable') = 1)
	DROP TABLE LEGACYSPED.Transform_IepService_Snapshot


	select *
	into LEGACYSPED.Transform_IepService_Snapshot
	from LEGACYSPED.Transform_IepService

end
set ansi_warnings on;

go




