IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.TeamMember_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.TeamMember_LOCAL  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.TeamMember'))  
DROP VIEW LEGACYSPED.TeamMember  
GO  
  
CREATE TABLE LEGACYSPED.TeamMember_LOCAL(  
   StaffEmail	varchar(150)	not null,
  StudentRefId	varchar(150)	not null,
  IsCaseManager	varchar(1)	not null
)  
GO  
Alter table LEGACYSPED.TeamMember_LOCAL
add constraint PK_LEGACYSPED_TeamMember_LOCAL_StaffEmail primary key (StaffEmail,StudentRefId)
GO  
  
CREATE VIEW LEGACYSPED.TeamMember  
AS  
 SELECT * FROM LEGACYSPED.TeamMember_LOCAL  
GO
