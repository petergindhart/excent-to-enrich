--#include ..\Objects\Transform_ServiceFrequency.sql

-- Map_ServiceFrequencyID is created in the Transform script.

/*

	In an effort to limit the number of files that needs to be touched for each new implementation of Enrich,
	this file contains all district-specific ETL connfiguration.
*/

-- OrgUnit 
update ou set Number = '36' -- Lee County State Reporting DistrictID
-- select ou.*
from dbo.OrgUnit ou join 
	dbo.SystemSettings ss on ou.ID = ss.LocalOrgRootID 
go




/*
	ServiceFrequency is part of seed data in Enrich.  Thus it must be hard-mapped.  
	ServiceFrequency did not support hiding from UI at the time this code was written, so additional service frequencies are not supported.
		For additional frequencies it may be possible to calculate the frequency based on an existing value 
			i.e. 2 times Quarterly = 8 times yearly,  30 minutes per quarter = 2 hours per year or 120 minutes per year
*/

-- Lee County had a MAP_ServiceFrequencyID from a previouos ETL run that had bogus frequency data. delete that data and insert the good.
declare @Map_ServiceFrequencyID table (ServiceFrequencyCode varchar(30), ServiceFrequencyName varchar(50), DestID uniqueidentifier)
set nocount on;
insert @Map_ServiceFrequencyID values ('day', 'daily', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
insert @Map_ServiceFrequencyID values ('week', 'weekly', 'A2080478-1A03-4928-905B-ED25DEC259E6')
insert @Map_ServiceFrequencyID values ('month', 'monthly', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
insert @Map_ServiceFrequencyID values ('year', 'yearly', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
insert @Map_ServiceFrequencyID values ('ZZZ', 'unknown', 'C42C50ED-863B-44B8-BF68-B377C8B0FA95')

if (select COUNT(*) from @Map_ServiceFrequencyID t join AURORAX.MAP_ServiceFrequencyID m on t.DestID = m.DestID) <> 5
	delete AURORAX.MAP_ServiceFrequencyID

set nocount off;
insert AURORAX.MAP_ServiceFrequencyID
select m.ServiceFrequencyCode, m.ServiceFrequencyName, m.DestID
from @Map_ServiceFrequencyID m left join
	AURORAX.MAP_ServiceFrequencyID t on m.DestID = t.DestID
where t.DestID is null

-- this is seed data, but maybe this is not the best place for this code.....
insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
select DestID, m.ServiceFrequencyName, 99, 0
from AURORAX.MAP_ServiceFrequencyID m left join
	ServiceFrequency t on m.DestID = t.ID
where t.ID is null
GO


/*

select 
	PlacementTypeCode = k.SubType,
	PlacementOptionCode = isnull(k.Code, convert(varchar(150), k.Label)), 
	StateCode = k.StateCode, -- ??
	DestID = coalesce(s.ID, t.ID, m.DestID),
	TypeID = coalesce(s.TypeID, t.TypeID, my.DestID),
	Sequence = coalesce(s.Sequence, t.Sequence, 99),
	Text = coalesce(s.Text, t.Text, k.Label),
	MinPercentGenEd = isnull(s.MinPercentGenEd, t.MinPercentGenEd),   
	MaxPercentGenEd = isnull(s.MaxPercentGenEd, t.MaxPercentGenEd),   
	DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN NULL -- Always show in UI where there is a StateID.  Period.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					ELSE GETDATE()
					END
			END 
from 
	AURORAX.Lookups k LEFT JOIN
	AURORAX.MAP_IepPlacementTypeID my on k.SubType = my.PlacementTypeCode LEFT JOIN 
	dbo.IepPlacementOption s on 
		my.DestID = s.TypeID and
		k.StateCode = s.StateCode LEFT JOIN 
	AURORAX.MAP_IepPlacementOptionID m on 
		my.PlacementTypeCode = m.PlacementTypeCode and
		isnull(k.Code, convert(varchar(150), k.label)) = m.PlacementOptionCode LEFT JOIN
	dbo.IepPlacementOption t on m.DestID = t.ID
where k.Type = 'LRE' and
	k.SubType in ('PK', 'K12') 



*/





