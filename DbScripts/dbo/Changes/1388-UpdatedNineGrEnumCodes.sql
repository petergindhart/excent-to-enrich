UPDATE EnumValue
SET Code = '0' + Code
WHERE ID in
(
'B1448803-749B-4222-96EC-9469B65E898E',
'E5659A91-6274-4E58-8A8E-11DF120C1D28',
'92CD610E-305E-4614-B47C-4A392CE29022',
'8FDDE954-AC86-4C32-A46B-F3CD778223F3',
'3BB264BC-F381-47D7-AC98-8758DC18ABC6',
'67CCB9B7-EE44-48A0-93EA-B0BBEB73122F',
'D6F55827-9E59-433B-98A9-E1C52CA858D7',
'FBB9F7AE-F42B-488C-A3D3-FD1FD6742260',
'9DD932B9-7649-41B4-90BE-91D2BDF29C94',
'25B94B05-FAF9-4E36-8A1B-41F40B299C19'
) AND LEN(Code) = 1