-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'x_LEGACY504'

-- Register module
exec VC3Deployment.AddModule 'x_LEGACY504'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACY504', @usedBy='dbo'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACY504', @usedBy='VC3ETL'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACY504', @usedBy='LEGACYSPED'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACY504', @usedBy='x_LEGACYDOC'
--exec VC3Deployment.AddModuleDependency @uses='x_LEGACY504', @usedBy='x_LEGACYGIFT'
--
