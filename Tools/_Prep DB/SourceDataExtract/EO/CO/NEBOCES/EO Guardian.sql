


	--ID varchar(150) NOT NULL,
	--FirstName varchar(50) NOT NULL,
	--LastName varchar(50) NOT NULL,
	--EmailAddress varchar(75) NULL,
	--Street varchar(50) NULL,
	--City varchar(50) NULL,
	--State char(2) NULL,
	--ZipCode varchar(10) NULL,
	--HomePhoneNumber varchar(40) NULL,
	--WorkPhoneNumber varchar(40) NULL,
	--CellPhoneNumber varchar(40) NULL

set nocount on;
select ID = c.RecNum, c.Firstname, c.Lastname, EmailAddress = isnull(c.Email,''), 
	Street = isnull(c.Addr1,'')+isnull(' '+c.addr2, ''), isnull(c.City,''), State = isnull(c.StateCode,''), ZipCode = isnull(c.Zip,''), 
	HomePoneNumber = isnull(c.ResPh,''), WorkPHoneNumber = isnull(c.OffPh,''), CellPhoneNumber = isnull(c.CellPh,'')
from SpecialEdStudentsAndIEPs x
join Contacts c on x.GStudentID = c.GStudentID
where isnull(c.del_flag,0)=0
and not isnull(c.Firstname + c.Lastname, '') = ''


