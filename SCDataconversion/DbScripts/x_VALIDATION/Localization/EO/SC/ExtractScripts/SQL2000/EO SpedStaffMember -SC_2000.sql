IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vw_SpedStaffMember') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.vw_SpedStaffMember
GO

CREATE VIEW dbo.vw_SpedStaffMember
AS
select
    --Line_No=Row_Number() OVER (ORDER BY (SELECT 1)), 
	StaffEmail = t.Email,
	t.Firstname,
	t.Lastname,
	EnrichRole = NULL
--select t.*
FROM 
	Staff t
where isnull(t.email,'') <> ''
	-- isnull(t.del_flag,0)=0  -- removing this criterion because some recent service providers may have been deleted
and t.email  in (select de.email from staff de where isnull(de.del_flag,0)=0 group by de.email having count(*) = 1)
and t.staffgid = (
	select min(convert(varchar(36), stmin.staffgid))
	from Staff stmin
	where t.email = stmin.email 
	and isnull(stmin.del_flag,0)= (
		select min(isnull(convert(tinyint,delmin.del_flag),0))
		from Staff delmin
		where stmin.email = delmin.email 
		)
	)
GO

IF  EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.SpedStaffMember_src') AND type in (N'U'))
DROP TABLE dbo.SpedStaffMember_src
GO

SELECT 	
	Line_No= IDENTITY(INT,1,1),
	StaffEmail,
	Firstname,
	Lastname,
	EnrichRole 
	INTO dbo.SpedStaffMember_src
FROM vw_SpedStaffMember

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.SpedStaffMember_EO') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW dbo.SpedStaffMember_EO
GO

CREATE VIEW dbo.SpedStaffMember_EO
AS
SELECT 	
	Line_No,
	StaffEmail ,
	Firstname,
	Lastname,
	EnrichRole 
FROM SpedStaffMember_src