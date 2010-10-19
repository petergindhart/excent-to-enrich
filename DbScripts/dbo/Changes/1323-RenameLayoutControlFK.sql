-- rename foreign key in order to generate list property
EXEC sp_rename 'FK_FormTemplateLayout#Control#', 'FK_FormTemplateLayout#Control#Layouts'
