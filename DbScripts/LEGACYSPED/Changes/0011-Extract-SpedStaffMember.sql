IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.SpedStaffMember_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.SpedStaffMember_LOCAL  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.SpedStaffMember'))  
DROP VIEW LEGACYSPED.SpedStaffMember  
GO  
/*********************************
*The data on this tab serves 2 purposes:  
* 1) lists Service Providers that are referenced on the Services tab and 
* 2) lists Team Members from the TeamMembers tab.  The EnrichRole is only required .
**********************************/
CREATE TABLE LEGACYSPED.SpedStaffMember_LOCAL(  
StaffEmail		varchar(150)
Lastname		varchar(50), 
Firstname		varchar(50), 
EnrichRole 		varchar(50) 

)  
GO  
/*  
EnrichRole: 
Staff Member's role in Enrich.  The value in this field must match exactly one of the User Roles in Enrich. 
This field is required if not using network authentication and Excent is adding user accounts.
*/
  
CREATE VIEW LEGACYSPED.SpedStaffMember  
AS  
 SELECT * FROM LEGACYSPED.SpedStaffMember_LOCAL  
GO  
--