-- NOTE: 0000 scripts run outside of a transaction so the schema can be created
-- so keep work here to a minimum

-- Create schema
exec VC3Deployment.CreateSchema 'EXCENTO'

-- Register module
exec VC3Deployment.AddModule 'EXCENTO'
exec VC3Deployment.AddModuleDependency @uses='EXCENTO', @usedBy='dbo'
exec VC3Deployment.AddModuleDependency @uses='EXCENTO', @usedBy='VC3ETL'
--