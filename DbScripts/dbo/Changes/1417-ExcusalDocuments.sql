-- delete excusal documents
delete from PrgDocument
where ID in
	(select DocumentID from PrgMeetingExcusal)

-- delete reldef reference to excusal document
update PrgItemRelDef set ExcusalDocumentDefID = null
GO
alter table [PrgItemRelDef]
drop constraint [FK_PrgItemRelDef#ExcusalDocumentDef#]
go
alter table [PrgItemRelDef]
drop column [ExcusalDocumentDefID]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItemRelDef_GetRecordsByExcusalDocumentDef]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [PrgItemRelDef_GetRecordsByExcusalDocumentDef]
go

-- delete excusal reference to document
alter table [PrgMeetingExcusal]
drop constraint [FK_PrgMeetingExcusal#Document#]
go
alter table [PrgMeetingExcusal]
drop column [DocumentID]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgMeetingExcusal_GetRecordsByDocument]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [PrgMeetingExcusal_GetRecordsByDocument]
go

-- add document def reference to rel def
alter table [PrgDocumentDef]
add [ItemRelDefId] uniqueidentifier null
go
alter table [PrgDocumentDef]
add constraint [FK_PrgDocumentDef#ItemRelDef#DocumentDefs]
foreign key (ItemRelDefId) references [PrgItemRelDef](ID)
go

-- add document reference to excusal
alter table [PrgDocument]
add [ExcusalId] uniqueidentifier null
go
alter table [PrgDocument]
add constraint [FK_PrgDocument#Excusal#Documents]
foreign key (ExcusalId) references [PrgMeetingExcusal](ID)
go
