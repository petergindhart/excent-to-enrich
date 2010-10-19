alter table FormTemplateInputSelectFieldOption
add Sequence int null
go

update FormTemplateInputSelectFieldOption
set Sequence = 0
go

/*
Conditionally order options
---------------------------
if @@version like 'Microsoft SQL Server  2000%'
begin
	-- No sequencing if rank is not supported
	update FormTemplateInputSelectFieldOption
	set Sequence = 0
end
else  -- >= SQL 2005
	update FormTemplateInputSelectFieldOption
	set Sequence = s.Sequence - 1
	from FormTemplateInputSelectFieldOption o
		join (
			select ID, Sequence = RANK() over
				-- for each field, order options by form (global first) and then label
				(partition by selectfieldid order by FormInstanceId, cast(Label as varchar(1000)))
			from FormTemplateInputSelectFieldOption
		) s on s.ID = o.ID
*/
go

alter table FormTemplateInputSelectFieldOption
alter column Sequence int not null
go
