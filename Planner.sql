USE [master]
GO
/****** Object:  Database [Planner]    Script Date: 01/07/2014 12:02:53 ******/
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
/****** Object:  User [Local Service]    Script Date: 01/07/2014 12:02:53 ******/
CREATE USER [Local Service] FOR LOGIN [NT AUTHORITY\LOCAL SERVICE] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IIS APPPOOL\ASP.NET v4.0]    Script Date: 01/07/2014 12:02:53 ******/
CREATE USER [IIS APPPOOL\ASP.NET v4.0] FOR LOGIN [IIS APPPOOL\ASP.NET v4.0]
GO
/****** Object:  Schema [cfg]    Script Date: 01/07/2014 12:02:53 ******/
CREATE SCHEMA [cfg] AUTHORIZATION [dbo]
GO
/****** Object:  Table [dbo].[Phases]    Script Date: 01/07/2014 12:02:55 ******/
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
	[xxx_TfsIterationPath] [varchar](300) NULL,
 CONSTRAINT [PK_Phases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Persons]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[NotificationHistory]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NotificationHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NULL,
	[PhaseId] [int] NULL,
	[EventType] [varchar](50) NULL,
	[NotificationType] [varchar](50) NULL,
	[NotificationCreatedDate] [datetime] NULL,
 CONSTRAINT [PK_NotificationHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Features]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[ErrorLogs]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ErrorLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorNumber] [int] NULL,
	[ErrorSeverity] [varchar](50) NULL,
	[ErrorState] [varchar](50) NULL,
	[ErrorLine] [varchar](50) NULL,
	[ErrorProcedure] [varchar](50) NULL,
	[ErrorMessage] [varchar](250) NULL,
	[Date] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Environments]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Environments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[Location] [varchar](50) NULL,
	[ShortName] [varchar](50) NULL,
 CONSTRAINT [PK_Environments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[Products]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Processes]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Processes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Operation] [nvarchar](100) NULL,
	[Description] [text] NULL,
	[ShortName] [nvarchar](10) NULL,
	[Type] [nvarchar](50) NULL,
	[Shared] [bit] NULL,
	[ParallelIdentical] [bit] NULL,
	[Batch] [bit] NULL,
	[ParallelContainer] [bit] NULL,
 CONSTRAINT [PK_Processes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContinuingProcessResources]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContinuingProcessResources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProcessId] [int] NULL,
	[PersonId] [int] NULL,
	[Dedication] [decimal](12, 2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DeliverableId] [int] NULL,
	[ActivityId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Activities]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[Deliverables]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[TfsImport]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[SoftwareVersions]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SoftwareVersions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[VersionNumber] [varchar](20) NULL,
 CONSTRAINT [PK_SoftwareVersions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [cfg].[ReleaseModels]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [cfg].[ReleaseModels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](50) NULL,
	[Description] [varchar](150) NULL,
 CONSTRAINT [PK_ReleaseModels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Meetings]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Meetings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](250) NULL,
	[Description] [varchar](500) NULL,
	[Objective] [varchar](250) NULL,
	[Moment] [varchar](250) NULL,
 CONSTRAINT [PK_Meetings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AbsenceImport]    Script Date: 01/07/2014 12:02:55 ******/
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
/****** Object:  Table [dbo].[ReleaseMeetings]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseMeetings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseId] [int] NOT NULL,
	[MeetingId] [int] NOT NULL,
	[Date] [datetime] NULL,
	[Time] [varchar](10) NULL,
 CONSTRAINT [PK_ReleaseMeetings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [cfg].[ReleaseModelPhases]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [cfg].[ReleaseModelPhases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseModelId] [int] NULL,
	[DaysAftertReleaseStart] [int] NULL,
	[LengthInDays] [int] NULL,
	[Title] [varchar](50) NULL,
	[Description] [varchar](150) NULL,
 CONSTRAINT [PK_ReleaseModelPhases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [cfg].[ReleaseModelMilestones]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [cfg].[ReleaseModelMilestones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseModelId] [int] NULL,
	[Title] [varchar](50) NULL,
	[DaysAfterReleaseStart] [int] NULL,
	[Time] [varchar](10) NULL,
	[Descriiption] [varchar](100) NULL,
 CONSTRAINT [PK_ReleaseMilestones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [cfg].[ReleaseModelMeetings]    Script Date: 01/07/2014 12:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [cfg].[ReleaseModelMeetings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseModelId] [int] NULL,
	[DaysAfterReleaseStart] [int] NULL,
	[Title] [varchar](50) NULL,
	[Description] [varchar](150) NULL,
 CONSTRAINT [PK_ReleaseModelMeetings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_meeting]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_meeting]
	@MeetingId int
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

			DELETE FROM Meetings WHERE Id = @MeetingId

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
/****** Object:  Table [dbo].[ReleaseProjects]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_add_notification_to_history]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_add_notification_to_history]
	@EventId int,
	@PhaseId int,
	@EventType varchar(50),
	@NotificationType varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO NotificationHistory(EventId, PhaseId, EventType, NotificationType, NotificationCreatedDate)
    VALUES(@EventId, @PhaseId, @EventType, @NotificationType, GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_release]    Script Date: 01/07/2014 12:02:57 ******/
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
@ParentId int
AS

UPDATE Phases set StartDate=@StartDate, EndDate=@EndDate, Title=@Title, [Description]=@Descr, [Type]='Release', ParentId=@ParentId where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Phases(StartDate, EndDate, Title, [Description], [Type], ParentId) 
	VALUES(@StartDate, @EndDate, @Title, @Descr, 'Release', @ParentId)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_project]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_upsert_process]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_process]
@Id int, 
@Title varchar(100),
@Descr varchar(250),
@ShortName varchar(10),
@Type varchar(50)
AS

UPDATE Processes set Title=@Title, [Description]=@Descr, ShortName = @ShortName, [Type] = @Type where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Processes(Title, [Description], ShortName, [Type]) 
	VALUES(@Title, @Descr, @ShortName, @Type)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_person]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_GetErrorInfo]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetErrorInfo]
AS
	INSERT INTO ErrorLogs(ErrorNumber, ErrorSeverity, ErrorState, ErrorLine, ErrorProcedure, ErrorMessage, [Date])
    SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_LINE () AS ErrorLine
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_MESSAGE() AS ErrorMessage
        , GETDATE();
GO
/****** Object:  Table [dbo].[ValueStreams]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ValueStreams](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[AmtCustomerDemand] [int] NULL,
	[AvailableTime] [int] NULL,
	[TimeCurrency] [varchar](50) NULL,
 CONSTRAINT [PK_ValueStreams] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_meeting]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_meeting]
@Id int, 
@Title varchar(250),
@Description varchar(500),
@Objective varchar(250),
@Moment varchar(250)
AS

UPDATE Meetings set Title=@Title, [Description]=@Description, Objective = @Objective, Moment = @Moment where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Meetings(Title, [Description], Objective, Moment) 
	VALUES(@Title, @Description, @Objective, @Moment)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_environment]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_environment]
@Id int, 
@Name varchar(250),
@Description varchar(500),
@Location varchar(250),
@ShortName varchar(100)
AS

UPDATE Environments set Name=@Name, [Description]=@Description, Location = @Location, ShortName = @ShortName where Id=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Environments(Name, [Description], Location, ShortName) 
	VALUES(@Name, @Description, @Location, @ShortName)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_activity]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_phase_dates]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_update_phase_dates]
@Id int, 
@StartDate datetime,
@EndDate datetime
AS

UPDATE Phases set StartDate=@StartDate, EndDate=@EndDate where ID=@Id
GO
/****** Object:  StoredProcedure [dbo].[sp_update_phase]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_update_phase]
@Id int, 
@StartDate datetime,
@EndDate datetime,
@Title varchar(150),
@Description varchar(500)
AS

UPDATE Phases set StartDate=@StartDate, EndDate=@EndDate, Title = @Title, Description = @Description where ID=@Id
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_process_resource_assignment]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_process_resource_assignment]
	@Id int,
	@ProcessId int,
	@PersonId int,
	@Dedication decimal(12,2),
	@StartDate datetime,
	@EndDate datetime,
	@ActivityId int,
	@DeliverableId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--EXEC sp_delete_resource_assignment @ReleaseId, @ProjectId, @PersonId, @MilestoneId, @DeliverableId, @StartDate, @EndDate, @ActivityId
	
    INSERT INTO ContinuingProcessResources(ProcessId, PersonId, Dedication, StartDate, EndDate, ActivityId, DeliverableId) 
		VALUES(@ProcessId, @PersonId, @Dedication, @StartDate, @EndDate, @ActivityId, @DeliverableId)
    
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_period]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_insert_period]
@Title varchar(100),
@StartDate datetime,
@EndDate datetime,
@Description varchar(250),
@NewId int OUTPUT
AS

INSERT INTO Phases(StartDate, EndDate, Title, [Description]) 
VALUES(@StartDate, @EndDate, @Title, @Description)

SELECT @NewId = SCOPE_IDENTITY()
GO
/****** Object:  Table [dbo].[DeliverableActivities]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  Table [dbo].[Absences]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  Table [dbo].[Milestones]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  Table [dbo].[ProcessActivities]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessActivities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProcessId] [int] NULL,
	[ActivityId] [int] NULL,
	[AmountResources] [int] NULL,
 CONSTRAINT [PK_ProcessActivities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnvironmentAssignments]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EnvironmentAssignments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PhaseId] [int] NULL,
	[EnvironmentId] [int] NULL,
	[SoftwareVersionId] [int] NULL,
	[Purpose] [varchar](250) NULL,
 CONSTRAINT [PK_EnvironmentAssignments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DeliverableStatus]    Script Date: 01/07/2014 12:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliverableStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseId] [int] NULL,
	[ProjectId] [int] NULL,
	[MilestoneId] [int] NULL,
	[DeliverableId] [int] NULL,
	[ActivityId] [int] NULL,
	[HoursRemaining] [int] NULL,
	[InitialEstimate] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MilestoneStatus]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  Table [dbo].[MilestoneDeliverables]    Script Date: 01/07/2014 12:02:57 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_loadAbsenceTable]    Script Date: 01/07/2014 12:02:58 ******/
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
		when title like '%Roland%' then 9
		when title like '%Yang%' then 31
		when title like '%Michel%' then 35
		when title like '%Kris%' or title like '%KK%' then 11
		when title like '%Reinier%' then 12
		when title like '%Martijn%' and title not like '%Martijn R%' then 15
		when title like '%Robert%' then 18
		when title like '%Berrie%' then 19
		when title like '%Raymond%' then 27
		when title like '%Michael%' then 28
		when title like '%Nash%' then 28
		when title like '%Wim%' then 30
		when title like '%EP%' then 33
		when title like '%Tsun%' then 34
		when title like '%Frans%' then 36
		when title like '%Michel%' then 35
	else null end as PersonId,
	Title,
	StartTime,
	EndTime
from
	[AbsenceImport]
where
	starttime > '29 Feb 2012'

--remove recurring stuff etc	
delete from [Planner].[dbo].[Absences] where DATEDIFF(year, startdate, enddate) > 1
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_releaseproject]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_milestone_planning]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_update_milestone_planning]
@Id int, 
@Date datetime,
@Time varchar(10)
AS

UPDATE Milestones set [Date]=@Date, [Time]=@Time where Id=@Id
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_deliverable]    Script Date: 01/07/2014 12:02:58 ******/
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
-- first remove all old activities since they will be inserted again with sp_insert_deliverableactivity
DELETE FROM DeliverableActivities WHERE DeliverableId = @Id

UPDATE Deliverables set Title=@Title, [Description]=@Description, Format=@Format, Location=@Location where ID=@Id
IF @@ROWCOUNT = 0
	INSERT INTO Deliverables(Title, [Description], Format, Location) 
	VALUES(@Title, @Description, @Format, @Location)

	SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_save_absence]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_save_absence] 
	@Id int,
	@PersonId int,
	@StartDate datetime,
	@EndDate datetime,
	@Title varchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @NewId int

    DELETE FROM 
		Absences 
    WHERE 
		Id = @Id

	INSERT INTO Absences(Title, StartDate, EndDate, PersonId)
	VALUES(@Title, @StartDate, @EndDate, @PersonId)
	
	SET @NewId = SCOPE_IDENTITY()
	
	SELECT * FROM Absences WHERE Id = @NewId
    
END
GO
/****** Object:  Table [dbo].[ValueStreamProcesses]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ValueStreamProcesses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ValueStreamId] [int] NULL,
	[ProcessId] [int] NULL,
 CONSTRAINT [PK_ValueStreamProcesses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_upsert_milestone]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_upsert_meeting_planning]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_upsert_meeting_planning]
@Id int, 
@Date datetime,
@Time varchar(10),
@ReleaseId int
AS

UPDATE ReleaseMeetings set [Date]=@Date, [Time]=@Time where MeetingId=@Id AND ReleaseId = @ReleaseId
IF @@ROWCOUNT = 0
	INSERT INTO ReleaseMeetings(ReleaseId, MeetingId, [Date], [Time]) 
	VALUES(@ReleaseId,@Id, @Date, @Time)
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_meeting_planning]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_delete_meeting_planning]
@Id int, 
@ReleaseId int
AS

DELETE FROM ReleaseMeetings where MeetingId=@Id AND ReleaseId = @ReleaseId
GO
/****** Object:  StoredProcedure [dbo].[sp_assign_environment]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_assign_environment]
@PhaseId int,
@EnvironmentId int,
@SoftwareVersionId int,
@Purpose varchar(250)
AS

INSERT INTO EnvironmentAssignments(PhaseId, EnvironmentId, SoftwareVersionId, Purpose) 
	VALUES(@PhaseId, @EnvironmentId, @SoftwareVersionId, @Purpose)
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_projects]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_release_projects]
	@ReleaseId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT
		p.Id, p.Title, p.Description, p.ShortName
	FROM
		Projects p
		INNER JOIN ReleaseProjects rp on p.Id = rp.ProjectId
	WHERE
		rp.PhaseId = @ReleaseId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_deliverableactivity]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_phase_milestones]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_person_absences_for_coming_days]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_person_absences_for_coming_days]
	@ResourceId int,
	@AmountDays int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		a.Id, a.personid, p.FirstName, p.MiddleName, p.LastName, p.HoursPerWeek, a.Title, a.StartDate, a.EndDate
	FROM
		Absences a
		INNER JOIN Persons p on a.PersonId = p.Id
	WHERE
		a.PersonId = @ResourceId
		AND a.StartDate >= GETDATE() AND a.StartDate <= GETDATE() + @AmountDays
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_person_absences]    Script Date: 01/07/2014 12:02:58 ******/
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
		a.Id, a.personid, p.FirstName, p.MiddleName, p.LastName, p.HoursPerWeek, a.Title, a.StartDate, a.EndDate
	FROM
		Absences a
		INNER JOIN Persons p on a.PersonId = p.Id
	WHERE
		a.PersonId = @ResourceId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_milestones_for_next_days]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_milestones_for_next_days] 
	@AmountDays int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		r.Id as ReleaseId, r.Title as ReleaseTitle,
		m.*
    FROM
		Milestones m
		INNER JOIN Phases r on m.PhaseId = r.Id
		-- exclude milestone that already notifications are sent for
		LEFT JOIN NotificationHistory n on m.Id = n.EventId AND m.PhaseId = n.PhaseId AND n.EventType = 'Milestone'
    WHERE
		m.Date BETWEEN GETDATE() AND GETDATE() + @AmountDays
		AND n.Id IS NULL
	ORDER BY
		m.Date
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_milestone_by_id]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_environment_assignments]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_environment_assignments] 
	@EnvironmentId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		a.Id as AssignmentId, e.Name as EnvironmentName, e.Location, e.Id as EnvironmentId, ph.StartDate, ph.EndDate, ph.Title as PhaseTitle, ph.Id as PhaseId, v.VersionNumber, v.Description, v.Id as VersionId
	FROM
		EnvironmentAssignments a
		INNER JOIN Environments e on a.EnvironmentId = e.Id
		INNER JOIN Phases ph on a.PhaseId = ph.Id
		INNER JOIN	SoftwareVersions v on a.SoftwareVersionId = v.Id
	WHERE
		a.EnvironmentId = @EnvironmentId
		
END
GO
/****** Object:  StoredProcedure [dbo].[get_activities_for_deliverable]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_absence]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_absence]
	@Id int
AS
BEGIN
	-- set nocount off to enable @@rowcount
	SET NOCOUNT OFF;

    DELETE FROM Absences WHERE Id = @Id
    
    SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_environment_assignment]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_environment_assignment] 
@PhaseId int,
@EnvironmentId int,
@SoftwareVersionId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DELETE FROM 
	EnvironmentAssignments 
WHERE
	PhaseId = @PhaseId
	AND EnvironmentId = @EnvironmentId
	AND SoftwareVersionId = @SoftwareVersionId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_absences_for_next_days]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_absences_for_next_days] 
	@AmountDays int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		a.Id as AbsenceId, a.Title as Title, a.StartDate, a.EndDate, a.PersonId,
		p.FirstName, p.MiddleName, p.LastName
    FROM
		Absences a
		INNER JOIN Persons p on a.PersonId = p.Id
		-- exclude milestone that already notifications are sent for
		LEFT JOIN NotificationHistory n on a.Id = n.EventId AND n.EventType = 'Absence'
    WHERE
		(
			(a.StartDate BETWEEN GETDATE() AND GETDATE() + @AmountDays)
			OR (a.EndDate BETWEEN GETDATE() AND GETDATE() + @AmountDays)
			OR (GETDATE() BETWEEN a.StartDate AND a.EndDate)
			OR (GETDATE() + @AmountDays BETWEEN a.StartDate AND a.EndDate)
		)
		AND n.Id IS NULL
	ORDER BY
		a.StartDate
END
GO
/****** Object:  Table [dbo].[RemainingWorkHistory]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RemainingWorkHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StatusDate] [datetime] NULL,
	[ReleaseId] [int] NULL,
	[MilestoneId] [int] NULL,
	[DeliverableId] [int] NULL,
	[ActivityId] [int] NULL,
	[ProjectId] [int] NULL,
	[HoursRemaining] [int] NULL,
 CONSTRAINT [PK_RemainingWorkHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RemainingWorkHistory] ON [dbo].[RemainingWorkHistory] 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReleaseResources]    Script Date: 01/07/2014 12:02:58 ******/
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
	[DeliverableId] [int] NULL,
 CONSTRAINT [uc_assignment] UNIQUE NONCLUSTERED 
(
	[ReleaseId] ASC,
	[ProjectId] ASC,
	[PersonId] ASC,
	[MilestoneId] ASC,
	[DeliverableId] ASC,
	[ActivityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReleaseMilestones]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseMilestones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseId] [int] NULL,
	[MilestoneId] [int] NULL,
	[Date] [datetime] NULL,
	[Time] [varchar](10) NULL,
	[Descriiption] [varchar](100) NULL,
 CONSTRAINT [PK_ReleaseMilestones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[get_release_deliverable_assignments]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_resource_assignment]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_resource_assignment]
	@ReleaseId int,
	@ProjectId int,
	@PersonId int,
	@MilestoneId int,
	@DeliverableId int,
	@StartDate datetime,
	@EndDate datetime,
	@ActivityId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM ReleaseResources 
	WHERE 
		ReleaseId = @ReleaseId 
		AND ProjectId = @ProjectId 
		AND PersonId = @PersonId 
		AND MilestoneId = @MilestoneId 
		AND DeliverableId = @DeliverableId
		AND ActivityId = @ActivityId
		AND 
		(CONVERT(varchar, StartDate, 103) = CONVERT(varchar, @StartDate, 103) OR CONVERT(varchar, EndDate, 103) = CONVERT(varchar, @EndDate, 103))
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_release]    Script Date: 01/07/2014 12:02:58 ******/
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
	-- SET XACT_ABORT ON will cause the transaction to be uncommittable
	-- when the constraint violation occurs.
	SET XACT_ABORT ON;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @Returns BIT      
	SET @Returns = 1
	BEGIN
		TRY  
			
			
			BEGIN TRANSACTION 

			DELETE FROM MilestoneStatus WHERE ReleaseId = @ReleaseId
			
			DELETE md FROM MilestoneDeliverables md INNER JOIN Milestones m ON md.MilestoneId = m.Id AND m.PhaseId = @ReleaseId
	    
			DELETE FROM ReleaseProjects WHERE PhaseId = @ReleaseId
	    
			DELETE FROM ReleaseResources WHERE ReleaseId = @ReleaseId
			
			DELETE FROM DeliverableStatus WHERE ReleaseId = @ReleaseId
			
			DELETE FROM RemainingWorkHistory WHERE ReleaseId = @ReleaseId
			
			DELETE FROM Milestones WHERE PhaseId = @ReleaseId
			
			DELETE FROM EnvironmentAssignments WHERE PhaseId IN (SELECT Id FROM Phases WHERE ParentId = @ReleaseId)
			
			DELETE FROM EnvironmentAssignments WHERE PhaseId = @ReleaseId
			
			DELETE FROM Phases WHERE ParentId = @ReleaseId
	    
			DELETE FROM Phases WHERE Id = @ReleaseId

			-- If the DELETE statements succeed, commit the transaction.
		    COMMIT TRANSACTION; 
		END TRY 
		BEGIN CATCH   
		   SET @Returns = 0      
			-- Test XACT_STATE:
				-- If 1, the transaction is committable.
				-- If -1, the transaction is uncommittable and should
				--     be rolled back.
				-- XACT_STATE = 0 means that there is no transaction and
				--     a commit or rollback operation would generate an error.

			-- Test whether the transaction is uncommittable.
			IF (XACT_STATE()) = -1
			BEGIN
				PRINT
					N'The transaction is in an uncommittable state.' +
					'Rolling back transaction.'
				ROLLBACK TRANSACTION;
				
				-- Execute error retrieval routine.
				EXECUTE usp_GetErrorInfo;
			END;

			-- Test whether the transaction is committable.
			IF (XACT_STATE()) = 1
			BEGIN
				PRINT
					N'The transaction is committable.' +
					'Committing transaction.'
				COMMIT TRANSACTION;  
			END;
		END CATCH

	RETURN @Returns
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_person]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_milestone]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_deliverable]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_deliverable]
	@DeliverableId int
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

			DELETE FROM DeliverableActivities WHERE DeliverableId = @DeliverableId
			
			DELETE FROM MilestoneStatus WHERE DeliverableId = @DeliverableId
			
			DELETE FROM MilestoneDeliverables WHERE DeliverableId = @DeliverableId
			
			DELETE FROM ReleaseResources WHERE DeliverableId = @DeliverableId

			DELETE FROM Deliverables WHERE Id = @DeliverableId

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
/****** Object:  StoredProcedure [dbo].[sp_delete_activity]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_count_milestonestatus_records]    Script Date: 01/07/2014 12:02:58 ******/
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
	@ProjectId int,
	@ActivityId int
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
		AND ActivityId = @ActivityId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_deliverables_for_milestone]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_deliverable_status_for_next_days]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_deliverable_status_for_next_days]
	-- Add the parameters for the stored procedure here
	@AmountDays INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		ph.Title as ReleaseTitle,
		p.Id as ProjectId, p.Title as ProjectTitle, p.ShortName as ProjectShortName,
		m.Title as MilestoneTitle, m.Date as MilestoneDate, m.Time as MilestoneTime,
		d.[Description] as DeliverableDescr, d.Format as DeliverableFormat, d.Location as DeliverableLocation, d.Title as DeliverableTitle,
		a.Title as ActivityTitle,
		ds.HoursRemaining, ds.InitialEstimate
	FROM
		DeliverableStatus ds
		INNER JOIN Projects p on ds.ProjectId = p.Id
		INNER JOIN Phases ph on ds.ReleaseId = ph.Id
		INNER JOIN Milestones m on ds.MilestoneId = m.Id
		INNER JOIN Deliverables d on ds.DeliverableId = d.Id
		INNER JOIN Activities a on ds.ActivityId = a.Id
	WHERE
		m.Date BETWEEN GETDATE() AND GETDATE() + @AmountDays
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_deliverable_status_for_milestone]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_deliverable_status_for_milestone]
	-- Add the parameters for the stored procedure here
	@MilestoneId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		ph.Title as ReleaseTitle,
		p.Id as ProjectId, p.Title as ProjectTitle, p.ShortName as ProjectShortName,
		m.Title as MilestoneTitle, m.Date as MilestoneDate, m.Time as MilestoneTime,
		d.[Description] as DeliverableDescr, d.Format as DeliverableFormat, d.Location as DeliverableLocation, d.Title as DeliverableTitle,
		a.Title as ActivityTitle,
		ds.HoursRemaining, ds.InitialEstimate
	FROM
		DeliverableStatus ds
		INNER JOIN Projects p on ds.ProjectId = p.Id
		INNER JOIN Phases ph on ds.ReleaseId = ph.Id
		INNER JOIN Milestones m on ds.MilestoneId = m.Id
		INNER JOIN Deliverables d on ds.DeliverableId = d.Id
		INNER JOIN Activities a on ds.ActivityId = a.Id
	WHERE
		m.Id = @MilestoneId
	ORDER BY
		p.Id
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_deliverable_status]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_assignments]    Script Date: 01/07/2014 12:02:58 ******/
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
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneId = md.MilestoneId AND rr.DeliverableId = md.DeliverableId
		LEFT JOIN Milestones m on md.MilestoneId = m.Id
		LEFT JOIN Deliverables d on md.DeliverableId = d.Id
		LEFT JOIN Activities a on rr.ActivityId = a.Id
	WHERE 
		rr.ReleaseId = @PhaseId AND rr.ProjectId = @ProjectId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_resources]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_release_resource]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_resource_assignments]    Script Date: 01/07/2014 12:02:58 ******/
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
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneId = md.MilestoneId AND rr.DeliverableId = md.DeliverableId
		LEFT JOIN Milestones m on md.MilestoneId = m.Id
		LEFT JOIN Deliverables d on md.DeliverableId = d.Id
		LEFT JOIN Activities a on rr.ActivityId = a.Id
	WHERE 
		rr.personId = @ResourceId
END
GO
/****** Object:  StoredProcedure [dbo].[xxx_sp_unassign_milestone_from_release]    Script Date: 01/07/2014 12:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[xxx_sp_unassign_milestone_from_release]
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
/****** Object:  StoredProcedure [dbo].[xxx_sp_get_release_deliverable_assignments]    Script Date: 01/07/2014 12:02:58 ******/
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
/****** Object:  View [dbo].[vw_remainingwork_history]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_remainingwork_history]
AS
SELECT     h.StatusDate, CONVERT(VARCHAR(10), h.StatusDate, 103) AS StatusDateString, h.HoursRemaining, m.Id AS MilestoneId, m.Title AS Milestone, ph.Title AS Release, 
                      ph.Id AS ReleaseId, p.Title AS Project, d.Title AS Artefact, a.Title AS Activity, a.Id AS ActivityId, d.Id AS ArtefactId
FROM         dbo.RemainingWorkHistory AS h INNER JOIN
                      dbo.Milestones AS m ON h.MilestoneId = m.Id INNER JOIN
                      dbo.Phases AS ph ON h.ReleaseId = ph.Id INNER JOIN
                      dbo.Projects AS p ON h.ProjectId = p.Id INNER JOIN
                      dbo.Deliverables AS d ON h.DeliverableId = d.Id INNER JOIN
                      dbo.Activities AS a ON h.ActivityId = a.Id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 195
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 233
               Bottom = 114
               Right = 384
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ph"
            Begin Extent = 
               Top = 6
               Left = 422
               Bottom = 114
               Right = 581
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 619
               Bottom = 114
               Right = 780
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 818
               Bottom = 114
               Right = 969
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 1007
               Bottom = 99
               Right = 1158
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_remainingwork_history'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_remainingwork_history'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_remainingwork_history'
GO
/****** Object:  StoredProcedure [dbo].[sp_remove_orphan_work_history_milestone_deliverables]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_remove_orphan_work_history_milestone_deliverables]
@ReleaseId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ToRemove TABLE
	(
	 id int
	) 
	
	INSERT INTO @ToRemove(id)
	SELECT 
		h.Id 
	FROM 
		RemainingWorkHistory h
		left join MilestoneDeliverables md on h.DeliverableId = md.DeliverableId and h.MilestoneId = md.MilestoneId
	WHERE
		md.Id is null
		AND h.ReleaseId = @ReleaseId
		
	DELETE FROM 
		RemainingWorkHistory 
	WHERE 
		Id IN (SELECT id from @ToRemove)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_remove_orphan_resource_assignments]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_remove_orphan_resource_assignments]
@ReleaseId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ToRemove TABLE
	(
	 id int
	) 
	
	INSERT INTO @ToRemove(id)
	SELECT 
		rr.id
		/*, rr.personId, p.FirstName, p.middlename, p.lastname, rr.releaseid as phaseid, 
		r.title as phasetitle, rr.projectid, pr.title as projecttitle, rr.FocusFactor, rr.EndDate, rr.StartDate, -- rr.Activity,
		md.Id as MilestoneDeliverableId, isnull(m.Id, 0) as MilestoneId, m.[Date] as MilestoneDate, m.Title as MilestoneTitle,
		isnull(d.Id, 0) as DeliverableId, d.Title as DeliverableTitle, d.[Description] as DeliverableDescription,
		isnull(a.Id, 0) as ActivityId, a.Title as ActivityTitle, a.[Description] as ActivityDescription*/
	FROM 
		ReleaseResources rr 
		INNER JOIN Persons p on rr.PersonId = p.Id 
		INNER JOIN Phases r on rr.ReleaseId = r.Id 
		INNER JOIN Projects pr on rr.ProjectId = pr.Id
		LEFT JOIN MilestoneDeliverables md on rr.MilestoneId = md.MilestoneId AND rr.DeliverableId = md.DeliverableId
	WHERE
		rr.ReleaseId = @ReleaseId AND
		md.Id is null
		
	DELETE FROM 
		ReleaseResources 
	WHERE 
		Id IN (SELECT id from @ToRemove)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_unassign_project_from_release]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unassign_project_from_release]
	@ReleaseId int,
	@ProjectId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM ReleaseProjects WHERE PhaseId = @ReleaseId AND ProjectId = @ProjectId
    
    DELETE FROM ReleaseResources WHERE ReleaseId = @ReleaseId AND ProjectId = @ProjectId
    
    DELETE FROM MilestoneStatus WHERE ReleaseId = @ReleaseId AND ProjectId = @ProjectId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_milestonestatus]    Script Date: 01/07/2014 12:02:59 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_milestonedeliverable]    Script Date: 01/07/2014 12:02:59 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_remainingwork_history_table]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_remainingwork_history_table]
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
	
	DELETE FROM RemainingWorkHistory 
	WHERE 
		CONVERT(VARCHAR(10), StatusDate, 103) = CONVERT(VARCHAR(10), GETDATE(), 103)
		AND ReleaseId = @ReleaseId
		AND ProjectId = @ProjectId
		AND MilestoneId = @MilestoneId
		AND DeliverableId = @DeliverableId
		AND ActivityId = @ActivityId

    INSERT INTO RemainingWorkHistory(StatusDate, ReleaseId, ProjectId, MilestoneId, DeliverableId, ActivityId, HoursRemaining)
    VALUES(GETDATE(), @ReleaseId, @ProjectId, @MilestoneId, @DeliverableId, @ActivityId, @HoursRemaining)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_load_deliverable_status]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_load_deliverable_status]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	TRUNCATE TABLE DeliverableStatus
	
	INSERT INTO DeliverableStatus(ReleaseId, ProjectId, MilestoneId, DeliverableId, ActivityId, HoursRemaining, InitialEstimate)
	SELECT
		p.Id as ReleaseId, pr.Id as ProjectId, m.Id as MilestoneId, d.Id as DeliverableId, da.ActivityId as ActivityId,
		ms.HoursRemaining, ms.InitialEstimate
	FROM
		MilestoneStatus ms
		INNER JOIN Phases p on ms.ReleaseId = p.Id
		INNER JOIN Projects pr on ms.ProjectId = pr.Id
		INNER JOIN Milestones m on ms.MilestoneId = m.Id
		INNER JOIN Deliverables d on ms.DeliverableId = d.Id
		INNER JOIN DeliverableActivities da on ms.DeliverableId = da.DeliverableId AND ms.ActivityId = da.ActivityId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_resource_assignment]    Script Date: 01/07/2014 12:02:59 ******/
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
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	EXEC sp_delete_resource_assignment @ReleaseId, @ProjectId, @PersonId, @MilestoneId, @DeliverableId, @StartDate, @EndDate, @ActivityId
	
    INSERT INTO ReleaseResources(ReleaseId, ProjectId, PersonId, FocusFactor, StartDate, EndDate, ActivityId, MilestoneId, DeliverableId) 
		VALUES(@ReleaseId, @ProjectId, @PersonId, @FocusFactor, @StartDate, @EndDate, @ActivityId, @MilestoneId, @DeliverableId)
    
    SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_snapshots_with_progress_data]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_release_snapshots_with_progress_data]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT DISTINCT
      ph.Title as PhaseTitle
      ,ph.Id as PhaseId
      ,m.Id as MilestoneId
      ,m.Title as MilestoneTitle
      FROM 
		[Planner].[dbo].Milestones m
		INNER JOIN [Planner].[dbo].Phases ph ON m.PhaseId = ph.Id
		INNER JOIN [Planner].[dbo].[vw_remainingwork_history] h on m.Id = h.MilestoneId AND m.PhaseId = h.ReleaseId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_release_progress]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_release_progress]
	@ReleaseId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [StatusDate]
      ,[HoursRemaining]
      ,[Milestone]
      ,[Release]
      ,[ReleaseId]
      ,[Project]
      ,[Artefact]
      ,[Activity]
      ,ArtefactId
      ,MilestoneId
  FROM [Planner].[dbo].[vw_remainingwork_history]
  WHERE
	ReleaseId = @ReleaseId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_milestone_progress]    Script Date: 01/07/2014 12:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_milestone_progress]
	@PhaseId int,
	@MilestoneId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [StatusDate]
      ,[HoursRemaining]
      ,[Milestone]
      ,[Release]
      ,[ReleaseId]
      ,[Project]
      ,[Artefact]
      ,[Activity]
      ,ArtefactId
      ,MilestoneId
  FROM [Planner].[dbo].[vw_remainingwork_history]
  WHERE
	ReleaseId = @PhaseId
	AND MilestoneId = @MilestoneId
END
GO
/****** Object:  ForeignKey [FK_Phases_Phases]    Script Date: 01/07/2014 12:02:55 ******/
ALTER TABLE [dbo].[Phases]  WITH CHECK ADD  CONSTRAINT [FK_Phases_Phases] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[Phases] CHECK CONSTRAINT [FK_Phases_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseMeetings_Meetings]    Script Date: 01/07/2014 12:02:55 ******/
ALTER TABLE [dbo].[ReleaseMeetings]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseMeetings_Meetings] FOREIGN KEY([MeetingId])
REFERENCES [dbo].[Meetings] ([Id])
GO
ALTER TABLE [dbo].[ReleaseMeetings] CHECK CONSTRAINT [FK_ReleaseMeetings_Meetings]
GO
/****** Object:  ForeignKey [FK_ReleaseMeetings_Phases]    Script Date: 01/07/2014 12:02:55 ******/
ALTER TABLE [dbo].[ReleaseMeetings]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseMeetings_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[ReleaseMeetings] CHECK CONSTRAINT [FK_ReleaseMeetings_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseModelPhases_ReleaseModels]    Script Date: 01/07/2014 12:02:55 ******/
ALTER TABLE [cfg].[ReleaseModelPhases]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseModelPhases_ReleaseModels] FOREIGN KEY([ReleaseModelId])
REFERENCES [cfg].[ReleaseModels] ([Id])
GO
ALTER TABLE [cfg].[ReleaseModelPhases] CHECK CONSTRAINT [FK_ReleaseModelPhases_ReleaseModels]
GO
/****** Object:  ForeignKey [FK_ReleaseModelMilestones_ReleaseModels]    Script Date: 01/07/2014 12:02:55 ******/
ALTER TABLE [cfg].[ReleaseModelMilestones]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseModelMilestones_ReleaseModels] FOREIGN KEY([ReleaseModelId])
REFERENCES [cfg].[ReleaseModels] ([Id])
GO
ALTER TABLE [cfg].[ReleaseModelMilestones] CHECK CONSTRAINT [FK_ReleaseModelMilestones_ReleaseModels]
GO
/****** Object:  ForeignKey [FK_ReleaseModelMeetings_ReleaseModels]    Script Date: 01/07/2014 12:02:55 ******/
ALTER TABLE [cfg].[ReleaseModelMeetings]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseModelMeetings_ReleaseModels] FOREIGN KEY([ReleaseModelId])
REFERENCES [cfg].[ReleaseModels] ([Id])
GO
ALTER TABLE [cfg].[ReleaseModelMeetings] CHECK CONSTRAINT [FK_ReleaseModelMeetings_ReleaseModels]
GO
/****** Object:  ForeignKey [FK_ReleaseProjects_Phases]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[ReleaseProjects]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseProjects_Phases] FOREIGN KEY([PhaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[ReleaseProjects] CHECK CONSTRAINT [FK_ReleaseProjects_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseProjects_Projects]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[ReleaseProjects]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseProjects_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[ReleaseProjects] CHECK CONSTRAINT [FK_ReleaseProjects_Projects]
GO
/****** Object:  ForeignKey [FK_ValueStreams_Products]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[ValueStreams]  WITH CHECK ADD  CONSTRAINT [FK_ValueStreams_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ValueStreams] CHECK CONSTRAINT [FK_ValueStreams_Products]
GO
/****** Object:  ForeignKey [FK_DeliverableActivities_Activities]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableActivities]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableActivities_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[DeliverableActivities] CHECK CONSTRAINT [FK_DeliverableActivities_Activities]
GO
/****** Object:  ForeignKey [FK_DeliverableActivities_Deliverables]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableActivities]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableActivities_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[DeliverableActivities] CHECK CONSTRAINT [FK_DeliverableActivities_Deliverables]
GO
/****** Object:  ForeignKey [FK_Absences_Persons]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[Absences]  WITH CHECK ADD  CONSTRAINT [FK_Absences_Persons] FOREIGN KEY([PersonId])
REFERENCES [dbo].[Persons] ([Id])
GO
ALTER TABLE [dbo].[Absences] CHECK CONSTRAINT [FK_Absences_Persons]
GO
/****** Object:  ForeignKey [FK_Milestones_Phases]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[Milestones]  WITH CHECK ADD  CONSTRAINT [FK_Milestones_Phases] FOREIGN KEY([PhaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[Milestones] CHECK CONSTRAINT [FK_Milestones_Phases]
GO
/****** Object:  ForeignKey [FK_ProcessActivities_Activities]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[ProcessActivities]  WITH CHECK ADD  CONSTRAINT [FK_ProcessActivities_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[ProcessActivities] CHECK CONSTRAINT [FK_ProcessActivities_Activities]
GO
/****** Object:  ForeignKey [FK_ProcessActivities_Processes]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[ProcessActivities]  WITH CHECK ADD  CONSTRAINT [FK_ProcessActivities_Processes] FOREIGN KEY([ProcessId])
REFERENCES [dbo].[Processes] ([Id])
GO
ALTER TABLE [dbo].[ProcessActivities] CHECK CONSTRAINT [FK_ProcessActivities_Processes]
GO
/****** Object:  ForeignKey [FK_EnvironmentAssignments_Environments]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[EnvironmentAssignments]  WITH CHECK ADD  CONSTRAINT [FK_EnvironmentAssignments_Environments] FOREIGN KEY([EnvironmentId])
REFERENCES [dbo].[Environments] ([Id])
GO
ALTER TABLE [dbo].[EnvironmentAssignments] CHECK CONSTRAINT [FK_EnvironmentAssignments_Environments]
GO
/****** Object:  ForeignKey [FK_EnvironmentAssignments_Phases]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[EnvironmentAssignments]  WITH CHECK ADD  CONSTRAINT [FK_EnvironmentAssignments_Phases] FOREIGN KEY([PhaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[EnvironmentAssignments] CHECK CONSTRAINT [FK_EnvironmentAssignments_Phases]
GO
/****** Object:  ForeignKey [FK_EnvironmentAssignments_SoftwareVersions]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[EnvironmentAssignments]  WITH CHECK ADD  CONSTRAINT [FK_EnvironmentAssignments_SoftwareVersions] FOREIGN KEY([SoftwareVersionId])
REFERENCES [dbo].[SoftwareVersions] ([Id])
GO
ALTER TABLE [dbo].[EnvironmentAssignments] CHECK CONSTRAINT [FK_EnvironmentAssignments_SoftwareVersions]
GO
/****** Object:  ForeignKey [FK_DeliverableStatus_Activities]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableStatus]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableStatus_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[DeliverableStatus] CHECK CONSTRAINT [FK_DeliverableStatus_Activities]
GO
/****** Object:  ForeignKey [FK_DeliverableStatus_Deliverables]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableStatus]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableStatus_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[DeliverableStatus] CHECK CONSTRAINT [FK_DeliverableStatus_Deliverables]
GO
/****** Object:  ForeignKey [FK_DeliverableStatus_Milestones]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableStatus]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableStatus_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[DeliverableStatus] CHECK CONSTRAINT [FK_DeliverableStatus_Milestones]
GO
/****** Object:  ForeignKey [FK_DeliverableStatus_Phases]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableStatus]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableStatus_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[DeliverableStatus] CHECK CONSTRAINT [FK_DeliverableStatus_Phases]
GO
/****** Object:  ForeignKey [FK_DeliverableStatus_Projects]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[DeliverableStatus]  WITH CHECK ADD  CONSTRAINT [FK_DeliverableStatus_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[DeliverableStatus] CHECK CONSTRAINT [FK_DeliverableStatus_Projects]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Activities]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Activities]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Deliverables]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Deliverables]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Milestones]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Milestones]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Phases]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Phases]
GO
/****** Object:  ForeignKey [FK_MilestoneStatus_Projects]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneStatus]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneStatus_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[MilestoneStatus] CHECK CONSTRAINT [FK_MilestoneStatus_Projects]
GO
/****** Object:  ForeignKey [FK_MilestoneDeliverables_Deliverables]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneDeliverables]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneDeliverables_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[MilestoneDeliverables] CHECK CONSTRAINT [FK_MilestoneDeliverables_Deliverables]
GO
/****** Object:  ForeignKey [FK_MilestoneDeliverables_Milestones]    Script Date: 01/07/2014 12:02:57 ******/
ALTER TABLE [dbo].[MilestoneDeliverables]  WITH CHECK ADD  CONSTRAINT [FK_MilestoneDeliverables_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[MilestoneDeliverables] CHECK CONSTRAINT [FK_MilestoneDeliverables_Milestones]
GO
/****** Object:  ForeignKey [FK_ValueStreamProcesses_Processes]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ValueStreamProcesses]  WITH CHECK ADD  CONSTRAINT [FK_ValueStreamProcesses_Processes] FOREIGN KEY([ProcessId])
REFERENCES [dbo].[Processes] ([Id])
GO
ALTER TABLE [dbo].[ValueStreamProcesses] CHECK CONSTRAINT [FK_ValueStreamProcesses_Processes]
GO
/****** Object:  ForeignKey [FK_ValueStreamProcesses_ValueStreams]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ValueStreamProcesses]  WITH CHECK ADD  CONSTRAINT [FK_ValueStreamProcesses_ValueStreams] FOREIGN KEY([ValueStreamId])
REFERENCES [dbo].[ValueStreams] ([Id])
GO
ALTER TABLE [dbo].[ValueStreamProcesses] CHECK CONSTRAINT [FK_ValueStreamProcesses_ValueStreams]
GO
/****** Object:  ForeignKey [FK_RemainingWorkHistory_Activities]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[RemainingWorkHistory]  WITH CHECK ADD  CONSTRAINT [FK_RemainingWorkHistory_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[RemainingWorkHistory] CHECK CONSTRAINT [FK_RemainingWorkHistory_Activities]
GO
/****** Object:  ForeignKey [FK_RemainingWorkHistory_Deliverables]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[RemainingWorkHistory]  WITH CHECK ADD  CONSTRAINT [FK_RemainingWorkHistory_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[RemainingWorkHistory] CHECK CONSTRAINT [FK_RemainingWorkHistory_Deliverables]
GO
/****** Object:  ForeignKey [FK_RemainingWorkHistory_Milestones]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[RemainingWorkHistory]  WITH CHECK ADD  CONSTRAINT [FK_RemainingWorkHistory_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[RemainingWorkHistory] CHECK CONSTRAINT [FK_RemainingWorkHistory_Milestones]
GO
/****** Object:  ForeignKey [FK_RemainingWorkHistory_Phases]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[RemainingWorkHistory]  WITH CHECK ADD  CONSTRAINT [FK_RemainingWorkHistory_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[RemainingWorkHistory] CHECK CONSTRAINT [FK_RemainingWorkHistory_Phases]
GO
/****** Object:  ForeignKey [FK_RemainingWorkHistory_Projects]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[RemainingWorkHistory]  WITH CHECK ADD  CONSTRAINT [FK_RemainingWorkHistory_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[RemainingWorkHistory] CHECK CONSTRAINT [FK_RemainingWorkHistory_Projects]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Activities]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Activities] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activities] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Activities]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Deliverables]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Deliverables] FOREIGN KEY([DeliverableId])
REFERENCES [dbo].[Deliverables] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Deliverables]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Milestones]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Milestones] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Milestones]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Persons]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Persons] FOREIGN KEY([PersonId])
REFERENCES [dbo].[Persons] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Persons]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Phases]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Phases] FOREIGN KEY([ReleaseId])
REFERENCES [dbo].[Phases] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Phases]
GO
/****** Object:  ForeignKey [FK_ReleaseResources_Projects]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseResources]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseResources_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[ReleaseResources] CHECK CONSTRAINT [FK_ReleaseResources_Projects]
GO
/****** Object:  ForeignKey [FK_ReleaseMilestones_Milestones1]    Script Date: 01/07/2014 12:02:58 ******/
ALTER TABLE [dbo].[ReleaseMilestones]  WITH CHECK ADD  CONSTRAINT [FK_ReleaseMilestones_Milestones1] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestones] ([Id])
GO
ALTER TABLE [dbo].[ReleaseMilestones] CHECK CONSTRAINT [FK_ReleaseMilestones_Milestones1]
GO
