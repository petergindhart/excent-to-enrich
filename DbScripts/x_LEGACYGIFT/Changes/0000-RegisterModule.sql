-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'x_LEGACYGIFT'

-- Register module
exec VC3Deployment.AddModule 'x_LEGACYGIFT'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACYGIFT', @usedBy='dbo'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACYGIFT', @usedBy='VC3ETL'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACYGIFT', @usedBy='LEGACYSPED'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACYGIFT', @usedBy='x_LEGACY504'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACYGIFT', @usedBy='x_LEGACYDOC'
--
