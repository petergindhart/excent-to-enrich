--if they can perform "ConfigureDistrictSetup" than they get added to "Manage Responsbilities"
INSERT INTO SecurityRoleSecurityTask
select 
	distinct srst.RoleID,
	'766C4E24-E3FD-48CD-B2CC-1A22B221367E' -- Manage Resonsibilities
From 
	SecurityRoleSecurityTask srst join
	SecurityTask st on srst.TaskID = st.ID
where 
	SecurityTaskTypeID = '9B496F36-FAC5-4957-817D-D6AC684860D5'