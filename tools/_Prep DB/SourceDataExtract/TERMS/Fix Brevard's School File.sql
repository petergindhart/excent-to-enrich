set nocount on;
select SchoolCode, SchoolName, DistrictCode = case DistrictRefID when 'BRE' then '05' else DistrictRefID end, MinutesPerWeek = MunitesPerWeek
from x_DATATEAM.SchoolBadFormat


select IepRefID, StudentRefID, IEPMeetDate, IEPStartDate, IEPEndDate, NextReviewDate, InitialEvaluationDate, LatestEvaluationDate, NextEvaluationDate, EligibilityDate, ConsentForServicesDate, ConsentForEvaluationDate = '', LREAgeGroup, LRECode, MinutesPerWeek, ServiceDeliveryStatement
from x_DATATEAM.IEPBadFormat 



--declare @cs varchar(max) ; set @cs = ''
--select @cs = @cs+c.name+ case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '' else ', ' end
--from sys.objects o
--join sys.columns c on o.object_id = c.object_id 
--where o.name = 'IEPBadFormat'
--print @cs
--go


declare @cs varchar(max) ; set @cs = ''
select @cs = @cs+c.name+ case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '' else ', ' end
from sys.objects o
join sys.columns c on o.object_id = c.object_id 
where o.name = 'StudentCOMPARE'
print @cs



select * from School

select * from x_DATATEAM.StudentCOMPARE -- 16253

set nocount on;
select IepRefID, i.StudentRefID, IEPMeetDate, IEPStartDate, IEPEndDate, NextReviewDate, InitialEvaluationDate, LatestEvaluationDate, NextEvaluationDate, EligibilityDate, ConsentForServicesDate, ConsentForEvaluationDate = '', LREAgeGroup, LRECode, MinutesPerWeek, ServiceDeliveryStatement
from x_DATATEAM.IEPBadFormat i -- 16255
join x_DATATEAM.StudentCOMPARE s on i.StudentRefID = s.StudentRefID -- 16253
where s.Disability1Code != 'L' -- 11566

-- look for race not populated
select StudentRefID, StudentLocalID, StudentStateID, FirstName, MiddleName, LastName, Birthdate, Sex, MedicaidNumber, GradeLevelCode, ServiceDistrictCode, ServiceSchoolCode, HomeDistrictCode, HomeSchoolCode, 
	IsHispanic = case when IsHispanic = '' then 'N' else IsHispanic end, 
	IsAmericanIndian = case when IsAmericanIndian = '' then 'N' else IsAmericanIndian end, 
	IsAsian = case when IsAsian = '' then 'N' else IsAsian end, 
	IsBlackAfricanAmerican = case when IsBlackAfricanAmerican = '' then 'N' else IsBlackAfricanAmerican end, 
	IsHawaiianPacIslander = case when IsHawaiianPacIslander = '' then 'N' else IsHawaiianPacIslander end, 
	IsWhite = case when IsWhite = '' then 'N' else IsWhite end, 
	Disability1Code, Disability2Code, Disability3Code, Disability4Code, Disability5Code, Disability6Code, Disability7Code, Disability8Code, Disability9Code, EsyElig, ESYTBDDate, ExitDate, ExitCode, SpecialEdStatus
from x_DATATEAM.StudentCOMPARE s 
-- where len(s.IsAmericanIndian+s.IsAsian+s.IsBlackAfricanAmerican+s.IsHawaiianPacIslander+s.IsHispanic+s.IsWhite)<>6

select s.ServiceSchoolCode, s.HomeSchoolCode,
	case when ss.SchoolCode is null then s.ServiceSchoolCode 
		when sh.SchoolCode is null then s.HomeSchoolCode 
	end, count(*) tot
from x_DATATEAM.StudentCOMPARE s
left join x_DATATEAM.SchoolBadFormat ss on s.ServiceSchoolCode = ss.SchoolCode
left join x_DATATEAM.SchoolBadFormat sh on s.HomeSchoolCode = sh.SchoolCode 
where not (ss.SchoolCode is not null and sh.SchoolCode is not null)
group by 
s.ServiceSchoolCode, s.HomeSchoolCode,
	case when ss.SchoolCode is null then s.ServiceSchoolCode 
		when sh.SchoolCode is null then s.HomeSchoolCode 
	end



select * from x_DATATEAM.StudentCOMPARE s where SpecialEdStatus <> 'A'


-------------------------------- find gifted

select s.StudentRefID, s.FirstName, s.MiddleName, s.lastname, s.Birthdate, s.Disability1Code
from x_DATATEAM.StudentCOMPARE s 
where s.Disability1Code = 'L' and s.Disability2Code = '' -- 4620

select * from x_DATATEAM.StudentCOMPARE s 
where s.Disability1Code != 'L'  -- select non-gifted primary to a file




set nocount on;
select IepRefID, i.StudentRefID, 
	IEPMeetDate, 
	IEPStartDate, 
	IEPEndDate, 
	NextReviewDate, 
	InitialEvaluationDate, 
	LatestEvaluationDate, 
	NextEvaluationDate, 
	EligibilityDate, 
	ConsentForServicesDate, 
	ConsentForEvaluationDate = '', 
	LREAgeGroup, LRECode, MinutesPerWeek, ServiceDeliveryStatement
from x_DATATEAM.IEPBadFormat i -- 16255
join x_DATATEAM.StudentCOMPARE s on i.StudentRefID = s.StudentRefID -- 16253
where s.Disability1Code != 'L' -- 11566
and not (
	isdate(IEPMeetDate) = 1 and
	isdate(IEPStartDate) = 1 and
	isdate(IEPEndDate) = 1 and
	isdate(NextReviewDate) = 1 and
	isdate(InitialEvaluationDate) = 1 and
	isdate(LatestEvaluationDate) = 1 and
	isdate(NextEvaluationDate) = 1 and
	isdate(EligibilityDate) = 1 and
	isdate(ConsentForServicesDate) = 1 
)

