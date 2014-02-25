IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.SchoolProgressFrequency_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.SchoolProgressFrequency_LOCAL
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.SchoolProgressFrequency'))
DROP VIEW LEGACYSPED.SchoolProgressFrequency
GO

CREATE TABLE LEGACYSPED.SchoolProgressFrequency_LOCAL(
  SchoolCode	varchar(10)     not null,
  FrequencyName	varchar(50)		not null
)
GO

Alter table LEGACYSPED.SchoolProgressFrequency_LOCAL
add constraint PK_SchoolProgressFrequency_LOCAL_SchoolCode primary key (SchoolCode)
GO

CREATE VIEW LEGACYSPED.SchoolProgressFrequency
AS
 SELECT * FROM LEGACYSPED.SchoolProgressFrequency_LOCAL
GO
