IF EXISTS(
	SELECT * 
	FROM SYSOBJECTS 
	WHERE ID = OBJECT_ID('dbo.AnnouncementViewing_InsertRecord') AND
	TYPE = 'P')
DROP PROCEDURE dbo.AnnouncementViewing_InsertRecord
GO

/*
<summary>
Inserts a new record into the AnnouncementViewing table with the specified values
</summary>
<param name="userId">Value to assign to the UserID field of the record</param>
<param name="announcementId">Value to assign to the AnnouncementID field of the record</param>
<param name="dateSeen">Value to assign to the DateSeen field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model returnType="System.Guid" />
*/
CREATE PROCEDURE dbo.AnnouncementViewing_InsertRecord	
	@userId uniqueidentifier, 
	@announcementId varchar(100), 
	@dateSeen datetime,
	@dateDismissed datetime
AS
	DECLARE @id as uniqueidentifier
	
	select @id = id
	from AnnouncementViewing
	where UserID=@userId and AnnouncementId=@AnnouncementId

	if @id is null
	begin
		SET @id = NewID()

		INSERT INTO AnnouncementViewing
		(
			Id, 
			UserId, 
			AnnouncementId, 
			DateSeen,
			DateDismissed
		)
		VALUES
		(
			@id, 
			@userId, 
			@announcementId, 
			@dateSeen,
			@dateDismissed
		)

	end

	SELECT @id
GO

