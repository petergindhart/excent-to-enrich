set nocount on;
declare @ms table (EOSchoolCode varchar(10), StateSchoolCode varchar(10))

insert @ms values ('1001', '4369')
insert @ms values ('5223', '5221')
insert @ms values ('9790', '9791')
insert @ms values ('9794', '9795')
insert @ms values ('9798', '9799')
insert @ms values ('9724', '9725')
insert @ms values ('9728', '9729')
insert @ms values ('9732', '9733')



--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.StaffSchool_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
--DROP VIEW dbo.StaffSchool_EO
--GO

--CREATE VIEW dbo.StaffSchool_EO
--AS
SELECT distinct StaffEmail = s.Email, SchoolCode = isnull(ms.StateSchoolCode, ss.SchoolID), ms.StateSchoolCode, ssSchoolID = ss.SchoolID, hSchoolID = h.SchoolID, h.DistrictID, h.SchoolName
FROM dbo.StaffSchool ss 
JOIN dbo.Staff s ON s.StaffGID = ss.StaffGID 
left join @ms ms on ss.SchoolID = ms.eoschoolcode
left join school h on ss.SchoolID = h.SchoolID
WHERE ss.DeleteID is NULL 
and s.Email is not null
--and ms.StateSchoolCode is not null
--and s.email = 'tdurbin@neboces.com'
--and isnull(ms.StateSchoolCode, ss.SchoolID) = '6528'
--select * from school where schoolid = '6528'
--and h.SchoolGID is null

