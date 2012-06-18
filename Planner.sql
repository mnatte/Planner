USE [Planner]
GO
/****** Object:  Table [dbo].[ReleaseResources]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReleaseResources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseId] [int] NULL,
	[ProjectId] [int] NULL,
	[PersonId] [int] NULL,
	[FocusFactor] [decimal](12, 2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReleaseProjects]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReleaseProjects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PhaseId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Projects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Description] [text] NULL,
	[ContactPersonId] [int] NULL,
	[TfsIterationPath] [nvarchar](250) NULL,
	[TfsDevBranch] [nvarchar](250) NULL,
	[ShortName] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phases]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Phases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Title] [varchar](150) NULL,
	[Description] [varchar](500) NULL,
	[ParentId] [int] NULL,
	[Type] [varchar](50) NULL,
	[CompanyId] [int] NULL,
	[TfsIterationPath] [varchar](300) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Persons]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Persons](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[FunctionId] [int] NULL,
	[Email] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[Initials] [varchar](10) NULL,
	[HoursPerWeek] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Features]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Features](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NULL,
	[ContactPersonId] [int] NULL,
	[State] [nvarchar](150) NULL,
	[StoryPoints] [int] NULL,
	[Title] [nvarchar](500) NULL,
	[BusinessId] [int] NULL,
	[TfsId] [int] NULL,
	[PlannedReleaseId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Absences]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Absences](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](500) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PersonId] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AbsenceImport]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AbsenceImport](
	[ImportId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](500) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TfsImport]    Script Date: 06/18/2012 20:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TfsImport](
	[ImportId] [int] IDENTITY(1,1) NOT NULL,
	[TfsId] [int] NULL,
	[BusinessId] [int] NULL,
	[Title] [varchar](500) NULL,
	[StoryPoints] [int] NULL,
	[ContactPerson] [varchar](50) NULL,
	[WorkRemaining] [int] NULL,
	[State] [varchar](50) NULL,
	[IterationPath] [varchar](250) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_release]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_release]
@Id int, 
@Title varchar(100),
@Descr varchar(250),
@StartDate datetime,
@EndDate datetime,
@IterationPath varchar(300),
@ParentId int
AS

UPDATE Phases set StartDate=@StartDate, EndDate=@EndDate, Title=@Title, [Description]=@Descr, [Type]='Release', ParentId=@ParentId, TfsIterationPath=@IterationPath where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Phases(StartDate, EndDate, Title, [Description], [Type], ParentId, TfsIterationPath) 
	VALUES(@StartDate, @EndDate, @Title, @Descr, 'Release', @ParentId, @IterationPath)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_project]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_project]
@Id int, 
@Title varchar(100),
@Descr varchar(250),
@ContactPersonId int,
@IterationPath varchar(300),
@TfsDevBranch varchar(300),
@ShortName varchar(10)
AS

UPDATE Projects set ContactPersonId=@ContactPersonId, TfsDevBranch=@TfsDevBranch, Title=@Title, [Description]=@Descr, TfsIterationPath=@IterationPath, ShortName = @ShortName where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Projects(ContactPersonId, TfsDevBranch, Title, [Description], TfsIterationPath, ShortName) 
	VALUES(@ContactPersonId, @TfsDevBranch, @Title, @Descr, @IterationPath, @ShortName)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_person]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_person]
@Id int, 
@FirstName varchar(100),
@MiddleName varchar(20),
@LastName varchar(100),
@Initials varchar(10),
@FunctionId int,
@Email varchar(300),
@CompanyId int,
@PhoneNumber varchar(20),
@HoursPerWeek int
AS

UPDATE Persons set FirstName=@FirstName, MiddleName=@MiddleName, LastName=@LastName, Initials=@Initials, 
	FunctionId=@FunctionId, Email = @Email, CompanyId = @CompanyId, PhoneNumber = @PhoneNumber, HoursPerWeek = @HoursPerWeek where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Persons(FirstName, MiddleName, LastName, Initials, FunctionId, Email, CompanyId, PhoneNumber, HoursPerWeek) 
	VALUES(@FirstName, @MiddleName, @LastName, @Initials, @FunctionId, @Email, @CompanyId, @PhoneNumber, @HoursPerWeek)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_loadAbsenceTable]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_loadAbsenceTable]
AS
TRUNCATE TABLE Absences

INSERT INTO Absences(PersonId, Title, StartDate, EndDate)  
select
	case 
		when title like '%Arno%' then 1
		when title like '%Twan%' then 2
		when title like '%MSC%' then 3
		when title like '%JP%' then 4
		when title like '%Tanvir%' then 6
		when title like '%Clint%' then 7
		when title like '%Roland%' then 9
		when title like '%Martijn R%' then 10
		when title like '%Kris%' or title like '%KK%' then 11
		when title like '%Reinier%' then 12
		when title like '%Johan%' then 13
		when title like '%Martijn van der M%' then 14
		when title like '%Martijn N%' then 15
		when title like '%Andreas%' then 16
		--when title like '%Robert%' then 16
		--when title like '%Berrie%' then 16
	else 0 end as PersonId,
	Title,
	StartTime,
	EndTime
from
	[AbsenceImport]
where
	starttime > '29 Feb 2012'
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_resource_assignment]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_resource_assignment]
	@Id int,
	@ReleaseId int,
	@ProjectId int,
	@PersonId int,
	@FocusFactor decimal(12,2)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    INSERT INTO ReleaseResources(ReleaseId, ProjectId, PersonId, FocusFactor) VALUES(@ReleaseId, @ProjectId, @PersonId, @FocusFactor)
    
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_releaseproject]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_releaseproject]
	-- Add the parameters for the stored procedure here
	@ReleaseId int,
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO ReleaseProjects(PhaseId, ProjectId) VALUES(@ReleaseId, @ProjectId)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_resources]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_release_resources]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, rr.projectid, pr.title as projecttitle, rr.FocusFactor
	FROM ReleaseResources rr INNER JOIN Persons p on rr.PersonId = p.Id INNER JOIN Phases r on rr.ReleaseId = r.Id INNER JOIN Projects pr on rr.ProjectId = pr.Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_resource]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_release_resource]
@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, rr.projectid, pr.title as projecttitle, rr.FocusFactor
	FROM ReleaseResources rr INNER JOIN Persons p on rr.PersonId = p.Id INNER JOIN Phases r on rr.ReleaseId = r.Id INNER JOIN Projects pr on rr.ProjectId = pr.Id
	WHERE rr.Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_assignments]    Script Date: 06/18/2012 20:49:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_assignments]
@PhaseId int,
@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, rr.projectid, pr.title as projecttitle, rr.FocusFactor
	FROM ReleaseResources rr INNER JOIN Persons p on rr.PersonId = p.Id INNER JOIN Phases r on rr.ReleaseId = r.Id INNER JOIN Projects pr on rr.ProjectId = pr.Id
	WHERE rr.ReleaseId = @PhaseId AND rr.ProjectId = @ProjectId
END
GO
