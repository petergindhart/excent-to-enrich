--#include ..\Include\SC_Config_01.sql
--#include ..\Include\SC_Config_02.sql

-- configure a program level activity definition with non versioned disability eligibility section
insert PrgStatus values ( '2E9F71DF-05ED-447E-B496-3B47ACB49BE4', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', 3, 'Eligible', 0, 0, NULL, 'FA528C27-E567-4CC9-A328-FF499BB803F6')
insert PrgItemDef values ( '2DD5FDB4-85E6-4F8F-BF8A-44E962B7D416', '2A37FB49-1977-48C7-9031-56148AEE8328', 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C', '2E9F71DF-05ED-447E-B496-3B47ACB49BE4', 'Disabilities', NULL, NULL, 0, NULL, 0)
INSERT PrgActivityReason VALUES( 'FF63110D-D40A-407C-99BF-3A8C77EE4CDD', '2DD5FDB4-85E6-4F8F-BF8A-44E962B7D416', 'imported from EO', 0 )
insert PrgSectionDef values ( '98F55873-FB51-4B1A-AE46-4BABC4B0FBA0', 'F65AEF7A-5EF8-46DD-B207-ADA61CD3A4CB', '2DD5FDB4-85E6-4F8F-BF8A-44E962B7D416', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL )

-- there needs to be a record in that table to reference from FileData
insert PrgDocumentDef (ID, ItemDefId, Name, TemplateFileId, Description, FinalizeTypeId, AutoAttach)
values ('E26B279A-4206-49F4-94C7-4933782A8E66', '251DA756-A67A-453C-A676-3B88C1B9340C', 'Imported ExcentOnline IEP document', NULL, 'Imported ExcentOnline IEP document', 'V', 0)
go
