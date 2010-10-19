ALTER TABLE FormTemplateInputItem
ADD Code VARCHAR(25) NULL;
GO

ALTER TABLE FormTemplate
ADD Code VARCHAR(25) NULL;
GO

-- Pre-populate template codes based on the name --
--###############################################--
	UPDATE FormTemplate
	SET Code = 
		SUBSTRING(
			REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(Name, '/', '')
								, ',', '')
							, '''', '')
						, '-', '')
					, '"', '')
				, '~', '_')
			, ' ', '')
		, 1, 25)
	GO

ALTER TABLE FormTemplate
ALTER COLUMN Code VARCHAR(25) NOT NULL;
GO
