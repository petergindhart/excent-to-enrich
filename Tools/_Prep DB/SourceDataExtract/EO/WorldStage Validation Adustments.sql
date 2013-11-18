

--drop table x_ADHOCIMPORT.Service



select * from iep 

select * from dbo.ifile
select * from dbo.iStudent
select * from dbo.itable
select * from dbo.ReportValidationData where tdesc = 'IEP File Import'


sp_helptext ReportValidationData



create view ReportValidationData

as

select b.rundate, f.runorder, t.tdesc, l.*
from IMPORTHX.iBatch b join 
importhx.iFile f on b.ibatchid = f.ibatchid join 
IMPORTHX.iTable t on f.itableid = t.itableid join 
IMPORTHX.iLine l on f.ifileid = l.ifileid


select * from IMPORTHX.iBatch


-- select * from sys.schemas


select * from IMPORTHX.ReportIEPFailed

select newid()


select * from x_ADHOCIMPORT.Service

set nocount on;
SELECT v.*
FROM dbo.IEP i
join x_ADHOCIMPORT.Service v on i.E_IEPREFID = v.IEPRefID






