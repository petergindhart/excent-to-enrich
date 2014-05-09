IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.forms_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.forms_EO
GO
CREATE VIEW dbo.forms_EO
AS
select top 1 * from dbo.forms where DistrictID is not null 

GO
IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'District_src') AND type in (N'U'))
DROP TABLE dbo.District_src
GO

select 	
	Line_No=IDENTITY(INT,1,1),
	DistrictCode = d.DistrictID,
	d.DistrictName
	INTO dbo.District_src
FROM forms f
JOIN dbo.District d on f.DistrictID = d.DistrictID

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.District_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.District_EO
GO

CREATE VIEW dbo.District_EO
AS
select 	
	Line_No,
	DistrictCode ,
    DistrictName
FROM dbo.District_src

--select * from dbo.District_EO