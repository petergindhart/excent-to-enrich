-- Create schema
exec VC3Deployment.CreateSchema 'x_DATAVALIDATION'

-- Register module
exec VC3Deployment.AddModule 'x_DATAVALIDATION'
--exec VC3Deployment.AddModuleDependency @uses='x_DATAVALIDATION', @usedBy='dbo'
--exec VC3Deployment.AddModuleDependency @uses='x_DATAVALIDATION', @usedBy='VC3ETL'
--exec VC3Deployment.AddModuleDependency @uses='x_DATAVALIDATION', @usedBy='LEGACYSPED'