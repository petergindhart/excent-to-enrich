/*

*/
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.School_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.School_LOCAL
GO

CREATE TABLE LEGACYSPED.School_LOCAL(
SchoolCode    varchar(10) not null,
SchoolName    varchar(255) not null,
DistrictCode    varchar(10) not null,
MinutesPerWeek	int not null

)
GO
Alter table LEGACYSPED.School_LOCAL
add constraint PK_LEGACYSPED_School_LOCAL_SchoolCode primary key (SchoolCode,DistrictCode)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.School'))
DROP VIEW LEGACYSPED.School
GO

CREATE VIEW LEGACYSPED.School  
AS
 SELECT * FROM LEGACYSPED.School_LOCAL  
GO
--