-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'SPEDDOC'

-- Register module
exec VC3Deployment.AddModule 'SPEDDOC'
exec VC3Deployment.AddModuleDependency @uses='SPEDDOC', @usedBy='dbo'
exec VC3Deployment.AddModuleDependency @uses='SPEDDOC', @usedBy='VC3ETL'
--