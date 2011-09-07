--#include Transform_IepPlacementOption.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_LRE') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW AURORAX.Transform_LRE
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_LREPlacement') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW AURORAX.Transform_LREPlacement
GO

-- ############################################################################# 
-- LRE Placement
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepPlacementID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_IepPlacementID
(
	IepRefID	varchar(150) NOT NULL,
	TypeId uniqueidentifier not null,
	DestID uniqueidentifier NOT NULL -- this is the id of the iepplacement recod
)

ALTER TABLE AURORAX.MAP_IepPlacementID ADD CONSTRAINT
PK_MAP_IepPlacement PRIMARY KEY CLUSTERED
(
	IepRefID,
	TypeId
)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepPlacement') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW AURORAX.Transform_IepPlacement
GO

CREATE VIEW AURORAX.Transform_IepPlacement
AS
	SELECT
		iep.IepRefID,
		DestID = m.DestID,
		InstanceID = lre.DestID,
		TypeID = t.ID,
		OptionID = case when p.TypeID = t.ID then p.DestID else NULL End,
		IsEnabled = case when p.TypeID = t.ID then 1 else 0 End,
		IsDecOneCount = case when p.TypeID = t.ID then 1 else 0 End -- select t.ID TypeID
	FROM dbo.IepPlacementType t CROSS JOIN
		AURORAX.Transform_PrgIep iep JOIN 
		AURORAX.Student s on iep.StudentRefID = s.StudentRefID JOIN
		AURORAX.Transform_IepLeastRestrictiveEnvironment lre ON iep.IepRefID = lre.IepRefId LEFT JOIN 
		AURORAX.Transform_IepPlacementOption p on 
			iep.AgeGroup = p.PlacementTypeCode AND
			iep.LRECode = p.PlacementOptionCode LEFT JOIN -- select * from AURORAX.Transform_IepPlacementOption -- go back and return all rows in the transform, making sure that the map populating queries aren't affected.
		AURORAX.MAP_IepPlacementID m on m.IepRefID = iep.IepRefID and t.ID = m.TypeID LEFT JOIN -- select * from AURORAX.MAP_IEPPlacement
		dbo.IepPlacement place on lre.DestID = place.ID 
		 -- left join -- select * from dbo.IepPlacementType 
GO



/*



GEO.ShowLoadTables IepPlacement


set nocount on;
declare @n varchar(100) ; select @n = 'IepPlacement'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	SourceTable = 'AURORAX.Transform_'+@n
	, HasMapTable = 1
	, MapTable = 'AURORAX.MAP_IepPlacementID'
	, KeyField = 'IepRefID, TypeId'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = NULL
	, Enabled = 1
from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


begin tran testPlace
DELETE AURORAX.MAP_IepPlacementID
FROM AURORAX.Transform_IepPlacement AS s RIGHT OUTER JOIN 
	AURORAX.MAP_IepPlacementID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE IepPlacement
SET OptionID=s.OptionID, TypeID=s.TypeID, IsEnabled=s.IsEnabled, InstanceID=s.InstanceID, IsDecOneCount=s.IsDecOneCount
FROM  IepPlacement d JOIN 
	AURORAX.Transform_IepPlacement  s ON s.DestID=d.ID

INSERT AURORAX.MAP_IepPlacementID
SELECT IepRefID, TypeId, NEWID()
FROM AURORAX.Transform_IepPlacement s
WHERE NOT EXISTS (SELECT * FROM IepPlacement d WHERE s.DestID=d.ID)

Msg 2627, Level 14, State 1, Line 12
Violation of PRIMARY KEY constraint 'PK_MAP_IepPlacement'. Cannot insert duplicate key in object 'AURORAX.MAP_IepPlacementID'.
The statement has been terminated.


SELECT IepRefID, TypeId, count(*)
FROM AURORAX.Transform_IepPlacement s
WHERE NOT EXISTS (SELECT * FROM IepPlacement d WHERE s.DestID=d.ID)
group by IepRefID, TypeId
having count(*) > 1

select * from AURORAX.MAP_IepPlacementID where IepRefID = '0F122B76-0855-4448-874A-8BBAC4C26CA2'
select * from AURORAX.IEP where IepRefID = '0F122B76-0855-4448-874A-8BBAC4C26CA2'
select * from AURORAX.Transform_IepPlacement where IepRefID = '0F122B76-0855-4448-874A-8BBAC4C26CA2'
select * from AURORAX.Transform_IepLeastRestrictiveEnvironment where IepRefID = '0F122B76-0855-4448-874A-8BBAC4C26CA2'

select m.*
from AURORAX.MAP_IepPlacementID m left join 
	dbo.IepPlacement p on m.DestID = p.ID
where p.ID is null




INSERT IepPlacement (ID, OptionID, TypeID, IsEnabled, InstanceID, IsDecOneCount)
SELECT s.DestID, s.OptionID, s.TypeID, s.IsEnabled, s.InstanceID, s.IsDecOneCount
FROM AURORAX.Transform_IepPlacement s
WHERE NOT EXISTS (SELECT * FROM IepPlacement d WHERE s.DestID=d.ID)

rollback tran testPlace

select * from IepPlacement























select t.ID, 
FROM 
	dbo.IepPlacementType t CROSS JOIN -- left join -- select * from dbo.IepPlacementType 
	AURORAX.Transform_Iep iep JOIN
	AURORAX.Student s on iep.StudentRefID = s.StudentRefID JOIN
	AURORAX.Transform_LRE lre ON iep.IepRefID = lre.IepRefId LEFT JOIN 
	AURORAX.Transform_IepPlacementOptionID p on iep.AgeGroup+iep.LRECode = p.SubType+p.LRECode LEFT JOIN -- select * from AURORAX.Transform_IepPlacementOptionID
	AURORAX.MAP_IepPlacement m on m.IepRefID = iep.IepRefID and p.TypeID = m.TypeID and t.TypeID = m.TypeID LEFT JOIN -- select * from AURORAX.MAP_IEPPlacement
	dbo.IepPlacement place on lre.DestID = place.ID 





select * from AURORAX.Transform_IepPlacementOptionID




--IsDecOneCount 

--for optionid record 
--	if dob between iepstart and dec1 then 0 else 1
--for optionid null
--	if dob between iepstart and dec1 then 1 else 0

--if student is 5 yo then
--	if dob between iepstart and nextdec1 then
--		if optionid is null then 1 else 0
--else 

-- (student 5yo and dob between iepstart and nextdec1)
	--optionid is null then 1 else 0 end
-- else 
	--optionid is null then 0 else 1 end

declare @iepstartdate datetime, @dob datetime, @nextdec1 datetime; select @iepstartdate = '12/5/2010', @dob = '12/6/2005'
select @nextdec1 = case when datepart(MM, @iepstartdate) < 12 then '12/1/'+convert(char(4), DATEPART(yy, @iepstartdate)) else '12/1/'+convert(char(4), DATEPART(yy, @iepstartdate)+1) end
-- select IEPAge = DATEDIFF(yy, @dob, @iepstartdate)
-- select datepart(yy, @nextdec1) - datepart(yy, @dob) + 1
select @nextdec1 -- , convert(varchar(2), datepart(MM, @dob)), convert(varchar(2), DATEPART(dd, @dob))


select 
	nextbday = case when (datediff(yy, @dob, @iepstartdate) = 5 )  
	then 
	convert(varchar, case
           when dateadd(year, year(@iepstartdate)- year(@dob), @dob) <= @iepstartdate
           then dateadd(year, year(@iepstartdate)- year(@dob)+1, @dob)
           else dateadd(year, year(@iepstartdate)- year(@dob), @dob)
        end, 101)
	else 'not 5 yo'
	end




	SELECT
		iep.IepRefID,
		DestID = lre.DestID,
		InstanceID = lre.DestID,
		TypeID = p.TypeID,
		OptionID = case when p.TypeID = t.ID then p.DestID else NULL End,
		IsEnabled = case when p.TypeID = t.ID then 1 else 0 End,
		IsDecOneCount = case when p.TypeID = t.ID then 1 else 0 End
	FROM 
		AURORAX.Transform_Iep iep JOIN
		AURORAX.Student s on iep.StudentRefID = s.StudentRefID JOIN
		AURORAX.Transform_LRE lre ON iep.IepRefID = lre.IepRefId LEFT JOIN 
		AURORAX.Transform_IepPlacementOptionID p on iep.AgeGroup+iep.LRECode = p.SubType+p.LRECode LEFT JOIN
		AURORAX.MAP_IepPlacement m on iep.IepRefID = m.IepRefID LEFT JOIN
		dbo.IepPlacement place on lre.DestID = place.ID CROSS JOIN
		dbo.IepPlacementType t 
order by InstanceID, OptionID, t.ID

select * from IepPlacement order by instanceid, optionID 

*/



