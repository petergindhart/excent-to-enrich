--#include Transform_IepDisability.sql

-- ############################################################################# 
-- IepDisabilityEligibility
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepDisabilityEligibilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepDisabilityEligibilityID 
(
	IepRefID varchar(150) not  null,
	DisabilityID	uniqueidentifier not null,
	DestID	uniqueidentifier not null
)
ALTER TABLE LEGACYSPED.MAP_IepDisabilityEligibilityID ADD CONSTRAINT
PK_MAP_IepDisabilityEligibilityID PRIMARY KEY CLUSTERED
(
	IepRefID, DisabilityID
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.StudentDisabilityPivot') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.StudentDisabilityPivot
GO

create view LEGACYSPED.StudentDisabilityPivot
as
	select StudentRefID, DisabilityCode, DisabSeq = min(DisabSeq) -- avoid duplicate disabilities for the same student
	from (
		select StudentRefID, DisabilityCode = Disability1Code, DisabSeq = cast(1 as int) from LEGACYSPED.Student
		union all
		select StudentRefID, DisabilityCode = Disability2Code, 2 from LEGACYSPED.Student where Disability2Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability3Code, 3 from LEGACYSPED.Student where Disability3Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability4Code, 4 from LEGACYSPED.Student where Disability4Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability5Code, 5 from LEGACYSPED.Student where Disability5Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability6Code, 6 from LEGACYSPED.Student where Disability6Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability7Code, 7 from LEGACYSPED.Student where Disability7Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability8Code, 8 from LEGACYSPED.Student where Disability8Code is not null
		union all
		select StudentRefID, DisabilityCode = Disability9Code, 9 from LEGACYSPED.Student where Disability9Code is not null
		) d
	group by StudentRefID, DisabilityCode
go



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepDisabilityEligibility') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepDisabilityEligibility
GO

CREATE VIEW LEGACYSPED.Transform_IepDisabilityEligibility
AS
	SELECT
		iep.IepRefID,
		DestID = me.DestID,
		InstanceID = m.DestID, 
		DisabilityID = d.DestID, 
		Sequence = (select count(*)+1 from LEGACYSPED.StudentDisabilityPivot where StudentRefID = s.StudentRefID and DisabSeq < s.DisabSeq),
		IsEligibileID = 'B76DDCD6-B261-4D46-A98E-857B0A814A0C', -- Only Eligible disabilities provided  
		FormInstanceID = cast(NULL as uniqueidentifier), -- select iep.ieprefid
		PrimaryOrSecondaryID = case when s.DisabSeq = 1 then 'AF6825FF-336C-42CE-AF57-CD095CD0DD2C' else '51619296-9938-4977-8B5F-A6E0FAEE4294' end -- snatched these from Lee Template.  Consistent everywhere?
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN
		LEGACYSPED.MAP_PrgSectionID m on 
			m.DefID = 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A' and
			m.VersionID = iep.VersionDestID JOIN
		dbo.IepEligibilityDetermination ed on m.DestID = ed.ID JOIN -- Only purpose is to ensure that this record exists.  
		LEGACYSPED.StudentDisabilityPivot s on iep.StudentRefID = s.StudentRefID JOIN
		LEGACYSPED.Transform_IepDisability d on s.DisabilityCode = d.DisabilityCode left join
		LEGACYSPED.MAP_IepDisabilityEligibilityID me on 
			iep.IepRefID = me.IepRefID and
			d.DestID = me.DisabilityID

GO
--
