-- use in all states, all districts
-- #############################################################################
-- IepServiceCategory Map Table
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepServiceCategoryID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) 
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepServiceCategoryID
(
	ServiceCategoryCode varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepServiceCategoryID ADD CONSTRAINT
PK_MAP_IepServiceCategoryID PRIMARY KEY CLUSTERED
(
	ServiceCategoryCode
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepServiceCategory') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepServiceCategory  
GO  

CREATE VIEW LEGACYSPED.Transform_IepServiceCategory  
AS
	SELECT
		k.ServiceCategoryCode,
		DestID = ISNULL(t.ID,MISerCatCode.DestID),
		Name = coalesce(t.Name, case k.ServiceCategoryCode when 'SpecialEd' then 'Special Education' else k.ServiceCategoryCode end), -- It is important to get t where it exists because we are updating the target table and we don't want to change t where t already existed
		Sequence = coalesce(t.Sequence, 99),
		DeletedDate = CAST(null as datetime)
	FROM
		(
		SELECT ServiceCategoryCode = SubType
		FROM LEGACYSPED.SelectLists 
		WHERE Type = 'Service'
		and SubType is not null
		GROUP BY SubType
		) k LEFT JOIN
		dbo.IepServiceCategory t on case k.ServiceCategoryCode when 'SpecialEd' then 'Special Education' else k.ServiceCategoryCode end = t.Name  LEFT JOIN LEGACYSPED.MAP_IepServiceCategoryID MISerCatCode ON k.ServiceCategoryCode = MISerCatCode.ServiceCategoryCode
GO
