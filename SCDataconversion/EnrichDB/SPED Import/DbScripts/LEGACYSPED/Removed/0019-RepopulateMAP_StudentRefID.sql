if (select COUNT(*) from LEGACYSPED.MAP_StudentRefID) = 0
begin
exec ('
	insert LEGACYSPED.MAP_StudentRefID 
	select 
		src.StudentRefID, 
		LegacyData = tgt.ManuallyEntered,
		DestID = tgt.ID
	from LEGACYSPED.Student src join
		dbo.Student tgt on 
			src.StudentLocalID = tgt.Number and
			src.LastName = tgt.LastName and 
			tgt.IsActive = 1
	')
end
go
