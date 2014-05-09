IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'usp_ImportLegacyToEnrich')
DROP PROC x_DATAVALIDATION.usp_ImportLegacyToEnrich 
GO

CREATE PROC x_DATAVALIDATION.usp_ImportLegacyToEnrich
AS
/* 
	Import legacy data into the Enrich database

	x_DATAVALIDATION.Populate_SelectLists
	x_DATAVALIDATION.Populate_District
	x_DATAVALIDATION.Populate_School
	x_DATAVALIDATION.Populate_Student
	x_DATAVALIDATION.Populate_IEP
	x_DATAVALIDATION.Populate_SpedStaffMember
	x_DATAVALIDATION.Populate_Service
	x_DATAVALIDATION.Populate_Goal
	x_DATAVALIDATION.Populate_Objective
	x_DATAVALIDATION.Populate_TeamMember
	x_DATAVALIDATION.Populate_StaffSchool


*/

BEGIN




declare @ImportTables table (
RowNum			int				not null identity(1,1),
RemoteObject	varchar(100)	not null,
EnrichTable		varchar(100)	not null
)

set nocount on;
insert @ImportTables (RemoteObject, EnrichTable) values ('SELECTLISTS_EO', 'X_DATAVALIDATION.SelectLists_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('DISTRICT_EO', 'X_DATAVALIDATION.District_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('SCHOOL_EO', 'X_DATAVALIDATION.School_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('STUDENT_EO', 'X_DATAVALIDATION.Student_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('IEP_EO', 'X_DATAVALIDATION.IEP_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('SPEDSTAFFMEMBER_EO', 'X_DATAVALIDATION.SpedStaffMember_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('SERVICE_EO', 'X_DATAVALIDATION.Service_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('GOAL_EO', 'X_DATAVALIDATION.Goal_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('OBJECTIVE_EO', 'X_DATAVALIDATION.Objective_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('TEAMMEMBER_EO', 'X_DATAVALIDATION.TeamMember_LOCAL')
insert @ImportTables (RemoteObject, EnrichTable) values ('STAFFSCHOOL_EO', 'X_DATAVALIDATION.StaffSchool_LOCAL')

--select * from @ImportTables


DECLARE @ro varchar(100), @et varchar(100), @dropq NVARCHAR(max), @insertq NVARCHAR(max), @LinkedserverAddress VARCHAR(100), @DatabaseOwner VARCHAR(100), @DatabaseName VARCHAR(100), @newline varchar(5) ; set @newline = '
'

SELECT @LinkedserverAddress = LinkedServer, @DatabaseOwner = DatabaseOwner, @DatabaseName = DatabaseName -- select *
FROM VC3ETL.ExtractDatabase 
WHERE ID = '54DD3C28-8F7F-4A54-BCF1-000000000000'

-- this is the only object populated with a stored procedure (on the remote server)
SET @insertq='EXEC '+@LinkedserverAddress+'.'+@DatabaseName+'.'+@DatabaseOwner+'.'+'DataConversionSpeedObjects'

exec (@insertq)

-- print @insertq

declare T cursor for
select RemoteObject, EnrichTable from @ImportTables order by RowNum

open T
fetch T into @ro, @et

while @@FETCH_STATUS = 0
begin
SET @dropq = 'DROP TABLE '+@et+''

SET @insertq ='SELECT * 
INTO  '+@et+' 
FROM  '+isnull(@LinkedserverAddress,'linkservhere')+'.'+isnull(@DatabaseName,'dbnamehere')+'.'+isnull(@DatabaseOwner,'dbohere')+'.'+''+@ro+''


exec(@dropq)
exec (@insertq)

-- print @newline+@dropq+@newline+@newline+@insertq+@newline



fetch T into @ro, @et
end
close T
deallocate T

END

GO



-- SELECT LinkedServer, DatabaseOwner, DatabaseName FROM VC3ETL.ExtractDatabase WHERE ID = '54DD3C28-8F7F-4A54-BCF1-000000000000'

