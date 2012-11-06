IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.ProgressFrequencySchool_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.ProgressFrequencySchool_LOCAL
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.ProgressFrequencySchool'))
DROP VIEW LEGACYSPED.ProgressFrequencySchool
GO

CREATE TABLE LEGACYSPED.ProgressFrequencySchool_LOCAL(
  SchoolCode	varchar(10)     not null,
  FrequencyName	varchar(50)		not null
)
GO

Alter table LEGACYSPED.ProgressFrequencySchool_LOCAL
add constraint PK_ProgressFrequencySchool_LOCAL_SchoolCode primary key (SchoolCode)
GO

CREATE VIEW LEGACYSPED.ProgressFrequencySchool
AS
 SELECT * FROM LEGACYSPED.ProgressFrequencySchool_LOCAL
GO
