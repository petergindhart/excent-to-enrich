IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.StaffSchool_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.StaffSchool_LOCAL  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.StaffSchool'))  
DROP VIEW LEGACYSPED.StaffSchool  
GO  
  
CREATE TABLE LEGACYSPED.StaffSchool_LOCAL(  
  StaffEmail	varchar(150)	not null,
  SchoolCode	varchar(10)     not null
)  
GO  
 
Alter table LEGACYSPED.StaffSchool_LOCAL
add constraint PK_LEGACYSPED_StaffSchool_LOCAL_StaffEmail primary key (StaffEmail,SchoolCode)
GO   
  
CREATE VIEW LEGACYSPED.StaffSchool  
AS  
 SELECT * FROM LEGACYSPED.StaffSchool_LOCAL  
GO
