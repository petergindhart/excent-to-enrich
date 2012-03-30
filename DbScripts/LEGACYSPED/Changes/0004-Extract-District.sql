/**/
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.District_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.District_LOCAL
GO

CREATE TABLE LEGACYSPED.District_LOCAL(
DistrictCode    varchar(10),
DistrictName    varchar(255)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.District'))
DROP VIEW LEGACYSPED.District
GO  

CREATE VIEW LEGACYSPED.District
AS
 SELECT * FROM LEGACYSPED.District_LOCAL
GO
--