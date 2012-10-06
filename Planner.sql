USE [master]
GO
/****** Object:  Database [Planner]    Script Date: 10/06/2012 16:52:05 ******/
CREATE DATABASE [Planner] ON  PRIMARY 
( NAME = N'Planner', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLENTERPRISE\MSSQL\DATA\Planner.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Planner_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLENTERPRISE\MSSQL\DATA\Planner_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Planner] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Planner].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Planner] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [Planner] SET ANSI_NULLS OFF
GO
ALTER DATABASE [Planner] SET ANSI_PADDING OFF
GO
ALTER DATABASE [Planner] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [Planner] SET ARITHABORT OFF
GO
ALTER DATABASE [Planner] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [Planner] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [Planner] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [Planner] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [Planner] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [Planner] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [Planner] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [Planner] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [Planner] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [Planner] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [Planner] SET  DISABLE_BROKER
GO
ALTER DATABASE [Planner] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [Planner] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [Planner] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [Planner] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [Planner] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [Planner] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [Planner] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Planner] SET  READ_WRITE
GO
ALTER DATABASE [Planner] SET RECOVERY FULL
GO
ALTER DATABASE [Planner] SET  MULTI_USER
GO
ALTER DATABASE [Planner] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [Planner] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'Planner', N'ON'
GO
USE [Planner]
GO
/****** Object:  User [IIS APPPOOL\ASP.NET v4.0]    Script Date: 10/06/2012 16:52:05 ******/
CREATE USER [IIS APPPOOL\ASP.NET v4.0] FOR LOGIN [IIS APPPOOL\ASP.NET v4.0]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 10/06/2012 16:52:06 ******/
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
	[ShortName] [nvarchar](10) NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phases]    Script Date: 10/06/2012 16:52:06 ******/
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
	[TfsIterationPath] [varchar](300) NULL,
 CONSTRAINT [PK_Phases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Persons]    Script Date: 10/06/2012 16:52:06 ******/
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
	[HoursPerWeek] [int] NULL,
 CONSTRAINT [PK_Persons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Activities]    Script Date: 10/06/2012 16:52:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Activities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NULL,
	[Description] [varchar](500) NULL,
 CONSTRAINT [PK_Activities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Features]    Script Date: 10/06/2012 16:52:06 ******/
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
/****** Object:  Table [dbo].[Deliverables]    Script Date: 10/06/2012 16:52:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Deliverables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[Format] [varchar](50) NULL,
	[Location] [varchar](250) NULL,
 CONSTRAINT [PK_Deliverables] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AbsenceImport]    Script Date: 10/06/2012 16:52:06 ******/
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
/****** Object:  Table [dbo].[TfsImport]    Script Date: 10/06/2012 16:52:06 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_upsert_deliverable]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_deliverable]
@Id int, 
@Title varchar(50),
@Description varchar(250),
@Format varchar(50),
@Location varchar(150)
AS

UPDATE Deliverables set Title=@Title, [Description]=@Description, Format=@Format, Location=@Location where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Deliverables(Title, [Description], Format, Location) 
	VALUES(@Title, @Description, @Format, @Location)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_activity]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_activity]
@Id int, 
@Title varchar(50),
@Description varchar(250)
AS

UPDATE Activities set Title=@Title, [Description]=@Description where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Activities(Title, [Description]) 
	VALUES(@Title, @Description)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  Table [dbo].[xxx_PhaseMilestones]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xxx_PhaseMilestones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PhaseId] [int] NULL,
	[MilestoneId] [int] NULL,
	[Date] [datetime] NULL,
	[Time] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_release]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_upsert_project]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_upsert_person]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  Table [dbo].[ReleaseProjects]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  Table [dbo].[Milestones]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Milestones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Description] [varchar](250) NULL,
	[Date] [datetime] NULL,
	[Time] [varchar](10) NULL,
	[PhaseId] [int] NOT NULL,
 CONSTRAINT [PK_Milestones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DeliverableActivities]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliverableActivities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliverableId] [int] NULL,
	[ActivityId] [int] NULL,
 CONSTRAINT [PK_DeliverableActivities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Absences]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  Table [dbo].[MilestoneStatus]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MilestoneStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MilestoneId] [int] NULL,
	[DeliverableId] [int] NULL,
	[ActivityId] [int] NULL,
	[HoursRemaining] [int] NULL,
	[InitialEstimate] [int] NULL,
	[ReleaseId] [int] NULL,
	[ProjectId] [int] NULL,
 CONSTRAINT [PK_MilestoneStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MilestoneDeliverables]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MilestoneDeliverables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MilestoneId] [int] NULL,
	[DeliverableId] [int] NULL,
	[xxx_InitialEstimate] [int] NULL,
	[xxx_HoursRemaining] [int] NULL,
	[xxx_State] [varchar](50) NULL,
	[xxx_Owner] [varchar](150) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReleaseResources]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseResources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseId] [int] NULL,
	[ProjectId] [int] NULL,
	[PersonId] [int] NULL,
	[FocusFactor] [decimal](12, 2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Activity] [varchar](100) NULL,
	[xxx_MilestoneDeliverableId] [int] NULL,
	[ActivityId] [int] NULL,
	[MilestoneId] [int] NULL,
	[DeliverableId] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_get_phase_milestones]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_phase_milestones]
@PhaseId int
AS
--Select 
	--pm.MilestoneId, pm.PhaseId, m.Title, pm.[Date], m.[Description], pm.[Time] 
--from PhaseMilestones pm inner join Milestones m on pm.MilestoneId = m.Id 
--where pm.PhaseId = @PhaseId
SELECT 
	Id as MilestoneId, PhaseId, [Title], [Date], [Description], [Time]
FROM
	Milestones
WHERE
	PhaseId = @PhaseId
GO
/****** Object:  StoredProcedure [dbo].[sp_get_person_absences]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_person_absences]
	@ResourceId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		a.personid, p.FirstName, p.MiddleName, p.LastName, p.HoursPerWeek, a.Title, a.StartDate, a.EndDate
	FROM
		Absences a
		INNER JOIN Persons p on a.PersonId = p.Id
	WHERE
		a.PersonId = @ResourceId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_milestone_by_id]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_milestone_by_id]
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id as MilestoneId, Title, Date, Time, Description, PhaseId FROM Milestones WHERE Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_deliverableactivity]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_deliverableactivity]
	-- Add the parameters for the stored procedure here
	@DeliverableId int,
	@ActivityId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO DeliverableActivities(DeliverableId, ActivityId) 
	VALUES(@DeliverableId, @ActivityId)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_milestone]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_milestone]
@Id int, 
@Title varchar(100),
@Description varchar(250),
@Date datetime,
@Time varchar(20),
@PhaseId int
AS

DECLARE @NewId int
--DECLARE @Exists int
--DECLARE @Assigned int
SET @NewId = 0

--update title and description for Milestone
UPDATE Milestones set Title=@Title, [Description]=@Description, [Date]=@Date, [Time] = @Time where ID=@Id
IF @@ROWCOUNT = 0
BEGIN
	--SET @Exists = 0
--	SET @Assigned = 0
	INSERT INTO Milestones(Title, [Date], [Time], [Description], PhaseId) 
	VALUES(@Title, @Date, @Time, @Description, @PhaseId)
	
	SET @NewId = SCOPE_IDENTITY()
END

SELECT @NewId
--ELSE
	--SET @Exists = 1

-- update date and time for Milestone (assignment)	
--UPDATE PhaseMilestones set [Date]=@Date, [Time] = @Time where PhaseID=@PhaseId AND MilestoneId = @Id
--IF @@ROWCOUNT = 0
--BEGIN
--	SET @Assigned = 0
--END
--ELSE
--	SET @Assigned = 1

--IF @Exists = 0
--BEGIN
--	INSERT INTO Milestones(Title, [Date], [Time], [Description], PhaseId) 
--	VALUES(@Title, @Date, @Time, @Description, @PhaseId)
	
--	SET @NewId = SCOPE_IDENTITY()
	--SET @Exists = 1
--END

---IF @Assigned = 0	
--	INSERT INTO PhaseMilestones(PhaseId, MilestoneId, [Date], [Time])
--	VALUES(@PhaseId, @NewId, @Date, @Time)
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_releaseproject]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_loadAbsenceTable]    Script Date: 10/06/2012 16:52:13 ******/
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
		when title like '%Robert%' then 18
		when title like '%Berrie%' then 19
		when title like '%Michael%' then 28
		when title like '%Wim%' then 30
	else 0 end as PersonId,
	Title,
	StartTime,
	EndTime
from
	[AbsenceImport]
where
	starttime > '29 Feb 2012'
GO
/****** Object:  StoredProcedure [dbo].[get_activities_for_deliverable]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_activities_for_deliverable]
	@DeliverableId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		a.Title, a.Id, a.[Description]
	FROM
		DeliverableActivities da
		INNER JOIN Activities a ON da.ActivityId = a.Id
	WHERE
		da.DeliverableId = @DeliverableId
END
GO
/****** Object:  StoredProcedure [dbo].[xxx_sp_get_release_deliverable_assignments]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[xxx_sp_get_release_deliverable_assignments]
	@PhaseId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, 
		rr.projectid, rr.StartDate, rr.EndDate, pr.title as projecttitle, rr.FocusFactor,-- rr.Activity,
		md.Id as MilestoneDeliverableId, isnull(m.Id, 0) as MilestoneId, m.[Date] as MilestoneDate, m.Title as MilestoneTitle,
		isnull(d.Id, 0) as DeliverableId, d.Title as DeliverableTitle, d.[Description] as DeliverableDescription,
		isnull(a.Id, 0) as ActivityId, a.Title as ActivityTitle, a.[Description] as ActivityDescription
	FROM 
		ReleaseResources rr 
		INNER JOIN Persons p on rr.PersonId = p.Id 
		INNER JOIN Phases r on rr.ReleaseId = r.Id 
		INNER JOIN Projects pr on rr.ProjectId = pr.Id
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneId = md.MilestoneId AND rr.DeliverableId = md.DeliverableId
		LEFT JOIN Milestones m on md.MilestoneId = m.Id
		LEFT JOIN Deliverables d on md.DeliverableId = d.Id
		LEFT JOIN Activities a on rr.ActivityId = a.Id
	WHERE 
		rr.ReleaseId = @PhaseId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_unassign_milestone_from_release]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unassign_milestone_from_release]
	@ReleaseId int,
	@MilestoneId int
AS
BEGIN
	DECLARE @Returns BIT      
	SET @Returns = 1
	BEGIN
		TRY  
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;
			
			BEGIN TRANSACTION 

			DELETE FROM MilestoneStatus WHERE ReleaseId = @ReleaseId AND MilestoneId = @MilestoneId
	    
			DELETE FROM PhaseMilestones where PhaseId = @ReleaseId AND MilestoneId = @MilestoneId
	    
			COMMIT 
		END TRY 
		BEGIN CATCH   
		   SET @Returns = 0      
		   -- Any Error Occurred during Transaction. Rollback     
		   IF @@TRANCOUNT > 0       
			   ROLLBACK  -- Roll back 
		END CATCH

	RETURN @Returns
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_resource_assignment]    Script Date: 10/06/2012 16:52:13 ******/
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
	@MilestoneId int,
	@DeliverableId int,
	@FocusFactor decimal(12,2),
	@StartDate datetime,
	@EndDate datetime,
	@ActivityId int
AS
BEGIN
	declare @MilestoneDeliverableId int;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @MilestoneDeliverableId = (SELECT TOP 1 Id FROM MilestoneDeliverables WHERE MilestoneId = @MilestoneId AND DeliverableId = @DeliverableId)
	
    INSERT INTO ReleaseResources(ReleaseId, ProjectId, PersonId, FocusFactor, StartDate, EndDate, ActivityId, MilestoneDeliverableId) 
		VALUES(@ReleaseId, @ProjectId, @PersonId, @FocusFactor, @StartDate, @EndDate, @ActivityId, @MilestoneDeliverableId)
    
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_milestonestatus]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_milestonestatus]
	@ReleaseId int,
	@ProjectId int,
	@MilestoneId int,
	@DeliverableId int,
	@ActivityId int,
	@HoursRemaining int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--DELETE FROM MilestoneStatus WHERE ReleaseId = @ReleaseId AND ProjectId = @ProjectId AND DeliverableId = @DeliverableId

    INSERT INTO MilestoneStatus(ReleaseId, ProjectId, MilestoneId, DeliverableId, ActivityId, HoursRemaining)
    VALUES(@ReleaseId, @ProjectId, @MilestoneId, @DeliverableId, @ActivityId, @HoursRemaining)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_milestonedeliverable]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_milestonedeliverable]
	-- Add the parameters for the stored procedure here
	@MilestoneId int,
	@DeliverableId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO MilestoneDeliverables(MilestoneId, DeliverableId) 
	VALUES(@MilestoneId, @DeliverableId)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_resource_assignments]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_resource_assignments]
@ResourceId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, 
		r.title as phasetitle, rr.projectid, pr.title as projecttitle, rr.FocusFactor, rr.EndDate, rr.StartDate, -- rr.Activity,
		md.Id as MilestoneDeliverableId, isnull(m.Id, 0) as MilestoneId, m.[Date] as MilestoneDate, m.Title as MilestoneTitle,
		isnull(d.Id, 0) as DeliverableId, d.Title as DeliverableTitle, d.[Description] as DeliverableDescription,
		isnull(a.Id, 0) as ActivityId, a.Title as ActivityTitle, a.[Description] as ActivityDescription
	FROM 
		ReleaseResources rr 
		INNER JOIN Persons p on rr.PersonId = p.Id 
		INNER JOIN Phases r on rr.ReleaseId = r.Id 
		INNER JOIN Projects pr on rr.ProjectId = pr.Id
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneDeliverableId = md.Id
		LEFT JOIN Milestones m on md.MilestoneId = m.Id
		LEFT JOIN Deliverables d on md.DeliverableId = d.Id
		LEFT JOIN Activities a on rr.ActivityId = a.Id
	WHERE 
		rr.personId = @ResourceId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_resources]    Script Date: 10/06/2012 16:52:13 ******/
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

	SELECT rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, rr.projectid, pr.title as projecttitle, rr.FocusFactor, rr.Activity
	FROM 
		ReleaseResources rr 
	INNER JOIN Persons p on rr.PersonId = p.Id 
	INNER JOIN Phases r on rr.ReleaseId = r.Id 
	INNER JOIN Projects pr on rr.ProjectId = pr.Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_resource]    Script Date: 10/06/2012 16:52:13 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_deliverables_for_milestone]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_deliverables_for_milestone]
	-- Add the parameters for the stored procedure here
	@MilestoneId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		md.DeliverableId, --md.InitialEstimate, md.HoursRemaining, md.[Owner], md.[State],
		d.[Description], d.Format, d.Location, d.Title
	FROM
		MilestoneDeliverables md
		INNER JOIN Deliverables d on md.DeliverableId = d.Id
	WHERE
		md.MilestoneId = @MilestoneId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_deliverable_status]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_deliverable_status]
@ReleaseId int,
@MilestoneId int,
@DeliverableId int,
@ProjectId int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		ms.HoursRemaining, ms.InitialEstimate,
		p.Title as ReleaseTitle, pr.Title as ProjectTitle, m.Title as MilestoneTitle, m.Date as MilestoneDate, 
		d.Title as DeliverableTitle, a.Title as ActivityTitle, a.Id as ActivityId, a.Description as ActivityDescription
	FROM
		MilestoneStatus ms
		INNER JOIN Phases p on ms.ReleaseId = p.Id
		INNER JOIN Projects pr on ms.ProjectId = pr.Id
		INNER JOIN Milestones m on ms.MilestoneId = m.Id
		INNER JOIN Deliverables d on ms.DeliverableId = d.Id
		INNER JOIN DeliverableActivities da on ms.DeliverableId = da.DeliverableId AND ms.ActivityId = da.ActivityId
		INNER JOIN Activities a on da.ActivityId = a.Id
	WHERE
		ms.ReleaseId = @ReleaseId
		AND ms.MilestoneId = @MilestoneId
		AND ms.DeliverableId = @DeliverableId
		AND ms.ProjectId = @ProjectId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_assignments]    Script Date: 10/06/2012 16:52:13 ******/
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

	SELECT 
		rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, 
		rr.projectid, rr.StartDate, rr.EndDate, pr.title as projecttitle, rr.FocusFactor,-- rr.Activity,
		md.Id as MilestoneDeliverableId, isnull(m.Id, 0) as MilestoneId, m.[Date] as MilestoneDate, m.Title as MilestoneTitle,
		isnull(d.Id, 0) as DeliverableId, d.Title as DeliverableTitle, d.[Description] as DeliverableDescription,
		isnull(a.Id, 0) as ActivityId, a.Title as ActivityTitle, a.[Description] as ActivityDescription
	FROM 
		ReleaseResources rr 
		INNER JOIN Persons p on rr.PersonId = p.Id 
		INNER JOIN Phases r on rr.ReleaseId = r.Id 
		INNER JOIN Projects pr on rr.ProjectId = pr.Id
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneDeliverableId = md.Id
		LEFT JOIN Milestones m on md.MilestoneId = m.Id
		LEFT JOIN Deliverables d on md.DeliverableId = d.Id
		LEFT JOIN Activities a on rr.ActivityId = a.Id
	WHERE 
		rr.ReleaseId = @PhaseId AND rr.ProjectId = @ProjectId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_release]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_release]
	@ReleaseId int
AS
BEGIN
	DECLARE @Returns BIT      
	SET @Returns = 1
	BEGIN
		TRY  
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;
			
			BEGIN TRANSACTION 

			DELETE FROM MilestoneStatus WHERE ReleaseId = @ReleaseId
	    
			DELETE FROM PhaseMilestones WHERE PhaseId = @ReleaseId
	    
			DELETE FROM Phases WHERE ParentId = @ReleaseId
	    
			DELETE FROM ReleaseProjects WHERE PhaseId = @ReleaseId
	    
			DELETE FROM ReleaseResources WHERE ReleaseId = @ReleaseId
	    
			DELETE FROM Phases WHERE Id = @ReleaseId

			COMMIT 
		END TRY 
		BEGIN CATCH   
		   SET @Returns = 0      
		   -- Any Error Occurred during Transaction. Rollback     
		   IF @@TRANCOUNT > 0       
			   ROLLBACK  -- Roll back 
		END CATCH

	RETURN @Returns
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_person]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_person]
	@PersonId int
AS
BEGIN
	DECLARE @Returns BIT      
	SET @Returns = 1
	BEGIN
		TRY  
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;
			
			BEGIN TRANSACTION 

			DELETE FROM Absences WHERE PersonId = @PersonId
	    
			DELETE FROM ReleaseResources WHERE PersonId = @PersonId
	    
			DELETE FROM Persons WHERE Id = @PersonId

			COMMIT 
		END TRY 
		BEGIN CATCH   
		   SET @Returns = 0      
		   -- Any Error Occurred during Transaction. Rollback     
		   IF @@TRANCOUNT > 0       
			   ROLLBACK  -- Roll back 
		END CATCH

	RETURN @Returns
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_milestone]    Script Date: 10/06/2012 16:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_milestone]
	@MilestoneId int
AS
BEGIN
	DECLARE @Returns BIT      
	SET @Returns = 1
	BEGIN
		TRY  
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;
			
			BEGIN TRANSACTION 

			DELETE FROM MilestoneDeliverables WHERE MilestoneId = @MilestoneId

			DELETE FROM MilestoneStatus WHERE MilestoneId = @MilestoneId

			DELETE FROM PhaseMilestones WHERE MilestoneId = @MilestoneId

			DELETE FROM ReleaseResources WHERE MilestoneId = @MilestoneId

			DELETE FROM Milestones WHERE Id = @MilestoneId

			COMMIT 
		END TRY 
		BEGIN CATCH   
		   SET @Returns = 0      
		   -- Any Error Occurred during Transaction. Rollback     
		   IF @@TRANCOUNT > 0       
			   ROLLBACK  -- Roll back 
		END CATCH

	RETURN @Returns
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_activity]    Script Date: 10/06/2012 16:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_activity]
	@ActivityId int
AS
BEGIN
	DECLARE @Returns BIT      
	SET @Returns = 1
	BEGIN
		TRY  
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;
			
			BEGIN TRANSACTION 

			DELETE FROM ReleaseResources WHERE ActivityId = @ActivityId
	    
			DELETE FROM MilestoneStatus WHERE ActivityId = @ActivityId
	    
			DELETE FROM DeliverableActivities WHERE ActivityId = @ActivityId
			
			DELETE FROM Activities WHERE Id = @ActivityId

			COMMIT 
		END TRY 
		BEGIN CATCH   
		   SET @Returns = 0      
		   -- Any Error Occurred during Transaction. Rollback     
		   IF @@TRANCOUNT > 0       
			   ROLLBACK  -- Roll back 
		END CATCH

	RETURN @Returns
END
GO
/****** Object:  StoredProcedure [dbo].[sp_count_milestonestatus_records]    Script Date: 10/06/2012 16:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_count_milestonestatus_records]
	@ReleaseId int,
	@MilestoneId int,
	@DeliverableId int,
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		COUNT(*) 
	FROM 
		MilestoneStatus 
	WHERE 
		ReleaseId = @ReleaseId 
		AND MilestoneId = @MilestoneId 
		AND DeliverableId = @DeliverableId 
		AND ProjectId = @ProjectId
END
GO
/****** Object:  StoredProcedure [dbo].[get_release_deliverable_assignments]    Script Date: 10/06/2012 16:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_release_deliverable_assignments]
	@PhaseId int,
	@ProjectId int,
	@MilestoneId int,
	@DeliverableId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		rr.id, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, r.title as phasetitle, 
		rr.projectid, rr.StartDate, rr.EndDate, pr.title as projecttitle, rr.FocusFactor,-- rr.Activity,
		md.Id as MilestoneDeliverableId, isnull(m.Id, 0) as MilestoneId, m.[Date] as MilestoneDate, m.Title as MilestoneTitle,
		isnull(d.Id, 0) as DeliverableId, d.Title as DeliverableTitle, d.[Description] as DeliverableDescription,
		isnull(a.Id, 0) as ActivityId, a.Title as ActivityTitle, a.[Description] as ActivityDescription
	FROM 
		ReleaseResources rr 
		INNER JOIN Persons p on rr.PersonId = p.Id 
		INNER JOIN Phases r on rr.ReleaseId = r.Id 
		INNER JOIN Projects pr on rr.ProjectId = pr.Id
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneId = md.MilestoneId AND rr.DeliverableId = md.DeliverableId
		LEFT JOIN Milestones m on md.MilestoneId = m.Id
		LEFT JOIN Deliverables d on md.DeliverableId = d.Id
		LEFT JOIN Activities a on rr.ActivityId = a.Id
	WHERE 
		rr.ReleaseId = @PhaseId AND rr.ProjectId = @ProjectId AND m.Id = @MilestoneId AND d.Id = @DeliverableId
END
GO
/****** Object:  ForeignKey [FK_PhaseMilestones_Phases]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[xxx_PhaseMilestones]  WITH CHECK ADD  CONSTRAINT [FK_PhaseMilestones_Phases] FOREIGN KEY([PhaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[xxx_PhaseMilestones] CHECK CONSTRAINT [FK_PhaseMilestones_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseProjects_Phases]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseProjects]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseProjects_Phases] FOREIGN KEY([PhaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[ReleaseProjects] CHECK CONSTRAINT [FK_ReleaseProjects_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseProjects_Projects]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseProjects]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseProjects_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[ReleaseProjects] CHECK CONSTRAINT [FK_ReleaseProjects_Projects]
GO
/****** Object:  ForeignKey [FK_Milestones_Phases]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[Milestones]  WITH CHECK ADD  CONSTRAINT [FK_Milestones_Phases] FOREIGN KEY([PhaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[Milestones] CHECK CONSTRAINT [FK_Milestones_Phases]
GO
/****** Object:  ForeignKey [FK_DeliverableActivities_Activities]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[DeliverableActivities]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableActivities_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[DeliverableActivities] CHECK CONSTRAINT [FK_DeliverableActivities_Activities]
GO
/****** Object:  ForeignKey [FK_DeliverableActivities_Deliverables]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[DeliverableActivities]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableActivities_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[DeliverableActivities] CHECK CONSTRAINT [FK_DeliverableActivities_Deliverables]
GO
/****** Object:  ForeignKey [FK_Absences_Persons]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[Absences]  WITH CHECK ADD  CONSTRAINT [FK_Absences_Persons] FOREIGN KEY([PersonId])
REFERENCES [dbo].[Persons] ([Id])
GO
ALTER TABLE [dbo].[Absences] CHECK CONSTRAINT [FK_Absences_Persons]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Activities]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Activities]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Deliverables]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Deliverables]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Milestones]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Milestones]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Phases]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Phases]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Projects]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Projects]
GO
/****** Object:  ForeignKey [FK_MilestoneDeliverables_Deliverables]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneDeliverables]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneDeliverables_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[MilestoneDeliverables] CHECK CONSTRAINT [FK_MilestoneDeliverables_Deliverables]
GO
/****** Object:  ForeignKey [FK_MilestoneDeliverables_Milestones]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[MilestoneDeliverables]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneDeliverables_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[MilestoneDeliverables] CHECK CONSTRAINT [FK_MilestoneDeliverables_Milestones]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Activities]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Activities]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Deliverables]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Deliverables]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Milestones]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Milestones]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Persons]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Persons] FOREIGN KEY([PersonId])
REFERENCES [dbo].[Persons] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Persons]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Phases]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Projects]    Script Date: 10/06/2012 16:52:13 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Projects]
GO
