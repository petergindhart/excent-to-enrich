IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgItemOutcome]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgItemOutcome]  
GO  
  
CREATE VIEW [AURORAX].[Transform_PrgItemOutcome]
AS
 SELECT
  ExitReason = k.Code,
  DestID = m.DestID, -- do i need isnull?
  CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3',
  Text = k.Label,   -- varchar(100)
  Sequence = (
    select count(*)+(select max(Sequence)+1 from PrgItemOutcome where CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3') 
    from AURORAX.Lookups
    where Type = 'Exit' and
    Type = k.Type and 
    Code < k.Code),
  NextStatusID = '12086FE0-B509-4F9F-ABD0-569681C59EE2',   
  DeletedDate = cast(NULL as datetime)
 FROM  
  AURORAX.Lookups k LEFT JOIN
  AURORAX.MAP_OutcomeID m on k.Code = m.ExitReason LEFT JOIN
  dbo.PrgItemOutcome o on m.DestID = o.ID
 WHERE
  k.Type = 'Exit'
GO
--