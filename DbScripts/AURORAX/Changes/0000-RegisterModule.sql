-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'AURORAX'

-- Register module
exec VC3Deployment.AddModule 'AURORAX'
exec VC3Deployment.AddModuleDependency @uses='AURORAX', @usedBy='dbo'
exec VC3Deployment.AddModuleDependency @uses='AURORAX', @usedBy='VC3ETL'
--