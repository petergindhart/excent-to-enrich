-- Create schema
exec VC3Deployment.CreateSchema 'DATAVALIDATION'

-- Register module
exec VC3Deployment.AddModule 'DATAVALIDATION'
exec VC3Deployment.AddModuleDependency @uses='DATAVALIDATION', @usedBy='dbo'
exec VC3Deployment.AddModuleDependency @uses='DATAVALIDATION', @usedBy='VC3ETL'
exec VC3Deployment.AddModuleDependency @uses='DATAVALIDATION', @usedBy='LEGACYSPED'