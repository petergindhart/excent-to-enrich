IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.SchoolProgressFrequency_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.SchoolProgressFrequency_LOCAL
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.SchoolProgressFrequency'))
DROP VIEW x_LEGACYGIFT.SchoolProgressFrequency
GO

CREATE TABLE x_LEGACYGIFT.SchoolProgressFrequency_LOCAL(
  SchoolCode	varchar(10)     not null,
  FrequencyName	varchar(50)		not null
)
GO

Alter table x_LEGACYGIFT.SchoolProgressFrequency_LOCAL
add constraint PK_SchoolProgressFrequency_LOCAL_SchoolCode primary key (SchoolCode)
GO

CREATE VIEW x_LEGACYGIFT.SchoolProgressFrequency
AS
 SELECT * FROM x_LEGACYGIFT.SchoolProgressFrequency_LOCAL
GO
