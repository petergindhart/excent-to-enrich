select 'insert @OrgUnit values ('''+convert(varchar(36), ID)+''', '''+Name+''','''+isnull(Number, '')+''')'
from OrgUnit
order by case when ID = '6531EF88-352D-4620-AF5D-CE34C54A9F53' then 0 else 1 end, Name


select * from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
