--#include ParseMarkNum.sql
--#include IsMarkNumFinal.sql
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Util_ImportReportCards]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Util_ImportReportCards]
GO

CREATE PROCEDURE [dbo].[Util_ImportReportCards]
(	
	@rosterYearToimport uniqueidentifier,
	@printSql bit = 0,
	@executeSql bit = 1,
	@executionLevel int = 4-- 1:Extract only, 2: AGRL_DN,RCI,RCT only, 3: RCS import only; 4: all
	)
AS
	DECLARE @counter			int
	DECLARE @sisGUID			uniqueidentifier --this will be a guid that will be used for all of the sisdatabases, to ensure that when SP is over it can be removed easily
	DECLARE @sisTable_AGRL_GUID	uniqueidentifier
	DECLARE @sisTable_AGRD_GUID	uniqueidentifier
	DECLARE @sisTable_ASTU_GUID	uniqueidentifier
	DECLARE @sisTable_AMST_GUID uniqueidentifier
	DECLARE @sisTable_AGDF_GUID uniqueidentifier

	DECLARE @crlf varchar(2)
	SET @crlf = char(13) + char(10)

	DECLARE @err int
	DECLARE @sqlToRun varchar(2000)
	SET @sqlToRun = ''

	--the constant GUID for each of the sisTable to create and use
	SET @sisGUID			= '108E6D73-1AD1-4C67-BC49-83BD9AC3B6AD'
	SET @sisTable_AGRL_GUID = '29877F6A-A393-4921-AFD3-5A5CA8F8032F'
	SET @sisTable_AGRD_GUID = 'D2756FB4-CC88-4BD9-A98E-AB5AD2074DE3'
	SET @sisTable_ASTU_GUID = '4A8166D3-59DA-473D-8205-B156D1ABBE88'
	SET @sisTable_AMST_GUID = 'E0910A72-2186-4CB3-892C-5EEC7E497646'
	SET @sisTable_AGDF_GUID = 'FA4CD74B-4ED5-4722-82F8-21EC9328E665'

	
	--declare values which will be pulled from a current sisdatabase entry
	DECLARE @ImportScheduleID	varchar(36)
	DECLARE @DbServer			varchar(64)
	DECLARE @DbName				varchar(128)
	DECLARE @DbUser				varchar(32)
	DECLARE @DbPassword			varchar(32)
	DECLARE @LinkedServer		varchar(16)
	DECLARE @LinkedServerMan	varchar(2)
	DECLARE @AbsentCodes		varchar(128)
	DECLARE	@Consolidated		varchar(2)
	DECLARE @tablePrefix		varchar(100)
	DECLARE @tableSuffix		varchar(100)
	DECLARE @importAGDF			bit
	DECLARE @dbTypeID			varchar(1)

select top 1
	@ImportScheduleID	= ImportScheduleID,--(select top 1 cast(ImportScheduleID as varchar(36))FROM sisdatabase WHERE SisTypeID ='S')
	@DbServer			= DbServer,--(select top 1 DbServer FROM sisdatabase WHERE SisTypeID ='S')
	@DbName				= DbName,--(select top 1 DbName	 FROM sisdatabase WHERE SisTypeID ='S')
	@DbUser				= DbUser,--(select top 1 DbUser   FROM sisdatabase WHERE SisTypeID ='S')
	@DbPassword			= DbPassword,--(select top 1 DbPassword FROM sisdatabase WHERE SisTypeID ='S')
	@dbTypeID			= DbTypeID,
	@LinkedServer		= LinkedServer,--(select top 1 LinkedServer FROM sisdatabase WHERE SisTypeID ='S')
	@LinkedServerMan	= cast(IsLinkedServerManaged as varchar(2)),--(select top 1 cast(IsLinkedServerManaged as varchar(2)) FROM sisdatabase WHERE SisTypeID ='S')
	@AbsentCodes		= AbsentCodes,--(select top 1 AbsentCodes FROM sisdatabase WHERE SisTypeID ='S')
	@Consolidated		= cast(IsConsolidated as varchar(2)), --(select top 1 cast(IsConsolidated as varchar(2)) FROM sisdatabase WHERE SisTypeID ='S')
	@importAGDF			= case DbTypeId when 'D' then 1 else 0 end,
	@tablePrefix		=  tablePrefix,
	@tableSuffix		=  tableSuffix
	
FROM
	sisdatabase
WHERE 
	id= '91BED6CC-69D6-4D4E-AAFA-D23E58934369'

	--start tran
--BEGIN TRAN

	IF (@executionLevel IN (1,4))
	BEGIN
		--checks to see if there exists an ACAM table, if there isn't it populates it from the current acam table,
		if NOT exists (select * from dbo.sysobjects where id = object_id(N'[sasi_acam_new]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			exec('select * into sasi_acam_new from sasi_acam')


		--create the sisdatabase entry
		SET @sqlToRun = 'INSERT INTO  SisDatabase ( ID             , SisTypeID             , ImportScheduleID             , ImportStatusID             , DbTypeID             , DbServer             , DbName             , DbUser             , DbPassword             , LinkedServer             , IsLinkedServerManaged             , TablePrefix             , TableSuffix             , AbsentCodes             , SnapshotDate             , SnapshotRosterYearID             , LastImportDate             , LastImportRosterYearID             , IsConsolidated             , ImportSucceededEmailAddress             , ImportSucceededSubject             , ImportSucceededMessage             , ImportFailedEmailAddress             , ImportFailedSubject             , ImportFailedMessage ) VALUES(''' + cast(@sisGUID as varchar(36)) + ''',''S'',''' + @ImportScheduleID + 
		''',''U'',''' + @dbTypeID + ''',''' + @DbServer + ''',''' + @DbName +''','''+ @DbUser + ''',''' + @DbPassWord + ''',''' + @LinkedServer + ''',' 
		+ @LinkedServerMan + ',''' + IsNull(@tablePrefix, '') + ''' , ''' + IsNull(@tableSuffix, '') + ''' ,''' +  @AbsentCodes + ''',NULL,'''+ cast( @rosterYearToimport as varchar(36)) +''',NULL,'''+  cast( @rosterYearToimport as varchar(36))+''',' + 
		cast( @Consolidated as varchar(2)) + ',''NULL'',''NULL'',''NULL'',''NULL'',''NULL'',''NULL'')'	 + @crlf + @crlf		

		--will create the sisdatabase record
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred			

		--create sistable records, these records do not change
		SET @sqlToRun = 'insert into Sistable values('''+ cast(@sisTable_AGRD_GUID as varchar(36)) + ''',''' + cast(@sisGuid as varchar(36))+ ''', ''SASI_AGRD'',''AGRD'',1,''SchoolNum,Stulink,Sequence,ClassLink'',NULL,0,0,NULL,1,''SchoolNum'',1)' + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		SET @sqlToRun = 'insert into Sistable values('''+ cast(@sisTable_AGRL_GUID as varchar(36)) + ''',''' + cast(@sisGuid as varchar(36))+ ''', ''SASI_AGRL'',''AGRL'',1,''SchoolNum,Stulink,Sequence,MarkNum'',''MarkNum,SchoolNum'',0,0,NULL,1,''SchoolNum'',1)' + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		SET @sqlToRun = 'insert into Sistable values(''' + cast(@sisTable_ASTU_GUID as varchar(36)) + ''','''+ cast(@sisGuid as varchar(36))+ ''', ''SASI_ASTU'',''ASTU'',1,''stulink, schoolnum'',''Permnum'',0,0,''(Len(IsNull(STATUS, '''''''')) = 0) AND Len(IsNull(CONCSCHOOL, '''''''')) = 0'',1,''SchoolNum'',1)' + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		SET @sqlToRun = 'insert into Sistable values(''' + cast(@sisTable_AGDF_GUID as varchar(36)) + ''','''+ cast(@sisGuid as varchar(36))+ ''', ''SASI_AGDF'',''AGDF'',1,''schoolnum'',NULL,0,0,NULL,1,''SchoolNum'',1)'	+ @crlf
		if(@importAGDF = 1)
		BEGIN
			exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
			if @err <> 0  
				GOTO ErrorOccurred
		END

		SET @sqlToRun = 'insert into Sistable values(''' +  cast(@sisTable_AMST_GUID as varchar(36))+ ''','''+ cast(@sisGuid as varchar(36))+ ''', ''SASI_AMST'',''AMST'',1,''classlink, schoolnum'',NULL,0,0,NULL,1,''SchoolNum'',1)' + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		--CREATE SNAPSHOTS
		print 'Creating snapshots of tables: '+ @crlf
		DECLARE @currentDate datetime
		select @currentDate = getDate()
		
		print 'Creating snapshot of AGRD table'+ @crlf
		--create a snapshot of the agrd table
		SET @sqlToRun = 'exec SisDatabase_CreateSnapshot '''+ cast(@rosterYearToimport as varchar(36)) +''',''' + cast(@currentDate as varchar(30))+''',''' + cast( @sisTable_AGRD_GUID as varchar(36))+''',1' + @crlf + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		print 'Creating snapshot of AGRL table'+ @crlf
		--create a snapshot of the agrl table
		SET @sqlToRun = 'exec SisDatabase_CreateSnapshot '''+ cast(@rosterYearToimport as varchar(36)) +''',''' + cast(@currentDate as varchar(30)) +''',''' +  cast(@sisTable_AGRL_GUID as varchar(36)) +''',1' + @crlf + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		
		print 'Creating snapshot of ASTU table'+ @crlf
		--create a snapshot of the astu table
		SET @sqlToRun = 'exec SisDatabase_CreateSnapshot '''+ cast(@rosterYearToimport as varchar(36)) +''',''' + cast(@currentDate as varchar(30)) +''',''' +  cast(@sisTable_ASTU_GUID as varchar(36))+''',1' + @crlf + @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		
		print 'Creating snapshot of AMST table'+ @crlf
		--create a snapshot of the amst table
		SET @sqlToRun = 'exec SisDatabase_CreateSnapshot '''+ cast(@rosterYearToimport as varchar(36)) +''',''' + cast(@currentDate as varchar(30)) +''',''' +  cast(@sisTable_AMST_GUID as varchar(36))+''',1' + @crlf	 + @crlf	
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred


		print 'Creating snapshot of AGDF table'+ @crlf
		--create a snapshot of the agdf table
		SET @sqlToRun = 'exec SisDatabase_CreateSnapshot '''+ cast(@rosterYearToimport as varchar(36)) +''',''' + cast(@currentDate as varchar(30)) +''',''' +  cast(@sisTable_AGDF_GUID as varchar(36))+''',1' + @crlf + @crlf	
		if(@importAGDF = 1)
		BEGIN
			exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
			if @err <> 0  
				GOTO ErrorOccurred
		END
	END
	
	IF (@executionLevel IN (2,4))
	BEGIN
		print 'truncating agrl_dn'
		SET @sqlToRun ='truncate table agrl_dn'
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred

		--import data into the AGRL_DN table, puts AGRL and AGRD data together, reduces time to run RCS import
		-- TimeToComplete( transform_AGRL_DN) + TimeToComplete( transform_ReportCardScore) 
		-- < TimeToComplete( transform_ReportCardScoreWithoutPriorAGRL_DN_Transform)
		print 'Inserting into AGRL_DN'+ @crlf
		/*	
		SET @sqlToRun = 
		'INSERT AGRL_DN (ClassLink, MarkNum, StuLink, SchoolNum, Mark)
		SELECT s.ClassLink, s.MarkNum, s.StuLink, s.SchoolNum, s.Mark
		FROM SASI_Transform_AGRL_DN s 
		WHERE s.Mark IS NOT NULL'+ @crlf
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred
		*/
		SET @SqlToRun=
		'INSERT AGRL_DN (ClassLink, MarkNum, StuLink, SchoolNum, Mark)
		Select a.ClassLink, a.MarkNum, a.StuLink,  a.SchoolNum,	agrl.Mark
		from
		(
			select
				agrl.StuLink,
				agrl.MarkNum,
				agrl.SchoolNum,
				agrd.ClassLink,			
				Sequence = max(agrl.Sequence)
			FROM				
				Sasi_AGRL_NEW agrl join
				Sasi_AGRD_NEW agrd on agrl.StuLink = agrd.StuLink and agrl.SchoolNum = agrd.SchoolNum and agrl.Sequence = agrd.Sequence		
			GROUP BY
				agrl.StuLink, agrl.MarkNum, agrl.SchoolNum, agrd.ClassLink
		) a join
		Sasi_AGRL_NEW agrl on a.StuLink = agrl.StuLink and a.MarkNum = agrl.MarkNum and a.Sequence = agrl.Sequence and a.SchoolNum = agrl.SchoolNum
		WHERE
				agrl.Mark is not null'
		exec @err = RunSql @sqlToRun,	@executeSql, @printSQL
		if @err <> 0 
			GOTO ErrorOccurred
	END
	
	IF (@executionLevel IN (3,4))
	BEGIN
		if @executeSql = 1
		BEGIN		
			DECLARE @rciMapping table(schoolnum varchar(4), marknum int, reportCardItem uniqueidentifier)		
		
			declare @schoolnum as varchar(3)

			declare tables_cursor cursor for 
			select distinct SchoolNum from Sasi_AGDF_NEW			
			
			open tables_cursor 
			FETCH NEXT FROM tables_cursor 
			INTO @schoolnum

			WHILE @@FETCH_STATUS = 0
			BEGIN
				--automatically creates an RCT for a school if no RCT exists yet for school
				IF NOT EXISTS( select * From sasi_map_ReportCardType where Schoolnum = @schoolnum AND RosterYear = @rosterYearToimport)
				BEGIN
					DECLARE @newRCTGuid uniqueidentifier
					SET @newRCTGuid = newID()
					DECLARE @rctName varchar(200)
					
					DECLARE @SchoolName varchar(100)
					DECLARE @year varchar(30)
					
					SELECT @year = cast( startYear as varchar(4)) + '-' + cast( startYear + 1 as varchar(4))
					from
						RosterYear 
					WHERE
						ID =  @rosterYearToimport					
						
					SELECT @SchoolName = Name 
					from 
						sasi_map_SchoolID ms join
						School sch on ms.DestId = sch.ID
					where 
						ms.Schoolnum = @schoolnum 										
						
					SET @rctName = @SchoolName + ' - ' + @year
					
					insert into ReportCardType values (@newRCTGuid, @rctName)
					--insert into sasi_map_ReportCardType values (@schoolnum, @rosterYearToimport, @newRCTGuid)					
				
					declare @validMarkNumList table(marknum int)
					
					INSERT INTO @validMarkNumList
					SELECT
						distinct MarkNum
					FROM 
						agrl_dn
					WHERE 
						schoolNum = @schoolnum	

					--the current number of marknums set for this school in AGRL
					declare @rctCurrentForSchool int				
					SELECT 
						@rctCurrentForSchool = MAX(MarkNum)  
					FROM 
						@validMarkNumList vml
						
					DECLARE @itemName varchar(10)
					SET @itemName = ''
					
					DECLARE @RCI_MarkNum int
					SET @RCI_MarkNum = 0
									

					print 'Creating new RCI''s for RCT: ' + @rctName + @crlf
					WHILE @RCI_MarkNum <= @rctCurrentForSchool
					BEGIN	
						--although highly unlikely, there exists the possibility that a school will not have a marknum that is defined, between other marknums which are defined, those should be skipped
						if( @RCI_MarkNum IN (select MarkNum from @validMarkNumList))
						BEGIN
							DECLARE @markString varchar(8000)
							DECLARE @newRCIGuid uniqueidentifier
							SET @newRCIGuid = newID()
							SELECT
								 @markString = isNull(MARKS$0101 + space(254 - len(MARKS$0101)),'') + isNull(MARKS$0102 + space(254 - len(MARKS$0102)),'') + isNull(MARKS$0103 + space(254 - len(MARKS$0103)),'') + isNull(MARKS$0104 + space(254 - len(MARKS$0104)),'') + isNull(MARKS$0105 + space(254 - len(MARKS$0105)),'') + isNull(MARKS$0106 + space(53 - len(MARKS$0106)),'')
							FROM
								sasi_agdf_new 
							where 
								schoolnum = @schoolnum

							SET @itemName = dbo.ParseMarkNum(@markString,  @RCI_MarkNum)

						
							insert into ReportCardItem VALUES (
								@newRCIGuid, 
								@newRCTGuid,
								@itemName, 
								Replace(@itemName,' ',''), 
								@RCI_MarkNum, 
								dbo.IsMarknumFinal(@markString, @RCI_MarkNum )
							)
		
							INSERT INTO @rciMapping VALUES (
								@schoolnum,
								@RCI_MarkNum,
								@newRCIGuid
							)
						END

						SET @RCI_MarkNum = @RCI_MarkNum + 1
					END
				END
						
				FETCH NEXT FROM tables_cursor 
				INTO @schoolnum
			END
						
			close tables_cursor 
			deallocate tables_cursor 

			print 'Inserting values into ReportCardScore table'+ @crlf	
			
			INSERT ReportCardScore (ID, ReportCardItem, Student, ClassRoster, PercentageScore, LetterScore)
			SELECT 
					ID = newId(),
					ReportCardItem	= mappings.reportCardItem,
					Student = stu.ID,
					ClassRoster = cr.ID,
					PercentageScore = CASE 
								WHEN ( isNumeric(agrl.Mark) = 1) AND agrl.Mark LIKE '%[0-9]%'--when its a number, make it an int
								then cast( agrl.Mark as float )
								ELSE null--when its not a number leave it blank and let LetterScore pick it up					 
							  END,	
					LetterScore =	CASE 
							   WHEN ( (isNumeric(agrl.Mark) = 0) AND (LEN(agrl.Mark) > 0))--when its a number, make it an int
								then agrl.Mark
							   ELSE null--its either a number of its not, this is unreachable			 
							END
				FROM
					AGRL_DN agrl join 
					Sasi_ASTU_NEW astu on astu.StuLink = agrl.StuLink and astu.SchoolNum = agrl.SchoolNum join
					Student stu on stu.Number = astu.PermNum join
					SASI_Map_SchoolID ms on ms.SchoolNum = agrl.SchoolNum join 
					Sasi_AMST_NEW amst on amst.SchoolNum = agrl.SchoolNum and amst.Classlink = agrl.CLassLink join
					ClassRoster cr on cr.SchoolID = ms.DestID and cr.SectionName = amst.SectionID and cr.RosterYearID = @rosterYearToimport join
					StudentClassRosterHistory scrh on scrh.StudentId = stu.ID and ClassRosterID = cr.ID join
					@rciMapping mappings on mappings.Schoolnum = agrl.Schoolnum and mappings.MarkNum = agrl.MarkNum
		END
		
		IF (@printSql = 1 ) AND  (@executeSql = 0)--if just print mode, otherwise don't print or else message are already outputted
		BEGIN 
			print 'Emptying Sasi_Map_ReportCardItem table (this needs to be regenerated for each year)'+ @crlf
			print 'populating sasi_Map_ReportCardItem tables'+ @crlf
			print 'Inserting values into ReportCardScore table'+ @crlf			
		END
	END



--cleanup tables, that would ordinarily be committed
DELETE FROM SisTable where sisDatabaseID = @sisGUID
DELETE FROM SisDatabase where ID = @sisGUID
		
--COMMIT TRAN
RETURN 0

ErrorOccurred:
--	rollback tran

