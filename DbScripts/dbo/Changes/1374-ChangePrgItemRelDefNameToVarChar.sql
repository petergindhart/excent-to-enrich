
exec sp_rename @objname='PrgItemRelDef.Name', @newname='OldName', @objtype='column'
GO
alter table PrgItemRelDef add Name varchar(100) null
GO 

update PrgItemRelDef set Name = cast(OldName as varchar(100))
GO

alter table PrgItemRelDef drop column OldName

