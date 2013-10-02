
ALTER FUNCTION [x_PORT].[BoulderIEP] ()
RETURNS @t TABLE 
(
	StudentID uniqueidentifier primary key,
	InvolvementID uniqueidentifier null,
	ItemID uniqueidentifier null, -- the IEP, not PrgItemForm

	studentNumber	varchar(20) NULL, -- Student number
	timeStamp	varchar(20) NULL,-- yyyy-mm-dd hh:mm:ss
	IEPYN	varchar(1),
	disabilityType	varchar(2),
	exitReason	varchar(2),
	exitDate varchar(10),
	specializedTransportation varchar(1)
)
-- update columns in the return table one-by-one
AS
BEGIN

--declare @t TABLE 
--(
--	StudentID uniqueidentifier primary key,
--	InvolvementID uniqueidentifier null,
--	ItemID uniqueidentifier null, -- the IEP, not PrgItemForm

--	studentNumber	varchar(20) NULL, -- Student number
--	timeStamp	varchar(20) NULL,-- yyyy-mm-dd hh:mm:ss
--	IEPYN	varchar(1),
--	disabilityType	varchar(2),
--	exitReason	varchar(2),
--	exitDate varchar(10)
--)


declare @startSchoolYear datetime ; select @startSchoolYear = StartDate from RosterYear where getdate() between StartDate and EndDate

--select startSchoolYear = @startSchoolYear

insert @t (StudentID, InvolvementID, studentNumber, timeStamp, IEPYN, disabilityType, exitReason, exitDate, specializedTransportation) 
select StudentID = s.ID, InvolvementID = inv.ID, studentNumber = s.Number, convert(varchar, getdate(), 120), '0', '', '', '', ''
from Student s /* join (select '443257' as Number) x on s.Number = x.Number */
--left join eff.Map_StudentID m on s.id = m.DestID
left join PrgInvolvement inv on s.ID = inv.StudentID
	and ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'
	and isnull(inv.EndDate, getdate()) > @startSchoolYear  
	-- new (only if there is a finalized IEP)
	and inv.ID = (
		select top 1 i.InvolvementID 
		from PrgItem i 
		join PrgItemDef id on i.DefID = id.ID and id.TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' -- IEP
		join PrgVersion v on i.ID = v.ItemID and v.DateFinalized is not null
		where inv.ID = i.InvolvementID 
		)
where 
	(select top 1 isnull(h.EndDate, getdate()) from StudentSchoolHistory h where s.ID = h.StudentID order by h.StartDate desc) > @startSchoolYear
	
declare @primdisab table (InvolvementID uniqueidentifier not null primary key, DisabilityID uniqueidentifier)
insert @primdisab (InvolvementID, DisabilityID)
select distinct pd.InvolvementID, pd.DisabilityID
from dbo.CurrentSpedView_PrimaryDisability pd
join @t t on pd.InvolvementID = t.InvolvementID

---- has IEP
update t set 
	ItemID = i.ID,
	IEPYN = '1'
-- select i.*
from @t t 
join PrgInvolvement inv on t.InvolvementID = inv.ID and isnull(inv.EndDate, getdate()) >= @startSchoolYear
join PrgItem i on t.InvolvementID = i.InvolvementID 
join PrgItemDef id on i.DefID = id.ID and id.TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' -- IEP
join PrgVersion v on i.ID = v.ItemID and v.DateFinalized is not null
--left join PrgStatus e on i.EndStatusID = e.ID 
where i.ID = (
	select top 1 imax.ID
	from PrgItem imax
	join PrgItemDef idmax on imax.DefID = idmax.ID and idmax.TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' -- IEP
	join PrgVersion v on imax.ID = v.ItemID and v.DateFinalized is not null
	where t.StudentID = imax.StudentID -- should not need to refine, since T is refined already
	--and imax.IsEnded = 0   Ended or not, we want to know if the student had an IEP this school year.
)

--update t set
--	exitReason = isnull(e.StateCode,'00'),
--	exitDate = isnull(convert(varchar, i.EndDate, 101), '')
--from @t t
--join PrgItem i on t.ItemID = i.ID
--join PrgStatus e on i.EndStatusID = e.ID 
--where t.IEPYN = 1

update t set
	exitReason = case when e.IsExit = 1 then isnull(e.StateCode,'00') else '00' end,
	exitDate = isnull(convert(varchar, i.EndDate, 101), '')
from @t t
join PrgInvolvementStatus i on t.InvolvementID = i.InvolvementID 
	and i.StartDate = (
		select MAX(im.StartDate)
		from PrgInvolvementStatus im
		where i.InvolvementID = im.InvolvementID)
join PrgStatus e on i.StatusID = e.ID
where t.IEPYN = 1
--and e.IsExit = 1
--and i.EndDate <= getdate()

update t set disabilityType = isnull(d.StateCode,'') 
-- select * 
from @primdisab pd
join IepDisability d on isnull(pd.DisabilityID, '00000000-0000-0000-0000-000000000000') = d.ID
join @t t on pd.InvolvementID = t.InvolvementID
where t.IEPYN = '1'

update t set specializedTransportation = '1'
-- select stu.Number, sp.*
from @t t
join PrgSection s on t.ItemID = s.ItemID
join IepServicePlan isp on s.ID = isp.InstanceID
join ServicePlan sp on isp.ID = sp.ID and sp.DefID = '003CF444-D485-43B9-8508-8D3B7E27FCB4' and sp.EndDate > dateadd(dd, -1, GETDATE()) -- transport service, active


RETURN
End;
