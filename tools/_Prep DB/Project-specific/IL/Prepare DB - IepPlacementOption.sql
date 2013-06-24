begin tran fixLRE
set nocount on;
declare @IepPlacementOption table (ID uniqueidentifier, TypeID uniqueidentifier, Sequence int, Text varchar(500), StateCode varchar(10))
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('FEFF9910-F320-4097-AFC2-A3D9713470BD','D9D84E5B-45F9-4C72-8265-51A945CD0049','0','40%-79% of pupils school day inside the general education classroom','2')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('521ACE5E-D04B-4E30-80E3-517516383536','D9D84E5B-45F9-4C72-8265-51A945CD0049','1','80% or more of pupils school day inside the general education classroom','1')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('9CD2726E-6461-4F6C-B65F-B4232FB4D36E','D9D84E5B-45F9-4C72-8265-51A945CD0049','2','Department of Human Services operated facility','16')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('84DAF081-F700-4F57-99DA-A2A983FDE919','D9D84E5B-45F9-4C72-8265-51A945CD0049','3','Full-time special ed. classes in county/municipal detention center or jail','7')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('09AFB313-607B-4FAE-9161-12E3F4C04C7F','D9D84E5B-45F9-4C72-8265-51A945CD0049','4','Full-time special education class in a separate public day school','4')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('81294084-167C-450F-8E0D-EB93840FC53D','D9D84E5B-45F9-4C72-8265-51A945CD0049','5','Full-time special education in a separate public day school in conjunction','5')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('0980382F-594C-453F-A0C9-77D54A0443B1','D9D84E5B-45F9-4C72-8265-51A945CD0049','6','Home: in principal residence','26')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('A1162DF7-648F-4B27-B95A-4584D411380C','D9D84E5B-45F9-4C72-8265-51A945CD0049','7','Homebound instructional program','11')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('13056D44-CBB6-4800-B7C2-E6C56E1481FD','D9D84E5B-45F9-4C72-8265-51A945CD0049','8','Hospital instructional program','12')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('EE9A9BF5-EA98-4110-B16B-F361F844763C','D9D84E5B-45F9-4C72-8265-51A945CD0049','9','Illinois Center for Rehabilitation & Education','15')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('175E9AB1-C70E-4D69-8A11-01E0B3C46D8E','D9D84E5B-45F9-4C72-8265-51A945CD0049','10','Illinois School for the Deaf','13')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('5123C823-3924-4E76-8AE3-25CD57ED2C0A','D9D84E5B-45F9-4C72-8265-51A945CD0049','11','Illinois School for the Visually Impaired','14')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('322C2412-1A26-4E86-B925-5C36F55FEF29','D9D84E5B-45F9-4C72-8265-51A945CD0049','12','less than 40% of pupils school day inside the general education classroom','3')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('3B0A8E9B-72DB-4676-8BBA-16556B901410','D9D84E5B-45F9-4C72-8265-51A945CD0049','13','No Services Recommended','NONE')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('CAB5FE8B-46DF-45DC-A74E-7A1D2DE2FBEE','D9D84E5B-45F9-4C72-8265-51A945CD0049','14','Parentally Placed in Nonpublic Schools or Home-Schooled','28')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('86D50EA6-D480-4CEB-961F-8B745F6D9A92','D9D84E5B-45F9-4C72-8265-51A945CD0049','15','Philip J. Rock Center and School','6')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('F1BCF2B0-011A-48F2-B2B4-794CD31B705E','D9D84E5B-45F9-4C72-8265-51A945CD0049','16','Private Day School or out-of-state public day school program','8')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('3FAAF008-0676-4B15-97A2-74FCA533D3B8','D9D84E5B-45F9-4C72-8265-51A945CD0049','17','Private residential, in state, also needs annual approval ISBE Form 34-37','9')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('80F6BEFD-BDA5-48A0-A47F-4004C8CFB583','D9D84E5B-45F9-4C72-8265-51A945CD0049','18','Private residential, out of state, also needs annual approval ISBE Form 34-37','10')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('DC20B53C-0559-44F6-A463-3A92D9D4F69A','D9D84E5B-45F9-4C72-8265-51A945CD0049','19','Regular Early Childhood Program: in program, 600+ minutes','30')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('113D7C93-D4EA-495E-9BF5-257367B0587E','D9D84E5B-45F9-4C72-8265-51A945CD0049','20','Residential Facility: in publicly/privately operated school/facility','25')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('333CBCB5-6925-43DA-94E6-996FCC528C3F','D9D84E5B-45F9-4C72-8265-51A945CD0049','21','Separate Class in a program with less than 50% non-disabled children','23')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('5085EEB4-4910-41A0-8E8C-44F2A5BC8997','D9D84E5B-45F9-4C72-8265-51A945CD0049','22','Separate School: in a public/private day school','24')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('1945D36A-8D62-4FDB-9F22-5836F553A958','D9D84E5B-45F9-4C72-8265-51A945CD0049','23','Service Provider Location','27')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('5654E9A5-10A8-4B58-8A5C-79DA92674A27','E47FBA7F-8EB0-4869-89DF-9DD3456846EC','0','Regular Early Childhood Program: in other location, 599- minutes','33')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('8EF92CCC-DA2E-4DEC-B596-BC558804EAD6','E47FBA7F-8EB0-4869-89DF-9DD3456846EC','1','Regular Early Childhood Program: in other location, 600+ minutes','31')
insert @IepPlacementOption (ID, TypeID, Sequence, Text, StateCode) values ('A3FA6E17-E828-4A7C-A002-0A49B834BD1E','E47FBA7F-8EB0-4869-89DF-9DD3456846EC','2','Regular Early Childhood Program: in program, 599- minutes','32')


--select * from IepPlacementOption
--select * from @IepPlacementOption


---- insert test
select t.ID, t.TypeID, t.Sequence, t.Text, t.StateCode
from IepPlacementOption x right join
@IepPlacementOption t on x.ID = t.ID 
where x.ID is null order by x.Text

---- delete test
select x.*
from IepPlacementOption x left join
@IepPlacementOption t on x.ID = t.ID 
where t.ID is null order by x.Text


UPDATE x
SET x.Text = t.Text,
x.StateCode = t.StateCode,
x.Sequence = t.Sequence
from IepPlacementOption x  join
@IepPlacementOption t on x.ID = t.ID 



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
--rollback tran fixLRE

--select * from IepPlacementOption order by text

