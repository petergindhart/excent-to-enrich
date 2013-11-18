-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'x_LEGACYESOL'

-- Register module
exec VC3Deployment.AddModule 'x_LEGACYESOL'
exec VC3Deployment.AddModuleDependency @usedBy='x_LEGACYESOL', @uses='dbo'
exec VC3Deployment.AddModuleDependency @usedBy='x_LEGACYESOL', @uses='VC3ETL'
--
