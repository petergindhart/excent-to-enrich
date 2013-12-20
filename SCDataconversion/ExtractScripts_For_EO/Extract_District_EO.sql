IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.District_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.District_EO
GO
CREATE VIEW dbo.District_EO
AS
select 	
	Line_No=Row_Number() OVER (ORDER BY (SELECT 1)),
	DistrictCode = d.DistrictID,
	d.DistrictName
FROM (select top 1 * from dbo.Forms where DistrictID is not null ) f
JOIN dbo.District d on f.DistrictID = d.DistrictID