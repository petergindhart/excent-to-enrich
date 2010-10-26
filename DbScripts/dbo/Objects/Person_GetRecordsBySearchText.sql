IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'Person_GetRecordsBySearchText'
		AND type = 'P')
	DROP PROCEDURE dbo.Person_GetRecordsBySearchText


IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'UserProfile_GetRecordsBySearchText'
		AND type = 'P')
	DROP PROCEDURE dbo.UserProfile_GetRecordsBySearchText

GO

/*
<summary>
Gets records from the UserProfile table that match the specified search text
</summary>
<param name="searchText">Text to search by</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Person_GetRecordsBySearchText]
	@searchText	varchar(250),
	@onlyUsers bit = 0
AS
	declare @searchTextNormal varchar(250)
	set @searchTextNormal = Replace(Replace(ltrim(rtrim(@searchText)), ',', ' '), '-', ' ')

	-- Tokenize string
	declare @tokens table (Sequence int identity primary key, Raw varchar(100), Cleaned varchar(100))
	insert into @tokens
	select Item, dbo.Clean(Item, '\')
	from dbo.Split(@searchTextNormal, ' ')

	-- build all comibinations of search terms
	declare @searchTerms table (Cleaned varchar(250), Raw varchar(250), Pattern varchar(250), FirstToken int, FirstTokenLen int, TokenCount int)

	insert into @searchTerms
	select
		Cleaned,
		Raw,
		Cleaned + '%',
		Sequence,
		len(Raw),
		1
	from
		@tokens

	declare @tokenCount int

	while @@ROWCOUNT > 0
	begin
		set @tokenCount = isnull(@tokenCount + 1, 1)

		insert into @searchTerms
		select
			st.Cleaned + ' ' + next.Cleaned,
			st.Raw + ' ' + next.Raw,
			st.Pattern + ' ' + next.Cleaned + '%',
			st.FirstToken,
			st.FirstTokenLen,
			st.TokenCount + 1
		from
			@tokens next join
			@searchTerms st on st.FirstToken + st.TokenCount = next.Sequence
		where
			st.TokenCount = @tokenCount
	end

	-- Locate matching records
	-- Look for matching roles
	declare @roleMatches table (ID uniqueidentifier primary key, Weight float)

	insert into @roleMatches
	select
		ID, max(term.TokenCount)
	from 
		PrgResponsibility pr join
		@searchTerms term on
			(term.FirstTokenLen >= len(pr.Name) or (term.FirstTokenLen >= charindex(' ', pr.Name)-1 and pr.Name like '% %')) and pr.Name like term.Cleaned + '%'
	group by
		pr.ID


	declare @hasRoleMatches bit
	set @hasRoleMatches = case when @@ROWCOUNT > 0 then 1 else 0 end


	-- Look for matching schools
	declare @schoolMatches table (ID uniqueidentifier primary key, Weight float)

	insert into @schoolMatches
	select
		ID, max(term.TokenCount)
	from 
		School sch join
		@searchTerms term on
			term.Raw = sch.Abbreviation or
			term.FirstTokenLen >= charindex(' ', sch.Name)-1 and sch.Name like term.Cleaned + '%'
	group by
		sch.ID

	declare @hasSchoolMatches bit
	set @hasSchoolMatches = case when @@ROWCOUNT > 0 then 1 else 0 end


	-- look for matching names
	declare @nameMatches table (ID uniqueidentifier primary key, Weight float, FirstToken int)

	insert into @nameMatches
	select
		ID, sum(term.TokenCount), min(term.FirstToken)
	from 
		Person p join
		@searchTerms term on
			(isnull(FirstName + ' ', '') + ' ' + isnull(LastName, '') like term.Pattern) OR
			(LastName like term.Pattern)
	where
		Deleted is null AND
		(@onlyUsers = 0 or p.TypeID = 'U')
	group by
		p.ID

	declare @hasNameMatches bit
	set @hasNameMatches = case when @@ROWCOUNT > 0 then 1 else 0 end

--	select 
--		nm=(select count(*) from @namematches),
--		sm=(select count(*) from @schoolmatches),
--		rm=(select count(*) from @rolematches)

	-- return results
	-- if no matches, return no rows
	if @hasNameMatches=0 and @hasSchoolMatches=0 and @hasRoleMatches=0
		select top 0 * from UserProfileView
	else
	begin
		declare @return table(ID uniqueidentifier primary key, Terms float, Dimensions float, FirstToken int)
		
		insert into @return
		select
			p.ID,
			isnull(nm.Weight, 0) + isnull(sm.Weight, 0) + isnull(rm.Weight, 0),
			(case when nm.ID is not null then 1 else 0 end) +
			(case when sm.ID is not null then 1 else 0 end) +
			(case when rm.ID is not null then 1 else 0 end),
			nm.FirstToken
		from
			Person p left join
			@nameMatches nm on nm.ID = p.ID left join
			UserProfile u on u.ID = p.ID left join
			@schoolMatches sm on sm.ID = u.SchoolID left join
			@roleMatches rm on rm.ID = u.PrgResponsibilityID
		where
			(nm.ID is not null or @hasNameMatches=0) and
			(sm.ID is not null or @hasSchoolMatches=0) and
			(rm.ID is not null or @hasRoleMatches=0) and 
			(@onlyUsers = 0 or p.TypeID = 'U') and
			p.Deleted IS NULL 

		select top 7
			p.*,
			up.SchoolID, up.RoleID, up.Username, up.PrgResponsibilityID
		from
			@return r join
			Person p on p.ID = r.ID join
			@tokens t on t.Sequence = r.FirstToken left join
			UserProfile up on up.ID = p.ID
		where
			r.Terms = (select max(Terms) from @return)
		order by
			r.Dimensions desc,
			--r.Terms desc,
			case
				when FirstName like t.Cleaned + '%' then 0
				when LastName like t.Cleaned + '%' then 1
				else 2
			end,
			FirstName,
			LastName
			-- IDEA: use case to select the right sort.  Ex: Smith; Tom
	end

GO
/*
insert into Person values (newid(), 'P', null, 'Alex', 'Slice', null)

exec [Person_GetRecordsBySearchText] 'CMS'
exec [Person_GetRecordsBySearchText] 'CES'

exec [Person_GetRecordsBySearchText] 'Math Coach CES'
exec [Person_GetRecordsBySearchText] 'Math Coach'

exec [Person_GetRecordsBySearchText] 'Math Coach Chapin'

exec [Person_GetRecordsBySearchText] 'Math Coach s'
exec [Person_GetRecordsBySearchText] 'Math Coach slice'
exec [Person_GetRecordsBySearchText] 'slice Math Coach'
exec [Person_GetRecordsBySearchText] 'slice'
exec [Person_GetRecordsBySearchText] 'A slice'

exec [Person_GetRecordsBySearchText] 'A slice', 0
exec [Person_GetRecordsBySearchText] 'A slice', 1


exec [Person_GetRecordsBySearchText] 'L Sam'
exec [Person_GetRecordsBySearchText] 'Lin Sa'
exec [Person_GetRecordsBySearchText] 'Lynda Sa'

exec [Person_GetRecordsBySearchText] 'Mar'
exec [Person_GetRecordsBySearchText] 'Mark'
exec [Person_GetRecordsBySearchText] 'Mark L'
exec [Person_GetRecordsBySearchText] 'Mark Lowel'
exec [Person_GetRecordsBySearchText] 'Mark B'
exec [Person_GetRecordsBySearchText] 'Marc B'

exec [Person_GetRecordsBySearchText] 'Mat Math'
exec [Person_GetRecordsBySearchText] 'Mar CES'
exec [Person_GetRecordsBySearchText] 'Mar Chapin Elem'
exec [Person_GetRecordsBySearchText] 'Mar Chapin'
exec [Person_GetRecordsBySearchText] 'Mar Chapin Mid'

exec [Person_GetRecordsBySearchText] 'Matt'
exec [Person_GetRecordsBySearchText] 'Missy Wall Mitc'
exec [Person_GetRecordsBySearchText] 'Miss Mitc'
exec [Person_GetRecordsBySearchText] 'Missy Wall'
exec [Person_GetRecordsBySearchText] 'Missy-Wall'
exec [Person_GetRecordsBySearchText] 'Missy'
exec [Person_GetRecordsBySearchText] 'Missy M'
exec [Person_GetRecordsBySearchText] 'Wall Mitchel'

exec [Person_GetRecordsBySearchText] 'M M'

exec [Person_GetRecordsBySearchText] 'Mi Mi'

exec [Person_GetRecordsBySearchText] 'Missy Wall Mitchell'

exec [Person_GetRecordsBySearchText] 'notfound'



exec [Person_GetRecordsBySearchText] 'Me Ma'
exec [Person_GetRecordsBySearchText] 'Ma Me'

exec [Person_GetRecordsBySearchText] 'Gina ay'
exec [Person_GetRecordsBySearchText] 'Gina'
exec [Person_GetRecordsBySearchText] 'Gina m'

exec [Person_GetRecordsBySearchText] 'Ginna Maes'
exec [Person_GetRecordsBySearchText] 'G m'
exec [Person_GetRecordsBySearchText] 'G m HW'
exec [Person_GetRecordsBySearchText] 'G m HWES'
exec [Person_GetRecordsBySearchText] 'G M Harbison'

exec [Person_GetRecordsBySearchText] 'G M'
exec [Person_GetRecordsBySearchText] 'G M Harbison'
exec [Person_GetRecordsBySearchText] 'G M HWeS'

exec [Person_GetRecordsBySearchText] 'Pa Th'

exec [Person_GetRecordsBySearchText] 'Smith K'


exec [Person_GetRecordsBySearchText] 'XXX'

exec [Person_GetRecordsBySearchText] 'Jo Smith'
exec [Person_GetRecordsBySearchText] 'A Smith'

*/

