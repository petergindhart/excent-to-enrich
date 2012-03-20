/*

*/
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.School_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.School_LOCAL
GO

CREATE TABLE LEGACYSPED.School_LOCAL(
SchoolRefID    varchar(150),
SchoolCode    varchar(10),
SchoolName    varchar(255),
DistrictRefID    varchar(150),
MinutesPerWeek	varchar(4)

)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.School'))
DROP VIEW LEGACYSPED.School
GO

CREATE VIEW LEGACYSPED.School  
AS
 SELECT * FROM LEGACYSPED.School_LOCAL  
GO
--