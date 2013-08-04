-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'x_LEGACY504'

-- Register module
exec VC3Deployment.AddModule 'x_LEGACY504'
exec VC3Deployment.AddModuleDependency @usedBy='x_LEGACY504', @uses='dbo'
exec VC3Deployment.AddModuleDependency @usedBy='x_LEGACY504', @uses='VC3ETL'
--
