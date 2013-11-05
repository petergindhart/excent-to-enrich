BULK
INSERT x_LEGACYRTI.RTIStudent_LOCAL 
FROM 'E:\DataFiles\FL\Bay\new\RTIStudents.csv'
WITH
(
FIELDTERMINATOR = '|',
FIRSTROW = 2,
ROWTERMINATOR = '\n'
)
GO



IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATATEAM.RTIStudent_LOCAL_Removed') AND type in (N'U'))
DROP TABLE x_DATATEAM.RTIStudent_LOCAL_Removed
GO  

CREATE TABLE x_DATATEAM.RTIStudent_LOCAL_Removed (	
	StudentLocalID	varchar(20) not null, -- remember this might be a GUID or something else in some other environement
	StudentStateID varchar(20) not null,
	FirstName varchar(20) null,
	LastName varchar(20) null,
	StartDate	datetime  null,
	EndDate	datetime null,
	Area VARCHAR(150) null,
	Status VARCHAR(150) null
)
GO

insert x_DATATEAM.RTIStudent_LOCAL_Removed
select * 
from x_LEGACYRTI.RTIStudent_LOCAL e
where isdate(startdate) =0

insert x_DATATEAM.RTIStudent_LOCAL_Removed
select * 
from x_LEGACYRTI.RTIStudent  rti
where status like '%|%'

insert x_DATATEAM.RTIStudent_LOCAL_Removed
select *
from x_LEGACYRTI.RTIStudent rti 
where studentlocalid in ('0306091099','0306222509','0312045695','0312046527','0306165146','0306173117','0306091825','0306192201', '0306096792')


delete e
--select * 
from x_LEGACYRTI.RTIStudent_LOCAL e
where isdate(startdate) =0

delete rti
--select * 
from x_LEGACYRTI.RTIStudent  rti
where status like '%|%'

delete rti
--select studentlocalid,area, startdate,count(*) 
from x_LEGACYRTI.RTIStudent rti 
where studentlocalid in ('0306091099','0306222509','0312045695','0312046527','0306165146','0306173117','0306091825','0306192201', '0306096792')