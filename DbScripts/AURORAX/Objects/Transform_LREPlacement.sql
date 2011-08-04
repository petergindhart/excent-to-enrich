--#include Transform_Section.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_LREPlacement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [AURORAX].[Transform_LREPlacement]
GO

CREATE VIEW AURORAX.Transform_LREPlacement
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
		AURORAX.Transform_Iep iep JOIN 
		AURORAX.Student s on iep.StudentRefID = s.StudentRefID JOIN
		AURORAX.Transform_LRE lre ON iep.IepRefID = lre.IepRefId LEFT JOIN 
		AURORAX.Transform_IepPlacementOptionID p on iep.AgeGroup+iep.LRECode = p.SubType+p.LRECode LEFT JOIN -- select * from AURORAX.Transform_IepPlacementOptionID
		AURORAX.MAP_IepPlacement m on m.IepRefID = iep.IepRefID and t.ID = m.TypeID LEFT JOIN -- select * from AURORAX.MAP_IEPPlacement
		dbo.IepPlacement place on lre.DestID = place.ID 
		 -- left join -- select * from dbo.IepPlacementType 
GO



/*



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



