
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


alter view [dbo].[SpecialEdStudentsAndIEPs]  
as  
select   
 s.GStudentID,  
 ic.iepseqnum,   
 AgeGroup = case when dbo.fn_AgeAsOf(ic.MeetDate, s.Birthdate) < 6 then 'PK' else 'K12' end,  
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
 s.SpedStat, s.SpedExitDate, s.SpedExitCode, ic.Meetdate, ESY = isnull(ic.ESY,0) 
from Student s   --- select s.StudentID from (select * from Student s where isnull(del_flag,0)=0 and SpedStat = 1 and EnrollStat = 1 /* and s.StudentID = '5300612818' */ ) s   -- 16207
join (select ic.GStudentID, s.StudentID, ic.IEPSeqNum, ic.MeetDate, ic.InitDate, ic.CurEvalDate, ic.ReEvalDate, ic.ESY from iepcompletetbl ic join student s on ic.gstudentid = s.gstudentid where isnull(ic.del_flag,0)=0 and isnull(s.del_flag,0)=0) ic  
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
join ICAssessmentTbl a on ic.IEPSeqNum = a.IEPComplSeqNum -- 11598   
where SpedStat = 1 /* or (SpedStat = 2 and SpedExitDate > '7/1/2011')*/ -- 11598  
and isnull(s.del_flag,0)=0  -- 11598  
and s.enrollstat = 1 -- 11598  
and ic.MeetDate is not null -- 11598
and  a.AssessSeqNum = (  
 select max(ain.AssessSeqNum)   
 from assessmenttbl ain  
 where ain.gstudentid = a.gstudentid  
 and isnull(ain.del_flag,0)=0  
 ) -- 11598  
and placement is not null -- 11404  
and s.GStudentID in (select sd.GStudentID from StudDisability sd join DisabilityLook d on sd.DisabilityID = d.DisabilityID where isnull(sd.del_flag,0)=0 and sd.PrimaryDiasb = 1)  -- 11393
and not (s.StudentID like 'Train%' or s.AlterID like 'Train%')  -- 11210
and ic.CurEvalDate is not null -- 11190
and ic.InitDate is not null -- 11190
and ic.MeetDate > dateadd(mm, -18, getdate())
-- 
 
  
  
