--Iep Dates
select st.Number,it.startdate ,it.PlannedEndDate 
,idat.LatestEvaluationDate,idat.InitialIepDate,idat.InitialEvaluationDate,idat.InitialEligibilityDate,idat.NextReviewDate,idat.NextEvaluationDate,idat.NextEligibilityDate
,consent.ConsentDate 
from Student st 
join PrgItem it on st.ID = it.StudentID 
join PrgSection sec on sec.ItemID = it.ID
--join PrgConsent pc on pc.ID = sec.ID  
join IepDates idat on idat.ID = sec.ID 
join (select pc.ID as ConsentID,st.ID  as studentid ,pc.ConsentDate
from PrgConsent pc join PrgSection sec on sec.ID = pc.ID 
join PrgItem it on it.ID = sec.ItemID join Student st on st.ID = it.StudentID) consent on consent.studentid = st.ID
where it.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

--Service 
select sp.* from ServicePlan sp join student st join servicedef sd on sp.DefID =sd.ID 

select pc.ID as ConsentID,st.ID  as studentid ,pc.ConsentDate
from PrgConsent pc join PrgSection sec on sec.ID = pc.ID 
join PrgItem it on it.ID = sec.ItemID join Student st on st.ID = it.StudentID
where it.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

select * from PrgItemDef 
--sp_help 'PrgConsent'

select iep.* from LEGACYSPED.IEP_LOCAL iep join LEGACYSPED.Student_LOCAL st on st.StudentRefID = iep.StudentRefID