
if exists (select 1 from sysobjects where name = 'fn_AgeAsOf')
drop function fn_AgeAsOf
go

create function fn_AgeAsOf (@AgeAsOfDate datetime, @Birthdate datetime)  
returns int
as  
begin
declare @AgeOut int;
select @AgeOut = cast ((  
  (datepart(yy, @AgeAsOfDate)- datepart(yy, @Birthdate))*360.0 +  
  (datepart(mm, @AgeAsOfDate)- datepart(mm, @Birthdate))*30 +  
  (datepart(dd, @AgeAsOfDate)- datepart(dd, @Birthdate)))/30/12 as int)
return @AgeOut
end
go


if exists (select 1 from sysobjects where name = 'SpecialEdStudentsAndIEPs')
drop view dbo.SpecialEdStudentsAndIEPs
go

create view dbo.SpecialEdStudentsAndIEPs
as  
select   
 s.GStudentID,  
 ic.iepseqnum, 
 SpedOrGifted = case when ic.EP_IEP = 0 then 'Gifted' else 'SpEd' end,
 AgeGroup = case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then 'PK' else 'K12' end,  
 a.Placement,   
 StateCode =   
  case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then   
   -- 'PK'   
   case a.Placement  
    when 9 then 'A'  
    when 6 then 'B'  
    when 5 then 'S'  
    when 1 then 'K'  
    when 2 then ''  
    when 3 then 'M'  
    when 8 then ''  
    when 0 then ''  
    else 'ZZZ'  
   end -- sped
  else   
   -- 'K12'   
   case a.Placement  
    when 7 then 'C'  
    when 5 then ''  
    when 6 then 'F'  
    when 4 then 'H'  
    when 1 then 'Z1'  
    when 2 then 'Z2'  
    when 3 then 'Z3'  
    when 8 then 'Z'  
    when 0 then ''  
    else 'ZZZ'  
   end -- sped
  end,  
 s.SpedStat, s.SpedExitDate, s.SpedExitCode, ic.Meetdate, ESY = isnull(ic.ESY,0) 
from Student s
join (select ic.GStudentID, s.StudentID, ic.IEPSeqNum, ic.MeetDate, ic.InitDate, ic.CurEvalDate, ic.ReEvalDate, ic.ESY, ic.ep_iep from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) ic  
 on s.gstudentid = ic.gstudentid and  
 ic.IEPSeqNum = (  
  select max(maxrec.IEPSeqNum)  
  from (select s.StudentID, ic.IEPSeqNum, ic.MeetDate from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) maxrec   
  where ic.StudentID = maxrec.studentID and  
  maxrec.MeetDate = (  
   select max(maxdate.MeetDate)  
   from (select s.StudentID, ic.IEPSeqNum, ic.MeetDate from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) maxdate  
   where maxrec.studentid = maxdate.studentid  
   )  
  ) 
left join ICAssessmentTbl a on ic.IEPSeqNum = a.IEPComplSeqNum
and  a.AssessSeqNum = (  
 select max(ain.AssessSeqNum)   
 from icassessmenttbl ain  
 where ain.gstudentid = a.gstudentid  
 and isnull(ain.del_flag,0)=0  
 ) 
where SpedStat = 1 
and isnull(s.del_flag,0)=0  
and s.enrollstat = 1 
and ic.MeetDate is not null 
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1) 
and not (s.StudentID like 'Train%' or s.AlterID like 'Train%')
 and (ic.EP_IEP = 0 or (ic.EP_IEP = 1 and ic.MeetDate > dateadd(mm, -18, getdate())))
-- 




