DECLARE @studentID UNIQUEIDENTIFIER
SET @studentID = 'AD7FE1E9-EA89-49C1-B62D-27059A191B4E'

--Iep Dates
select st.ID,st.Number,it.startdate ,it.PlannedEndDate 
,idat.LatestEvaluationDate,idat.InitialIepDate,idat.InitialEvaluationDate,idat.InitialEligibilityDate,idat.NextReviewDate,idat.NextEvaluationDate,idat.NextEligibilityDate
,consent.ConsentDate,(select Name from PrgItemDef where ID = it.DefID) ProgramName
from Student st 
join PrgItem it on st.ID = it.StudentID 
join PrgSection sec on sec.ItemID = it.ID
--join PrgConsent pc on pc.ID = sec.ID  
join IepDates idat on idat.ID = sec.ID 
join (select pc.ID as ConsentID,st.ID  as studentid ,pc.ConsentDate
from PrgConsent pc join PrgSection sec on sec.ID = pc.ID 
join PrgItem it on it.ID = sec.ItemID join Student st on st.ID = it.StudentID) consent on consent.studentid = st.ID
where  st.ID = @studentID

--Service 
select st.Number,sd.Name as ServiceName,sp.StartDate,sp.EndDate,spt.Name,(convert( varchar(50),sp.Amount) +' '+ su.Name + ' '+ sf.Name) Amount 
,(case when isp.DirectID= 'A7061714-ADA3-44F7-8329-159DD4AE2ECE' then 'Direct' when isp.DirectID = '1A8BF908-E3ED-45B0-8EEC-99CB1AD0806F' then 'Indirect' else '' end) as DirectOrInDirect
,(case when isp.ExcludesID= '235C3167-A3E6-4D1D-8AAB-0B2B57FD5160' then 'Inside General Education Classroom' when isp.ExcludesID ='493713FB-6071-42D4-B46A-1B09037C1F8B' then 'Outside General Education Classroom' else '' end )as Setting
,cat.Name as Category,typ.Name
from ServicePlan sp 
join IepServicePlan isp on isp.ID = sp.ID
left join student st on st.ID = sp.studentID left join servicedef sd on sp.DefID =sd.ID 
--left join PrgItem it on it.StudentID = st.ID 
--left join PrgItemDef itd on it.DefID = itd.ID 
left join ServiceFrequency sf on sf.ID = sp.FrequencyID
left join ServiceProviderTitle spt on spt.ID = sp.ProviderTitleID
left join ServiceUnit su on su.ID = sp.UnitID
left join ServiceType typ on typ.ID = sp.ServiceTypeID
left join IepServiceCategory cat on cat.ID = isp.CategoryID
WHERE st.ID = @studentID

--LRE
select st.ID as StudentID,st.Number as StudentNumber,plop.Text as PlacementOption,plty.Name as PlacementType,pl.AsOfDate,(select Name from PrgItemDef where ID = it.DefID) ProgramName
from IepPlacement pl 
left join IepPlacementOption plop on pl.OptionID = plop.ID
left join IepPlacementType plty on plty.ID = pl.TypeID
left join IepLeastRestrictiveEnvironment lre on lre.ID = pl.InstanceID
left join PrgSection sec on sec.ID = lre.ID
left join PrgItem it on sec.ItemID = it.ID
left join Student st on st.ID = it.StudentID
Where st.ID = @studentID

--Disability
SELECT st.ID as StudentID, st.Number as StudentNumber,dis.Name, 
(case when diselig.PrimaryOrSecondaryID = 'AF6825FF-336C-42CE-AF57-CD095CD0DD2C' then 'PrimaryDisability' when diselig.PrimaryOrSecondaryID = '51619296-9938-4977-8B5F-A6E0FAEE4294' then 'SecondaryDisability' else ''end ) as PrimaryOrSecondary
FROM IepDisabilityEligibility diselig
left join IepDisability dis on dis.ID = diselig.DisabilityID
left join PrgSection sec on sec.ID = diselig.InstanceID
left join PrgItem it on sec.ItemID = it.ID
left join Student st on st.ID = it.StudentID
Where st.ID = @studentID

--PrgGoal
select st.ID,pg.GoalStatement,pgt.Name as GoalType,igad.Name as GoalArea,pgf.Name,pg.StartDate,pg.TargetDate,itd.Name as PrgItemName from PrgGoal pg 
join IepGoal ig on pg.ID = ig.ID 
left join IepGoalArea iga on iga.ID = ig.GoalAreaID
left join IepGoalAreaDef igad on igad.ID = iga.DefID
left join PrgGoals pgs on pgs.ID = pg.InstanceID
left join PrgGoalProgressFreq pgf on pgf.ID  = pgs.ReportFrequencyID
left join PrgGoalType pgt on pgt.ID = pg.TypeID 
left join PrgSection sec on sec.ID = pgs.ID
left join PrgItem it on it.ID = sec.ItemID
left join PrgItemDef itd on itd.ID = it.DefID
left join Student st on st.ID = it.StudentID 
where st.ID = @studentID

/*
select * from PrgGoal
select * from IepServicePlan
select pc.ID as ConsentID,st.ID  as studentid ,pc.ConsentDate
from PrgConsent pc join PrgSection sec on sec.ID = pc.ID 
join PrgItem it on it.ID = sec.ItemID join Student st on st.ID = it.StudentID
where it.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
select * from IepServiceCategory

select * from PrgItemDef 
--sp_help 'IepServicePlan'
select * from LEGACYSPED.Transform_Student
select Distinct IsEligibileID from IepDisabilityEligibility

select * from EnumValue where Type = '8AAE4560-A340-4E96-AD68-257013400684'
--TYPE ='3084B4BA-0EC7-418B-B860-CF93F6325D84'
select Distinct DirectID from IepServicePlan

select st.Number,it.startdate ,it.PlannedEndDate 
--,idat.LatestEvaluationDate,idat.InitialIepDate,idat.InitialEvaluationDate,idat.InitialEligibilityDate,idat.NextReviewDate,idat.NextEvaluationDate,idat.NextEligibilityDate
--,consent.ConsentDate 
from Student st 
join PrgItem it on st.ID = it.StudentID 
--join PrgSection sec on sec.ItemID = it.ID
--join PrgConsent pc on pc.ID = sec.ID  
--join IepDates idat on idat.ID = sec.ID 

where  st.ID = 'FEB41F81-42D3-4270-8A06-16AA74E9D271'

select iep.* from LEGACYSPED.IEP_LOCAL iep join LEGACYSPED.Student_LOCAL st on st.StudentRefID = iep.StudentRefID

select * from ServiceSchedule
*/

