
update VC3Reporting.ReportSchemaColumn
set ValueExpression = 'COUNT(distinct cast({this}.id as binary(16)))'
where Id in ('D113E740-51AF-41E8-87CC-2C270A43BA4A', '229A2D95-8C74-4AB3-A9DA-39E6A361F902')