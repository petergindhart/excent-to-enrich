if (select COUNT(*) from AURORAX.MAP_StudentRefID) = 0
begin
exec ('
	insert AURORAX.MAP_StudentRefID 
	select 
		src.StudentRefID, 
		LegacyData = tgt.ManuallyEntered,
		DestID = tgt.ID
	from AURORAX.Student src join
		dbo.Student tgt on 
			src.StudentLocalID = tgt.Number and
			src.LastName = tgt.LastName and 
			tgt.IsActive = 1
	')
end
go
