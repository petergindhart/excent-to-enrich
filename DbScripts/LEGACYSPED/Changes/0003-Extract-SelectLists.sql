-- AUROAX.SelectLists source file has changed and so the table needs to be rebuilt where it has already been deployed.

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.SelectLists_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.SelectLists_LOCAL
GO

CREATE TABLE LEGACYSPED.SelectLists_LOCAL(
Type	varchar(20) not null,
SubType	varchar(20) null,
EnrichID varchar(150) null, -- Newly included column to map with the target table
StateCode	varchar(20) null,
LegacySpedCode	varchar(150) null,
EnrichLabel	varchar(254) not null
--Sequence	varchar(3),
--DisplayInUI char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.SelectLists'))
DROP VIEW LEGACYSPED.SelectLists
GO


CREATE VIEW LEGACYSPED.SelectLists
AS
	SELECT * FROM LEGACYSPED.SelectLists_LOCAL
GO


IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.SelectListsUniqueLabel'))
DROP VIEW LEGACYSPED.SelectListsUniqueLabel
GO

CREATE VIEW LEGACYSPED.SelectListsUniqueLabel
as
--/*
--	We are not only importing these Legacy SelectLists, but also the client's preferred SelectLists.  
--		The Preferred SelectLists will not have a Code, but will have a Type and Label, and possibly a subtype (Service Defs, Service Locations, etc. are good examples).
--	We will be comparing the Legacy SelectLists with the Preferred SelectLists on Type, SubType and Label
--	It is possible to have a lookup record that is unique between Type, SubType, Code and Label, but is not unique by Type, SubType and Label.
--		Where there are duplicates on Type, SubType and Label, we add the Code to the Label.
--		It is possible to have a Legacy lookup with a Label and no code, but there will not be duplicates among them.
	
--	Use this view as follows:
	
--	select SubType, Code, Label
--	from LEGACYSPED.SelectListsUniqueLabel k
--	where Type = 'Service'
--	union
--	select SubType, Code, Label
--	from LEGACYSPED.SelectListsPreferences p 
--	where Type = 'Service'
--	-- with this unique list of Legacy and Preferred SelectLists it can be determined which need to be displayed in the UI or hiddent from it

--*/
select
	k.Type,
	k.SubType,
	k.EnrichID,
	k.LegacySpedCode,
	EnrichLabel = isnull(kd.EnrichLabel+' - '+k.LegacySpedCode, k.EnrichLabel)
from LEGACYSPED.SelectLists k left join
	(
	-- left join to this to add code to label where dups exist.  we will use this when compairing with SelectListsPreferences
	select SubType, EnrichLabel, count(*) tot
	from LEGACYSPED.SelectLists k
	where SubType is not null
	group by SubType, EnrichLabel
	having count(*) > 1
	) kd on k.SubType = kd.SubType and k.EnrichLabel = kd.EnrichLabel
go
--
