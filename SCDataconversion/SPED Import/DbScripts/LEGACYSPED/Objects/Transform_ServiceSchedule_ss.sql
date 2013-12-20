
-- just use the table.


--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_ServiceSchedule_ss'))
--DROP VIEW LEGACYSPED.Transform_ServiceSchedule_ss
--GO

--create view LEGACYSPED.Transform_ServiceSchedule_ss
--as
--select *
--from LEGACYSPED.Transform_ServiceSchedule_Snapshot s 

--go


--select c.name+', '
--from sys.schemas s join
--sys.objects o on s.schema_id = o.schema_id join
--sys.columns c on o.object_id = c.object_id 
--where s.name= 'LEGACYSPED'
--and o.name = 'Transform_ServiceSchedule'
