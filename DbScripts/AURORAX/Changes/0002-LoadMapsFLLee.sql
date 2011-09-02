-- All MAP tables have been moved to the transform script files.  This file contains drop table statements for MAP tables that are no longer used.

-- #############################################################################
-- ServiceDef
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ServiceDefIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ServiceDefIDstatic
GO
-- no longer used

-- #############################################################################
-- ExitReason
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_OutcomeID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_OutcomeID
GO
-- we are using PrgStatus

-- #############################################################################
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceLocationIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceLocationIDstatic
GO
-- no longer used

-- #############################################################################
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceLocationID
GO
-- we are using PrgLocation


-- #############################################################################
-- School
IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_SchoolView')
	DROP VIEW AURORAX.MAP_SchoolView
GO
-- no longer used

-- #############################################################################
-- ServiceDefID
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_ServiceDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_ServiceDefID
GO
-- renamed this transform
