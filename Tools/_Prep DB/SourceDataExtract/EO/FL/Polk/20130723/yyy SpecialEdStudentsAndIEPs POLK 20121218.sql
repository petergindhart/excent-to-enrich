
create view [dbo].[SpecialEdStudentsAndIEPs]  
as  
select   
 s.GStudentID,  
 ic.iepseqnum,   

/*
 AgeGroup = case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then 'PK' else 'K12' end,  --- see the view dbo.ReportIEPLRETblPlace
 a.Placement,   
 StateCode =   
  case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then   
   -- 'PK'   
   case a.Placement  
    when 9 then 'A'  
    when 6 then 'B'  
    when 5 then 'S'  
    when 1 then ''  
    when 2 then ''  
    when 3 then ''  
    when 8 then ''  
    when 0 then ''  
    else 'ZZZ'  
   end  
  else   
   -- 'K12'   
   case a.Placement  
    when 7 then 'C'  
    when 5 then 'D'  
    when 6 then 'F'  
    when 4 then 'H'  
    when 1 then ''  
    when 2 then ''  
    when 3 then ''  
    when 8 then ''  
    when 0 then ''  
    else 'ZZZ'  
   end  
  end,  
*/
p.AgeGroup, p.LREPlacement, p.LREPlacementB,
 s.SpedStat, s.SpedExitDate, s.SpedExitCode, ic.Meetdate/* , ESY = isnull(ic.ESY,0)  */
from Student s   --- select s.StudentID from (select * from Student s where isnull(del_flag,0)=0 and SpedStat = 1 and EnrollStat = 1 /* and s.StudentID = '5300612818' */ ) s   -- 16207
join (select ic.GStudentID, s.StudentID, ic.IEPSeqNum, ic.MeetDate/* , ic.InitDate, ic.CurEvalDate, ic.ReEvalDate, ic.ESY */ from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) ic  
 on s.gstudentid = ic.gstudentid and  
 ic.IEPSeqNum = (  
  select max(maxrec.IEPSeqNum)  
  from (select s.StudentID, ic.IEPSeqNum, ic.MeetDate from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) maxrec   
  where ic.StudentID = maxrec.studentID and  
  maxrec.MeetDate = (  
   select max(maxdate.MeetDate)  
   from (select s.StudentID, ic.IEPSeqNum, ic.MeetDate from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0 /* and ic.InitDate between '7/1/2010' and '4/2/2012' */ ) maxdate  
   where maxrec.studentid = maxdate.studentid  
   )  
  )  -- 15774
----------------------------- JENNIFER --------------  new and untested 

join (
	select L.GStudentID, l.IEPComplSeqNum, L.IEPLRESeqNum,
		CASE WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 1 and 10 THEN 'Infant'
			WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 21 and 30 THEN 'Preschool'
			WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 41 and 50 then 'Grades K-12 Part 1'
			WHEN isnull(priminstsetcode, isnull(schpriminstrcode,0) )  between 51 and 60 then 'Grades K-12 Part 2'
			ELSE 'Invalid AgeGroup' END as AgeGroup, -- check ICIEPLRETbl PrimInstSetCode and SchInstSetCode
		ltrim(isnull(priminstsetcode, schpriminstrcode)) LREPlacement,
		-- For grouping by AgeGroup in Crystal Reports, we need LREPlacement to be the same for every different AgeGroup.  Each will be 01-10 (Infant is already that)
		CASE 
			WHEN ( isnull(priminstsetcode, isnull(schpriminstrcode,0) ) between 21 and 40) THEN right('0'+convert(nvarchar,convert(int,isnull(priminstsetcode, isnull(schpriminstrcode,0) ))-20),2)
			WHEN ( isnull(priminstsetcode, isnull(schpriminstrcode,0) ) between 41 and 50) THEN right('0'+convert(nvarchar,convert(int,isnull(priminstsetcode, isnull(schpriminstrcode,0) ))-40),2)
			WHEN ( isnull(priminstsetcode, isnull(schpriminstrcode,0) ) between 51 and 60) THEN right('0'+convert(nvarchar,convert(int,isnull(priminstsetcode, isnull(schpriminstrcode,0) ))-50),2)
			ELSE ltrim(isnull(priminstsetcode, isnull(schpriminstrcode,0) )) END as LREPlacementB,
		'' HomeHosPlace,
		isnull(priminstset, schpriminstr) PlacementDesc,
		I.IEPSeqNum, I.MeetDate, I.IEPComplete
	From ICIEPLRETbl L
	Join IEPCompleteTbl I on L.GStudentID = I.GStudentID 
		and L.IEPComplSeqNum = i.IEPSeqNum 
	where isnull(L.del_flag,0)!=1 AND isnull(I.Del_flag,0)!=1 AND (isnumeric(priminstsetcode) = 1 or isnumeric(schpriminstrcode) = 1)
		AND isnull(priminstsetcode, schpriminstrcode) < '61' -- exclude invalid values
) p on ic.IEPSeqNum = p.IEPComplSeqNum 

----------------------------- JENNIFER --------------  new and untested 
--join ICAssessmentTbl a on ic.IEPSeqNum = a.IEPComplSeqNum -- 11598   
where SpedStat = 1 /* or (SpedStat = 2 and SpedExitDate > '7/1/2011')*/ -- 11598  
and isnull(s.del_flag,0)=0  -- 11598  
and s.enrollstat = 1 -- 11598  
and ic.MeetDate is not null -- 11598
--and  a.AssessSeqNum = (  
-- select max(ain.AssessSeqNum)   
-- from assessmenttbl ain  
-- where ain.gstudentid = a.gstudentid  
-- and isnull(ain.del_flag,0)=0  
-- ) -- 11598  
-- and placement is not null -- 11404  
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1)  -- 11393
and not (s.StudentID like 'Train%' or s.AlterID like 'Train%')  -- 11210
--and ic.CurEvalDate is not null -- 11190
--and ic.InitDate is not null -- 11190

-- 


