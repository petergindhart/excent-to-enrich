alter table [FormInputValue]
drop constraint [FK_FormInputValue#InputField#]
go

alter table [FormInputValue]
add constraint [FK_FormInputValue#InputField#]
foreign key(InputFieldId) references FormTemplateInputItem(Id)
on delete cascade
go

alter table [FormInputValue]
check constraint [FK_FormInputValue#InputField#]
go
