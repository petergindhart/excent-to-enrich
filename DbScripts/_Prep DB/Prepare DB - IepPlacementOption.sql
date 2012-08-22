begin tran fixLRE
set nocount on;
declare @IepPlacementOption table (ID uniqueidentifier, TypeID uniqueidentifier, Sequence int, Text varchar(500), StateCode varchar(10))
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('0B2E63D7-6493-44A7-95B1-8DF327D77C38', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 4, 'Separate class', '204')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('2E45FDA2-0767-43D0-892D-D1BB40AFCEC1', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 5, 'Separate school', '205')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('0DA48AA5-183C-4434-91C1-AC3C9941BE15', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 6, 'Residential facility', '206')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('0980382F-594C-453F-A0C9-77D54A0443B1', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 7, 'Home', '207')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('1945D36A-8D62-4FDB-9F22-5836F553A958', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 8, 'Service Provider Location', '208')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('DC20B53C-0559-44F6-A463-3A92D9D4F69A', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 0, 'Attending a regular early childhood program at least 10 hours per week AND receiving the majority of hours of special education and related services in the regular early childhood program.', '209')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('E5741B2C-CE35-4F3B-8AD5-58774E31C531', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 1, 'Attending a regular early childhood program at least 10 hours per week AND receiving the majority of hours of special education and related services in some other location.', '210')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('A3FA6E17-E828-4A7C-A002-0A49B834BD1E', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 2, 'Attending a regular early childhood program less than 10 hours per week AND receiving the majority of hours of special education and related services in the regular early childhood program.', '211')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('5654E9A5-10A8-4B58-8A5C-79DA92674A27', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC', 3, 'Attending a regular early childhood program less than 10 hours per week AND receiving the majority of hours of special education and related services in some other location.', '212')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('FEFF9910-F320-4097-AFC2-A3D9713470BD', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 0, 'General education class at least 80% of the time', '301')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('521ACE5E-D04B-4E30-80E3-517516383536', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 1, 'General education class 40% to 79% of the time', '302')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('9CD2726E-6461-4F6C-B65F-B4232FB4D36E', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 2, 'General education class less than 40% of the time', '303')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('77E0EE80-143B-41E5-84B9-5076605CCC9A', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 3, 'Separate school', '304')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('E4EE85F2-8307-4C8D-BA77-4EB5D12D8470', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 4, 'Residential facility', '305')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('91EF0ECE-A770-4D05-8868-F19180A000DB', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 5, 'Homebound/hospital', '306')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('84DAF081-F700-4F57-99DA-A2A983FDE919', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 8, 'Correctional facilities (including short-term detention)', '307')


--select * from IepPlacementOption
--select * from @IepPlacementOption


------ insert test
--select t.ID, t.TypeID, t.Sequence, t.Text, t.StateCode
--from IepPlacementOption x right join
--@IepPlacementOption t on x.ID = t.ID 
--where x.ID is null order by x.Text

------ delete test
--select x.*
--from IepPlacementOption x left join
--@IepPlacementOption t on x.ID = t.ID 
--where t.ID is null order by x.Text



-- insert missing.  This has to be done before updating the records to be deleted and before deleting.
insert IepPlacementOption (ID, TypeID, Sequence, Text, StateCode)
select t.ID, t.TypeID, t.Sequence, t.Text, t.StateCode
from IepPlacementOption x right join
@IepPlacementOption t on x.ID = t.ID 
where x.ID is null
order by x.Text


delete x
-- select x.*
from IepPlacementOption x left join
@IepPlacementOption t on x.ID = t.ID 
where t.ID is null



commit tran fixLRE

--select * from IepPlacementOption

