-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'LEGACYSPED'

-- Register module
exec VC3Deployment.AddModule 'LEGACYSPED'
exec VC3Deployment.AddModuleDependency @uses='LEGACYSPED', @usedBy='dbo'
exec VC3Deployment.AddModuleDependency @uses='LEGACYSPED', @usedBy='VC3ETL'
--