
set nocount on;
declare @SelectLists table (Type varchar(20), SubType varchar(20), EnrichID uniqueidentifier, StateCode varchar(10), EnrichLabel varchar(254))

insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '4B3DB67E-21B2-4ABC-B7FF-6CE7194B9973', '01', 'Race: American Indian or Alaska Native')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '9089FEE5-A947-47DF-A75E-48FD36497634', '02', 'Race: Asian')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '016E70C1-28B8-4DE3-B497-7D63E157031B', '03', 'Race: Black or African American')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '6039E197-C060-4ACD-BD46-410517E5EA0A', '06', 'Ethnicity: Hispanic or Latino')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '77C31E40-CAC1-43F8-9537-39A0003FE84C', '04', 'Race: Native Hawaiian or Other Pacific Islander')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, '5E9AD89E-04D1-449D-B052-D8D3B57D748E', '07', 'Race: Two or more races')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Race', NULL, 'B8D4CB59-4714-4D23-A066-1CF408FE480F', '05', 'Race: White')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '6061CD90-8BEC-4389-A140-CF645A5D47FE', 'PK', 'PK')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '10B6907F-2675-4610-983E-B460338569BE', NULL, '00')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '7269BD32-C052-455B-B3E3-FF5BCB199679', 'KG', 'K')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', '1', '01')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'DDC4180A-64FC-49BD-AC11-DAA185059885', '2', '02')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'D3C1BD80-0D32-4317-BAB8-CAF196D19350', '3', '03')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '4', '04')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '5A021B34-D33B-43B5-BD8A-40446AC2E972', '5', '05')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '92B484A3-2DBD-4952-9519-03B848AE1215', '6', '06')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', '7', '07')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '245F48A7-6927-4EFA-A3F2-AF30463C9B4D', '8', '08')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', '9', '09')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', '10', '10')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, 'EA727CED-8A2C-4434-974A-6D8D924D95C6', '11', '11')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Grade', NULL, '0D7B8529-62C7-4F25-B78F-2A4724BD7990', '12', '12')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Gender', NULL, 'ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD', 'F', 'Female')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Gender', NULL, '2FF51A82-9351-481A-8288-DCF8F7D96083', 'M', 'Male')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '0E026822-6B22-43A1-BD6E-C1412E3A6FA3', '01', 'Specific Learning Disability')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'BF42D497-E9A0-436B-8F86-6FF9DD2F648E', '02', 'Cognitive Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09', '04', 'Speech Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'E26404CB-F3D2-44CA-9F82-82AFDAA90735', '05', 'Language Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '96AB644C-1AFE-4D75-8A94-39F832D558E0', '06', 'Emotional Disturbance')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '3ECBA21A-577B-4973-A074-F040127EB736', '07', 'Health Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'CA10B0A9-D7CB-4709-9A70-36D8E18D988F', '08', 'Orthopedic Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '7A8F92E3-92BB-4B32-A958-174ABED2B17E', '09', 'Deafness')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'D1CFA1E9-D8D8-4317-92A4-94621F5C3466', '10', 'Hearing Impairment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'CF411FEB-F76E-4EC0-BE2F-0F84AA453292', '11', 'Vision Impairment, Including Blindness')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '1DB91C77-1898-463B-AC07-A9E7534FFB5E', '12', 'Deaf-Blindness')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'CA41A561-16BE-4E21-BE8A-BC59ED86C921', '13', 'Multiple Disabilities')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, '0AF6F9ED-D011-4FBE-83F4-33B4BC657FD3', '14', 'Developmental Delay')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676', '15', 'Autism')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Disab', NULL, 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3', '16', 'Traumatic Brain Injury')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '24827AAC-3DE7-432D-A15B-00BE41BF8BDF', NULL, 'No Consent')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '73DC240D-EF00-42C9-910D-3953ED3540D4', NULL, 'Not Eligible')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '12086FE0-B509-4F9F-ABD0-569681C59EE2', NULL, 'Exited After Eligibility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '1A10F969-4C63-4EB0-A00A-5F0563305D7A', NULL, 'Exited Before Eligibility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '9B1CC467-3D34-4AA1-BED5-7EE37ECBD799', NULL, 'No Disability Suspected')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'B6FD50F7-3154-4831-974E-E41D91A49525', '01', 'Graduate - Met Regular Requirements')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'CD184A31-1F54-4FC0-96CA-5DD8653B0CD9', '02', 'Graduate - Met Reduced Requirements')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'F7C2F259-7497-42AB-8274-274CFB5EFE1F', '03', 'Certificate of Completion/Attendance')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '63272934-A855-4E96-B75B-865ADD84DC70', '04', 'Reached Maximum Age')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'E28E543A-A45B-4C55-9EAF-C2DCDFD0A84E', '05', 'Dropped Out')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '910B6CAA-72E3-4AA0-A40F-823AAD29FCBC', '06', 'Transfer to Another Education Environment')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '95B9417B-9746-4076-91BE-F0A4E51E4AE9', '07', 'No Longer Eligible for Program')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'E776A203-2701-49DE-BFB3-2B9E53763F4B', '08', 'Deceased')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, 'E6DAFFA8-1A83-4FD3-B7E5-8D7FBE784F80', '09', 'Status Unknown (dropout)')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Exit', NULL, '91E0214F-F587-40C8-B859-E8819B347572', '12', 'Summer Break')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'DBC87BF4-FECF-4AB7-9C02-8E36E488BC8E', '01', 'General ed class 80% or more')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'F237216A-3969-4740-836D-D7B060F28B98', '02', 'General ed class 40 - 80%')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'B0CDC7EC-244D-43EB-A94D-82D6F307DB71', '03', 'General ed class less than 40%')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '64667C72-E29E-43B6-A00E-9B04CC529C18', '11', 'Public separate day school')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '0225B74D-A711-47A4-8991-3C2C4430BC77', '12', 'Private separate day school')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '29CAFE39-B62F-4A48-A8A9-7DB2E688C46E', '13', 'Public residential facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '58A2C111-088B-4AB1-9E20-68137D757536', '14', 'Private residential facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '019E3868-3B14-453F-A7E1-482E153C3B06', '15', 'Homebound/Hospital')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', 'A2B46B82-2CA0-4511-BA3B-3C334F130C93', '16', 'Correctional facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'K12', '1267E203-0111-4348-AAB7-155BA2D4F6C5', '21', 'Enrolled private by parents')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'F7A4B6C5-0A87-4228-BDE2-8B80743CC6A9', '44', 'Separate Class')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', '8026D621-4C8D-4C15-92BE-5B07BF02B102', '45', 'Separate School')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', '914AD573-0C9A-43B4-9A3E-0800CEB6709E', '46', 'Residential Facility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'E84CC109-FF37-4154-B93C-16AE5D9448DF', '47', 'Service Provider Location')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'BCC5FF10-E35F-44E0-9F31-9964A292BED1', '48', 'Home')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'FB3F9819-4295-498F-929B-9194909CB165', '49', '>10 hours Regular EC Program provides majority of services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'D388B0AC-FD80-4D73-A702-3C240F73C6E7', '50', '>10 hours Regular EC Program; majority of services provided elsewhere')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', '6B1194D7-A73B-4850-A4F0-CBEC499174EC', '51', '<10 hours Regular EC Program provides majority of services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('LRE', 'PK', 'AAD2442C-5AA7-43CC-9959-C9A38DBB725E', '52', '< 10 hours Regular EC Program; majority of services provided elsewhere')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '932CB806-3EEA-4D95-9973-01A3E05F55E0', '18', 'Assistive Technology Device')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '2C1096E4-BA93-42BB-8C1A-0EE1C5C5B6B0', '14', 'Family Support Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '42A2EC5D-FB02-4680-A27B-11BB873EDA5F', '22', 'Hearing Interpretive Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'DA5809CF-21EB-4B48-A071-143A33402F7B', '17', 'Vocational Rehabilitation')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'AE882D0F-926F-46B3-ABB2-255494A959B7', '04', 'Physical Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'CDE709CD-8A11-43C9-9D7B-2ACF4EC4C051', '11', 'Vision Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '18CB6534-7E68-409A-A64D-307C190530D5', '09', 'School Health')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '3B17CA1F-D52C-4D93-BBFF-32DA033D4D5B', '20', 'Intensive Behavior Intervention')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'B9E8033A-EF97-4283-8BC8-419DFDFD3463', '01', 'Speech Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'FD34680D-E368-41CF-A7F9-472DF7C8609A', '03', 'Occupational Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '5CDABA40-A230-4E80-9C77-49A541231730', '34', 'Extended school year')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'A619217E-0A76-4F63-A13E-4CB60E6E42BA', '19', 'Assistive Technology Service')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '1556C098-DE6C-4324-B4F9-5B31C1690A91', '05', 'School Psychological Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '3860C66C-7D62-4C29-A692-65F0E1F43CD0', '06', 'Social Work')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '2832170F-9BFD-4222-8032-6FA6C00A907A', '21', 'One to one aide outside genera')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '00967470-8A60-41E8-9D32-7084538EEE4E', '32', 'Community Based Education')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '73436B05-6A48-4F48-AD12-81787469D743', '99', 'Other Spec Ed Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'E10274DB-2ED7-4A46-958C-837E18460766', '15', 'One-to-One Aide/General class')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'B44DAB63-CAB0-4E98-83DE-8910B1B4E676', '23', 'Title One Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'C4D5D929-0D74-45D7-8F42-8AA86DD6CDEB', '10', 'Counseling')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '8B762FD6-02C6-4DB9-8A71-93F213AB7210', '31', 'Orientation and Mobility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'F3094011-D87E-4942-A486-A0953904F68D', '25', 'Psycho-Social Rehabilitation')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '93C18E55-ED8E-4537-9EC7-B653DEA388AD', '08', 'Adaptive P.E.')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'A53B1E53-2FE5-4254-B622-D3A24B9CA034', '13', 'Specially Arranged Transport')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '85140049-E850-4650-AE1B-D550BA85F0C0', '02', 'Language Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '6ED9C679-F52D-4453-9770-E0DF86318335', '12', 'Hearing Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', '361C98C1-B835-4448-981B-E9046A1C8867', '33', 'Emotion/behavior intervention')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'CF8B709A-CF54-47E7-916D-EC8CCB9883D4', '16', 'Vocational Services')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('Service', 'Related', 'E287E083-C477-4461-8373-F79FA22F82DF', '07', 'Licensed Psychologist/Psychiat')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServLoc', NULL, '55AF0E53-2F76-46F5-B7E0-A2627E35DA57', '01', 'Classroom')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServLoc', NULL, '52C74FE7-5685-4F8C-AAF2-63B40A8E4B51', '02', 'Special Education Classroom')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServLoc', NULL, '7A691C77-B4D6-4D4D-8A29-131FC1E7A33A', '03', 'Home')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServLoc', NULL, '2B7104D9-C119-4DA9-8F90-FCAE6C27AB53', '04', 'Hospital')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServLoc', NULL, '8FC37445-260F-4185-8E43-F5EC8AFCDDB3', '05', 'Community')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServLoc', NULL, '465C097B-DEC0-4E20-ACDC-2ACF9E7F5DEF', '06', 'Therapy Room')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, 'D2130FB0-1E2A-4827-B1D0-92BC49E94A22', NULL, 'Adapted PE Teacher')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '7F0EABB5-286D-473C-BFC2-79A2658D9879', NULL, 'Audiologist')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '56460F78-90AB-485A-B829-0C78B0332BA8', NULL, 'Counselor')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '0CDE139C-787F-4E30-9A74-E6535C85EDB0', NULL, 'Early Childhood Special Educator')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '149F36E1-DF2D-4CD3-BA4B-96D58C52012A', NULL, 'Educational Interpreter')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '6F563A7A-EBCA-4438-8819-F4266600F5E0', NULL, 'Occupational Therapist')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '0FB24F63-7A71-42A7-ABCA-1B9E58093194', NULL, 'Orientation & Mobility Specialist')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '74DF6273-69EA-4CA3-AD38-510A457BAA25', NULL, 'Physical Therapist')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, 'A3471353-6064-4C5C-9E24-8FDE3E05B084', NULL, 'School Psychologist')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '0E23822F-678E-4532-A28A-B42BA569C617', NULL, 'Social Worker')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '7F0195EC-B20A-443E-B13B-8DD0139FF115', NULL, 'Special Education Teacher')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '5D0EB909-4245-40EE-94EA-11F7E9F0A42E', NULL, 'Speech Language Pathologist')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '12E058BB-7407-4CC9-AB5A-15ED8BACE440', NULL, 'Teacher of Deaf/Hard of Hearing')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, 'B4464F73-BEF2-4D84-88E4-23EB8D0CAE7D', NULL, 'Teacher of the Blind/Visually Impaired')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, 'F52095B8-91DE-45C5-9296-C730989A1AEE', 'HM', 'Parapro')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '45ED2583-565F-430E-AD12-68844897605D', 'HO', 'Professional')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, '385ABF0C-567E-44B0-9684-AFB27B5AE5B9', 'LP', 'Licensed Practical Nurse')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServProv', NULL, 'E78F8FE2-BE96-4F8E-8829-DC26F9AF0F35', 'TD', 'Registered Nurse')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '71590A00-2C40-40FF-ABD9-E73B09AF46A1', 'D5', 'daily')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '3D4B557B-0C2E-4A41-9410-BA331F1D20DD', 'M4', 'monthly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, 'A2080478-1A03-4928-905B-ED25DEC259E6', 'W1', 'weekly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '25F0F5BE-AEC6-4E16-B694-E51F089B5FBF', 'W2', 'bi-monthly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('ServFreq', NULL, '5F3A2822-56F3-49DA-9592-F604B0F202C3', 'Y36', 'yearly')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7', NULL, 'Behavior')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '4F131BE0-D2A9-4EB2-8639-D772E05F3D5E', NULL, 'Developmental Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '0E95D360-5CBE-4ECA-820F-CC25864D70D8', NULL, 'Mathematics')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB', NULL, 'Occupational Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C', NULL, 'Orientation and Mobility')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '702A94A6-9D11-408B-B003-11B9CCDE092E', NULL, 'Other')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, 'B23994DB-2DEB-4D87-B77E-86E76F259A3E', NULL, 'Physical Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8', NULL, 'Reading')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '25D890C3-BCAE-4039-AC9D-2AE21686DEB0', NULL, 'Speech/Language Therapy')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('GoalArea', NULL, '37EA0554-EC3F-4B95-AAD7-A52DECC7377C', NULL, 'Written Language')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('PostSchArea', NULL, '823BA9DB-AF13-42BD-9CC2-EAA884701523', NULL, 'Career Employment Goal')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('PostSchArea', NULL, '2B5D9C8A-7FA7-4E74-9F0C-53327209E751', NULL, 'Independent Living Skills Goal (when appropriate)')
insert @SelectLists (Type, SubType, EnrichID, StateCode, EnrichLabel) values ('PostSchArea', NULL, 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1', NULL, 'Post-School Education/Training Goal')

--==============================Race=======================================
--select * from @SelectLists where Type = 'Race'
--select * from EnumValue v where v.Type = (select ID from EnumType t where t.Type = 'ETH') order by Code

--set nocount on;
--begin tran FixRace

--declare @s varchar(150), @o varchar(150), @c varchar(150), @gold varchar(36), @gnew varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'

--declare @MAP_Race table (Code varchar(10), OldRace uniqueidentifier, NewRace uniqueidentifier) -- based on COMPARE OLD AND NEW above, please fill in the OLD values below.  If there are OLD values that do not corespond to the NEW values, do not include them in the MAP table
----Vallivue
--insert @MAP_Race values ('01','06D1BB41-9516-4C56-B12B-37EA8CACD083', '4B3DB67E-21B2-4ABC-B7FF-6CE7194B9973') -- Race: American Indian or Alaska Native
--insert @MAP_Race values ('02','1C012C25-3BC1-40CC-8FD3-CF8A874DAF69', '9089FEE5-A947-47DF-A75E-48FD36497634') -- Race: Asian
--insert @MAP_Race values ('03','CC8E3624-8D04-43DA-B9F8-41B60D06D015', '016E70C1-28B8-4DE3-B497-7D63E157031B') -- Race: Black or African American
--insert @MAP_Race values ('06','3D89F11D-449F-4CDB-9386-33072073A52C', '6039E197-C060-4ACD-BD46-410517E5EA0A') -- Ethnicity: Hispanic or Latino
--insert @MAP_Race values ('05','7A4383F3-CC9C-4A9A-AE16-0A052CCFD775', 'B8D4CB59-4714-4D23-A066-1CF408FE480F') -- Race: White
--insert @MAP_Race values ('04','7B7CCD93-AF44-45DD-BD74-0502DC2B2E50', '77C31E40-CAC1-43F8-9537-39A0003FE84C') -- Race: Native Hawaiian or Other Pacific Islander
--insert @MAP_Race values ('07','9A65D79B-AD12-4F21-8276-EC01ADE19503', '5E9AD89E-04D1-449D-B052-D8D3B57D748E') -- Race: Two or more races

--update r set StateCode = m.Code
--from (select * from @SelectLists where Type = 'Race') r join
--@MAP_Race m on r.EnrichID = m.NewRace


---- isnert test
--select t.EnrichID, t.Type, t.EnrichLabel,1, t.StateCode
--from EnumValue x right join
--(select * from @SelectLists where Type = 'Race')t on x.ID = t.EnrichID 
--where x.ID is null
--order by x.StateCode, x.DisplayValue

--insert EnumValue (ID, Type, DisplayValue, isActive, StateCode)
--select t.EnrichID, 'CBB84AE3-A547-4E81-82D2-060AA3A50535', t.EnrichLabel,1, t.StateCode
--from EnumValue x right join
--(select * from @SelectLists where Type = 'Race')t on x.ID = t.EnrichID 
--where x.ID is null
--order by x.StateCode, x.DisplayValue

--update ev set Code = r.StateCode
--from EnumValue ev join
--(select * from @SelectLists where Type = 'Race')r on ev.ID = r.EnrichID

---- this cursor will check for the existance of the specific EnumValue ID everywhere it exists in the database (as a GUID) and update it to the new value
---- this operation is especially important to update the SIS import MAP table DestID
--declare G cursor for 
--select OldRace, NewRace from @MAP_Race

--open G
--fetch G into @gold, @gnew

--while @@fetch_status = 0
--begin

--set @g = @gold

--	declare OC cursor for 
--	select s.name, o.name, c.name
--	from sys.schemas s join
--	sys.objects o on s.schema_id = o.schema_id join 
--	sys.columns c on o.object_id = c.object_id join
--	sys.types t on c.user_type_id = t.user_type_id
--	where o.type = 'U'
--	and t.name = 'uniqueidentifier'
--	and o.name <> 'EnumValue' -- don't touch this!
--	order by o.name, c.name

--	open OC
--	fetch OC into @s, @o, @c

--	while @@FETCH_STATUS = 0
--	begin

--	exec ('if exists (select 1 from '+@s+'.'+@o+' o where '+@c+' = '''+@g+''')
--	exec (''update x set '+@c+' = '''''+@gnew+''''' from '+@s+'.'+@o+' x where '+@c+' = '''''+@gold+''''''')')

--	fetch OC into @s, @o, @c
--	end

--	close OC
--	deallocate OC

---- print ''

--fetch G into @gold, @gnew
--end
--close G
--deallocate G

--update EnumValue set IsActive = 0 where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and ID not in (select EnrichID from @SelectLists where Type = 'Race')

----commit tran FixRace
----rollback tran FixRace

--select * from EnumValue where Type = 'CBB84AE3-A547-4E81-82D2-060AA3A50535' and IsActive = 1

--=================================Gender=====================
--select * from @SelectLists where Type = 'Gender'
--select * from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B'

--begin tran FixGender
--set nocount on;

--declare @s varchar(150), @o varchar(150), @c varchar(150), @TossID varchar(36), @KeepID varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'
--declare @MAP_Gender table (KeepID uniqueidentifier, TossID uniqueidentifier) 
---- based on COMPARE OLD AND NEW above, please fill in the OLD values below.  If there are OLD values that do not corespond to the NEW values, do not include them in the MAP table
----insert @MAP_Gender values ('ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD','') -- 'Female', 
----insert @MAP_Gender values ('2FF51A82-9351-481A-8288-DCF8F7D96083','') -- 'Male', 
----ACD31A4B-66FD-4D49-9A5A-2DB12005A1DD	Female
----2FF51A82-9351-481A-8288-DCF8F7D96083	Male

------ insert test
--select t.EnrichID, x.Type, t.EnrichLabel, 1, t.StateCode
--from EnumValue x right join
--(select * from @SelectLists where Type = 'Gender') t on x.ID = t.EnrichID 
--where x.ID is null
--order by x.StateCode, x.DisplayValue

---- insert missing.  This has to be done before updating related tables with new EnumValue.
--insert EnumValue (ID, Type, DisplayValue, isActive, StateCode)
--select t.EnrichID, x.Type, t.EnrichLabel, 1, t.StateCode
--from EnumValue x right join
--(select * from @SelectLists where Type = 'Gender') t on x.ID = t.EnrichID 
--where x.ID is null
--order by x.StateCode, x.DisplayValue

----this cursor will check for the existance of the specific EnumValue ID everywhere it exists in the database (as a GUID) and update it to the new value
---- this operation is especially important to update the SIS import MAP table DestID
--declare G cursor for 
--select TossID, KeepID from @MAP_Gender

--open G
--fetch G into @TossID, @KeepID

--while @@fetch_status = 0
--begin

--set @g = @TossID

--	declare OC cursor for 
--	select s.name, o.name, c.name
--	from sys.schemas s join
--	sys.objects o on s.schema_id = o.schema_id join 
--	sys.columns c on o.object_id = c.object_id join
--	sys.types t on c.user_type_id = t.user_type_id
--	where o.type = 'U'
--	and t.name = 'uniqueidentifier'
--	and o.name <> 'EnumValue' -- don't touch this!
--	order by o.name, c.name

--	open OC
--	fetch OC into @s, @o, @c

--	while @@FETCH_STATUS = 0
--	begin

--	exec ('if exists (select 1 from '+@s+'.'+@o+' o where '+@c+' = '''+@g+''')
--	exec (''update x set '+@c+' = '''''+@KeepID+''''' from '+@s+'.'+@o+' x where '+@c+' = '''''+@TossID+''''''')')

--	fetch OC into @s, @o, @c
--	end

--	close OC
--	deallocate OC

--print ''

--fetch G into @TossID, @KeepID
--end
--close G
--deallocate G

--update EnumValue set IsActive = 0 where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and ID not in (select EnrichID from @SelectLists where Type = 'Gender')


----commit tran FixGender
------ rollback tran FixGender

--=====================================GradeLevel==================================================
--select * from @SelectLists where Type = 'Grade'
--select * from GradeLevel g order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

--declare @GradeLevel table (ID uniqueidentifier, Name varchar(10), Active bit, BitMask int, Sequence int)

--insert @GradeLevel (ID, Name, Active, BitMask, Sequence) values ('6061CD90-8BEC-4389-A140-CF645A5D47FE','PK',1,1,0)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('10B6907F-2675-4610-983E-B460338569BE','00',1,2,1)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('7269BD32-C052-455B-B3E3-FF5BCB199679','K',1,2,0)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B','01',1,4,2)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('DDC4180A-64FC-49BD-AC11-DAA185059885','02',1,8,3)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350','03',1,16,4)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68','04',1,32,5)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('5A021B34-D33B-43B5-BD8A-40446AC2E972','05',1,64,6)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('92B484A3-2DBD-4952-9519-03B848AE1215','06',1,128,6)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC','07',1,256,8)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D','08',1,512,9)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3','09',1,1024,10)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6','10',1,2048,11)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('EA727CED-8A2C-4434-974A-6D8D924D95C6','11',1,4096,12)
--insert @GradeLevel (ID, Name, Active, BitMask, Sequence ) values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990','12',1,8192,13)

--select t.EnrichID, t.EnrichLabel,tg.Active, tg.BitMask, tg.Sequence, t.StateCode
--from GradeLevel g right join
--(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID  join 
--@GradeLevel tg on g.ID =tg.ID
--where g.ID is null
--order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

------ delete test
--select g.*, t.StateCode
--from GradeLevel g left join
--(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID 
--where t.EnrichID is null

--Begin tran fixgrad


---- update state code
--update g set StateCode = t.StateCode,
--			 Active = tg.Active	
---- select g.*, t.StateCode
--from GradeLevel g  join
--(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID join 
--@GradeLevel tg on g.ID =tg.ID

------ 7269BD32-C052-455B-B3E3-FF5BCB199679	00
------ insert missing.  This has to be done before updating the records to be deleted and before deleting.
--insert GradeLevel 
--select t.EnrichID, t.EnrichLabel,tg.Active, tg.BitMask, tg.Sequence, t.StateCode
--from GradeLevel g right join
--(select * from @SelectLists where Type = 'Grade') t on g.ID = t.EnrichID  join 
--@GradeLevel tg on g.ID =tg.ID
--where g.ID is null
--order by g.Active desc, g.Sequence, g.BitMask, g.stateCode, g.Name

------ test for mapping table values
----select g.*, t.StateCode
----from GradeLevel g left join
----@GradeLevel t on g.ID = t.ID 
----where t.ID is null



------10B6907F-2675-4610-983E-B460338569BE	00

--declare @MAP_GradeLevel table (KeepID uniqueidentifier, TossID uniqueidentifier)

------ populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
----	-- this needs to be done by visual inspection because Grade Level names can vary widely
------ 1. un-comment the rows required to map for updating FK related tables.  
------ 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert
------insert @MAP_GradeLevel values ('C808C991-CA93-4F51-AF41-A8BA494AC10F', '') --  '') --  'Infant', 1, 0, 0, '002') 
------insert @MAP_GradeLevel values ('4B0ED575-7C9A-451D-A8E6-2D9F22F31349', '') --  'Half Day K', 1, 0, 0, '006') 
----insert @MAP_GradeLevel values ('6061CD90-8BEC-4389-A140-CF645A5D47FE', 'E4C4E846-B85F-4AB5-871B-A8976EE25A69') --  'Pre-K', 1, 1, 0, '004') 
----insert @MAP_GradeLevel values ('6061CD90-8BEC-4389-A140-CF645A5D47FE', 'D90C08C8-683F-4C2B-9D1F-769D904CD060') --  'Pre-K', 1, 1, 0, '004') 
----insert @MAP_GradeLevel values ('7269BD32-C052-455B-B3E3-FF5BCB199679', '10B6907F-2675-4610-983E-B460338569BE') --  '00', 1, 2, 0, '007') 
----insert @MAP_GradeLevel values ('7269BD32-C052-455B-B3E3-FF5BCB199679', 'AA2D13F2-ABFF-4245-8B48-EA13EE264B70') --  '00', 1, 2, 0, '007') 
------insert @MAP_GradeLevel values ('07975B7A-8A1A-47AE-A71F-7ED97BA9D48B', '') --  '01', 1, 4, 2, '010') 
------insert @MAP_GradeLevel values ('DDC4180A-64FC-49BD-AC11-DAA185059885', '') --  '02', 1, 8, 3, '020') 
------insert @MAP_GradeLevel values ('D3C1BD80-0D32-4317-BAB8-CAF196D19350', '') --  '03', 1, 16, 4, '030') 
------insert @MAP_GradeLevel values ('BE4F651A-D5B5-4B05-8237-9FD33E4D2B68', '') --  '04', 1, 32, 5, '040') 
------insert @MAP_GradeLevel values ('5A021B34-D33B-43B5-BD8A-40446AC2E972', '') --  '05', 1, 64, 6, '050') 
------insert @MAP_GradeLevel values ('92B484A3-2DBD-4952-9519-03B848AE1215', '') --  '06', 1, 128, 7, '060') 
------insert @MAP_GradeLevel values ('81FEC824-DB83-4C5D-91A5-2DFE72DE93EC', '') --  '07', 1, 256, 8, '070') 
------insert @MAP_GradeLevel values ('245F48A7-6927-4EFA-A3F2-AF30463C9B4D', '') --  '08', 1, 512, 9, '080') 
------insert @MAP_GradeLevel values ('FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3', '') --  '09', 1, 1024, 10, '090') 
------insert @MAP_GradeLevel values ('8085537C-8EA9-4801-8EC8-A8BDA7E61DB6', '') --  '10', 1, 2048, 11, '100') 
------insert @MAP_GradeLevel values ('EA727CED-8A2C-4434-974A-6D8D924D95C6', '') --  '11', 1, 4096, 12, '110') 
------insert @MAP_GradeLevel values ('0D7B8529-62C7-4F25-B78F-2A4724BD7990', '') --  '12', 1, 8192, 13, '120') 


------10B6907F-2675-4610-983E-B460338569BE	00	1	2	1	NULL	NULL





------ list all tables with FK on GradeLevel and update them 

--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

--declare I cursor for 
--select KeepID, TossID from @MAP_GradeLevel 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'GradeLevel' 
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--		and OBJECT_NAME(f.parent_object_id) <> 'StudentGradeLevelHistory'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )
--	--print 'update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' 
--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--exec ('
--update ts set GradeLevelID = '''+@KeepID+'''
---- select ts.*, kp.GradeLevelID
--from dbo.StudentGradeLevelHistory ts 
--left join dbo.StudentGradeLevelHistory kp on kp.StudentID = ts.StudentID and kp.StartDate = ts.StartDate and kp.GradeLevelID = '''+@KeepID+'''
--where ts.GradeLevelID = '''+@TossID+'''
--and kp.GradeLevelID is null

--delete ts 
---- select ts.*, kp.GradeLevelID
--from dbo.StudentGradeLevelHistory ts 
--where ts.GradeLevelID = '''+@TossID+'''

--')

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I



-- --delete unneeded
--delete g
---- select g.*, t.StateCode
--from GradeLevel g join
--@MAP_GradeLevel t on g.ID = t.TossID 

----commit tran fixgrad

----Rollback tran fixgrad

----select * from GradeLevel order by bitmask


--==================================================================================================================
--								Disability
--==================================================================================================================
--select * from @SelectLists where Type = 'Disab' order by EnrichLabel
--select * from IepDisability d order by d.Name

--declare @IepDisability table (ID uniqueidentifier, Name varchar(50), Definition text, DeterminationFormTemplateID uniqueidentifier)

--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values ('B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676','Autism','<b>Definition:</b> Autism is a developmental disability, generally evident before age 3, significantly affecting verbal and nonverbal communication and social interaction, and adversely affecting educational performance. A student who manifests the characteristics of autism after age 3 could be diagnosed as having autism. Other characteristics often associated with autism include, but are not limited to, engagement in repetitive activities and stereotyped movements, resistance to environmental change or change in daily routines, and unusual responses to sensory experiences. Characteristics vary from mild to severe as well as in the number of symptoms present. Diagnoses may include, but are not limited to, the following autism spectrum disorders: Childhood Disintegrative Disorder, Autistic Disorder, Asperger’s Syndrome, or Pervasive Developmental Disorder: Not Otherwise Specified (PDD:NOS).',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('BF42D497-E9A0-436B-8F86-6FF9DD2F648E','Cognitive Impairment','<b>Definition:</b> Cognitive impairment is defined as significantly sub-average intellectual functioning that exists concurrently with deficits in adaptive behavior. These deficits are manifested during the student’s developmental period, and adversely affect the student’s educational performance.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('1DB91C77-1898-463B-AC07-A9E7534FFB5E','Deaf-Blindness','<b>Definition:</b> A student with deaf-blindness demonstrates both hearing and visual impairments, the combination of which causes such severe communication and other developmental and educational needs that the student cannot be appropriately educated with special education services designed solely for students with deafness or blindness.',
--NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('7A8F92E3-92BB-4B32-A958-174ABED2B17E','Deafness','<b>Definition:</b> Deafness is a hearing impairment that adversely affects educational performance and is so severe that with or without amplification the student is limited in processing linguistic information through hearing.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('0AF6F9ED-D011-4FBE-83F4-33B4BC657FD3','Developmental Delay','<b>Definition:</b> The term developmental delay may be used only for students ages 3 through 9 who are experiencing developmental delays as measured by appropriate diagnostic instruments and procedures in one or more of the following areas: (1) cognitive development – includes skills involving perceptual discrimination, memory, reasoning, academic skills, and conceptual development; (2) physical development – includes skills involving coordination of both the large and small muscles of the body (i.e., gross, fine, and perceptual motor skills); (3) communication development – includes skills involving expressive and receptive communication abilities, both verbal and nonverbal; (4) social or emotional development – includes skills involving meaningful social interactions with adults and other children including self-expression and coping skills; or (5) adaptive development – includes daily living skills (e.g., eating, dressing, and toileting) as well as skills involving attention and personal responsibility.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('96AB644C-1AFE-4D75-8A94-39F832D558E0','Emotional Disturbance','<b>Definition:</b> A student with emotional disturbance has a condition exhibiting one or more of the following characteristics over a long period of time, and to a marked degree, that adversely affects his or her educational performance: (1) an inability to learn that cannot be explained by intellectual, sensory, or health factors; (2) an inability to build or maintain satisfactory interpersonal relationships with peers and teachers; (3) inappropriate types of behavior or feelings under normal circumstances; (4) a general pervasive mood of unhappiness or depression; or (5) a tendency to develop physical symptoms or fears associated with personal or school problems.  The term <i>does not</i> include students who are socially maladjusted unless it is determined they have an emotional disturbance. The term emotional disturbance <i>does</i> include students who are diagnosed with schizophrenia.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('3ECBA21A-577B-4973-A074-F040127EB736','Health Impairment','',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('D1CFA1E9-D8D8-4317-92A4-94621F5C3466','Hearing Impairment','<b>Definition:</b> A hearing impairment is a permanent or fluctuating hearing loss that adversely affects a student’s educational performance but is not included under the category of deafness.
--Language Impairment	<b>Definition:</b> A language impairment exists when there is a disorder or delay in the development of comprehension and/or the uses of spoken or written language and/or other symbol systems. The impairment may involve any one or a combination of the following: (1) the form of language (morphological and syntactic systems); (2) the content of language (semantic systems); and/or (3) the function of language in communication (pragmatic systems).',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('E26404CB-F3D2-44CA-9F82-82AFDAA90735','Language Impairment','<b>Definition:</b> A language impairment exists when there is a disorder or delay in the development of comprehension and/or the uses of spoken or written language and/or other symbol systems. The impairment may involve any one or a combination of the following: (1) the form of language (morphological and syntactic systems); (2) the content of language (semantic systems); and/or (3) the function of language in communication (pragmatic systems).',
--NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values 
--('CA41A561-16BE-4E21-BE8A-BC59ED86C921','Multiple Disabilities','<b>Definition:</b> Multiple disabilities are two or more co-existing severe impairments, one of which usually includes a cognitive impairment, such as cognitive impairment/blindness, cognitive impairment/orthopedic, etc. Students with multiple disabilities exhibit impairments that are likely to be life long, significantly interfere with independent functioning, and may necessitate environmental modifications to enable the student to participate in school and society. The term does not include deaf-blindness.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
--('CA10B0A9-D7CB-4709-9A70-36D8E18D988F','Orthopedic Impairment','<b>Definition:</b> Orthopedic impairment means a severe physical limitation that adversely affects a student’s educational performance. The term includes impairments caused by congenital anomaly (clubfoot, or absence of an appendage), an impairment caused by disease (poliomyelitis, bone tuberculosis, etc.), or an impairment from other causes (cerebral palsy, amputations, and fractures or burns that cause contracture).',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
--('0E026822-6B22-43A1-BD6E-C1412E3A6FA3','Specific Learning Disability','<b>Definition:</b> Specific Learning Disability (SLD) means a disorder in one or more of the basic psychological processes involved in understanding or in using language, spoken or written, that may manifest itself in the imperfect ability to listen, think, speak, read, write, spell, or to do mathematical calculations, including conditions such as perceptual disabilities, brain injury, minimal brain dysfunction, dyslexia, and developmental aphasia. Specific Learning Disability does not include learning problems that are primarily the result of visual, hearing, or motor disabilities, of cognitive impairment, of emotional disturbance, or of environmental, cultural, or economic disadvantage.','714A1265-86A3-4166-8D9E-FE36BE7F6F71')
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
--('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09','Speech Impairment','<b>Definition:</b> The term speech impairment includes articulation/phonology disorders, voice disorders, or fluency disorders that adversely impact a child’s educational performance: (1) Articulation disorders are incorrect productions of speech sounds including omissions, distortions, substitutions, and/or additions that may interfere with intelligibility. Phonology disorders are errors involving phonemes, sound patterns, and the rules governing their combinations; (2) A fluency disorder consists of stoppages in the flow of speech that is abnormally frequent and/or abnormally long. The stoppages usually take the form of repetitions of sounds, syllables, or single syllable words; prolongations of sounds; or blockages of airflow and/or voicing in speech; (3) Voice disorders are the absence or abnormal production of voice quality, pitch, intensity, or resonance. Voice disorders may be the result of a functional or an organic condition.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
--('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3','Traumatic Brain Injury','<b>Definition:</b> Traumatic brain injury refers to an acquired injury to the brain caused by an external physical force resulting in a total or partial functional disability or psychosocial impairment, or both, that adversely affects educational performance. The term applies to open or closed head injuries resulting in impairments in one or more areas such as cognition, language, memory, attention, reasoning, abstract thinking, judgment, problem solving, sensory, perceptual and motor abilities, psychosocial behavior, physical functions, information processing, and speech. The term does not apply to congenital or degenerative brain injuries or to brain injuries induced by birth trauma.',NULL)
--insert @IepDisability  (ID, Name, Definition, DeterminationFormTemplateID) values
--('CF411FEB-F76E-4EC0-BE2F-0F84AA453292','Vision Impairment, Including Blindness','<b>Definition:</b> Visual impairment refers to an impairment in vision that, even with correction, adversely affects a student’s educational performance. The term includes both partial sight and blindness. Partial sight refers to the ability to use vision as one channel of learning if educational materials are adapted. Blindness refers to the prohibition of vision as a channel of learning, regardless of the adaptation of materials.',NULL)

---- insert test
--select t.EnrichID, t.EnrichLabel, ti.Definition, ti.DeterminationFormTemplateID, t.StateCode
--from IepDisability x right join
--(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID JOIN 
-- @IepDisability ti on t.EnrichID = ti.ID
--where x.ID is null order by x.Name

---- delete test
--select x.*, t.StateCode
--from IepDisability x left join
--(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID 
--where t.EnrichID is null order by x.Name


--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

--begin tran FixDisab


--/* ============================================================================= NOTE ============================================================================= 

--	This cursor is to delete as many values as possible without having to MAP them visually below in order to save time and effort that would be required to 
--	match them by sight.

--   ============================================================================= NOTE ============================================================================= */


--declare T cursor for 
--select x.ID
--from IepDisability x left join
--(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID 
--where t.EnrichID is null

--open T
--fetch T into @toss

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'IepDisability' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID' --------------- Column name here
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('delete x from dbo.IepDisability x left join '+@RelTable+' r on x.ID = r.'+@RelColumn+' where x.ID = '''+@toss+''' and r.'+@RelColumn+' is null')

---- print 

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch T into @toss
--end
--close T
--deallocate T



---- delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
---- In this case the section "populate MAP" can be skipped
--select x.*, t.StateCode
--from IepDisability x left join
--(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID 
--where t.EnrichID is null order by x.Name



-- --update state code
--update x set StateCode = t.StateCode,
--			 Definition = ti.Definition,
--			 DeterminationFormTemplateID = ti.DeterminationFormTemplateID
-- --select g.*, t.StateCode
--from IepDisability x  join
--(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID JOIN 
-- @IepDisability ti on t.EnrichID = ti.ID


-- --insert missing.  This has to be done before updating the records to be deleted and before deleting.
--insert IepDisability (ID, Name, Definition, DeterminationFormTemplateID, StateCode, IsOutOfState)
--select t.EnrichID, t.EnrichLabel, ti.Definition, ti.DeterminationFormTemplateID, t.StateCode,0
--from IepDisability x right join
--(select * from @SelectLists where Type = 'Disab') t on x.ID = t.EnrichID JOIN 
-- @IepDisability ti on t.EnrichID = ti.ID
--where x.ID is null order by x.Name


--declare @MAP_IepDisability table (KeepID uniqueidentifier, TossID uniqueidentifier)


--/* ============================================================================= NOTE ============================================================================= 

--	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
--	will need to be updated for all hosted districts in Coloardo.  
	
--	HOWEVER
	
--	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

--   ============================================================================= NOTE ============================================================================= */


----B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676	Autism Spectrum Disorders
----D1CFA1E9-D8D8-4317-92A4-94621F5C3466	Hearing Impairment, Including Deafness
----1D0B34DD-55BF-42EB-A0CA-7D2542EBC059	Preschooler with a Disability
----7599B90D-8842-4B49-9BFC-B5CDBAAAA074	Serious Emotional Disability
----CF411FEB-F76E-4EC0-BE2F-0F84AA453292	Vision Impairment, Including Blindness

---- populate MAP
---- this needs to be done by visual inspection because IepDisability names can vary widely
--insert @MAP_IepDisability  values ('BBB4773F-4A8A-49E5-A0D4-952D2A0D1F18', 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676') -- 'Autism Spectrum Disorders'
--insert @MAP_IepDisability  values ('0C02B702-D681-4C66-BA67-8F9D3847E6A9', 'D1CFA1E9-D8D8-4317-92A4-94621F5C3466') -- 'Hearing Impairment, Including Deafness'
----insert @MAP_IepDisability  values ('12F08D30-1ADA-4F9A-AD2A-EF5451BB2325', '') -- 'Intellectual Disability'
----insert @MAP_IepDisability  values ('CA41A561-16BE-4E21-BE8A-BC59ED86C921', '') -- 'Multiple Disabilities'
----insert @MAP_IepDisability  values ('07093979-0C3F-414D-9750-8080C6BB7C45', '') -- 'Physical Disability'
--insert @MAP_IepDisability  values ('917D79C8-8604-49E5-A64F-0ADCFD85819B', '1D0B34DD-55BF-42EB-A0CA-7D2542EBC059') -- 'Preschooler with a Disability'
--insert @MAP_IepDisability  values ('41500452-3FEB-4EBF-87A0-BFC5F385A973', '7599B90D-8842-4B49-9BFC-B5CDBAAAA074') -- 'Serious Emotional Disability'
----insert @MAP_IepDisability  values ('0E026822-6B22-43A1-BD6E-C1412E3A6FA3', '') -- 'Specific Learning Disability'
----insert @MAP_IepDisability  values ('96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09', '') -- 'Speech or Language Impairment'
----insert @MAP_IepDisability  values ('E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3', '') -- 'Traumatic Brain Injury'
--insert @MAP_IepDisability  values ('E77D061F-0E5B-4CF8-AB46-A0D4042E8601', 'CF411FEB-F76E-4EC0-BE2F-0F84AA453292') -- 'Vision Impairment, Including Blindness'

-- --list all tables with FK on GradeLevel and update them 


--declare I cursor for 
--select KeepID, TossID from @MAP_IepDisability 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'IepDisability' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I



-- --delete unneeded
--delete x
-- --select g.*, t.StateCode
--from IepDisability x join
--@MAP_IepDisability t on x.ID = t.TossID 

----commit tran FixDisab
------rollback tran FixDisab 

----======================================================================================================
----							PrgLocation
----=======================================================================================================
--select EnrichID,EnrichLabel from @SelectLists where Type = 'ServLoc'
--select * from PrgLocation order by Name

--set nocount on;
---- this needs to be run on the CDE Sandbox template for CO instanaces as well as on all CO import databases
--declare @PrgLocation table (ID uniqueidentifier,Name varchar(50), Definition text, DeterminationFormTemplateID uniqueidentifier, DeletedDate datetime)

--insert @PrgLocation  (ID, Name) values ('55AF0E53-2F76-46F5-B7E0-A2627E35DA57','Classroom')
--insert @PrgLocation  (ID, Name) values ('52C74FE7-5685-4F8C-AAF2-63B40A8E4B51','Special Education Classroom')
--insert @PrgLocation  (ID, Name) values ('7A691C77-B4D6-4D4D-8A29-131FC1E7A33A','Home')
--insert @PrgLocation  (ID, Name) values ('2B7104D9-C119-4DA9-8F90-FCAE6C27AB53','Hospital')
--insert @PrgLocation  (ID, Name) values ('8FC37445-260F-4185-8E43-F5EC8AFCDDB3','Community')
--insert @PrgLocation  (ID, Name) values ('465C097B-DEC0-4E20-ACDC-2ACF9E7F5DEF','Therapy Room')

------ insert test
--select t.EnrichID, t.EnrichLabel, tp.Definition, tp.DeterminationFormTemplateID, t.StateCode
--from PrgLocation x right join
--(select * from @SelectLists where Type = 'ServLoc') t on x.ID = t.EnrichID JOIN 
-- @PrgLocation tp on t.EnrichID = tp.ID
--where x.ID is null order by x.Name

------ delete test
--select x.*, t.StateCode
--from PrgLocation x left join
--(select * from @SelectLists where Type = 'ServLoc') t on x.ID = t.EnrichID
--where t.EnrichID is null order by x.Name


--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

--begin tran FixLocation

------ delete test -------------------------------------------------------- If there remain no values to be updated, the following query will return 0 rows.  
------ In this case the section "populate MAP" can be skipped
----select x.*, t.StateCode
----from PrgLocation x left join
----@PrgLocation t on x.ID = t.ID 
----where t.ID is null order by x.Name

---- update state code
--update x set StateCode = t.StateCode,
--			 Name = t.EnrichLabel
---- select g.*, t.StateCode
--from PrgLocation x  join
--(select * from @SelectLists where Type = 'ServLoc') t on x.ID = t.EnrichID

---- insert missing.  This has to be done before updating the records to be deleted and before deleting.
--insert PrgLocation (ID, Name,StateCode) 
--select t.EnrichID, t.EnrichLabel,t.StateCode
--from PrgLocation x right join
--(select * from @SelectLists where Type = 'ServLoc') t on x.ID = t.EnrichID
--where x.ID is null
--order by x.Name


--/* ============================================================================= NOTE ============================================================================= 

--	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
--	will need to be updated for all hosted districts in Coloardo.  
	
--	HOWEVER
	
--	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

--   ============================================================================= NOTE ============================================================================= */

---- populate MAP
---- this needs to be done by visual inspection because PrgLocation names can vary widely
--declare @MAP_PrgLocation table (KeepID uniqueidentifier, TossID uniqueidentifier)

----insert @MAP_PrgLocation values ('2B7104D9-C119-4DA9-8F90-FCAE6C27AB53', 'B5EAF5AE-D610-457F-9BAC-BFF3B30F54FD') -- 'Hospital')
----insert @MAP_PrgLocation values ('27D86DFE-218E-4E1B-A6DB-8B8E74D6F8BA', '') -- 'General Education Classroom')
----insert @MAP_PrgLocation values ('B21973A7-5A68-4D9A-B93D-18B0335D7257', '6102B96C-1549-4C65-AD59-683FF00639BA') -- 'Outside General Classroom')
---- 6102B96C-1549-4C65-AD59-683FF00639BA	Outside General Classroom

--declare I cursor for 
--select KeepID, TossID from @MAP_PrgLocation 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'PrgLocation' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I

---- delete unneeded
--delete x
---- select g.*, t.StateCode
--from PrgLocation x join
--@MAP_PrgLocation t on x.ID = t.TossID 

--commit tran FixLocation
----rollback tran FixLocation

--select * from PrgLocation d order by d.Name


--===================================================================================================
--						ServFreq
--===================================================================================================
--select * from @SelectLists where Type ='ServFreq'
--select * from ServiceFrequency

--declare @ServiceFrequency table (ID uniqueidentifier, Sequence int, WeekFactor float)
--insert @ServiceFrequency (ID) values  ('71590A00-2C40-40FF-ABD9-E73B09AF46A1')
--insert @ServiceFrequency (ID) values ('3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
--insert @ServiceFrequency (ID) values ('A2080478-1A03-4928-905B-ED25DEC259E6')
--insert @ServiceFrequency (ID) values ('25F0F5BE-AEC6-4E16-B694-E51F089B5FBF')
--insert @ServiceFrequency (ID) values ('5F3A2822-56F3-49DA-9592-F604B0F202C3')

--update tsf set Sequence = isnull(tsf.Sequence,99), WeekFactor = isnull(tsf.WeekFactor,1)
--from (select *from @SelectLists where Type ='ServFreq') t  join 
--@ServiceFrequency tsf on t.EnrichID = tsf.ID

----insert test 
--select t.EnrichID, t.EnrichLabel, tsf.Sequence, tsf.WeekFactor
--from ServiceFrequency x right join
--(select *from @SelectLists where Type ='ServFreq')  t on x.ID = t.EnrichID left JOIN 
--@ServiceFrequency tsf on t.EnrichID = tsf.ID
--where x.ID is null order by x.Name

------ delete test
--select x.*
--from ServiceFrequency x left join
--(select *from @SelectLists where Type ='ServFreq')  t on x.ID = t.EnrichID left JOIN 
--@ServiceFrequency tsf on x.ID = tsf.ID
--where t.EnrichID is null order by x.Name

--begin tran fixfreq

--insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
--select t.EnrichID, t.EnrichLabel, tsf.Sequence, tsf.WeekFactor
--from ServiceFrequency x right join
--(select *from @SelectLists where Type ='ServFreq')  t on x.ID = t.EnrichID left JOIN 
--@ServiceFrequency tsf on t.EnrichID = tsf.ID
--where x.ID is null
--order by x.Name


--commit tran fixfreq
------rollback tran fixfreq


----===================================================================================================================
----						ServProviderTitle
----===================================================================================================================

--select * from @SelectLists where Type ='ServProv' order by EnrichLabel
--select * from ServiceProviderTitle order by Name

------ insert test
--select t.*
--from ServiceProviderTitle x right join
--(select * from @SelectLists where Type ='ServProv') t on x.ID = t.EnrichID 
--where x.ID is null order by x.Name

------ delete test
--select x.*
--from ServiceProviderTitle x left join
--(select * from @SelectLists where Type ='ServProv') t on x.ID = t.EnrichID 
--where t.EnrichID is null order by x.Name

--begin tran fixspt

--declare @RelaSchema varchar(100), @RelaTable varchar(100), @RelaColumn varchar(100), @ID varchar(50)

----declare D cursor for 
----select dspt.ID from(select x.*
----from ServiceProviderTitle x left join
----(select * from @SelectLists where Type ='ServProv') t on x.ID = t.EnrichID 
----where t.EnrichID is null) dspt

----open D
----fetch D into @ID

----while @@fetch_status = 0

----begin

----	declare Re cursor for 
----	SELECT 
----		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
----		OBJECT_NAME(f.parent_object_id) AS TableName,
----		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
----	FROM sys.foreign_keys AS f
----		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
----		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
----	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
----		and OBJECT_NAME (f.referenced_object_id) = 'ServiceProviderTitle' 
----		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
----		and OBJECT_NAME(f.parent_object_id) not in ('PrgItem', 'Teacher')
----	order by SchemaName, TableName, ColumnName

----	open Re
----	fetch Re into @Relaschema, @RelaTable, @Relacolumn

----	while @@fetch_status = 0
----	begin

---- 	exec ('DELETE t  from '+@Relaschema+'.'+@Relatable+' t where t.'+@Relacolumn+' = '''+@ID+'''' )

----	fetch Re into @Relaschema, @RelaTable, @Relacolumn
----	end
----	close Re
----	deallocate Re

----fetch D into @ID
----end
----close D
----deallocate D








----delete g
--select g.*
--from ServiceProviderTitle g left join
--(select * from @SelectLists where Type ='ServProv') t on g.ID = t.EnrichID 
--where t.EnrichID is null or g.DeletedDate is not null

--select * from ServiceProviderTitle 


--update g set StateCode = t.StateCode,
--		     Name = t.EnrichLabel
---- service provider title in CO does not have a state code
----select g.*, t.StateCode,t.Name
--from ServiceProviderTitle g  join
--(select * from @SelectLists where Type ='ServProv') t on g.ID = t.EnrichID 


--insert ServiceProviderTitle (ID,Name,StateCode) 
--select t.EnrichID, t.EnrichLabel,  t.StateCode
--from ServiceProviderTitle x right join
--(select * from @SelectLists where Type ='ServProv') t on x.ID = t.EnrichID 
--where x.ID is null order by x.Name



--declare @MAP_ServiceProviderTitle table (KeepID uniqueidentifier, TossID uniqueidentifier)

---- populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
--	-- this needs to be done by visual inspection because Grade Level names can vary widely
---- 1. un-comment the rows required to map for updating FK related tables.  
---- 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert

----insert @MAP_ServiceProviderTitle values ('D2130FB0-1E2A-4827-B1D0-92BC49E94A22','') -- 'Adapted PE Teacher',NULL)
----insert @MAP_ServiceProviderTitle values ('7F0EABB5-286D-473C-BFC2-79A2658D9879','') -- 'Audiologist',NULL)
----insert @MAP_ServiceProviderTitle values ('56460F78-90AB-485A-B829-0C78B0332BA8','') -- 'Counselor',NULL)
----insert @MAP_ServiceProviderTitle values ('0CDE139C-787F-4E30-9A74-E6535C85EDB0','') -- 'Early Childhood Special Educator',NULL)
----insert @MAP_ServiceProviderTitle values ('149F36E1-DF2D-4CD3-BA4B-96D58C52012A','') -- 'Educational Interpreter',NULL)
----insert @MAP_ServiceProviderTitle values ('385ABF0C-567E-44B0-9684-AFB27B5AE5B9','') -- 'Licensed Practical Nurse',NULL)
----insert @MAP_ServiceProviderTitle values ('6F563A7A-EBCA-4438-8819-F4266600F5E0','') -- 'Occupational Therapist',NULL)
----insert @MAP_ServiceProviderTitle values ('0FB24F63-7A71-42A7-ABCA-1B9E58093194','') -- 'Orientation & Mobility Specialist',NULL)
----insert @MAP_ServiceProviderTitle values ('74DF6273-69EA-4CA3-AD38-510A457BAA25','') -- 'Physical Therapist',NULL)
----insert @MAP_ServiceProviderTitle values ('839A1D38-EB55-474F-BF97-297FE372F866','') -- 'Registered Nurse',NULL)
----insert @MAP_ServiceProviderTitle values ('A3471353-6064-4C5C-9E24-8FDE3E05B084','') -- 'School Psychologist',NULL)
----insert @MAP_ServiceProviderTitle values ('0E23822F-678E-4532-A28A-B42BA569C617','') -- 'Social Worker',NULL)
----insert @MAP_ServiceProviderTitle values ('7F0195EC-B20A-443E-B13B-8DD0139FF115','') -- 'Special Education Teacher',NULL)
----insert @MAP_ServiceProviderTitle values ('5D0EB909-4245-40EE-94EA-11F7E9F0A42E','') -- 'Speech Language Pathologist',NULL)
----insert @MAP_ServiceProviderTitle values ('12E058BB-7407-4CC9-AB5A-15ED8BACE440','') -- 'Teacher of Deaf/Hard of Hearing',NULL)
----insert @MAP_ServiceProviderTitle values ('B4464F73-BEF2-4D84-88E4-23EB8D0CAE7D','') -- 'Teacher of the Blind/Visually Impaired',NULL)



------ delete test
--select g.*
--from ServiceProviderTitle g left join
--@MAP_ServiceProviderTitle t on g.ID = t.TossID 


---- list all tables with FK on GradeLevel and update them 

--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

--declare I cursor for 
--select KeepID, TossID from @MAP_ServiceProviderTitle 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'ServiceProviderTitle' 
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I



---- delete unneeded
--delete g
--from ServiceProviderTitle g  join
--@MAP_ServiceProviderTitle t on g.ID = t.TossID


--commit tran fixspt
---- Rollback tran fixspt

--=========================================================================================================================
--				IepGoalAreaDef
--=========================================================================================================================

--select EnrichID, EnrichLabel from @SelectLists where Type ='GoalArea'
--select * from IepGoalAreaDef order by Sequence		

--Begin tran fixgoal

--declare @IepGoalAreaDef table (ID uniqueidentifier,Sequence int, Name varchar(50),AllowCustomProbes bit,RequireGoal bit)

--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7',0,'Behavior',0,1)
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('4F131BE0-D2A9-4EB2-8639-D772E05F3D5E',1,'Developmental Therapy',0,1)
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('0E95D360-5CBE-4ECA-820F-CC25864D70D8',3,'Mathematics',0,1)	
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB',4,'Occupational Therapy',0,1)
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C',5,'Orientation and Mobility',0,1)	
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('702A94A6-9D11-408B-B003-11B9CCDE092E',6,'Other',0,1)	
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('B23994DB-2DEB-4D87-B77E-86E76F259A3E',7,'Physical Therapy',0,1)	
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('504CE0ED-537F-4EA0-BD97-0349FB1A4CA8',8,'Reading',0,1)	
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('25D890C3-BCAE-4039-AC9D-2AE21686DEB0',9,'Speech/Language Therapy',0,1)	
--insert @IepGoalAreaDef (ID,Sequence,Name,AllowCustomProbes,RequireGoal) values ('37EA0554-EC3F-4B95-AAD7-A52DECC7377C',10,'Written Language',0,1)			
	
	
----insert test
--select t.EnrichID, tig.Sequence , t.EnrichLabel,t.StateCode,tig.RequireGoal
--from IepGoalAreaDef g right join
--(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID JOIN 
--@IepGoalAreaDef tig on t.EnrichID =tig.ID
--where g.ID is null
--order by  g.Name

------ delete test
--select g.*, t.StateCode
--from IepGoalAreaDef g left join
--(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID 
--where t.EnrichID is null

--update tig set RequireGoal = g.RequireGoal,
--		 Sequence = g.Sequence,
--		 AllowCustomProbes = g.AllowCustomProbes
----select g.*, t.StateCode
--from IepGoalAreaDef g  join
--(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID JOIN 
--@IepGoalAreaDef tig on t.EnrichID =tig.ID
--where g.ID is null

--insert IepGoalAreaDef (ID,Sequence,Name,StateCode,AllowCustomProbes,RequireGoal)
--select t.EnrichID, tig.Sequence , t.EnrichLabel,t.StateCode,tig.AllowCustomProbes, tig.RequireGoal
--from IepGoalAreaDef g right join
--(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID JOIN 
--@IepGoalAreaDef tig on t.EnrichID =tig.ID
--where g.ID is null
--order by  g.Name

--update g set Name = t.EnrichLabel
----select g.*, t.StateCode
--from IepGoalAreaDef g  join
--(select * from @SelectLists where Type ='GoalArea') t on g.ID = t.EnrichID

--declare @MAP_IepGoalAreaDef table (KeepID uniqueidentifier, TossID uniqueidentifier)

---- populate a mapping that to update FK related records of GradeLevvel records that will be deleted   
--	-- this needs to be done by visual inspection because Grade Level names can vary widely
---- 1. un-comment the rows required to map for updating FK related tables.  
---- 2. Add the ID that needs to be deleted in the Empty quotes of the Values insert
----insert @MAP_IepGoalAreaDef values('51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7','')
----insert @MAP_IepGoalAreaDef values('6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB','')
----insert @MAP_IepGoalAreaDef values('0E95D360-5CBE-4ECA-820F-CC25864D70D8','')
----insert @MAP_IepGoalAreaDef values('0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C','')
----insert @MAP_IepGoalAreaDef values('702A94A6-9D11-408B-B003-11B9CCDE092E','')
----insert @MAP_IepGoalAreaDef values('504CE0ED-537F-4EA0-BD97-0349FB1A4CA8','')
----insert @MAP_IepGoalAreaDef values('25D890C3-BCAE-4039-AC9D-2AE21686DEB0','')
----insert @MAP_IepGoalAreaDef values('4F131BE0-D2A9-4EB2-8639-D772E05F3D5E','')
----insert @MAP_IepGoalAreaDef values('37EA0554-EC3F-4B95-AAD7-A52DECC7377C','')

--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50)

--declare I cursor for 
--select KeepID, TossID from @MAP_IepGoalAreaDef 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'IepGoalAreaDef' ------------------------------- table name
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I

--delete g
-- --select g.*, t.StateCode
--from IepGoalAreaDef g join
--@MAP_IepGoalAreaDef t on g.ID = t.TossID 

--select * from IepGoalAreaDef where DeletedDate is null order by Name

--commit tran fixgoal

--ROLLBACK  tran fixgoal

----========================================================================================================
----					ServiceDef
----========================================================================================================
--select * from @SelectLists where Type = 'Service'  order by EnrichLabel
--select * from ServiceDef 

--declare @ServiceDef table (ID uniqueidentifier, CategoryID uniqueidentifier, Name varchar(100), Description text, DefaultLocationID uniqueidentifier, MinutesPerUnit int) 

--insert @ServiceDef (ID, CategoryID, Name) values ('93C18E55-ED8E-4537-9EC7-B653DEA388AD','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Adaptive P.E.')
--insert @ServiceDef (ID, CategoryID, Name) values ('932CB806-3EEA-4D95-9973-01A3E05F55E0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Assistive Technology Device')
--insert @ServiceDef (ID, CategoryID, Name) values ('A619217E-0A76-4F63-A13E-4CB60E6E42BA','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Assistive Technology Service')
--insert @ServiceDef (ID, CategoryID, Name) values ('00967470-8A60-41E8-9D32-7084538EEE4E','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Community Based Education')	
--insert @ServiceDef (ID, CategoryID, Name) values ('C4D5D929-0D74-45D7-8F42-8AA86DD6CDEB','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Counseling')	
--insert @ServiceDef (ID, CategoryID, Name) values ('361C98C1-B835-4448-981B-E9046A1C8867','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Emotion/behavior intervention')	
--insert @ServiceDef (ID, CategoryID, Name) values ('5CDABA40-A230-4E80-9C77-49A541231730','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Extended school year')	
--insert @ServiceDef (ID, CategoryID, Name) values ('2C1096E4-BA93-42BB-8C1A-0EE1C5C5B6B0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Family Support Services')	
--insert @ServiceDef (ID, CategoryID, Name) values ('42A2EC5D-FB02-4680-A27B-11BB873EDA5F','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Hearing Interpretive Services')	
--insert @ServiceDef (ID, CategoryID, Name) values ('6ED9C679-F52D-4453-9770-E0DF86318335','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Hearing Services')		
--insert @ServiceDef (ID, CategoryID, Name) values ('3B17CA1F-D52C-4D93-BBFF-32DA033D4D5B','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Intensive Behavior Intervention')		
--insert @ServiceDef (ID, CategoryID, Name) values ('85140049-E850-4650-AE1B-D550BA85F0C0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Language Therapy')		
--insert @ServiceDef (ID, CategoryID, Name) values ('E287E083-C477-4461-8373-F79FA22F82DF','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Licensed Psychologist/Psychiat')		
--insert @ServiceDef (ID, CategoryID, Name) values ('FD34680D-E368-41CF-A7F9-472DF7C8609A','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Occupational Therapy')		
--insert @ServiceDef (ID, CategoryID, Name) values ('2832170F-9BFD-4222-8032-6FA6C00A907A','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','One to one aide outside genera')		
--insert @ServiceDef (ID, CategoryID, Name) values ('E10274DB-2ED7-4A46-958C-837E18460766','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','One-to-One Aide/General class')		
--insert @ServiceDef (ID, CategoryID, Name) values ('8B762FD6-02C6-4DB9-8A71-93F213AB7210','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Orientation and Mobility')		
--insert @ServiceDef (ID, CategoryID, Name) values ('73436B05-6A48-4F48-AD12-81787469D743','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Other Spec Ed Services')		
--insert @ServiceDef (ID, CategoryID, Name) values ('AE882D0F-926F-46B3-ABB2-255494A959B7','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Physical Therapy')		
--insert @ServiceDef (ID, CategoryID, Name) values ('F3094011-D87E-4942-A486-A0953904F68D','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Psycho-Social Rehabilitation')		
--insert @ServiceDef (ID, CategoryID, Name) values ('18CB6534-7E68-409A-A64D-307C190530D5','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','School Health')		
--insert @ServiceDef (ID, CategoryID, Name) values ('1556C098-DE6C-4324-B4F9-5B31C1690A91','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','School Psychological Services')		
--insert @ServiceDef (ID, CategoryID, Name) values ('3860C66C-7D62-4C29-A692-65F0E1F43CD0','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Social Work')		
--insert @ServiceDef (ID, CategoryID, Name) values ('A53B1E53-2FE5-4254-B622-D3A24B9CA034','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Specially Arranged Transport')		
--insert @ServiceDef (ID, CategoryID, Name) values ('B9E8033A-EF97-4283-8BC8-419DFDFD3463','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Speech Therapy')		
--insert @ServiceDef (ID, CategoryID, Name) values ('B44DAB63-CAB0-4E98-83DE-8910B1B4E676','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Title One Services')		
--insert @ServiceDef (ID, CategoryID, Name) values ('CDE709CD-8A11-43C9-9D7B-2ACF4EC4C051','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vision Services')		
--insert @ServiceDef (ID, CategoryID, Name) values ('DA5809CF-21EB-4B48-A071-143A33402F7B','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vocational Rehabilitation')		
--insert @ServiceDef (ID, CategoryID, Name) values ('CF8B709A-CF54-47E7-916D-EC8CCB9883D4','4CA5DB1F-2CAC-4DDC-B856-B4B8BFE88BDD','Vocational Services')
----select ID from @ServiceDef order by Name

--update tsd set Description = sd.Description, DefaultLocationID = sd.DefaultLocationID, MinutesPerUnit = sd.MinutesPerUnit
--from (select * from @SelectLists where Type = 'Service') x join 
--@ServiceDef tsd on x.EnrichID = tsd.ID JOIN 
--ServiceDef sd on tsd.Name = sd.Name



----select * from ServiceDef order by Name
----select ID, 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', Name from @ServiceDef order by Name

------ insert test
----select t.EnrichID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.EnrichLabel, tsd.Description, tsd.DefaultLocationID, tsd.MinutesPerUnit
----from ServiceDef x right join
----(select * from @SelectLists where Type = 'Service') t on x.ID =t.EnrichID JOIN 
----@ServiceDef tsd on t.EnrichID = tsd.ID 
----where x.ID is null order by x.Name

-------- delete test		-- we will not be deleting services that were entered manually by the customer.
--select x.*
--from ServiceDef x left join
--(select * from @SelectLists where Type = 'Service') t on x.ID =t.EnrichID  
-- where t.EnrichID is null
--order by x.Name

---- update test - deleted date
--select sd.*
---- update sd set DeletedDate = GETDATE()
--from ServiceDef sd left join
--@ServiceDef t on sd.ID = t.ID 
--where t.ID is null

--Begin tran fixservdef

--insert ServiceDef (ID, TypeID, Name, Description, DefaultLocationID, MinutesPerUnit,UserDefined)
--select t.EnrichID, TypeID = 'D3945E9D-AA0E-4555-BCB2-F8CA95CC7784', t.EnrichLabel, tsd.Description, tsd.DefaultLocationID, tsd.MinutesPerUnit,1
--from ServiceDef x right join
--(select * from @SelectLists where Type = 'Service') t on x.ID =t.EnrichID JOIN 
--@ServiceDef tsd on t.EnrichID = tsd.ID 
--where x.ID is null order by x.Name



----------------------------------------------------------------------------------------------------------------------------------------------------------------------


--declare @MAP_ServiceDef table (KeepID uniqueidentifier, TossID uniqueidentifier)


--/* ============================================================================= NOTE ============================================================================= 

--	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
--	will need to be updated for all hosted districts in Coloardo.  
	
--	HOWEVER
	
--	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

--   ============================================================================= NOTE ============================================================================= */


--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);
--insert @MAP_ServiceDef values ('93C18E55-ED8E-4537-9EC7-B653DEA388AD','D845912D-8FDF-442B-A7F1-97C92AD7CACC')--Adaptive P.E.
--insert @MAP_ServiceDef values ('932CB806-3EEA-4D95-9973-01A3E05F55E0','45441F0E-84DC-4746-8629-7E45C406CDE9')--	Assistive Technology Device
--insert @MAP_ServiceDef values ('A619217E-0A76-4F63-A13E-4CB60E6E42BA','8C054380-B22F-4D2A-98DE-568498E06EAB')--	Assistive Technology Service
--insert @MAP_ServiceDef values ('00967470-8A60-41E8-9D32-7084538EEE4E','CD96747D-3D67-4207-86FD-FD754A498102')--Community Based Education
--insert @MAP_ServiceDef values ('C4D5D929-0D74-45D7-8F42-8AA86DD6CDEB','A8A6FB3F-7EFC-47C5-8FB5-D97A4852E964')--Counseling
----insert @MAP_ServiceDef values ('361C98C1-B835-4448-981B-E9046A1C8867','')--Emotion/behavior intervention
--insert @MAP_ServiceDef values ('5CDABA40-A230-4E80-9C77-49A541231730','0B05CD43-2829-4D3C-AAF7-C045DA553DB0')--Extended school year
--insert @MAP_ServiceDef values ('2C1096E4-BA93-42BB-8C1A-0EE1C5C5B6B0','9DA3A043-5CAF-44A7-A79E-9CD99FC7D3EE')--Family Support Services
--insert @MAP_ServiceDef values ('42A2EC5D-FB02-4680-A27B-11BB873EDA5F','4C4226F6-5188-4396-BF62-32CA2251E348')--Hearing Interpretive Services
--insert @MAP_ServiceDef values ('6ED9C679-F52D-4453-9770-E0DF86318335','FB84D772-5DAB-42E7-8B1B-44A2D716F6E8')--Hearing Services
--insert @MAP_ServiceDef values ('3B17CA1F-D52C-4D93-BBFF-32DA033D4D5B','982D81E2-ABA4-411E-B4BA-4D75EC8F0541')--Intensive Behavior Intervention
--insert @MAP_ServiceDef values ('85140049-E850-4650-AE1B-D550BA85F0C0','93F77552-3134-43D8-8A70-E754215130F8')--Language Therapy
--insert @MAP_ServiceDef values ('E287E083-C477-4461-8373-F79FA22F82DF','1FB4A0D4-36E5-4F56-8AAE-B88A91F03720')--Licensed Psychologist/Psychiat
--insert @MAP_ServiceDef values ('FD34680D-E368-41CF-A7F9-472DF7C8609A','B874A136-2F0E-4955-AA1E-1F0D45F263FB')--Occupational Therapy
--insert @MAP_ServiceDef values ('2832170F-9BFD-4222-8032-6FA6C00A907A','94298B87-BA02-40CF-8E3E-5C257B63FFDF')--One to one aide outside genera
--insert @MAP_ServiceDef values ('E10274DB-2ED7-4A46-958C-837E18460766','FE9238F3-7707-41E4-8DA5-8F82D4DF62AA')--One-to-One Aide/General class
--insert @MAP_ServiceDef values ('8B762FD6-02C6-4DB9-8A71-93F213AB7210','275B088C-8FB1-4574-A6F6-983F36343AD8')--Orientation and Mobility
----insert @MAP_ServiceDef values ('73436B05-6A48-4F48-AD12-81787469D743','')--Other Spec Ed Services
--insert @MAP_ServiceDef values ('AE882D0F-926F-46B3-ABB2-255494A959B7','73107912-4959-4137-910B-B17E52076074')--Physical Therapy
--insert @MAP_ServiceDef values ('F3094011-D87E-4942-A486-A0953904F68D','62C696F1-AEF3-4636-A425-BEF95584CFD1')--Psycho-Social Rehabilitation
--insert @MAP_ServiceDef values ('18CB6534-7E68-409A-A64D-307C190530D5','75D07F63-F586-4C55-8FDE-A5B6D0737157')--School Health
--insert @MAP_ServiceDef values ('1556C098-DE6C-4324-B4F9-5B31C1690A91','7BBAAB01-398D-4835-B4B0-13D543FAC564')--School Psychological Services
--insert @MAP_ServiceDef values ('3860C66C-7D62-4C29-A692-65F0E1F43CD0','BB0B78C6-5B61-44C9-B1C8-F301DE831028')--Social Work
--insert @MAP_ServiceDef values ('A53B1E53-2FE5-4254-B622-D3A24B9CA034','B630AE87-E461-4DAC-B5B9-3FB85C78F56D')--Specially Arranged Transport
--insert @MAP_ServiceDef values ('B9E8033A-EF97-4283-8BC8-419DFDFD3463','BF859DEF-67A2-4285-A871-E80315AF3BD5')--Speech Therapy
--insert @MAP_ServiceDef values ('B44DAB63-CAB0-4E98-83DE-8910B1B4E676','4A220C42-559C-4E03-A591-7DEF6DE16061')--Title One Services
--insert @MAP_ServiceDef values ('CDE709CD-8A11-43C9-9D7B-2ACF4EC4C051','7FA2A03B-D9AF-482C-9027-32333081E1B9')--Vision Services
--insert @MAP_ServiceDef values ('DA5809CF-21EB-4B48-A071-143A33402F7B','93A101A0-4278-4EFA-BB75-16CA0CF3A60F')--Vocational Rehabilitation
--insert @MAP_ServiceDef values ('CF8B709A-CF54-47E7-916D-EC8CCB9883D4','75426BD7-DD80-4D61-B19A-8EE5F14E2714')--Vocational Services


--declare I cursor for 
--select KeepID, TossID from @MAP_ServiceDef 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'ServiceDef' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )
----print 'update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' 
--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I

---- delete unneeded
--delete x
---- select g.*, t.StateCode
--from ServiceDef x join
--@MAP_ServiceDef t on x.ID = t.TossID 

----select * from ServiceDef order by Name
---- another way to handle this:  delete unused records with delete script, and in trannsform, set all new records to deleleteddate not null.  
---- however, that may have a negative impact on FL districts, who may want to keep the services that have entered in their Staging instance.
----update sd set DeletedDate = GETDATE()
----from ServiceDef sd left join
----@ServiceDef t on sd.ID = t.ID 
----where t.ID is null


--insert IepServiceDef (ID, CategoryID, ScheduleFreqOnly) 
--select s.ID, s.CategoryID,  0
--from @ServiceDef s left join
--IepServiceDef t on s.ID = t.ID
--where t.ID is null



---- select * from ServiceDef order by Name
----select * from IepServiceDef

--commit tran fixservdef
------rollback tran fixservdef

--=================================================================================================================
--						IepPlacementOption
--=================================================================================================================
--select EnrichID,EnrichLabel from @SelectLists where Type = 'LRE' order by StateCode
--select * from IepPlacementOption order by StateCode


--declare @IepPlacementOption table (ID uniqueidentifier, TypeID uniqueidentifier, Sequence int)


--insert @IepPlacementOption (ID, TypeID, Sequence) values ('DBC87BF4-FECF-4AB7-9C02-8E36E488BC8E','D9D84E5B-45F9-4C72-8265-51A945CD0049',0)--General ed class 80% or more
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('F237216A-3969-4740-836D-D7B060F28B98','D9D84E5B-45F9-4C72-8265-51A945CD0049',1)--General ed class 40 - 80%
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('B0CDC7EC-244D-43EB-A94D-82D6F307DB71','D9D84E5B-45F9-4C72-8265-51A945CD0049',2)--General ed class less than 40%
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('64667C72-E29E-43B6-A00E-9B04CC529C18','D9D84E5B-45F9-4C72-8265-51A945CD0049',3)--Public separate day school
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('0225B74D-A711-47A4-8991-3C2C4430BC77','D9D84E5B-45F9-4C72-8265-51A945CD0049',4)--Private separate day school
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('29CAFE39-B62F-4A48-A8A9-7DB2E688C46E','D9D84E5B-45F9-4C72-8265-51A945CD0049',5)--Public residential facility
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('58A2C111-088B-4AB1-9E20-68137D757536','D9D84E5B-45F9-4C72-8265-51A945CD0049',6)--Private residential facility
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('019E3868-3B14-453F-A7E1-482E153C3B06','D9D84E5B-45F9-4C72-8265-51A945CD0049',7)--Homebound/Hospital
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('A2B46B82-2CA0-4511-BA3B-3C334F130C93','D9D84E5B-45F9-4C72-8265-51A945CD0049',8)--Correctional facility
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('1267E203-0111-4348-AAB7-155BA2D4F6C5','D9D84E5B-45F9-4C72-8265-51A945CD0049',9)--Enrolled private by parents
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('F7A4B6C5-0A87-4228-BDE2-8B80743CC6A9','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',3)--Separate Class
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('8026D621-4C8D-4C15-92BE-5B07BF02B102','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',4)--Separate School
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('914AD573-0C9A-43B4-9A3E-0800CEB6709E','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',5)--Residential Facility
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('E84CC109-FF37-4154-B93C-16AE5D9448DF','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',6)--Service Provider Location
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('BCC5FF10-E35F-44E0-9F31-9964A292BED1','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',7)--Home
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('FB3F9819-4295-498F-929B-9194909CB165','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',0)-->10 hours Regular EC Program provides majority of services
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('D388B0AC-FD80-4D73-A702-3C240F73C6E7','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',1)-->10 hours Regular EC Program; majority of services provided elsewhere
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('6B1194D7-A73B-4850-A4F0-CBEC499174EC','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',2)--<10 hours Regular EC Program provides majority of services
--insert @IepPlacementOption (ID, TypeID, Sequence) values ('AAD2442C-5AA7-43CC-9959-C9A38DBB725E','E47FBA7F-8EB0-4869-89DF-9DD3456846EC',3)--< 10 hours Regular EC Program; majority of services provided elsewhere


-------- insert test
--select t.EnrichID, tiepop.TypeID, tiepop.Sequence, t.EnrichLabel, t.StateCode
--from IepPlacementOption x right join
--(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID JOIN 
--@IepPlacementOption tiepop on t.EnrichID = tiepop.ID
--where x.ID is null order by x.StateCode
-------- delete test
--select x.*
--from IepPlacementOption x left join
--(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID  
--where t.EnrichID is null order by x.StateCode

--begin tran fixLRE

--insert IepPlacementOption (ID, TypeID, Sequence, Text, StateCode)
--select t.EnrichID, tiepop.TypeID, tiepop.Sequence, t.EnrichLabel, t.StateCode
--from IepPlacementOption x right join
--(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID JOIN 
--@IepPlacementOption tiepop on t.EnrichID = tiepop.ID
--where x.ID is null order by x.StateCode

--declare @MAP_IepPlacementOption table (KeepID uniqueidentifier, TossID uniqueidentifier)


----/* ============================================================================= NOTE ============================================================================= 

----	It is expected that the ID values in the rows below for Autism, Hearing Impairment, Preschooler with a Disability, Serious Emotional and Vision Impairment
----	will need to be updated for all hosted districts in Coloardo.  
	
----	HOWEVER
	
----	it is very important to verify that these are the only values need to be updated / deleted.  Please use the     "delete test"    query above to verify.

----   ============================================================================= NOTE ============================================================================= */


--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);

--insert @MAP_IepPlacementOption values ('DBC87BF4-FECF-4AB7-9C02-8E36E488BC8E','FEFF9910-F320-4097-AFC2-A3D9713470BD')--General ed class 80% or more
--insert @MAP_IepPlacementOption values ('F237216A-3969-4740-836D-D7B060F28B98','521ACE5E-D04B-4E30-80E3-517516383536')--	General ed class 40 - 80%
--insert @MAP_IepPlacementOption values ('B0CDC7EC-244D-43EB-A94D-82D6F307DB71','9CD2726E-6461-4F6C-B65F-B4232FB4D36E')--	General ed class less than 40%
----insert @MAP_IepPlacementOption values ('64667C72-E29E-43B6-A00E-9B04CC529C18','77E0EE80-143B-41E5-84B9-5076605CCC9A')--	Public separate day school
----insert @MAP_IepPlacementOption values ('0225B74D-A711-47A4-8991-3C2C4430BC77','E4EE85F2-8307-4C8D-BA77-4EB5D12D8470')--	Private separate day school
--insert @MAP_IepPlacementOption values ('29CAFE39-B62F-4A48-A8A9-7DB2E688C46E','91EF0ECE-A770-4D05-8868-F19180A000DB')--	Public residential facility
--insert @MAP_IepPlacementOption values ('58A2C111-088B-4AB1-9E20-68137D757536','84DAF081-F700-4F57-99DA-A2A983FDE919')--	Private residential facility
--insert @MAP_IepPlacementOption values ('019E3868-3B14-453F-A7E1-482E153C3B06','035CDD42-06A6-498D-B5AA-B16EE4A06FE9')--	Homebound/Hospital
--insert @MAP_IepPlacementOption values ('A2B46B82-2CA0-4511-BA3B-3C334F130C93','9B2DB2E0-CAE8-4CD0-AD4B-2BD61FD6C773')--	Correctional facility
----insert @MAP_IepPlacementOption values ('1267E203-0111-4348-AAB7-155BA2D4F6C5','9C830385-8B5E-4CB4-AA2E-9C8DB80E9F8B')--	Enrolled private by parents
--insert @MAP_IepPlacementOption values ('F7A4B6C5-0A87-4228-BDE2-8B80743CC6A9','5654E9A5-10A8-4B58-8A5C-79DA92674A27')--	Separate Class
--insert @MAP_IepPlacementOption values ('8026D621-4C8D-4C15-92BE-5B07BF02B102','0B2E63D7-6493-44A7-95B1-8DF327D77C38')--	Separate School
--insert @MAP_IepPlacementOption values ('914AD573-0C9A-43B4-9A3E-0800CEB6709E','2E45FDA2-0767-43D0-892D-D1BB40AFCEC1')--	Residential Facility
--insert @MAP_IepPlacementOption values ('E84CC109-FF37-4154-B93C-16AE5D9448DF','0DA48AA5-183C-4434-91C1-AC3C9941BE15')--	Service Provider Location
--insert @MAP_IepPlacementOption values ('BCC5FF10-E35F-44E0-9F31-9964A292BED1','0980382F-594C-453F-A0C9-77D54A0443B1')--	Home
----insert @MAP_IepPlacementOption values ('FB3F9819-4295-498F-929B-9194909CB165','')--	>10 hours Regular EC Program provides majority of services
----insert @MAP_IepPlacementOption values ('D388B0AC-FD80-4D73-A702-3C240F73C6E7','')--	>10 hours Regular EC Program; majority of services provided elsewhere
----insert @MAP_IepPlacementOption values ('6B1194D7-A73B-4850-A4F0-CBEC499174EC','')--	<10 hours Regular EC Program provides majority of services
----insert @MAP_IepPlacementOption values ('AAD2442C-5AA7-43CC-9959-C9A38DBB725E','')--	< 10 hours Regular EC Program; majority of services provided elsewhere

--declare I cursor for 
--select KeepID, TossID from @MAP_IepPlacementOption 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'IepPlacementOption' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )
----print 'update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' 
--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I


--UPDATE x
--set Text = t.EnrichLabel,
--	Sequence = tiepop.Sequence
--from IepPlacementOption x  join
--(select * from @SelectLists where Type = 'LRE')t on x.ID = t.EnrichID  JOIN 
--@IepPlacementOption tiepop On t.EnrichID = tiepop.ID

---- delete unneeded
--delete x
---- select g.*, t.StateCode
--from IepPlacementOption x join
--@MAP_IepPlacementOption t on x.ID = t.TossID 

--commit tran fixLRE
----rollback tran fixLRE


--======================================================================================================
--								PrgStatus
--========================================================================================================
--select EnrichID,EnrichLabel from @SelectLists where Type = 'Exit' ORDER BY StateCode
--select * from PrgStatus order by StateCode



--declare @PrgStatus table (ID uniqueidentifier, ProgramID uniqueidentifier, Sequence int, IsExit bit, IsEntry bit,  StatusStyleID uniqueidentifier)

--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('24827AAC-3DE7-432D-A15B-00BE41BF8BDF','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',7,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--No Consent
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('73DC240D-EF00-42C9-910D-3953ED3540D4','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',8,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Not Eligible
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('12086FE0-B509-4F9F-ABD0-569681C59EE2','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',10,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Exited After Eligibility
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('1A10F969-4C63-4EB0-A00A-5F0563305D7A','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',9,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Exited Before Eligibility
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('9B1CC467-3D34-4AA1-BED5-7EE37ECBD799','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',6,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--No Disability Suspected
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('B6FD50F7-3154-4831-974E-E41D91A49525','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',11,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('CD184A31-1F54-4FC0-96CA-5DD8653B0CD9','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',12,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Graduate - Met Reduced Requirements
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('F7C2F259-7497-42AB-8274-274CFB5EFE1F','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',13,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Certificate of Completion/Attendance
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('63272934-A855-4E96-B75B-865ADD84DC70','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',14,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Reached Maximum Age
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('E28E543A-A45B-4C55-9EAF-C2DCDFD0A84E','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',15,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Dropped Out
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('910B6CAA-72E3-4AA0-A40F-823AAD29FCBC','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',16,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Transfer to Another Education Environment
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('95B9417B-9746-4076-91BE-F0A4E51E4AE9','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',17,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--No Longer Eligible for Program
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('E776A203-2701-49DE-BFB3-2B9E53763F4B','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',18,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Deceased
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('E6DAFFA8-1A83-4FD3-B7E5-8D7FBE784F80','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',99,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Status Unknown (dropout)
--insert @PrgStatus (ID, ProgramID, Sequence, IsExit, IsEntry,  StatusStyleID) VALUES ('91E0214F-F587-40C8-B859-E8819B347572','F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',20,1,0,'FA528C27-E567-4CC9-A328-FF499BB803F6')--Summer Break


----- insert test
--select t.EnrichID, tpgs.ProgramID, tpgs.Sequence, t.EnrichLabel, tpgs.IsExit, tpgs.IsEntry, tpgs.StatusStyleID, t.StateCode
--from PrgStatus g right join
--(select * from @SelectLists where Type = 'Exit') t on g.ID = t.EnrichID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' JOIN 
--@PrgStatus tpgs on t.EnrichID = tpgs.ID
--where g.ID is null
--order by tpgs.Sequence, t.stateCode, t.EnrichLabel 

------ delete test
--select g.*
--from PrgStatus g left join
--(select * from @SelectLists where Type = 'Exit') t on g.ID = t.EnrichID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'  
--where t.EnrichID is null and g.IsExit = 1
--order by g.DeletedDate desc, g.Sequence, g.stateCode, g.Name

--begin tran FixPrgStatus

--declare @RelSchema varchar(100), @RelTable varchar(100), @RelColumn varchar(100), @KeepID varchar(50), @TossID varchar(50), @toss varchar(50);



---- insert missing.  This has to be done before updating the records to be deleted and before deleting.
--insert PrgStatus (ID, ProgramID, Sequence, Name, IsExit, IsEntry,  StatusStyleID, StateCode)
--select t.EnrichID, tpgs.ProgramID, tpgs.Sequence, t.EnrichLabel, tpgs.IsExit, tpgs.IsEntry, tpgs.StatusStyleID, t.StateCode
--from PrgStatus g right join
--(select * from @SelectLists where Type = 'Exit') t on g.ID = t.EnrichID and g.ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' JOIN 
--@PrgStatus tpgs on t.EnrichID = tpgs.ID
--where g.ID is null
--order by tpgs.Sequence, t.stateCode, t.EnrichLabel 

--declare @MAP_PrgStatus table (KeepID uniqueidentifier, TossID uniqueidentifier)
----insert @MAP_PrgStatus (KeepID, TossID) values ('24827AAC-3DE7-432D-A15B-00BE41BF8BDF','')--	No Consent
----insert @MAP_PrgStatus (KeepID, TossID) values ('73DC240D-EF00-42C9-910D-3953ED3540D4','')--	Not Eligible
----insert @MAP_PrgStatus (KeepID, TossID) values ('12086FE0-B509-4F9F-ABD0-569681C59EE2','')--	Exited After Eligibility
----insert @MAP_PrgStatus (KeepID, TossID) values ('1A10F969-4C63-4EB0-A00A-5F0563305D7A','')--	Exited Before Eligibility
----insert @MAP_PrgStatus (KeepID, TossID) values ('9B1CC467-3D34-4AA1-BED5-7EE37ECBD799','')--	No Disability Suspected
--insert @MAP_PrgStatus (KeepID, TossID) values ('B6FD50F7-3154-4831-974E-E41D91A49525','CCFEA3D2-5A97-4590-89B7-5B72C3462222')--	Graduate - Met Regular Requirements
--insert @MAP_PrgStatus (KeepID, TossID) values ('CD184A31-1F54-4FC0-96CA-5DD8653B0CD9','F8E18ACA-4147-4D80-8026-5DAD21177ED3')--	Graduate - Met Reduced Requirements
--insert @MAP_PrgStatus (KeepID, TossID) values ('F7C2F259-7497-42AB-8274-274CFB5EFE1F','0BB89AF0-544E-478A-AD21-5DE93698EB27')--	Certificate of Completion/Attendance
--insert @MAP_PrgStatus (KeepID, TossID) values ('63272934-A855-4E96-B75B-865ADD84DC70','7F95788C-4317-4450-9540-3C14A7316E3B')--	Reached Maximum Age
--insert @MAP_PrgStatus (KeepID, TossID) values ('E28E543A-A45B-4C55-9EAF-C2DCDFD0A84E','338F2F0A-A8FF-47C4-AF04-423D6094243A')--	Dropped Out
--insert @MAP_PrgStatus (KeepID, TossID) values ('910B6CAA-72E3-4AA0-A40F-823AAD29FCBC','22F4F0D4-1463-435C-B2C7-01B3CCAFF31F')--	Transfer to Another Education Environment
--insert @MAP_PrgStatus (KeepID, TossID) values ('95B9417B-9746-4076-91BE-F0A4E51E4AE9','D21EC563-676A-44A6-9650-0433C3BC0EA0')--	No Longer Eligible for Program
--insert @MAP_PrgStatus (KeepID, TossID) values ('E776A203-2701-49DE-BFB3-2B9E53763F4B','25B25E2B-ECBB-4392-BF09-11D7F011FDB5')--	Deceased
----insert @MAP_PrgStatus (KeepID, TossID) values ('E6DAFFA8-1A83-4FD3-B7E5-8D7FBE784F80','')--	Status Unknown (dropout)
--insert @MAP_PrgStatus (KeepID, TossID) values ('91E0214F-F587-40C8-B859-E8819B347572','979F387E-8AE3-473E-9854-2649A82B15F0')--	Summer Break


--declare I cursor for 
--select KeepID, TossID from @MAP_PrgStatus 

--open I
--fetch I into @KeepID, @TossID

--while @@fetch_status = 0

--begin

--	declare R cursor for 
--	SELECT 
--		SCHEMA_NAME(f.SCHEMA_ID) SchemaName,
--		OBJECT_NAME(f.parent_object_id) AS TableName,
--		COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName
--	FROM sys.foreign_keys AS f
--		INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
--		INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
--	where SCHEMA_NAME(o.SCHEMA_ID) = 'dbo' 
--		and OBJECT_NAME (f.referenced_object_id) = 'PrgStatus' ------------------------- Table name here
--		and COL_NAME(fc.referenced_object_id,fc.referenced_column_id) = 'ID'
--	order by SchemaName, TableName, ColumnName

--	open R
--	fetch R into @relschema, @RelTable, @relcolumn

--	while @@fetch_status = 0
--	begin

-- 	exec ('update t set '+@relcolumn+' = '''+@KeepID+''' from '+@relschema+'.'+@reltable+' t where t.'+@relcolumn+' = '''+@TossID+'''' )

--	fetch R into @relschema, @RelTable, @relcolumn
--	end
--	close R
--	deallocate R

--fetch I into @KeepID, @TossID
--end
--close I
--deallocate I

---- delete unneeded
--delete x
---- select g.*, t.StateCode
--from PrgStatus x join
--@MAP_PrgStatus t on x.ID = t.TossID 


--commit tran FixPrgStatus
----rollback tran FixPrgStatus