-- All MAP tables have been moved to the transform script files.  This file contains drop table statements for MAP tables that are no longer used.

-- #############################################################################
-- ServiceDef
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Map_ServiceDefIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE LEGACYSPED.Map_ServiceDefIDstatic
GO
-- no longer used

-- #############################################################################
-- ExitReason
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_OutcomeID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE LEGACYSPED.MAP_OutcomeID
GO
-- we are using PrgStatus

-- #############################################################################
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceLocationIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE LEGACYSPED.MAP_ServiceLocationIDstatic
GO
-- no longer used

-- #############################################################################
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE LEGACYSPED.MAP_ServiceLocationID
GO
-- we are using PrgLocation


-- #############################################################################
-- School
IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_SchoolView')
	DROP VIEW LEGACYSPED.MAP_SchoolView
GO
-- no longer used

-- #############################################################################
-- ServiceDefID
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_ServiceDefID
GO
-- renamed this transform
