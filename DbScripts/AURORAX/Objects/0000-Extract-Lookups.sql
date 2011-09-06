-- AUROAX.Lookups source file has changed and so the table needs to be rebuilt where it has already been deployed.

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.Lookups_LOCAL') AND type in (N'U'))
DROP TABLE AURORAX.Lookups_LOCAL
GO

CREATE TABLE AURORAX.Lookups_LOCAL(
Type	varchar(20),
SubType	varchar(20),
StateCode	varchar(10),
Code	varchar(150),
Label	varchar(254),
Sequence	varchar(3),
DisplayInUI char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'AURORAX.Lookups'))
DROP VIEW AURORAX.Lookups
GO


CREATE VIEW AURORAX.Lookups
AS
	SELECT * FROM AURORAX.Lookups_LOCAL
GO


IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'AURORAX.LookupsUniqueLabel'))
DROP VIEW AURORAX.LookupsUniqueLabel
GO

CREATE VIEW AURORAX.LookupsUniqueLabel
as
--/*
--	We are not only importing these Legacy Lookups, but also the client's preferred lookups.  
--		The Preferred lookups will not have a Code, but will have a Type and Label, and possibly a subtype (Service Defs, Service Locations, etc. are good examples).
--	We will be comparing the Legacy Lookups with the Preferred Lookups on Type, SubType and Label
--	It is possible to have a lookup record that is unique between Type, SubType, Code and Label, but is not unique by Type, SubType and Label.
--		Where there are duplicates on Type, SubType and Label, we add the Code to the Label.
--		It is possible to have a Legacy lookup with a Label and no code, but there will not be duplicates among them.
	
--	Use this view as follows:
	
--	select SubType, Code, Label
--	from AURORAX.LookupsUniqueLabel k
--	where Type = 'Service'
--	union
--	select SubType, Code, Label
--	from AURORAX.LookupsPreferences p 
--	where Type = 'Service'
--	-- with this unique list of Legacy and Preferred Lookups it can be determined which need to be displayed in the UI or hiddent from it

--*/
select
	k.Type,
	k.SubType,
	k.Code,
	Label = isnull(kd.Label+' - '+k.Code, k.Label)
from AURORAX.Lookups k left join
	(
	-- left join to this to add code to label where dups exist.  we will use this when compairing with LookupsPreferences
	select SubType, Label, count(*) tot
	from AURORAX.Lookups k
	where SubType is not null
	group by SubType, Label
	having count(*) > 1
	) kd on k.SubType = kd.SubType and k.Label = kd.Label
go
--
