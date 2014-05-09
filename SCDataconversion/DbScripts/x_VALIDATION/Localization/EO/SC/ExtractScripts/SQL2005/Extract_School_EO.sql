IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.School_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.School_EO
GO

CREATE VIEW dbo.School_EO
AS
select Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), *
from (
select SchoolCode = h.SchoolID, h.SchoolName, DistrictCode = h.DistrictID, MinutesPerWeek = cast(0 as int)
from DataConvSpedStudentsAndIEPs x 
join SchoolTbl ht on x.GStudentID = ht.GStudentID 
join School h on ht.SchoolID = h.SchoolID
where isnull(h.del_flag,0)=0
group by h.SchoolID, h.SchoolName, h.DistrictID
union 
SELECT SchoolCode = ss.SchoolID, h.SchoolName, DistrictCode = h.DistrictID, MinutesPerWeek = cast(0 as int)
FROM dbo.StaffSchool ss 
join School h on ss.SchoolID = h.SchoolID
WHERE ss.DeleteID is NULL 
) sch
