

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Dates') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Dates
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDates') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDates
GO

CREATE VIEW LEGACYSPED.Transform_IepDates
AS
	SELECT
		DestID = m.DestID,
		NextReviewDate = CASE WHEN ISDATE(iep.NextReviewDate) = 1 THEN iep.NextReviewDate ELSE NULL END,
		NextEvaluationDate = CASE WHEN ISDATE(iep.NextEvaluationDate) = 1 THEN iep.NextEvaluationDate ELSE NULL END,
		InitialEvaluationDate = CASE WHEN ISDATE(iep.InitialEvaluationDate) = 1 THEN iep.InitialEvaluationDate ELSE NULL END,
		LatestEvaluationDate = CASE WHEN ISDATE(iep.LatestEvaluationDate) = 1 THEN iep.LatestEvaluationDate ELSE NULL END,
		i.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep i LEFT JOIN
		LEGACYSPED.IEP iep on i.IepRefID = iep.IepRefID LEFT JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			i.VersionDestID = m.VersionID and
			m.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' 
GO
--



/*

select * from LEGACYSPED.MAP_PrgSectionID where DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' -- 11903 (from 12329)
select * from LEGACYSPED.IEP -- 11902 
select * from LEGACYSPED.Student -- 11902
select * from LEGACYSPED.Transform_PrgIep -- 11427  (interesting we are not looking at all of the records here)

select distinct versionid from LEGACYSPED.MAP_PrgSectionID -- 11907
select * from PrgVersion where ItemID in (select Id from PrgItem) -- 13161

-- select v.ItemId, count(*) tot from PrgVersion v join PrgItem i on v.ItemID = i.ID and i.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' group by ItemID having count(*) > 1





select s.* 
from LEGACYSPED.MAP_PrgSectionID ms join 
PrgSection s on ms.DestID = s.ID join 
PrgItem i on s.ItemID = i.ID left join 
LEGACYSPED.Transform_PrgIep iep on i.ID = iep.DestID
where ms.DefID = 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B' 

select distinct versionID from LEGACYSPED.MAP_PrgSectionID -- 11907


*/
