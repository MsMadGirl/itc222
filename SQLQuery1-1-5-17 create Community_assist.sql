USE Master
GO
if exists
   (SELECT Name FROM sys.Databases where name ='Community_Assist')
   BEGIN
   DROP Database Community_Assist
   END
Go
CREATE DATABASE Community_Assist
Go

USE [Community_Assist]
GO
/****** Object:  XmlSchemaCollection [dbo].[ReviewNotesSchema]    Script Date: 4/25/2016 2:40:39 PM ******/
CREATE XML SCHEMA COLLECTION [dbo].[ReviewNotesSchema] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.community_assist.org/reviewnotes" targetNamespace="http://www.community_assist.org/reviewnotes" elementFormDefault="qualified"><xsd:element name="reviewnote"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="comment" type="xsd:anyType" /><xsd:element name="concerns"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="concern" type="xsd:anyType" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:element name="recommendation" type="xsd:string" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'
GO
/****** Object:  UserDefinedFunction [dbo].[fx_GetSeed]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fx_GetSeed]()
returns int
As
Begin
Declare @dateconcat nvarchar(20)
Declare @hour nchar(2)
Declare @minute nchar(2)
Declare @second nchar(2)
Declare @millesecond nchar(3)

Set @hour=Cast(DatePart(hour, GetDate()) as nchar(2))
if (len(@Hour)<2) set @hour=@hour + '0'

Set @minute=Cast(DatePart(hour, GetDate()) as nchar(2))
if (len(@minute)<2) set @minute=@minute + '0'

Set @second=Cast(DatePart(hour, GetDate()) as nchar(2))
if (len(@second)<2) set @second=@second + '0'

set @millesecond=Cast(Datepart(ms,GetDate())as nchar(3))

set @DateConcat=@hour+@minute+@second+@millesecond
return cast(@DateConcat as int)
End

GO
/****** Object:  UserDefinedFunction [dbo].[fx_HashPassword]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[fx_HashPassword]
(@seed int, @password nvarchar(50))
returns varbinary(500)
As
Begin
Declare @ToHash nvarchar(70)
Set @ToHash=@password + cast(@seed as nvarchar(20))
Declare @hashed varbinary(500)
set @hashed=hashbytes('sha2_512',@ToHash)
return @hashed
End

GO
/****** Object:  Table [dbo].[BusinessRule]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusinessRule](
	[BusinessRuleKey] [int] IDENTITY(1,1) NOT NULL,
	[BusinessRuleText] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[BusinessRuleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Contact]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactKey] [int] IDENTITY(1,1) NOT NULL,
	[ContactNumber] [nvarchar](255) NOT NULL,
	[ContactTypeKey] [int] NULL,
	[PersonKey] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactType]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactType](
	[ContactTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[ContactTypeName] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Donation]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donation](
	[DonationKey] [int] IDENTITY(1,1) NOT NULL,
	[PersonKey] [int] NULL,
	[DonationDate] [datetime] NOT NULL,
	[DonationAmount] [money] NOT NULL,
	[DonationConfirmation] [uniqueidentifier] NULL DEFAULT (newid()),
PRIMARY KEY CLUSTERED 
(
	[DonationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employee]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeKey] [int] IDENTITY(1,1) NOT NULL,
	[PersonKey] [int] NULL,
	[EmployeeHireDate] [date] NOT NULL,
	[EmployeeAnnualSalary] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeePosition]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePosition](
	[PositionKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
 CONSTRAINT [PK_EmployeePosition] PRIMARY KEY CLUSTERED 
(
	[PositionKey] ASC,
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GrantRequest]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GrantRequest](
	[GrantRequestKey] [int] IDENTITY(1,1) NOT NULL,
	[GrantRequestDate] [datetime] NOT NULL,
	[PersonKey] [int] NULL,
	[GrantTypeKey] [int] NULL,
	[GrantRequestExplanation] [nvarchar](255) NULL,
	[GrantRequestAmount] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[GrantRequestKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GrantReview]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GrantReview](
	[GrantReviewKey] [int] IDENTITY(1,1) NOT NULL,
	[GrantReviewDate] [datetime] NOT NULL,
	[GrantRequestKey] [int] NULL,
	[GrantRequestStatus] [nvarchar](50) NULL,
	[GrantAllocationAmount] [money] NULL,
	[EmployeeKey] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[GrantReviewKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GrantReviewComment]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GrantReviewComment](
	[GrantReviewCommentKey] [int] IDENTITY(1,1) NOT NULL,
	[GrantReviewKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[GrantReviewCommentDate] [datetime] NOT NULL,
	[GrantReviewNote] [xml](CONTENT [dbo].[ReviewNotesSchema]) NULL,
PRIMARY KEY CLUSTERED 
(
	[GrantReviewCommentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GrantType]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GrantType](
	[GrantTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[GrantTypeName] [nvarchar](255) NULL,
	[GrantTypeMaximum] [money] NOT NULL,
	[GrantTypeLifetimeMaximum] [money] NOT NULL,
	[GrantTypeDescription] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[GrantTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoginHistoryTable]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginHistoryTable](
	[LoginHistoryKey] [int] IDENTITY(1,1) NOT NULL,
	[PersonKey] [int] NULL,
	[LoginTimeStamp] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginHistoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Person]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Person](
	[PersonKey] [int] IDENTITY(1,1) NOT NULL,
	[PersonLastName] [nvarchar](255) NOT NULL,
	[PersonFirstName] [nvarchar](255) NULL,
	[PersonEmail] [nvarchar](255) NULL,
	[PersonPassWord] [varbinary](500) NULL,
	[PersonEntryDate] [datetime] NOT NULL,
	[PersonPassWordSeed] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersonAddress]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonAddress](
	[PersonAddressKey] [int] IDENTITY(1,1) NOT NULL,
	[PersonAddressApt] [nvarchar](255) NULL,
	[PersonAddressStreet] [nvarchar](255) NULL,
	[PersonAddressCity] [nvarchar](255) NULL DEFAULT ('Seattle'),
	[PersonAddressState] [nvarchar](255) NULL DEFAULT ('WA'),
	[PersonAddressZip] [nvarchar](255) NULL,
	[PersonKey] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonAddressKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Position]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[PositionKey] [int] IDENTITY(1,1) NOT NULL,
	[PositionName] [nvarchar](255) NULL,
	[PositionDescription] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PositionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[BusinessRule] ON 

GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (1, N'All Requests must be reviewed by an employee within 48 hours of entry')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (2, N'No individual grant can be greated than the Service Maximum')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (3, N'No individual can recieve more than the lifetime maximum in total grants for a particular service')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (4, N'Grants are meant for one time assistance only and are not to be given on a recurring schedule')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (5, N'Employees should seek to help clients find more long term solutions to problems')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (6, N'Grants should not be awarded if other funding sources are available')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (7, N'All grants should be approved or disapproved within 7 days of entry')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (8, N'All donations recieve a verification number from the credit card processing service')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (9, N'All passwords consist of the user last name and the word Pass')
GO
INSERT [dbo].[BusinessRule] ([BusinessRuleKey], [BusinessRuleText]) VALUES (10, N'Every login should be logged in the loginHistory table')
GO
SET IDENTITY_INSERT [dbo].[BusinessRule] OFF
GO
SET IDENTITY_INSERT [dbo].[Contact] ON 

GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (1, N'2065551234', 1, 1)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (2, N'2065552345', 1, 2)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (3, N'3605551234', 3, 2)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (4, N'2065551356', 1, 3)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (5, N'2065555678', 1, 4)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (6, N'2065556789', 1, 5)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (7, N'2065550001', 2, 5)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (8, N'2065559876', 1, 6)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (9, N'2065553344', 2, 6)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (10, N'2065558642', 1, 7)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (11, N'2065550002', 2, 7)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (12, N'2065550875', 1, 9)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (13, N'2065556767', 1, 10)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (14, N'2065552323', 1, 11)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (15, N'2065551111', 2, 11)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (16, N'2065559965', 1, 12)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (17, N'2065550003', 2, 12)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (18, N'4155551234', 1, 13)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (19, N'4155550001', 2, 13)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (20, N'4155551469', 3, 13)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (21, N'2065550192', 1, 14)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (22, N'2065557777', 3, 15)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (23, N'36065551234', 1, 16)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (24, N'2065552121', 1, 17)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (25, N'2065550747', 1, 18)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (26, N'2065550004', 2, 18)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (27, N'2065558888', 4, 18)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (28, N'4155551200', 1, 19)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (29, N'2065557089', 1, 20)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (30, N'2065552543', 1, 21)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (31, N'2065558697', 1, 22)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (32, N'2065551666', 1, 23)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (33, N'2065550005', 2, 23)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (34, N'2065550019', 4, 23)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (35, N'3605552374', 1, 24)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (36, N'2065552019', 1, 25)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (37, N'2065558734', 1, 26)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (38, N'2065559532', 3, 27)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (39, N'4155551987', 1, 28)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (40, N'2065551003', 3, 29)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (41, N'2065554710', 3, 30)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (42, N'2065553478', 1, 31)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (43, N'3065551277', 1, 32)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (44, N'3065551008', 3, 32)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (45, N'2065557102', 3, 33)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (46, N'2065559381', 1, 34)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (47, N'2065556842', 1, 35)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (48, N'2065557046', 1, 36)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (49, N'2065550065', 1, 37)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (50, N'2065559603', 1, 38)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (51, N'4255551234', 3, 39)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (52, N'2065551113', 1, 40)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (53, N'2065552224', 3, 41)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (54, N'2065552354', 3, 42)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (55, N'3605558886', 1, 43)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (56, N'2065555060', 1, 44)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (57, N'2065550033', 3, 45)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (58, N'2065550853', 1, 46)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (59, N'2065550706', 1, 47)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (60, N'4235551423', 1, 48)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (61, N'2065550006', 2, 48)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (62, N'2065557543', 3, 49)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (63, N'2065558206', 1, 50)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (64, N'2065557102', 3, 51)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (65, N'2065559823', 1, 51)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (66, N'2065559823', 1, 53)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (67, N'2065559723', 1, 54)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (68, N'2065559082', 1, 55)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (69, N'2535551002', 3, 55)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (70, N'2065553297', 1, 56)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (71, N'2535552754', 3, 56)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (72, N'2065553222', 1, 57)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (73, N'3605559001', 3, 57)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (74, N'3605551298', 1, 58)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (75, N'3605558708', 3, 58)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (76, N'2065554343', 1, 59)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (77, N'2065552021', 1, 60)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (78, N'2535557676', 3, 60)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (79, N'2535558731', 3, 61)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (80, N'3605556983', 3, 62)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (81, N'2065554342', 1, 63)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (82, N'2065551254', 1, 64)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (83, N'3605552100', 3, 64)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (84, N'2525554009', 3, 65)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (85, N'2535557812', 3, 66)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (86, N'3605552170', 1, 67)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (87, N'3605552100', 3, 67)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (88, N'2065552301', 1, 68)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (89, N'3605558021', 1, 69)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (90, N'2535559010', 3, 69)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (91, N'2065553278', 1, 70)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (92, N'2065559801', 3, 71)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (93, N'2065554803', 1, 72)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (94, N'3605558715', 3, 73)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (95, N'2535552988', 3, 74)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (96, N'2065551067', 1, 75)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (97, N'2535552968', 3, 75)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (98, N'3605559000', 1, 76)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (99, N'2065552579', 1, 77)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (100, N'3605559809', 1, 78)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (101, N'2065552975', 1, 79)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (102, N'2535556757', 3, 79)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (103, N'2535559802', 3, 80)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (104, N'2535554209', 3, 81)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (105, N'2065552950', 1, 82)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (106, N'3605553421', 3, 83)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (107, N'2065552197', 1, 84)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (108, N'2535558631', 3, 84)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (109, N'2065552910', 1, 85)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (110, N'2065552198', 1, 86)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (111, N'3605559999', 3, 86)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (112, N'2065558134', 3, 87)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (113, N'3605555742', 3, 88)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (114, N'2065553030', 1, 89)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (115, N'2535551209', 3, 89)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (116, N'2065552017', 1, 90)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (117, N'2535550065', 3, 91)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (118, N'2065552132', 1, 92)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (119, N'2535557722', 3, 93)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (120, N'2065550091', 1, 94)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (121, N'2065554444', 1, 95)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (122, N'3695551010', 3, 95)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (123, N'2065553399', 1, 96)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (124, N'2535551000', 3, 96)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (125, N'3605552188', 3, 97)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (126, N'3605556689', 3, 98)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (127, N'2535551069', 3, 99)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (128, N'3605552449', 3, 100)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (129, N'2065552245', 1, 101)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (130, N'2535550087', 3, 101)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (131, N'2065558856', 3, 102)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (132, N'2065553002', 1, 103)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (133, N'2065553021', 1, 104)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (134, N'2065557772', 1, 105)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (135, N'2065558981', 1, 106)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (136, N'3605551821', 3, 106)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (137, N'2535559011', 3, 107)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (138, N'2065559975', 1, 108)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (139, N'3605552112', 3, 108)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (140, N'2535556809', 3, 109)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (141, N'3605551558', 3, 110)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (142, N'3605557766', 3, 111)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (143, N'2965552200', 1, 112)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (144, N'3605552111', 3, 113)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (145, N'3605552398', 1, 114)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (146, N'2065563014', 1, 115)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (147, N'3605552111', 3, 115)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (148, N'2535552009', 3, 116)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (149, N'2065557788', 1, 117)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (150, N'3685553298', 3, 117)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (151, N'2065550087', 1, 118)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (152, N'3635559001', 3, 118)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (153, N'2065556665', 1, 119)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (154, N'2065550000', 1, 120)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (155, N'1005552367', 1, 121)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (156, N'2065558884', 1, 122)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (157, N'3605553212', 3, 122)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (158, N'3605552323', 3, 123)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (159, N'2535557811', 3, 124)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (160, N'2065554499', 1, 125)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (161, N'2065559103', 1, 126)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (162, N'2065551006', 1, 127)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (163, N'2065551217', 2, 127)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (164, N'2065559082', 1, 128)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (165, N'2065552100', 1, 129)
GO
INSERT [dbo].[Contact] ([ContactKey], [ContactNumber], [ContactTypeKey], [PersonKey]) VALUES (166, N'', 2, 129)
GO
SET IDENTITY_INSERT [dbo].[Contact] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactType] ON 

GO
INSERT [dbo].[ContactType] ([ContactTypeKey], [ContactTypeName]) VALUES (1, N'Home Phone')
GO
INSERT [dbo].[ContactType] ([ContactTypeKey], [ContactTypeName]) VALUES (2, N'Work Phone')
GO
INSERT [dbo].[ContactType] ([ContactTypeKey], [ContactTypeName]) VALUES (3, N'Cell Phone')
GO
INSERT [dbo].[ContactType] ([ContactTypeKey], [ContactTypeName]) VALUES (4, N'pager')
GO
INSERT [dbo].[ContactType] ([ContactTypeKey], [ContactTypeName]) VALUES (5, N'fax')
GO
SET IDENTITY_INSERT [dbo].[ContactType] OFF
GO
SET IDENTITY_INSERT [dbo].[Donation] ON 

GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (1, 51, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 157.5000, N'2dcde384-2463-4f07-b12b-96db142d9339')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (2, 53, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 157.5000, N'0e5f230d-ffc2-40a2-ac6b-868543b81f20')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (3, 3, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 500.0000, N'2cbaa8f3-a2e7-4699-9e53-bee2dd481a1f')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (4, 6, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 250.0000, N'67820b76-25bf-4605-b74a-6f4f431f28ce')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (5, 8, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 50.0000, N'bba52b20-1521-4373-9b78-5d7770b92fbe')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (6, 11, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 1500.0000, N'fd1afef9-1af4-4059-928d-25612359efd2')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (7, 13, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 25.0000, N'bbde3e16-90d2-4d8d-92d5-3ec2d7d4933e')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (8, 15, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 100.0000, N'7d95f3b1-b25a-4787-bdbd-8fb9f9afce73')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (9, 19, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 500.0000, N'2523cb4a-b954-40e2-bb6a-7cbce519169c')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (10, 26, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 1200.0000, N'0b478398-3356-4c34-8d93-728136afb18b')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (11, 28, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 2500.0000, N'd365d778-2486-478b-8244-2cfb4b9ab569')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (12, 3, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 500.0000, N'591e4c5b-2fe2-4144-b495-8dad3e9d4988')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (13, 29, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 100.0000, N'b4de4f09-7257-4c76-af8b-ae5294c94903')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (14, 31, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 5000.0000, N'cee40d11-cdf2-414d-84e2-68b523befe36')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (15, 33, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 50.0000, N'b9c882b3-b23b-46a9-8c85-c51441bc62ed')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (16, 35, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 100.0000, N'2af1d27b-dfe0-4044-a51d-f6e6a78034a4')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (17, 38, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 500.0000, N'82cb8bb3-42aa-4a18-9379-47dc8e6b7b7a')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (18, 40, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 2500.0000, N'77c752ec-8ed5-4175-afa3-d27167820257')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (19, 41, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 1500.0000, N'0ee758ae-57f7-4a83-bfdf-7d618172b5db')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (20, 42, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 50.0000, N'0fc23989-2581-44a0-bb69-32e1ea9d2b5c')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (21, 48, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 250.0000, N'4733b860-b749-4bce-84b4-bc0b3f1b114d')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (22, 50, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 150.0000, N'413f788b-0f11-4999-82ce-e1acc348e80b')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (23, 3, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 500.0000, N'd8b0645b-44c3-42ba-8cf2-50ad6d1f859f')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (24, 54, CAST(N'2015-08-09 10:02:44.220' AS DateTime), 320.5000, N'dfe8c950-0018-4923-928d-9c282d35dff5')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (25, 1, CAST(N'2015-08-10 15:42:48.633' AS DateTime), 345.9000, N'6845ee6c-437b-4b93-ad52-22771118bf31')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (26, 6, CAST(N'2015-08-10 16:05:46.977' AS DateTime), 375.0000, N'76de3784-20a7-4604-99ac-7281ebf71d98')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (27, 11, CAST(N'2015-08-10 16:10:06.180' AS DateTime), 290.5600, N'dac49a43-f5b9-4e5c-a522-b7ec036ebbfa')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (28, 56, CAST(N'2015-08-11 19:52:14.920' AS DateTime), 578.5500, N'6dd92fba-d0b3-4476-9478-c5574d3f7bd6')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (29, 57, CAST(N'2015-08-11 20:00:35.890' AS DateTime), 245.3800, N'2f89fd09-12eb-4248-ba69-3b0aca4a06ec')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (30, 58, CAST(N'2015-08-11 20:38:49.217' AS DateTime), 982.4500, N'bdd24ee3-f515-416a-8976-ad49c9a99d9a')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (31, 67, CAST(N'2015-08-17 11:50:12.797' AS DateTime), 535.5000, N'34fccf1a-74f4-437d-9dc4-8f47f7c28edc')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (32, 69, CAST(N'2015-08-17 11:56:23.330' AS DateTime), 500.0000, N'5120e8f9-219e-48de-a8f8-b4912b2b0ac2')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (33, 71, CAST(N'2015-08-18 10:32:06.773' AS DateTime), 235.5500, N'336eb73f-a036-45ab-8417-30b30dae399c')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (34, 75, CAST(N'2015-08-18 10:58:44.223' AS DateTime), 2000.0000, N'cb39c7b4-18fd-4cdc-8119-ced753f94b6e')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (35, 76, CAST(N'2015-08-18 11:00:29.067' AS DateTime), 6000.0000, N'c035c825-b594-422d-a6c5-8e899ebc2f1a')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (36, 77, CAST(N'2015-08-18 11:08:12.253' AS DateTime), 2000.0000, N'2eed0d42-1e7a-4eb0-a562-7241467afaf0')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (37, 11, CAST(N'2015-08-18 11:10:49.173' AS DateTime), 980.5500, N'52005469-f6df-48a5-9370-a502a65192b5')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (38, 29, CAST(N'2015-08-18 11:12:17.420' AS DateTime), 678.9300, N'4079b9b8-965a-4ef5-8643-8f6fb9100a35')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (39, 78, CAST(N'2015-08-18 11:14:25.303' AS DateTime), 12150.5500, N'c1a1e3a1-4a35-493e-9efa-0afcf7c1f1c0')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (40, 79, CAST(N'2015-08-18 11:18:07.060' AS DateTime), 450.7500, N'c9103e72-f5ea-4d04-a960-3acc8a12c57b')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (41, 96, CAST(N'2015-08-24 12:59:40.990' AS DateTime), 2450.0000, N'1224c286-99f5-4215-b5d1-67e14cf4a079')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (42, 114, CAST(N'2015-09-03 10:46:27.660' AS DateTime), 1200.0000, N'fea9c027-4540-4a3f-9eb3-170759d55ab9')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (43, 115, CAST(N'2015-09-05 14:15:23.663' AS DateTime), 800.0000, N'9f302bcb-77da-41b0-b6c2-a7b121aa45d2')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (44, 121, CAST(N'2015-09-05 14:32:14.907' AS DateTime), 2500.0000, N'0a641db3-097b-4f09-94cf-887d5c0b43bc')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (45, 122, CAST(N'2015-09-11 12:41:37.537' AS DateTime), 200.0000, N'5ae24b7e-0fb9-4f88-a785-f9c38988583c')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (46, 127, CAST(N'2016-02-14 11:42:30.597' AS DateTime), 550.0000, N'3f26881a-9d40-4f36-9f96-13d80bf009c4')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (47, 129, CAST(N'2016-02-27 14:50:59.687' AS DateTime), 255.9000, N'cc66f9d4-9384-4f5d-8d12-60ede376a658')
GO
INSERT [dbo].[Donation] ([DonationKey], [PersonKey], [DonationDate], [DonationAmount], [DonationConfirmation]) VALUES (48, 3, CAST(N'2016-04-25 12:58:19.937' AS DateTime), 1000.0000, N'bf7893ea-6822-4a3a-be34-a50c96582785')
GO
SET IDENTITY_INSERT [dbo].[Donation] OFF
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

GO
INSERT [dbo].[Employee] ([EmployeeKey], [PersonKey], [EmployeeHireDate], [EmployeeAnnualSalary]) VALUES (1, 5, CAST(N'2005-02-21' AS Date), 65000.0000)
GO
INSERT [dbo].[Employee] ([EmployeeKey], [PersonKey], [EmployeeHireDate], [EmployeeAnnualSalary]) VALUES (2, 12, CAST(N'2006-05-05' AS Date), 60151.4000)
GO
INSERT [dbo].[Employee] ([EmployeeKey], [PersonKey], [EmployeeHireDate], [EmployeeAnnualSalary]) VALUES (3, 18, CAST(N'2007-03-10' AS Date), 0.0000)
GO
INSERT [dbo].[Employee] ([EmployeeKey], [PersonKey], [EmployeeHireDate], [EmployeeAnnualSalary]) VALUES (4, 23, CAST(N'2007-03-10' AS Date), 0.0000)
GO
INSERT [dbo].[Employee] ([EmployeeKey], [PersonKey], [EmployeeHireDate], [EmployeeAnnualSalary]) VALUES (5, 47, CAST(N'2012-01-15' AS Date), 63505.2800)
GO
INSERT [dbo].[Employee] ([EmployeeKey], [PersonKey], [EmployeeHireDate], [EmployeeAnnualSalary]) VALUES (6, 7, CAST(N'2013-04-21' AS Date), 21605.4000)
GO
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (1, 1)
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (2, 1)
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (3, 2)
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (4, 5)
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (5, 3)
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (5, 4)
GO
INSERT [dbo].[EmployeePosition] ([PositionKey], [EmployeeKey]) VALUES (5, 6)
GO
SET IDENTITY_INSERT [dbo].[GrantRequest] ON 

GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (2, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 4, 1, N'We have two children and are running low of money for groceries this month', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (3, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 14, 3, N'We can''t afford childcare this month, but need to use it if we are going to work', 180.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (4, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 27, 7, N'Our Utilities bills have been extra high this month because of the excessive heat', 300.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (5, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 9, 1, N'Our food stamps have been reduced and we can''t afford basic groceries', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (6, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 39, 10, N'The kids need clothes for the upcoming school year', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (7, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 25, 1, N'We have run short of food money', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (8, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 25, 8, N'The pipe in our bathroom broke and ruined the floor', 500.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (9, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 1, 4, N'I just got a new job and need a bus pass. After I have gotten a paycheck I can afford my own.', 100.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (10, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 1, 1, N'Food money is short and we don''t qualify for food stamps', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (11, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 16, 2, N'I need to have a treatment for skin condition', 800.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (12, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 20, 1, N'We are going to be short of rent this coming month because of some unexpected bills. We have talked to the landlord but he is unwilling to let us pay late.', 600.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (13, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 25, 1, N'Kids need food.', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (14, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 39, 1, N'Food stamps have run out, but still need to feed the kids', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (15, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 17, 6, N'I need to have several fillings. I have insurance, but can''t afford the part I have to pay.', 475.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (16, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 49, 10, N'Need clothes for school', 100.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (17, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 45, 7, N'Our landlord requires us to maintain the lawn, but we can''t afford the water bill.', 133.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (18, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 37, 9, N'Need Help paying tuition for Fall classes', 500.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (19, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 34, 1, N'Empty cupboards', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (20, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 34, 2, N'We are short of our rent payment this month', 850.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (21, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 16, 2, N'The rent payment has gone up and we weren''t prepared for the increase in expenses.', 500.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (22, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 25, 1, N'Food prices have gone up. Our budget won''t stretch through the month.', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (23, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 27, 1, N'Can''t afford food this month', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (24, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 27, 3, N'Have a new job and need child care until I can get a paycheck or two', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (25, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 21, 9, N'Need help with Fall Tuition', 500.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (26, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 9, 7, N'Utilities were unexpectedly high this month', 197.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (27, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 43, 1, N'Kids need Food', 75.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (28, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 24, 8, N'Roof is leaking need to repair before Autumn', 475.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (29, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 22, 3, N'Need child care while training for my job', 250.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (30, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 45, 2, N'Can''t pay rent', 1200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (31, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 46, 9, N'Need Help with Fall Tuition', 1200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (32, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 39, 5, N'My Doctor says I must have a colonoscopy. I have some insurance but cannot pay the deducttable.', 400.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (33, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 32, 10, N'We need school clothes for three elementary school students', 175.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (34, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 26, 8, N'Need plumming repairs in the Kitchen', 367.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (35, CAST(N'2015-08-09 15:44:13.000' AS DateTime), 36, 6, N'I need a tooth extraction and can''t afford it', 475.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (36, CAST(N'2015-08-16 10:32:28.000' AS DateTime), 59, 4, N'I need a bus pass to get me to work until I can get my first pay check', 65.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (37, CAST(N'2015-08-16 11:30:05.000' AS DateTime), 60, 7, N'I just need a one time grant to cover an unexpected water bill--the result of a leak', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (38, CAST(N'2015-08-16 11:32:27.000' AS DateTime), 61, 9, N'Need to buy supplies for three elementary school students', 125.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (39, CAST(N'2015-08-16 11:39:31.000' AS DateTime), 62, 13, N'I need money to go to a one time training to keep my job', 500.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (40, CAST(N'2015-08-16 11:48:00.000' AS DateTime), 63, 3, N'Need childcare for short term while Training for job', 85.5000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (41, CAST(N'2015-08-16 11:50:26.000' AS DateTime), 64, 5, N'Need to pay an emergency room bill from three months ago', 450.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (42, CAST(N'2015-08-16 11:52:25.000' AS DateTime), 65, 8, N'Floor in kitchen ruined by a bad dishwasher', 345.6600)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (43, CAST(N'2015-08-16 11:56:17.000' AS DateTime), 66, 2, N'One of my roommates left without paying his share of the rent. We are getting a new roommate as soon as possible', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (44, CAST(N'2015-08-17 11:53:36.000' AS DateTime), 68, 9, N'Need supplies and clothes for 2 children  in Elementary school', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (45, CAST(N'2015-08-17 11:59:04.000' AS DateTime), 70, 3, N'I need child care for a couple of days while I go in for surgery', 250.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (46, CAST(N'2015-08-18 10:36:18.000' AS DateTime), 72, 9, N'My financial aid doesn''t cover text books', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (47, CAST(N'2015-08-18 10:38:58.000' AS DateTime), 73, 1, N'I have no money left for food after college and room expenses', 120.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (48, CAST(N'2015-08-18 10:41:57.000' AS DateTime), 74, 13, N'My father has become quite ill. I don''t have the money to go visit him', 300.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (49, CAST(N'2015-08-19 15:49:09.000' AS DateTime), 80, 13, N'I need a little extra to fly home to visit my father in Vietnam', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (50, CAST(N'2015-08-19 15:51:35.000' AS DateTime), 81, 9, N'I need money for books. I have paid for all the rest', 320.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (51, CAST(N'2015-08-19 15:53:51.000' AS DateTime), 82, 10, N'Need clothes to attend a wedding', 150.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (52, CAST(N'2015-08-19 15:57:31.000' AS DateTime), 83, 8, N'Roof sprang a leak. This is amount is the difference between what I can afford and what it will cost', 356.9000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (53, CAST(N'2015-08-19 15:59:48.000' AS DateTime), 84, 3, N'Need temporary childcare while I look for work', 250.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (54, CAST(N'2015-08-19 16:02:53.000' AS DateTime), 85, 6, N'I need a filling and have no dental insurance. This would be the down payment. I would make monthly payments after that', 345.2100)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (55, CAST(N'2015-08-24 11:59:41.000' AS DateTime), 86, 4, N'I need a one month buss pass until I start getting paychecks', 255.5000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (56, CAST(N'2015-08-24 12:37:23.000' AS DateTime), 87, 5, N'Had foot surgery. Paid for all I could', 432.7500)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (57, CAST(N'2015-08-24 12:39:24.000' AS DateTime), 88, 13, N'I need money to travel to a job interview', 450.7500)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (58, CAST(N'2015-08-24 12:41:50.000' AS DateTime), 89, 7, N'Need to pay electricity or they will shut it off', 150.6600)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (59, CAST(N'2015-08-24 12:43:57.000' AS DateTime), 90, 6, N'I have no insurance and need a crown badly', 689.9900)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (60, CAST(N'2015-08-24 12:45:47.000' AS DateTime), 91, 3, N'I need child care for three weeks while I train for my new job', 300.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (61, CAST(N'2015-08-24 12:48:04.000' AS DateTime), 92, 8, N'I need emergency roof repair', 454.5000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (62, CAST(N'2015-08-24 12:51:23.000' AS DateTime), 93, 13, N'My mother broke her hip and has no one to watch her. I need to fly back to help out for a couple of weeks', 550.4400)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (63, CAST(N'2015-08-24 12:53:22.000' AS DateTime), 94, 8, N'The bathroom floor needs serious repair', 450.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (64, CAST(N'2015-08-24 12:56:58.000' AS DateTime), 95, 7, N'Because of a broken pipe my water bill is extremely high. I have had the pipe repaired', 250.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (65, CAST(N'2015-08-24 13:02:11.000' AS DateTime), 97, 9, N'I need to attend a seminar for my job but the employer won''t pay for it', 250.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (66, CAST(N'2015-08-24 13:05:57.000' AS DateTime), 98, 6, N'I need to have my wisdom teeth extracted', 545.5500)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (67, CAST(N'2015-08-27 20:51:08.000' AS DateTime), 99, 4, N'Need a bus pass for one month to start school', 255.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (68, CAST(N'2015-08-27 20:55:21.000' AS DateTime), 100, 1, N'I have run out of foodstamps, and money', 200.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (69, CAST(N'2015-08-27 20:58:29.000' AS DateTime), 101, 9, N'I need to take a class to become certified for employment', 545.5000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (70, CAST(N'2015-08-27 21:03:18.000' AS DateTime), 102, 8, N'Back door broken need it fixed for safety', 230.4000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (71, CAST(N'2015-08-28 17:28:37.000' AS DateTime), 103, 9, N'This is the cost of books beyond which my financial aide covers', 234.9900)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (72, CAST(N'2015-08-28 20:03:18.000' AS DateTime), 104, 3, N'I need childcare during my first month of work', 300.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (73, CAST(N'2015-08-28 20:08:45.000' AS DateTime), 105, 8, N'Need to buy lumber to build a wheelchair rampon the house', 476.5500)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (74, CAST(N'2015-08-28 20:11:00.000' AS DateTime), 106, 6, N'Need a root canal and have no insurance', 450.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (75, CAST(N'2015-08-28 20:14:27.000' AS DateTime), 107, 13, N'Need to air fair home to help my ailing father', 675.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (76, CAST(N'2015-08-30 20:46:16.000' AS DateTime), 108, 7, N'I need to fill up the oil tank before winter', 230.2000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (77, CAST(N'2015-08-30 20:48:20.000' AS DateTime), 109, 3, N'Need help with childcare', 140.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (78, CAST(N'2015-09-01 18:10:35.000' AS DateTime), 110, 9, N'Need graphing calculator for myhigh school student', 136.7700)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (79, CAST(N'2015-09-01 18:13:05.000' AS DateTime), 111, 6, N'Emergency Dental Care', 420.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (80, CAST(N'2015-09-01 18:15:23.000' AS DateTime), 112, 8, N'Porch unsafe needs rebuilt', 245.5500)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (81, CAST(N'2015-09-01 18:18:55.000' AS DateTime), 113, 2, N'Because of illness I missed a few days of work and can''t make the rent payment this month', 400.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (82, CAST(N'2015-09-05 14:18:29.000' AS DateTime), 116, 4, N'Need to rent a car to go to my uncle''s funeral', 324.5500)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (83, CAST(N'2015-09-05 14:21:11.000' AS DateTime), 117, 5, N'Need x-rays for possible cancer', 400.9000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (84, CAST(N'2015-09-05 14:24:17.000' AS DateTime), 118, 8, N'Need to replace broken front windows', 476.9900)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (85, CAST(N'2015-09-05 14:26:43.000' AS DateTime), 119, 8, N'I need a mower to cut my lawn because of city ordinance', 285.7700)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (86, CAST(N'2015-09-05 14:29:32.000' AS DateTime), 120, 10, N'Need to replace a very long, very rare scarf', 175.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (87, CAST(N'2015-09-11 12:44:07.000' AS DateTime), 123, 4, N'Need a monthly bus pass', 78.9000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (88, CAST(N'2015-09-11 12:46:51.000' AS DateTime), 124, 3, N'Need childcare while starting new job', 250.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (89, CAST(N'2015-09-11 12:49:12.000' AS DateTime), 125, 9, N'need money for retraining for job hunt', 540.0000)
GO
INSERT [dbo].[GrantRequest] ([GrantRequestKey], [GrantRequestDate], [PersonKey], [GrantTypeKey], [GrantRequestExplanation], [GrantRequestAmount]) VALUES (91, CAST(N'2016-02-20 14:28:43.533' AS DateTime), 128, 1, N'Food or Books', 128.5000)
GO
SET IDENTITY_INSERT [dbo].[GrantRequest] OFF
GO
SET IDENTITY_INSERT [dbo].[GrantReview] ON 

GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (2, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 2, N'approved', 180.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (3, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 3, N'denied', 300.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (4, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 4, N'approved', 75.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (5, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 5, N'Approved', 200.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (6, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 6, N'approved', 75.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (7, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 7, N'approved', 500.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (8, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 8, N'Approved', 100.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (9, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 9, N'approved', 75.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (10, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 10, N'denied', 800.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (11, CAST(N'2015-08-10 00:00:00.000' AS DateTime), 11, N'approved', 600.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (12, CAST(N'2015-10-11 00:00:00.000' AS DateTime), 12, N'approved', 75.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (13, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 13, N'approved', 75.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (14, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 14, N'denied', 475.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (15, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 15, N'approved', 100.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (16, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 16, N'approved', 133.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (17, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 17, N'denied', 500.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (18, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 18, N'approved', 75.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (19, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 19, N'approved', 850.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (20, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 20, N'approved', 500.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (21, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 21, N'approved', 75.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (22, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 22, N'approved', 75.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (23, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 23, N'approved', 200.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (24, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 24, N'denied', 500.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (25, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 25, N'approved', 197.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (26, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 26, N'Approved', 75.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (27, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 27, N'approved', 475.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (28, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 28, N'approved', 250.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (29, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 29, N'Denied', 1200.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (30, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 30, N'denied', 1200.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (31, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 31, N'denied', 400.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (32, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 32, N'approved', 175.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (33, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 33, N'approved', 367.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (34, CAST(N'2015-08-11 00:00:00.000' AS DateTime), 34, N'denied', 475.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (35, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 35, N'Approved', 65.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (36, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 36, N'approved', 200.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (37, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 37, N'approved', 125.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (38, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 38, N'approved', 500.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (39, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 39, N'approved', 85.5000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (40, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 40, N'Reduced', 200.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (41, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 41, N'Approved', 345.6600, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (42, CAST(N'2015-08-16 00:00:00.000' AS DateTime), 42, N'approved', 200.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (43, CAST(N'2015-08-18 00:00:00.000' AS DateTime), 43, N'approved', 200.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (44, CAST(N'2015-08-18 00:00:00.000' AS DateTime), 44, N'approved', 250.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (45, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 45, N'approved', 200.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (46, CAST(N'2015-08-18 00:00:00.000' AS DateTime), 46, N'approved', 120.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (47, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 47, N'approved', 300.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (48, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 48, N'approved', 200.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (49, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 49, N'Approved', 320.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (50, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 50, N'denied', 150.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (51, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 51, N'Approved', 356.9000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (52, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 52, N'approved', 250.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (53, CAST(N'2015-08-19 00:00:00.000' AS DateTime), 53, N'approved', 345.2100, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (54, CAST(N'2015-08-24 00:00:00.000' AS DateTime), 54, N'Approved', 255.5000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (55, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 55, N'Approved', 432.7500, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (56, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 56, N'Approved', 450.7500, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (57, CAST(N'2015-08-13 00:00:00.000' AS DateTime), 57, N'Reduced', 50.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (58, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 58, N'Reduced', 189.9900, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (59, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 59, N'approved', 300.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (60, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 60, N'Approved', 454.5000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (61, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 61, N'Reduced', 340.9600, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (62, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 62, N'Reduced', 300.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (63, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 63, N'Reduced', 100.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (64, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 64, N'Denied', 0.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (65, CAST(N'2015-08-26 00:00:00.000' AS DateTime), 65, N'Reduced', 145.5500, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (66, CAST(N'2015-08-28 00:00:00.000' AS DateTime), 66, N'Reduced', 125.5000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (67, CAST(N'2015-08-28 00:00:00.000' AS DateTime), 67, N'approved', 200.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (68, CAST(N'2015-08-28 00:00:00.000' AS DateTime), 68, N'denied', 0.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (69, CAST(N'2015-08-28 00:00:00.000' AS DateTime), 69, N'approved', 230.4000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (70, CAST(N'2015-08-30 00:00:00.000' AS DateTime), 70, N'Reduced', 100.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (71, CAST(N'2015-08-30 00:00:00.000' AS DateTime), 71, N'approved', 300.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (72, CAST(N'2015-08-30 00:00:00.000' AS DateTime), 72, N'approved', 476.5500, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (73, CAST(N'2015-08-30 00:00:00.000' AS DateTime), 73, N'Reduced', 200.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (74, CAST(N'2015-08-30 00:00:00.000' AS DateTime), 74, N'approved', 675.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (75, CAST(N'2015-09-03 00:00:00.000' AS DateTime), 75, N'approved', 230.2000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (76, CAST(N'2015-09-03 00:00:00.000' AS DateTime), 76, N'approved', 140.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (77, CAST(N'2015-09-03 00:00:00.000' AS DateTime), 77, N'approve', 136.7700, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (78, CAST(N'2015-09-03 00:00:00.000' AS DateTime), 78, N'reduced', 120.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (79, CAST(N'2015-09-03 00:00:00.000' AS DateTime), 79, N'approved', 245.5500, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (80, CAST(N'2015-09-03 00:00:00.000' AS DateTime), 80, N'approved', 400.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (81, CAST(N'2015-09-06 00:00:00.000' AS DateTime), 81, N'approved', 324.5500, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (82, CAST(N'2015-09-06 00:00:00.000' AS DateTime), 82, N'approved', 400.9000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (83, CAST(N'2015-09-06 00:00:00.000' AS DateTime), 83, N'approved', 476.9900, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (84, CAST(N'2015-09-06 00:00:00.000' AS DateTime), 84, N'Reduced', 175.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (85, CAST(N'2015-09-06 00:00:00.000' AS DateTime), 85, N'denied', 0.0000, 5)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (86, CAST(N'2015-09-13 00:00:00.000' AS DateTime), 86, N'approved', 78.9000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (87, CAST(N'2015-09-13 00:00:00.000' AS DateTime), 87, N'approved', 250.0000, 2)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (88, CAST(N'2015-09-13 00:00:00.000' AS DateTime), 88, N'approved', 540.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (89, CAST(N'2015-09-13 00:00:00.000' AS DateTime), 89, N'approved', 400.0000, 6)
GO
INSERT [dbo].[GrantReview] ([GrantReviewKey], [GrantReviewDate], [GrantRequestKey], [GrantRequestStatus], [GrantAllocationAmount], [EmployeeKey]) VALUES (90, CAST(N'2016-02-20 15:43:42.007' AS DateTime), 91, N'Reduced', 100.0000, 6)
GO
SET IDENTITY_INSERT [dbo].[GrantReview] OFF
GO
SET IDENTITY_INSERT [dbo].[GrantReviewComment] ON 

GO
INSERT [dbo].[GrantReviewComment] ([GrantReviewCommentKey], [GrantReviewKey], [EmployeeKey], [GrantReviewCommentDate], [GrantReviewNote]) VALUES (1, 3, 5, CAST(N'2013-08-11 00:00:00.000' AS DateTime), N'<reviewnote xmlns="http://www.community_assist.org/reviewnotes"><comment>This is a continuing request. We need to make sure they find other funds</comment><concerns><concern>We can''t continue to pay these requests</concern><concern>We have counciled them, but it hasn'' helped</concern></concerns><recommendation>Deny</recommendation></reviewnote>')
GO
INSERT [dbo].[GrantReviewComment] ([GrantReviewCommentKey], [GrantReviewKey], [EmployeeKey], [GrantReviewCommentDate], [GrantReviewNote]) VALUES (2, 3, 5, CAST(N'2013-08-11 00:00:00.000' AS DateTime), N'<reviewnote xmlns="http://www.community_assist.org/reviewnotes"><comment>What other options do they have?</comment><concerns><concern>Do they have other options</concern></concerns><recommendation>Deny</recommendation></reviewnote>')
GO
INSERT [dbo].[GrantReviewComment] ([GrantReviewCommentKey], [GrantReviewKey], [EmployeeKey], [GrantReviewCommentDate], [GrantReviewNote]) VALUES (3, 10, 5, CAST(N'2013-08-11 00:00:00.000' AS DateTime), N'<reviewnote xmlns="http://www.community_assist.org/reviewnotes"><comment>Other funds are available</comment><concerns><concern>Better funding options</concern></concerns><recommendation>Deny</recommendation></reviewnote>')
GO
INSERT [dbo].[GrantReviewComment] ([GrantReviewCommentKey], [GrantReviewKey], [EmployeeKey], [GrantReviewCommentDate], [GrantReviewNote]) VALUES (4, 14, 5, CAST(N'2013-08-11 00:00:00.000' AS DateTime), N'<reviewnote xmlns="http://www.community_assist.org/reviewnotes"><comment>This is a continuing request. We need to make sure they find other funds</comment><concerns><concern>We can''t continue to pay these requests</concern></concerns><recommendation>Deny</recommendation></reviewnote>')
GO
SET IDENTITY_INSERT [dbo].[GrantReviewComment] OFF
GO
SET IDENTITY_INSERT [dbo].[GrantType] ON 

GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (1, N'Food', 200.0000, 1000.0000, N'assistance for purchasing groceries')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (2, N'Rent', 900.0000, 2700.0000, N'assistance for monthly Rent payments')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (3, N'Child care', 300.0000, 1000.0000, N'assistance for childcare expenses')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (4, N'Transportation', 250.0000, 500.0000, N'assistance for transportation to and from work')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (5, N'Medical', 1200.0000, 5000.0000, N'assistance with medical bills')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (6, N'Dental', 950.0000, 5000.0000, N'assistance with dental bills')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (7, N'Utilities', 250.0000, 1000.0000, N'help with monthly utilites')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (8, N'home repair', 800.0000, 5000.0000, N'one time assistance with home repair')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (9, N'Education', 700.0000, 2100.0000, N'help with worker retraining')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (10, N'Clothes', 200.0000, 800.0000, N'help especially with cothes for job search or work clothes')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (11, N'Funerary', 1500.0000, 1500.0000, N'assistence for funeral costs')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (12, N'holiday', 300.0000, 750.0000, N'holiday assistance (food, gifts, etc)')
GO
INSERT [dbo].[GrantType] ([GrantTypeKey], [GrantTypeName], [GrantTypeMaximum], [GrantTypeLifetimeMaximum], [GrantTypeDescription]) VALUES (13, N'Emergency travel', 1000.0000, 1000.0000, N'assistance for emergancy travel needs')
GO
SET IDENTITY_INSERT [dbo].[GrantType] OFF
GO
SET IDENTITY_INSERT [dbo].[LoginHistoryTable] ON 

GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (1, 8, CAST(N'2016-02-07 14:43:14.367' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (2, 41, CAST(N'2016-02-07 14:45:38.530' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (3, 3, CAST(N'2016-02-14 10:54:40.883' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (4, 3, CAST(N'2016-02-14 10:59:55.960' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (5, 23, CAST(N'2016-02-14 11:13:55.210' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (6, 3, CAST(N'2016-02-14 11:19:58.573' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (7, 5, CAST(N'2016-02-14 11:22:34.943' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (8, 23, CAST(N'2016-02-14 11:24:15.970' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (9, 23, CAST(N'2016-02-14 11:27:37.740' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (10, 129, CAST(N'2016-02-27 14:33:53.540' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (11, 129, CAST(N'2016-02-27 14:35:11.530' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (12, 129, CAST(N'2016-02-27 14:48:23.460' AS DateTime))
GO
INSERT [dbo].[LoginHistoryTable] ([LoginHistoryKey], [PersonKey], [LoginTimeStamp]) VALUES (13, 129, CAST(N'2016-02-27 14:50:54.150' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[LoginHistoryTable] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (1, N'Anderson', N'Jay', N'JAnderson@gmail.com', 0x193B2D14F98BCFB4CD6636C9427ABE36ADE4A24816A1B0E46F6D9A3398590CEBFD4916D800F0F3789432D21619E8A618BA135EE54F3408B7336C0F47997C1449, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5595738)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (2, N'Zimmerman', N'Toby', N'TZimmerman@gmail.com', 0xCD7647163152599BC358D449D0232934CA7C1F9F5F6640F92D4C2EE123A1BEBD36B6FBF5CD73D6B66FCA58D0DD797F866DE0D18832D6C5BFA402DEAB07AD858D, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 4123155)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (3, N'Mann', N'Louis', N'LMann@gmail.com', 0x834F8D18672B2DC58FC2BDA587047EADA59AC32F92EBDA708FF8BAA68CAC4A024CC2726CAC55FDE7079F6781C8D3F9D19EA525A99C5D4565CF022EA8E0BE9411, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (4, N'Carmel', N'Bob', N'BCarmel@gmail.com', 0x23FFE89EC481DF51C4F2D9CA4E3CE2BD7748EAA325D5CB14A930D3D215FF5973D59D47A65369566C8B78B605F4A776CC462F92EE549C02FF532E249FE9D47FDF, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (5, N'Lewis', N'Mary', N'MLewis@gmail.com', 0x7CB51A4CD9CAAE8D92EF793784A3AD03B310BC667480D663780AA26782CA94293C6FF8006AADDEB5C55D712A01935005A64C3D43AAEEF1E9DB2FB1D8E27177F3, CAST(N'2001-02-21 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (6, N'Tanner', N'Thomas', N'TTanner@gmail.com', 0x065F3655D5FB3F0003ED4F156FC11EB6B364618CBFBB6B27866A732C64DCD15F555A03D0F5B47C383D10EBBE55F26D309C8E1AF715BD4668733E019AE9265089, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (7, N'Patterson', N'Jody', N'JPatterson@gmail.com', 0x788022F0B685F018D49D0A8AD36A2EBE67168933B84194FAD6F535ED3F62812BC36C6C51D6FDB9939B31DB4D1542CE68405C3BDCF04775050F4327C2972C8928, CAST(N'2009-04-21 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (8, N'Brown', N'Matt', N'MBrown@gmail.com', 0xC6E191295C0F53843C2E23F64A7565F8F1B7E94DDC4985ECC59DE5F2BA47CB35F640CC9C1DF52BA16D8F0641BE955E747D4A8DDDA9401CFCAE5F799B6D0C5ABD, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (9, N'Smith', N'Jerry', N'JSmith@gmail.com', 0xB271CF0464F0B83ACED9C8844CEAFB75ADA1C8124A336046223335470FBFD700717887FB8E186E07147CB471D2B16DBAFCC4C63675D69D1CEA958DA10DBAA484, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (10, N'Peters', N'Jay', N'JPeters@gmail.com', 0x679C42DCEC330194939C238B6117469773541B7D53E08C778B2B6A2083F77E69B3C54A7BE1162FC199E6911966871CFE5937F27984FC6D08C826F701786016EA, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (11, N'Masters', N'Fae', N'FMasters@gmail.com', 0x786C12A0F0B960197DA6FD354C795C885B4B963C25340EB40F73AA9EB97B3A26798F6AF792FAF80DD9132FA55115C60F81EE6EE4B8246F5333B986EF25D68FF7, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 7352400)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (12, N'Moon', N'Tina', N'TMoon@gmail.com', 0x55337F581FC6EC53B0A813172ACD2F4A4E925DF740DF5EA6D13DBA2FAD77AD6278DE1B8A4A88652B347D8F1B5384CC229E70E313F3E78E907D640E072BE56C41, CAST(N'2002-05-05 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (13, N'Nguyen', N'Lu', N'LNguyen@gmail.com', 0x4761F568688352850EC66F1239C8FAF4BB3045B75E5612BFDFFE8A9903796A6DB1C1BDD761A5954D1993FDA8775A72BAD18620B11330D62D1D9403EB2933A49E, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (14, N'Chau', N'Mary', N'MChau@gmail.com', 0xDCEE78E6A96463F153242D01B6AA7A7CD2ABA67415CF77C3D8DE2DA78E9DC2251F2677EDE352FA5EE2F1A848BADED4230C421B96930D9C55349625198599F481, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (15, N'Kerry', N'Anne', N'AKerry@gmail.com', 0x76EDA644E122246A4FB24BE4885418F1F9917743766E8CB87E7678EB167A4983D945C5678CA2C61AAF60528C31BE261514FA5A986765860FF10FBA9DF54B16C5, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (16, N'Robinson', N'Mike', N'MRobinson@gmail.com', 0x7A199CD2B452DC6A085B43BC9BFBF43695CB47F29D0BDC3B612C0ACDB9DD890788C19BD069D3FA2A88BC7096CAED4385098FF6F0DD1982ED4516D6EDD7B8D966, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (17, N'Martin', N'Taylor', N'TMartin@gmail.com', 0x9B5912E40256C315166781694D66DC542676CAF95AB30AFDF2002B3F015FFAABD3C314BF74FB974E61542DFDF88A46265A027D7281CB761E044E9ED81E90D2FA, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (18, N'McGraw', N'Alysson', N'AMcGraw@gmail.com', 0x1F811F2E3F0BD5342AB8B41A48918C458018D7C5B890D6489C634CC823F20CDC2CBABDC3F5BD3254BD40EF8D614CF19FF5DFB60F0D83F9ED9C287A69B5E4201C, CAST(N'2003-03-10 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (19, N'Morgan', N'Cheryl', N'CMorgan@gmail.com', 0x63CDFE39273422B01C183A21707623A0FC52BE35EBC29B12A9677BF7F6D1EDB24B024F965CCC45846942FECD277BDEB3982C12AF9758C6239236CA19817F25D4, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (20, N'Tan', N'Lee', N'LTan@gmail.com', 0x35B70A658BC8BC492C4DE057A91B2BAE0E80D108B5D879C466E8219A147C5829A27C47D2B076FFC888DB7D1986C26F26D33120B0B8597EE01524613D9A84C792, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (21, N'Jameson', N'Roberto', N'RJameson@gmail.com', 0xF86D3C5BEFBE38C3BF689010D417677BE523AEA9EBBF53C6D0D8AB7DAB1584462BD3B3972F39C930C202C327AB9EFABD00B219E8D58470945F76AC6B0F92985F, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (22, N'Banner', N'June', N'JBanner@gmail.com', 0xB7730A0D461BC9A11869682D508A560C45B718D1799D8A9BEC1950F477016FD869B195B76371E50031E8D7A4415B0696489D4E5D29C08C30EE50B9D959EB1BD6, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1581646)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (23, N'Lee', N'Tracy', N'TLee@gmail.com', 0xDFF80C2B18553733BF711AF187317EFC2A142964C75947CDE070C3A42E7E9F580566E39CDA22093E2FC02B92F92F2FA17B4B6087E2E2B6AB0A9959A66434977B, CAST(N'2003-03-10 00:00:00.000' AS DateTime), 9109062)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (24, N'Fabre', N'Jill', N'JFabre@gmail.com', 0xBBE81CEEF78868D943B5DA4F9C9DF3B350E8D65E0CF09066AC1EE57CFA8C93F6D3F07DC9E98633221EE47E0E7C0719FC5BB0FAECDC145D3748E2C291B160C150, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (25, N'Gardner', N'Tom', N'TGardner@gmail.com', 0xA5ABA98363F619D59466818DB5E716C63ECB713261D626239867A36F954BC59090AFD0297CB8F3DE59430C0FCE72FBAAB7AA03E2D6EFC1B1EE4A22DD1150FC1C, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (26, N'Yesler', N'Bill', N'BYesler@gmail.com', 0x13F4A296D95A298BFD23BF280B293615E33987AD08B7FF4CC898081354247553FA3AADA66959EB5DF0DF176EF3E04F5E62DFE839C185417A120A7D99DDAEC68E, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (27, N'Caroll', N'Lisa', N'LCaroll@gmail.com', 0x271DBBFF71B8B0097C0780530E07826BD3043B0D0BB7E2E4144E99C2334AD0BCD9A31A5EED1B6D89C00CCBEE389683D80A406E8F6AF7D542DCEDB62C28212931, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (28, N'Lamont', N'Tess', N'TLamont@gmail.com', 0x082FE1F991F0F71253A311A899A9DEA95E3357F040ACDA29C26B29A4D9D0386608AE1595BF9B181A78A1E346C9436BBC02599BF698E7644FBB69C29AC8FE4E10, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (29, N'Johnston', N'Sara', N'SJohnston@gmail.com', 0x3A71FDC26D2ED8B6BC294C16C68C8E2EA690612A87C78975F09081B44C3975EB6C5F269C75265EDC18D8F0AC02C9F174959CB5CD37D7413C2CF9CDA1C246E5FC, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (30, N'Eliot', N'James', N'JEliot@gmail.com', 0x46DE9A269F3234C55ACB9FDC2EC92D29EB876F5AFBA670F4947B7F8373C8C46EA62FE98E7AA3BB92973C36B3C0752327D5B91E7E690ACFAE2698F77D9D0F5A46, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (31, N'Nguyen', N'Jane', N'JNguyen@gmail.com', 0xBE576D53C762EE00AE08CEA8FCEA27627A98D841FADBC3FFF555B4DFD57AB22D6058E9FE1D4B97EDAA32EB744ECC2AC4D3EE6C01211805726538C682A357573F, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (32, N'Perry', N'Lee', N'LPerry@gmail.com', 0xD1A1045F1069706DAE823278AB5103D16A567046CBAD4A12965AF61B9C0E634D616EE0EB5F32FA0FD7965A94695FCC8653176BFB2D5ACDD40C7FE551F2F7532E, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 3338308)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (33, N'Norton', N'Carrie', N'CNorton@gmail.com', 0x631D490D8BF5CB57379026F15925D7C1B5F2E39B69240C55720C6C30B535530F20A728CA2798A4CA0D8BF272BB948EE53FB0412004C79F3FD3C8973A2AC07578, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1865726)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (34, N'Farris', N'Mark', N'MFarris@gmail.com', 0x648211BDF9689DEE67D81B5ACB862CADCE2BB39708A5B69A73601D2C0661E3B95811ADD80F2A8F49ADBC762A4993DC0E503420966DA2ABDCE2CA81E7819E7F16, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 1865726)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (35, N'Farmer', N'Tim', N'TFarmer@gmail.com', 0x0064A4C18A2CF635D075290594ED2D8AA3D370482383F42DD0D9B3FE429959ADD194A2C2CE0C45C92C9AF48CD85A259F2584F0C90AE3D8E3AA11AA0A73AE8F1B, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (36, N'Sanders', N'Lea', N'LSanders@gmail.com', 0x1ACAB6C90CF05E7056F649C66D217E44B566559EC49ADC77EB0063970D53CC44EDEA0DA232A2863E2FACAFD72F2444A4D355469C8C4DC22ADBC2149A6C1EF03F, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (37, N'Smith', N'Jim', N'JohnSmith@msn.com', 0x914A2D1421DD067289D3C643E6E4D665EE0A91AC07435C5179B730A18929B6B1CCAADEB2F9D12F0A08755F47F661BEA52F2D03A88DC1345FDFBA2E4F5B7F65D9, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (38, N'Zukof', N'Petra', N'PZukof@gmail.com', 0x13435A9F0C1E7648D41DC9F3F66E5378D5B758D09DCB7C0BFB042C12F1279C33CA2CC426F482387BFE92D060003DA65FA28F57463EAD1529CC9A989ED9F02785, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (39, N'Kim', N'Karen', N'KKim@gmail.com', 0xA0C56248C53528771F689754AA7FAF428C0B5BD95DC90A4D2C4463978A1E41135B0F0B62A7E59E8282E58CD5B77296C60C1D8DE45D92F5257543CE9CB73965F4, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (40, N'Norman', N'Tina', N'TNorman@gmail.com', 0x2B2121015A1599552C2672BEB37390ECD966602BF8C3C05F6DFF80DE49E510351C84D950B53097FB2E47B66F58CFE4BC50D190F30B0A3E736373C6D654EC676E, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (41, N'Manning', N'Carol', N'CManning@gmail.com', 0xEA0C97238305D87DDF72E9319059002E4A45C47E273C6351E6530C34886426B7C649D82213C6441F5F42402F31376676C5EE1B6DA0B3F679D69EE4D323DC6D53, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (42, N'Patton', N'Laura', N'LPatton@gmail.com', 0xEF76C2C1943766071384051D33E694F66461A33DBBB02DACD946FA424C5689ED626EA16EB49B3D5D7CEC42F2F77F0F8ED7E8AA4F268AF4956B25DFC4A1742247, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (43, N'Jorgenson', N'Amy', N'AJorgenson@gmail.com', 0x75E9DE684E792888C386C4D5ED071F8B1827AD0BC5B4B0CD7ABF044ED1D14604DD722C5A78F852E3E9DD88786C69F88EA2D0F28C485894940B1E3EC1065D7446, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (44, N'Schneider', N'Franz', N'FSchneider@gmail.com', 0x8E8898F90F0EB5FB28A3A21ADB8F4D29816C7D03E32C505F0D00AC18D3A75830A62ED0D89EBCC9A848C10DA20B4328EC7D133CC0ECA8638C846137271CE42106, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 5094971)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (45, N'Kim', N'Lee', N'LKim@gmail.com', 0x61B5D34BC7D8030F325D456A57AA750BF36BE16CBD1545937D314C2F3EA858BDEECB02B2728ACB6811A4ABC7E16EC1BC0885AEE49600F9F0B53BE552BD819478, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (46, N'Denny', N'Phil', N'PDenny@gmail.com', 0xDE4923C3EE83B6A9A95B166C8D88859E1CE5EB0B1C117FB90CB883820C6AD081DB4B40B87B267CD73AAA0E4D1B4B033A746B6F1A3FA48667089FCF84057CB751, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (47, N'Conner', N'Jessie', N'JConner@gmail.com', 0x8458DA1861819B3AEE4D4B908D605A562506158845E27740CBF378DB49C1B8498E5A7391F5B6789D162D9868E950D3BA140247005C0BA3FA198A7D6E782C4091, CAST(N'2008-01-15 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (48, N'Keanne', N'Ann', N'AKeanne@gmail.com', 0xB890C8086CB05DB0EE1D7BE4475E41F3FC76486CA0C6A321CD4ACD59BFA6E5B75C21D674BFBAFF2AC9DEBFC853808AAEC27E0047B42C5D2C28BC04F0DFB1B9BC, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (49, N'Meuller', N'John', N'JMeuller@gmail.com', 0x76509DA9C3561DEE90CA35F9A38C988CC59736221949B868C0CFA65D3416E54C5336CD4550305AFD3D9EFE3352A89D0D93B07DBD3576EB6E0A8DD1C691E5A7D1, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (50, N'Rogers', N'Cherise', N'CRogers@gmail.com', 0xC27ABC125598C365A2584DA4EC659B46ED6C6329AEEC4142F407B8FC7A355A589BAEFAF29887DB250CE162541EC77ED542A4A93F9C279512DFF6A92EA560504C, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (51, N'Ponge', N'Sue', N'SPonge@gmail.com', 0xC19D5E1EB36CAB9C17D5F5406E8CB835F7EA5DDCF1778C606997E95F201D481DF36564241862336290C9A7569448D6F63D113F799BDFD459F1F37226309C04BE, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (52, N'Tanner', N'Chelsea', N'ctanner@gmail.com', 0xFCC93C468D172BD2BB1799EB0DAEF0AACC6CEF16AA0677BC26CB576283E504146AFF5264F579E68AC721E54834DB141B30CE1CBC18E8E2A35EFE8B85CCA7297B, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 8324216)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (53, N'Olson', N'Sonya', N'solson@gmail.com', 0x72E167D01807A69EB9FB847C95F7CDA7BE528AE4C9A64673257A804BE498A3EB3652A090469FEA637A84C85A2519B951B16C25BDEA29D532DA80B7B169944C88, CAST(N'2013-08-09 00:00:00.000' AS DateTime), 6851633)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (54, N'Robertson', N'Jeff', N'JeffRobertson@msn.com', 0x633C111CC19650E8B98CF495C07298399C2CA91892796B52AC1D8C13B8CCE2C01F861F50E0675255D83C7FB36D52F113EB88F6AE93FA847EC4BCA67FFF9C0BD6, CAST(N'2013-08-11 00:00:00.000' AS DateTime), 4285846)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (55, N'Jameson', N'Jessica', N'jj@yahoo.com', 0xDB9164677B08D0A03318EF91BA1B270AC733F37378BFAA380FE286DE2DE98BEA681679FF4B047231B31985018B8B1AB09CE3111A4AE51B2200E79FA7C218BBDE, CAST(N'2013-08-11 00:00:00.000' AS DateTime), 2749031)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (56, N'Masters', N'Carley', N'cmasters@msn.com', 0x00A84D6FBA2B0F04EA10837A3EE0B5C8724488DEA89F93B3F46AA820BD24223F5C6609BB1ED6585C295474562DE9C565D75F777E5E60100BA86915F57215C7BE, CAST(N'2013-08-11 00:00:00.000' AS DateTime), 5620605)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (57, N'Nelson', N'Martha', N'marthan@yahoo.com', 0xB0839AC295858C635AAB12FC833B0047E20051848617D97364C3A3B1C3B784EBCB27BC83556FA3FDBB05F3017E3177CF2B79CF164FA3557F56AE7171826F828A, CAST(N'2013-08-11 00:00:00.000' AS DateTime), 2814605)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (58, N'Pearson', N'Monica', N'pearson@gmail.com', 0x8869AD8757F5D5A349EB26A08B43120495E0658419D85BC28DEF965709F33E6BCD614FF77BD5ADFD3CA7C0EF444C83E3C9C2C355AA2F17C6AE38435895FE5979, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 5612101)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (59, N'Lynn', N'Jennifer', N'jl@aol.com', 0x9766BF3EA6E9F5159BFE9092D392DBB889280109A1890F5BD3356137E9A4A72925F669E2139D4055AD2B952DD8B25746E96AE47CF1480111B6BBC37A9FF83679, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 8339094)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (60, N'Johnson', N'Tina', N'tj@msn.com', 0x5C9D15ADC566F7404E565B1612C69AF18D92C43EC87DE11584AD8C2ACE6B558BCCEE52600FE43B05E0E36A96B9EB8F6D50206AF2B9DF919BF622899CC206C6E0, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 7010204)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (61, N'Thompson', N'Danielle', N'dthompson@msn.com', 0xD679C19CD0C8B22F6B0658459A6865EC3767313A5480BE655C002AD08F5AAA913A5856766675A3881F05FB2AF1FD379D2A3CF797058B3ECDF13C59C1099F0CD7, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 2780401)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (62, N'Brown', N'Leah', N'leahbrown@comcast.com', 0x1678680FDE42E6C912CEF8477D6551277DBBDC68F2843CA4A05A8732FEAEEB03788A8AED92D55F3EAD3CE50543E6919F331FFE4EA3A81FE9FE1DCA6C4AAF393D, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 1019655)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (63, N'Nelson', N'Caitlin', N'caitlinnelson@msn.com', 0x6D637D72649489A79F63FD2BA790A26CE8FA7261DF1E150F749CA496EA640644F2642FB9E8493CE1789B9D7E7D5160FE671C8D27C584EAB4B78D40BC8A4E6A5E, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 9929625)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (64, N'Handle', N'Martin', N'handlethis@google.com', 0x7D5459304AA8A4358B08254E70C70847BFDDC840D68B17923727E585EC007E334A234D91FDE5BD2ECCE15C0BC23462CF515B1182018E5A001E275FF6D74E254B, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 4027146)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (65, N'Comstad', N'Fred', N'comstad@gmail.com', 0xEACF539A98A69EC99547FAA05A4BDB89E4BC76EF68149B656C3F9FB8E60CBD05BF493681ED1A66D74975AD1D3631D958DF561579946D60E5C44AFBCF33CCC805, CAST(N'2013-08-16 00:00:00.000' AS DateTime), 3487077)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (66, N'Manson', N'Patrick', N'pm@gmail.com', 0x419B746CD10268213FE280ECC5102648CC595D42A7F89D642472BB9F02564D727003FE7178917E56D313E88010333191FA57500350F2E3136B03572A2FEEBA40, CAST(N'2013-08-17 00:00:00.000' AS DateTime), 8248342)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (67, N'Baker', N'Sally', N'sallyb@gmail.com', 0x5353D56C41EC556A88C95D07DFB81C92C0E720B1D2A2DDAEFFE99FB2997A63F13E68785AD8FEF16DA556310CAAFA033FFE91762804A9EEBCEBE8E39282F84726, CAST(N'2013-08-17 00:00:00.000' AS DateTime), 4200342)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (68, N'Mithin', N'Tammy', N'tammy@mithon.org', 0xDB58E937A2D796BAD88032A9C033F048379040DD4ED53FE1EA29F4E01F43E3EA69618576D44BD2AAD4D0F40EE8A4FE77C14750C54F98ACEFDEA97E9A930B8A1F, CAST(N'2013-08-17 00:00:00.000' AS DateTime), 2661350)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (69, N'Peterson', N'Monica', N'mpet@msn.com', 0xAB766D8C8FF21A316204FC2599465F7373EBC1461BB9430603AD0187044174BDC5845765C07183C76A1441EA302DEBAC353E921FC5FC0F31F08246CD06C766DA, CAST(N'2013-08-17 00:00:00.000' AS DateTime), 3926441)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (70, N'Blake', N'Salem', N'salemblake@yahoo.com', 0x0102DE252C7C52380AE6E02D542501FB35F47FDE0E2572A978D9387FB993B2708200504FE47B579FFD5CC5292294E309DAC0091968C5E5A011CCB6AD10DC8AD1, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 2490392)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (71, N'Zorn', N'Ken', N'kz@yahoo.com', 0xE3F6FAEA0132F5F633BD9FDD9A8078B82AB6E44C4212448549919F0BC5D1C18F2AFEFF9B811C3A5ACBC12EC732CAA33F3086C66480954245D8BDD6D013EB9F1B, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 4304367)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (72, N'Baylor', N'Henry', N'hbaylor@uwashington.edu', 0x579411AB65A1EDD6979F6DE89904CB60C124D5BEC4550FD40A770DF39ED91486B4CD91B84952B844D296BF414AB2D7B3E51317C1334E5996F89867CADBC7F010, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 3236262)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (73, N'Taylor', N'Beth', N'btaylor@yahoo.com', 0xF9DBFF5A40782D7DA3CA338708D8043EF0D3AA32C6815A7F8CCCF1B941D50A001A75441D6095D0A487E2C3B3C5E3B9EB2098AAEFA9C02E51211402AB1EA75880, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 8626647)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (74, N'Madison', N'Lawrence', N'lmadison@msn.com', 0xB818B9CECE33AFAF4838125C38F4262FE3FEA70BEEA12F43DCED3B4BD0B91A84BF41C24D32C0A203545DFE9710C3AB53F8B223BA27B898C43FF9C30A733E5B55, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 8958346)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (75, N'Gates', N'Bill', N'ggates@microsoft.com', 0xC38D0401E6761E7BC8B7B024555B5A75B78B482440201AB61D39609543622EF93FF9A03743861F0FB76E7B26CC774A95A7298AD4DA93031332086C2C7E620FC0, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 8981262)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (76, N'Green', N'Lewis', N'lg@outlook.com', 0xB359399D4BDD2A7891489FA1D97158DF95B17A43792C8F8A5229CACB85BC28C43491E61CB4B326F846086517B74F7019E3C66494257D6C6D3BB1B0BA5DD65CB4, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 6763893)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (77, N'Allen', N'Paul', N'pa@outlook.com', 0x6D05E17D061700B623E09A458AC7B8BA2F2510CA872A99FB4A46983F133721FBA4339D561A250C81F54B9DB1D55D76BAA096DE6A6F90D82445D056BE3BCC7508, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 6909274)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (78, N'Fortier', N'Karen', N'KFortier@outlook.com', 0x3EE4DCF522A1A072D22EA5750FE02C62D80C38D2F269D2B8F0D487CB5753A83F49A860A18421BCED94A388ABAD277F67D5C4C765C3995B8CA34B5AA976F00556, CAST(N'2013-08-18 00:00:00.000' AS DateTime), 7026519)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (79, N'nguyen', N'Lee', N'nguyen200@msn.com', 0x35296F5AAA7BABD82FF9F4853EEF73E77F620F72F90806914F4908FAFA5E482A91F9FB7CC3AD4339A013B005561AA364550CC28F3A8256CE0D0FFD4B2233DC50, CAST(N'2013-08-19 00:00:00.000' AS DateTime), 5090530)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (80, N'Christensen', N'Judy', N'jChristensen@seattleu.edu', 0xA43D8D0308F50C9AE45AB4BB4A746F46A29DE78EC3F14A162EB54C6A1B69EFCF4DFFADA003A156893C747A4E6FAF520B5AF6D30F843AA2131808DE791FEDF047, CAST(N'2013-08-19 00:00:00.000' AS DateTime), 6022177)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (81, N'Eliot', N'Neil', N'neliot@yahoo.com', 0x1F7817C599D8A5D7D3A99C196546CDDC06B1C15B3EBB646EF3F77A63DEFFFFDCA47BA37BE4EE5B92F3CE16B6EFE8B4AC6526D45D696196F1BCD27CEEFAC82B4E, CAST(N'2013-08-19 00:00:00.000' AS DateTime), 2929660)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (82, N'Weinberg', N'Jeffery', N'jWeinberg@speakeasy.org', 0xB9715BC4DB969F6A6263A6C6E6750E040D9B121A981E1A6D0844DD9C6F933A478CEE1ABA2A6ECE9A2963EC438F37C4A1FDCE6B8A829BE7D55C4CD0991F05B847, CAST(N'2013-08-19 00:00:00.000' AS DateTime), 5523966)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (83, N'Beneford', N'Gail', N'beneford@gmail.com', 0x9E71D337766502B0958E5C4C0FF1308AC4C65D5C2EC6F66A9DE238AC66F7C4D5A6F0F8FDF3ACB931DE9FA86BC89857CB75F86FDA0D8C8C33DF86CD70A71903EB, CAST(N'2013-08-19 00:00:00.000' AS DateTime), 9924298)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (84, N'Owens', N'Leslie', N'leslieOwen@outlook.com', 0x3AF4A134B6DBC941C788262AA9296793DAD9A4BCFE3AB63D4DE6B6A0096603343E469B72440D1CE5ACD1A7985520CA2C9BF469CAF65C5FA9554928DCFA2A0B99, CAST(N'2013-08-19 00:00:00.000' AS DateTime), 1973408)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (85, N'Sullivan', N'Heather', N'heatherSullivan@gmail.com', 0x35C28FF47F0CEFA6E982F99FC88EF091830A899182AEA1DD5A7CDEBDCB5ED800A63B5EB71163A0745D3F7C56A1D3C8558ADA20A7EF68F71B777E991EE43CD901, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 8307411)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (86, N'KIngsley', N'Sally', N'sk@kingsley.com', 0x97CBC2F00471AD9577C7EB4F1DB5131478943C2C4AE15789BD58318A7F1642456D8C6B9288BAB3EAE58283C62FB40D9D26D331CD20C82E312E13F461F3DEE2D7, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 8652279)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (87, N'Miller', N'Walter', N'waltermiller@yahoo.com', 0x13F00799D2D834142039B153330EB08F7C5CDC0ED15D7614A3BD4DC9115EFEC02CC6376725D52FF7DB8BAFFD8FB5BAED54EE1821428240034783DFF454444678, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 8807244)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (88, N'Nelson', N'Leah', N'leah@starwars.org', 0x946D0B41B29AA76A26B72447AC54A77BC4ECA67254741DAC07658542BADD0E82FC6233A53D0D2E7ED7D2EBE5980DD6E17738C27CCCED26FE90B05AD9B11842E8, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 2435622)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (89, N'Tanner', N'Nathan', N'natherntanner@gmail.com', 0xF9CB6AD7F12E5E280DD31C4DE69E8B2FD410ABB710026D1F12C01866663E46503DB773727496016F2D8CB5544F14E0E486E36B02CAAAC76001276A6E23D1B9CB, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 1390813)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (90, N'Denten', N'Laura', N'ldenten@aol.com', 0xBACDA94B8436A18427257B0EF4EB096CE327C54174531067BB9435E41519EC4C3A1FCCFCAACD62F25C6031793AFBD67DED8AC7F8DDFAE121A23A5E4C596B8C96, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 8502425)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (91, N'Clayborne', N'Robert', N'rclayborne@outlook.com', 0x3989D10E6E71B6DA128CD0D92B7784419A2ADCA5816DB3BA1ECD1214C8AED3FCD7E005F3A763D3383557F733EA52ACE2F9A4134A805D388B31215A15B80BB438, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 2346080)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (92, N'Meyer', N'Paul', N'pmeyer@hotmail.com', 0x82F859C7A699B6E5CB825FAB0C69727CD8A4B5D904CC111F12F7C98D77ED240DCA657BDA718236BBC0F0080723C144AB89D9C514D3B9B0C44F5B3178AD0B32BA, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 5931143)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (93, N'Mithen', N'Leslie', N'leslie24@hotmail.com', 0x1F25AFE211B9EC8D13F3ECB0D1DB907E61F0651BAC4DDD4A8C3818486EF9EF4BBC2F00DFE84FE9B8494BF9CA669F3043854631673F10DF1536382B7F47078190, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 6617795)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (94, N'Hawks', N'Gina', N'hawks@northwest.org', 0xE53A852361B7512BB4CB69C3DBF75A6886C069E1F8584779EB0B02C3F5CD2C8287AE8C8BCA49A7C63E95D62C46C7B8B2ABA6D1E22AD36D1BFB259C7BC849AA7D, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 1883630)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (95, N'Bishop', N'Martin', N'mBishop@enterprise.com', 0x61A9A797BF247C84F6684397900A13E90B88D7FC6390ADB444666FA471F50F40FCFFDFDFFAA7DD44F4C71AACB8490CE1D808DE246B5DB62CDE928CF7142DAB9D, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 1693337)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (96, N'Danielson', N'Erin', N'EDanielson@hotmail.com', 0xC32E0DB0A1E89DB0C70E392607DC09DD71B4A75B372B22962F9B5771D13F3B33905A55427F9F16E5B017D3A676179D186B365F362ED829434FE493DA3D5CD4D0, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 3318275)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (97, N'Skeat', N'Jonathen', N'skeat@newage.com', 0x405182AB9026D6BA0590B7DAB6DC682DB92FBD2EB3AB15A4CE8E4A217B4163099816FAA68209250A0770BBF7E6DC47B0A644EBD525E9AC6625E0A697CBA73F5D, CAST(N'2013-08-24 00:00:00.000' AS DateTime), 3328834)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (98, N'Lovelace', N'Monica', N'mlove@hotmail.com', 0xBE660E3F6E131418A9D6718DA20CB5F66326543832E092D809B9C53B4F004BDB260D4B3CFCF0D4D758059D545B3A364EF5E6A6BC7CE3ADFD933751EE94484727, CAST(N'2013-08-27 00:00:00.000' AS DateTime), 7465721)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (99, N'Manners', N'Jill', N'jillmanners@outlook.com', 0x21CAE3081746A0BC42AA1CF6A46637C701E4B8409B1D64EB8149F5FAAEDE74302727582FDEAC5FECBAF98E5BF4FD7CB9C1032EE8EA485ACA61A7E5CA1AEB7743, CAST(N'2013-08-27 00:00:00.000' AS DateTime), 4649606)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (100, N'St. Marie', N'Nelson', N'nelson@seattleworks.org', 0xBDE84F7558FE41EA46C292DAF7283084325D32AAFC0FCA63C046FCA1BAEF9864E3D6AD3FBAE6F6CB1C9631DD29A0548AB871B2B13F688B17D2526C5EF0803E35, CAST(N'2013-08-27 00:00:00.000' AS DateTime), 2574413)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (101, N'Kerry', N'Elizabeth', N'ekerry@gmail.com', 0x6DA0A95FFBF53F2E0DBA1B1431C09DE48232975A9D0410F9DC6D7B8352865BABDA68A748A2E68E33E06B70A8BFE542CDC8A2E2AC8AC4C7D431E70A018BB959CF, CAST(N'2013-08-27 00:00:00.000' AS DateTime), 3160963)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (102, N'Kendel', N'Harriet', N'hkendel@outlook.com', 0xB454D2057EBB7064F57B53D46426CFEACEB4527B3BB7398C713BBE7635536F3B8996218FBD4A96D29780065E03928ECD3E5AB8B4D4899DB503B30293AB38DF41, CAST(N'2013-08-28 00:00:00.000' AS DateTime), 4187422)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (103, N'Taylor', N'Rachel', N'rtaylor@gmail.com', 0x8C08BEFF2945DAD7D74E8913A11D8B3929009E14277E3C7102BA2AFF40F0F31EDC80C97D76655809E5A529AEE691FC4FA1E9D0D255796CFC5C4FC2E5596C13F0, CAST(N'2013-08-28 00:00:00.000' AS DateTime), 2656333)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (104, N'Grindle', N'Harris', N'hgrindle@outlook.com', 0x528F62DAFD04F9FB1B2BF6A32900FC9AAC6F2D783FF3663D829B8E6858890EC73DF1C6569A0C94A2799958AA01257FC0D90996A3A122C80865E286674BBA1277, CAST(N'2013-08-28 00:00:00.000' AS DateTime), 3784641)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (105, N'Esperanzo', N'Letty', N'esperabzo@aol.com', 0xFB4AD61F79B4F55240F3EF70238BD35BCC3EC46E5132C5904FBCB5D2FFCB5E53260D1467DF81355B5B9F0B40D3B6DDAD8F71257D4BAD5EAD7602DAFB6D7E4DE7, CAST(N'2013-08-28 00:00:00.000' AS DateTime), 3541877)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (106, N'Susuki', N'Lee', N'leesusuki@emeraldcity.org', 0x770E4618AFBB6C664ACD376F4731740B67535062CDF494704E3CB25001525EAB66641A61523727AF7E3E776F0A33BF2789156FFB3F2F7A404797316741CBCE17, CAST(N'2013-08-28 00:00:00.000' AS DateTime), 5849492)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (107, N'Valencia', N'Roger', N'rvalencia@gmail.com', 0x350E6A03D93B2685B75EEF30E254B49249CBA6545BCDD73BE47246664ADCCC490ACFF99F3AF363F30D63314C5382CD160A8DBC505C2F238E19474859A2AA2245, CAST(N'2013-08-30 00:00:00.000' AS DateTime), 4102888)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (108, N'Scanlon', N'Renee', N'scanlon@outlook.com', 0x0B070E81163E3B7D8C8D6CC50BB78CB29555C9A4DFA5D9F29206CC7BB91D78F37B9278EC7354FC02756C8205693D14CD5405A2C806999F44418439049517127E, CAST(N'2013-08-30 00:00:00.000' AS DateTime), 8389408)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (109, N'Pham', N'Lee', N'leepham@outlook.com', 0x245F088044A685F964742A90C46CF9A81A0EC368898B2EE8780EC24FEDD41525D1984654013D143E5D9D032FD3DC18288F4CDFFF146FAB350FB8FB4B072E82F7, CAST(N'2013-09-01 00:00:00.000' AS DateTime), 2611978)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (110, N'Mandela', N'Terry', N'tmandela@community.org', 0xE9ABEBF5CBCC5157DBEB1C3E493446875C533A7800EFFDBD6B6874B0EE8CF9AD58EEAF77826BDE0F56CD0DC043E96B5A508ADDB615DA9ABAF4E54F979D8C6510, CAST(N'2013-09-01 00:00:00.000' AS DateTime), 2172173)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (111, N'Snow', N'Lester', N'lestersnow@hotmail.com', 0xA30D6D6409D827F6B4B2C28C4BB26EE00F47E9475FE23189B1B04BA8A3582115B079FD25ED5474238CED97472DA163A2FA662D922E5FA45B9A56751E3A24516B, CAST(N'2013-09-01 00:00:00.000' AS DateTime), 7773319)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (112, N'Miller', N'Aldus', N'aldusmiller@gmail.com', 0x04371927B72D3DDDE0236A1437AC16440D0EFD56CF94FC9ABAC95082F7A2806DF17045A30A762BBE758565025190E4C2CBFBBB366F0CD5D8390CB9A797532B59, CAST(N'2013-09-01 00:00:00.000' AS DateTime), 9821513)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (113, N'Rogers', N'Jill', N'jillRogers@msn.com', 0x757FA7512E19F9F6F8401760A73AB9CDD1B0D4F47D83DCABF7DF8C07376C795657D845483DAE34911B9A859783EB3D67CE02313A56E3FA6F4FAA3FAF997DBF35, CAST(N'2013-09-03 00:00:00.000' AS DateTime), 2227245)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (114, N'Sung', N'Mary', N'marysung@outlook.com', 0x593FD7971C17D35119E36997F41257D5BD416637E4FB3EB1C12C528DCC26AA809BAA7138EDB77E00B9589E93B979C4AD01467A10FC46BEE8453A158E6B2D7820, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 7242466)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (115, N'Jones', N'Lester', N'lj@speakeasy.org', 0x24CDF2717DF3AF5986922BEAC741C7F87DF4A53E717EB874EE8242CD30E9DA72342F20902C9C67DD31F1C544F684B4058EE6F78D5BE31726EC61BE83B29BB3FA, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 2186176)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (116, N'Xui', N'Nick', N'Xui@yahoo.com', 0xFE473912E35151B6487AA17880B84FD55D82D61B3B1868E1F5009088F3D6793E30A138CDC734747E4AA533D09CFE743A2C6231D611A46AF59DE3AA0C93625818, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 9481604)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (117, N'Yun', N'Luong', N'Yun@outlook.com', 0xD5784E4783A41460FCFC6EE2F1BFF9CAC89CB2C82AF1A912C748BF1E9C5277BF33041AAB0EFE86B3D4F7B331C77930DB37BF2EC0BFFB410A4E1379EF7D4EB018, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 7990405)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (118, N'Kendrick', N'Peter', N'pk403@yahoo.com', 0x97B8B68D580752D31A7C3AF5767B7C2ACD4D32805D8415F4265368CE797688CDB15E463A0644D5C89B7E4E0E55DA2959EC314367E415D484A7A82E3878F06F21, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 9534021)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (119, N'Baker', N'Tom', N'tombaker@bbc.org', 0x4DD008C256FEF70ACE002A08562F3074CAEA4AC5F3288FB28AB3147573DD5BE9E99A437F87B540B847646951AA6EC2A575EC98B2BB919F3B9EE00C0C188DFA02, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 2854319)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (120, N'Liddell', N'Scott', N'scottLiddel@oxford.uk.edu', 0x269C7604C42A559EEA06A457AD16021F8D2A3B7D1F594A1225BF965118383D8740099F94E4B02644EE7FC8711C097F76550C7B368DFB390B8E666013A69A711A, CAST(N'2013-09-05 00:00:00.000' AS DateTime), 9864962)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (121, N'Nguyen', N'Lee', N'leeNguyen@outlook.com', 0x2956834037C5A023DB20DEEE25A51C62A61988C8B494A102648D4B2117537F87E40D4143DE2792F2C20205E1B1D59CB6999ACCD88AAFE6398A49F82BFFA497DA, CAST(N'2013-09-11 00:00:00.000' AS DateTime), 6340983)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (122, N'Browning', N'Sally', N'SallyBrowning@aol.com', 0xE6C839034FCDBC3DA52DBCA8736F0EB2B072A04B6EE860C9CDD09E93563319257FD514E920B1173385D3421D25D4C9A0948BDF80623ED317BB7706A6110555AC, CAST(N'2013-09-11 00:00:00.000' AS DateTime), 5088357)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (123, N'Stevens', N'Carla', N'carlaStevens@msn.com', 0xC9952402FC1A2E4A81E498B7CE16A8C626062883DF1E252AB1A403A978F9DC11268714F2956909C29FB114FD9AB4348E3ECFAE56ABC695182556706B4A0ABCC9, CAST(N'2013-09-11 00:00:00.000' AS DateTime), 4307647)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (124, N'Steeler', N'Beth', N'bsteeler@hotmail.com', 0x7FAC8658568753769B9C54BC4F8466E412DFAEA58D5F00A9EE310D2A4D154FC1A8FD90AB208C751239EABBEC3A04479560645799F6C4359F608A731C8CF7C7FA, CAST(N'2013-09-11 00:00:00.000' AS DateTime), 2755811)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (125, N'Davidson', N'Pat', N'patDavidson@speakeasy.org', 0x3E3D05DF63E5073EE0FCC3B6E610AEAFBB9BA14EF3F8C3091939A67D47D2EB388EC7986042FAA76C05ED5B099EF40D2DDEC254E259DADAD8D6F8A396E17C8EEF, CAST(N'2013-09-11 00:00:00.000' AS DateTime), 2048257)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (126, N'Dexter', N'Johanne', N'johanne.Dexter@msn.com', 0x796E47E4ABB8C72B3E16427CAA0870846AADD035388A179B3D5A1C49350BFB0844E90807D22D3A0AE9BBA60E64F71C1FCEB733B58787C22412CD7630002A53A0, CAST(N'2016-02-07 14:11:23.910' AS DateTime), 141414910)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (127, N'Norman', N'Jennifer', N'Jennifer@msn.com', 0x702B2B57E06DB250D6470B2B01A6575C0BC716321CD4624A62392F352B72EA62403DC1C6B52404566E5A309BAB31EC4C65E82983378809A945BE14D35C27B5D9, CAST(N'2016-02-14 11:35:01.383' AS DateTime), 111111383)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (128, N'Nelson', N'Mark', N'MarkNelson@gmail.com', 0xA3082B98F4E38AC753BF829E33FAD18FAEBDD07557B6EE2B1574EA105444D58D84D4A672B7E28E0CA6EAD53DC838F7F9F6CC05360BACF125FF9FE57D7559EEFC, CAST(N'2016-02-14 11:49:32.367' AS DateTime), 111111367)
GO
INSERT [dbo].[Person] ([PersonKey], [PersonLastName], [PersonFirstName], [PersonEmail], [PersonPassWord], [PersonEntryDate], [PersonPassWordSeed]) VALUES (129, N'Mason', N'Thomas', N'thomas.mason@msn.com', 0x30FC10419051710F1B2F4175FFD67633B4B6A08685B078D0BB2080B515237FF310151AB268D8910B4E093105135AA879405B55EBB34AF3E74C2CBC2B3DE997E4, CAST(N'2016-02-27 13:59:51.050' AS DateTime), 13131350)
GO
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonAddress] ON 

GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (1, NULL, N'100 South Mann Street', N'Seattle', N'WA', N'98001', 1)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (2, N'205A', N'328 Norh Division Blvd', N'Seattle', N'WA', N'98001', 2)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (3, N'Suite 756', N'110 4th Avenue', N'Seattle', N'WA', N'98002', 3)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (4, NULL, N'230 Eastland Street', N'Seattle', N'WA', N'98001', 3)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (5, NULL, N'213 Elm Street', N'Seattle', N'WA', N'98001', 4)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (6, N'201', N'222 Jackson Way', N'Seattle', N'WA', N'98002', 5)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (7, N'Suite 344', N'132 Second Avenue', N'Seattle', N'WA', N'98010', 6)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (8, NULL, N'932 Maple Ave', N'Seattle', N'WA', N'98001', 7)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (9, NULL, N'1928 Bradly', N'Seattle', N'WA', N'98002', 8)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (10, N'314', N'7070 Westlake Ave', N'Seattle', N'WA', N'98001', 9)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (11, N'Suite 2003', N'Western Towers', N'Seattle', N'WA', N'98010', 10)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (12, N'Apt 905', N'100 Madison', N'Seattle', N'WA', N'98010', 10)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (13, NULL, N'201A Birch', N'Seattle', N'WA', N'98001', 11)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (14, NULL, N'1325 Backway Park Road', N'Seattle', N'WA', N'98001', 12)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (15, NULL, N'100 Main', N'Kent', N'WA', N'98011', 13)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (16, N'110', N'1212 Native Street', N'Seattle', N'WA', N'98001', 14)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (17, NULL, N'400 West Bank Road', N'Seattle', N'WA', N'98001', 15)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (18, NULL, N'1000 Forest Lane', N'Bellevue', N'WA', N'98012', 16)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (19, NULL, N'930 A Street', N'Seattle', N'WA', N'98002', 17)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (20, N'720', N'3030 Belle', N'Seattle', N'WA', N'98001', 18)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (21, NULL, N'23 W. Century Way', N'Shoreline', N'WA', N'98013', 19)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (22, NULL, N'909 Waterview Way', N'Seattle', N'WA', N'98002', 20)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (23, N'101', N'200 Division South', N'Seattle', N'WA', N'98001', 21)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (24, NULL, N'503 Route 20', N'Seattle', N'WA', N'98010', 22)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (25, NULL, N'100 12th Avenue', N'Seattle', N'WA', N'98001', 23)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (26, N'213', N'365 3rd Avenue South', N'Seattle', N'WA', N'98001', 24)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (27, NULL, N'99 C Street', N'Seattle', N'WA', N'98001', 25)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (28, NULL, N'233 Kelso Road', N'Seattle', N'WA', N'98010', 26)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (29, N'1200', N'200 Lakeside Plaza', N'Seattle', N'WA', N'98010', 27)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (30, N'Rm 202', N'22 Jackson Way', N'Seattle', N'WA', N'98002', 27)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (31, NULL, N'3400 Candlestick blvd', N'Kent', N'WA', N'98012', 28)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (32, NULL, N'922 Hillstone way', N'Seattle', N'WA', N'98002', 29)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (33, NULL, N'1112 Nelson Blvd', N'Seattle', N'WA', N'98002', 30)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (34, NULL, N'3400 Candlestick blvd', N'Seattle', N'WA', N'98002', 31)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (35, N'322', N'22 D Street', N'Kent', N'WA', N'98002', 32)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (36, NULL, N'200 Harvard', N'Shoreline', N'WA', N'98011', 33)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (37, N'Suite 222', N'1020 Smith Bld', N'Seattle', N'WA', N'98001', 34)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (38, NULL, N'900 West Lake', N'Seattle', N'WA', N'98002', 34)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (39, N'523', N'101 Fourth', N'Seattle', N'WA', N'98002', 35)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (40, NULL, N'1200 Wilson Road', N'Seattle', N'WA', N'98002', 36)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (41, NULL, N'3030 Lester', N'Seattle', N'WA', N'98002', 37)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (42, N'300', N'300 Brown', N'Seattle', N'WA', N'98002', 38)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (43, NULL, N'400 G Street', N'Shoreline', N'WA', N'98011', 39)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (44, N'103', N'5667 Patterson', N'Seattle', N'WA', N'98001', 40)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (45, NULL, N'9732 Denny', N'Seattle', N'WA', N'98001', 41)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (46, NULL, N'300 8th', N'Seattle', N'WA', N'98001', 42)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (47, N'Suite 200', N'278 Mall Way', N'Bellevue', N'WA', N'98013', 43)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (48, N'412', N'78 Yale Blvd', N'Seattle', N'WA', N'98002', 44)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (49, N'Suite 200', N'756 9th', N'Seattle', N'WA', N'98001', 45)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (50, N'Suite 1200', N'800 23rd', N'Bellevue', N'WA', N'98013', 45)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (51, NULL, N'303 Lincoln', N'Seattle', N'WA', N'98002', 46)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (52, NULL, N'879 Martin', N'Seattle', N'WA', N'98002', 47)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (53, NULL, N'900 South Broadway', N'Seattle', N'WA', N'98001', 48)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (54, NULL, N'8792 N Street', N'Seattle', N'WA', N'98002', 49)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (55, NULL, N'500 Still Street', N'Seattle', N'WA', N'98001', 50)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (56, NULL, N'900 Fifth Avenue', N'Seattle', N'WA', N'98001', 51)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (57, NULL, N'1001 Meridain South', N'Seattle', N'WA', N'98911', 51)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (58, NULL, N'1001 Meridain South', N'Seattle', N'WA', N'98911', 53)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (59, NULL, N'1001 Fremont South', N'Seattle', N'WA', N'98911', 54)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (60, NULL, N'1924 Broadway street', N'Seattle', N'WA', N'98102', 55)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (61, NULL, N'2001 Oddessy Avenue', N'Seattle', N'WA', N'98001', 56)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (62, NULL, N'Kenwood Blvd', N'Seattle', N'WA', N'98001', 57)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (63, NULL, N'1823 Eastern Way', N'Seattle', N'WA', N'98122', 58)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (64, NULL, N'201 South Luther Way', N'Seattle', N'WA', N'98002', 59)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (65, N'203', N'111 South Jackson', N'Seattle', N'WA', N'98122', 60)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (66, NULL, N'2312 Broadway Ave', N'Seattle', N'WA', N'98122', 61)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (67, NULL, N'121 Brandon Way', N'Seattle', N'WA', N'98002', 62)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (68, NULL, N'2022 Northgate way', N'Seattle', N'WA', N'98011', 63)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (69, N'243', N'802 Pine', N'Seattle', N'WA', N'98212', 64)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (70, NULL, N'2323 24th Street', N'Seattle', N'WA', N'98112', 65)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (71, N'110', N'2102 Pike ', N'Seattle', N'WA', N'98122', 66)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (72, NULL, N'1230 Meridian Street', N'Puyallup', N'WA', N'98328', 67)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (73, NULL, N'234 2nd Ave ', N'Seattle', N'WA', N'98100', 68)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (74, NULL, N'404 EightAvenue', N'Bellevue', N'WA', N'98234', 69)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (75, N'101 ', N'21st ', N'Seattle', N'WA', N'98100', 70)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (76, N'103', N'200 S Fifth', N'Seattle', N'WA', N'98003', 71)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (77, NULL, N'24th Street E', N'Seattle', N'WA', N'98123', 72)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (78, N'321', N'211 Pacific Ave', N'Seattle', N'WA', N'98102', 73)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (79, N'343', N'1405 Pine', N'Seattle', N'WA', N'98100', 74)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (80, NULL, N'201 North Elliot', N'Seattle', N'WA', N'98011', 75)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (81, NULL, N'', N'', N'', N'', 76)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (82, N'121', N'234 Ballard Way', N'Seattle', N'WA', N'98100', 77)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (83, NULL, N'', N'', N'', N'', 78)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (84, NULL, N'204 34th Street', N'Seattle', N'WA', N'980122', 79)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (85, NULL, N'212 Union Street', N'Seattle', N'WA', N'98001', 80)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (86, N'203', N'123 14th', N'Seattle', N'WA', N'98123', 81)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (87, NULL, N'323 North Broad Street', N'Seattle', N'WA', N'98124', 82)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (88, N'321', N'291 harvard', N'Seattle', N'WA', N'98100', 83)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (89, N'201', N'2323 WestLake', N'Seattle', N'WA', N'98110', 84)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (90, NULL, N'2345 Eastlake', N'Seattle', N'WA', N'98100', 85)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (91, N'322', N'1423 North Pike', N'Seattle', N'WA', N'98123', 86)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (92, NULL, N'203 South Denny', N'Seattle', N'WA', N'98200', 87)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (93, N'435', N'346 2nd Ave', N'Seattle', N'WA', N'98100', 88)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (94, N'765', N'2021 Bell', N'Seattle', N'WA', N'98100', 89)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (95, NULL, N'1201 Magnolia blvd', N'Seattle', N'WA', N'98100', 90)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (96, N'451', N'Bell', N'Seattle', N'WA', N'98100', 91)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (97, NULL, N'324 82nd Ave', N'Seattle', N'WA', N'98001', 92)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (98, N'212', N'234 Ballard Way', N'Seattle', N'WA', N'98100', 93)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (99, NULL, N'2121 65th Street', N'Seattle', N'WA', N'98001', 94)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (100, NULL, N'292 Greenwood', N'Seattle', N'WA', N'98100', 95)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (101, N'756', N'1201 East 8th', N'Bellevue', N'WA', N'98302', 96)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (102, NULL, N'306 Westlake', N'Seattle', N'WA', N'98100', 97)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (103, N'344', N'121 Harvard', N'Seattle', N'WA', N'98122', 98)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (104, N'101', N'325 24th Street', N'Seattle', N'WA', N'98001', 99)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (105, NULL, N'2003 North 34th', N'Seattle', N'WA', N'98100', 100)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (106, N'343', N'501 Nineth', N'Seattle', N'WA', N'98100', 101)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (107, NULL, N'213 NorthGate Blvd', N'', N'', N'', 102)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (108, N'345', N'North 8th Street', N'Seattle', N'WA', N'98100', 103)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (109, NULL, N'203 East Ballard', N'Seattle', N'WA', N'98001', 104)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (110, N'303', N'102 34thStreet', N'Seattle', N'WA', N'98100', 105)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (111, NULL, N'404 Lester aver', N'Seattle', N'WA', N'98001', 106)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (112, N'342', N'102 Jackson Street', N'Seattle', N'WA', N'98002', 107)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (113, N'231b', N'2003 Northwest Blvd', N'Seattle', N'WA', N'98100', 108)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (114, NULL, N'1231 15th', N'Seattle', N'WA', N'98100', 109)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (115, N'121', N'1101 Pine', N'Seattle', N'WA', N'98100', 110)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (116, NULL, N'908 24th Streer', N'Seattle', N'WA', N'98001', 111)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (117, NULL, N'131 North 36th Ave', N'Seattle', N'WA', N'98001', 112)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (118, N'213', N'201 Queen Anne', N'Seattle', N'WA', N'98100', 113)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (119, NULL, N'204 56th Street', N'Redmond', N'WA', N'98102', 114)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (120, NULL, N'324 WestLake Drive', N'Seattle', N'WA', N'98001', 115)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (121, N'109', N'1536 Madison', N'Seattle', N'WA', N'98200', 116)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (122, N'453', N'2031 15th East', N'Seattle', N'WA', N'98100', 117)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (123, NULL, N'1245 James ', N'Seattle', N'WA', N'98001', 118)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (124, NULL, N'432 24th Ave', N'Seattle', N'WA', N'98101', 119)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (125, NULL, N'203 Tardis Way', N'Seattle', N'WA', N'98100', 120)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (126, NULL, N'900 West Fifth', N'New York', N'NY', N'00012', 121)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (127, N'419', N'324 8th Street', N'Seattle', N'WA', N'98001', 122)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (128, NULL, N'153 North Denny', N'Seattle', N'WA', N'98002', 123)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (129, NULL, N'456 Eastlake', N'Seattle', N'WA', N'98100', 124)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (130, N'2', N'334 Ballard Ave', N'Seattle', N'WA', N'98002', 125)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (131, NULL, N'333 South Eliot Way', N'Seattle', N'WA', N'98002', 126)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (132, N'101 N', N'1232 Main', NULL, NULL, N'981001', 127)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (133, NULL, N'1291 Broadway', N'Seattle', N'WA', N'98122', 128)
GO
INSERT [dbo].[PersonAddress] ([PersonAddressKey], [PersonAddressApt], [PersonAddressStreet], [PersonAddressCity], [PersonAddressState], [PersonAddressZip], [PersonKey]) VALUES (134, N'', N'123 NorthEast Broad', N'', N'  ', N'98122', 129)
GO
SET IDENTITY_INSERT [dbo].[PersonAddress] OFF
GO
SET IDENTITY_INSERT [dbo].[Position] ON 

GO
INSERT [dbo].[Position] ([PositionKey], [PositionName], [PositionDescription]) VALUES (1, N'Manager', N'Manages basic office and personel')
GO
INSERT [dbo].[Position] ([PositionKey], [PositionName], [PositionDescription]) VALUES (2, N'Web Donation Supervisor', N'Researches and Confirms donations')
GO
INSERT [dbo].[Position] ([PositionKey], [PositionName], [PositionDescription]) VALUES (3, N'Donation Manager', N'Helps confirm and research donations')
GO
INSERT [dbo].[Position] ([PositionKey], [PositionName], [PositionDescription]) VALUES (4, N'Grant Reviewer', N'Reviews grants and brings concerns to other employees')
GO
INSERT [dbo].[Position] ([PositionKey], [PositionName], [PositionDescription]) VALUES (5, N'Associate', N'Volunteer, helps in various capacities')
GO
SET IDENTITY_INSERT [dbo].[Position] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [unique_email]    Script Date: 4/25/2016 2:40:39 PM ******/
ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [unique_email] UNIQUE NONCLUSTERED 
(
	[PersonEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD FOREIGN KEY([ContactTypeKey])
REFERENCES [dbo].[ContactType] ([ContactTypeKey])
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD FOREIGN KEY([PersonKey])
REFERENCES [dbo].[Person] ([PersonKey])
GO
ALTER TABLE [dbo].[Donation]  WITH CHECK ADD FOREIGN KEY([PersonKey])
REFERENCES [dbo].[Person] ([PersonKey])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([PersonKey])
REFERENCES [dbo].[Person] ([PersonKey])
GO
ALTER TABLE [dbo].[EmployeePosition]  WITH CHECK ADD FOREIGN KEY([EmployeeKey])
REFERENCES [dbo].[Employee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[EmployeePosition]  WITH CHECK ADD FOREIGN KEY([PositionKey])
REFERENCES [dbo].[Position] ([PositionKey])
GO
ALTER TABLE [dbo].[GrantRequest]  WITH CHECK ADD FOREIGN KEY([GrantTypeKey])
REFERENCES [dbo].[GrantType] ([GrantTypeKey])
GO
ALTER TABLE [dbo].[GrantRequest]  WITH CHECK ADD FOREIGN KEY([PersonKey])
REFERENCES [dbo].[Person] ([PersonKey])
GO
ALTER TABLE [dbo].[GrantReview]  WITH CHECK ADD FOREIGN KEY([EmployeeKey])
REFERENCES [dbo].[Employee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[GrantReview]  WITH CHECK ADD FOREIGN KEY([GrantRequestKey])
REFERENCES [dbo].[GrantRequest] ([GrantRequestKey])
GO
ALTER TABLE [dbo].[GrantReviewComment]  WITH CHECK ADD FOREIGN KEY([EmployeeKey])
REFERENCES [dbo].[Employee] ([EmployeeKey])
GO
ALTER TABLE [dbo].[GrantReviewComment]  WITH CHECK ADD  CONSTRAINT [Fk_GrantReview] FOREIGN KEY([GrantReviewKey])
REFERENCES [dbo].[GrantReview] ([GrantReviewKey])
GO
ALTER TABLE [dbo].[GrantReviewComment] CHECK CONSTRAINT [Fk_GrantReview]
GO
ALTER TABLE [dbo].[LoginHistoryTable]  WITH CHECK ADD FOREIGN KEY([PersonKey])
REFERENCES [dbo].[Person] ([PersonKey])
GO
ALTER TABLE [dbo].[PersonAddress]  WITH CHECK ADD FOREIGN KEY([PersonKey])
REFERENCES [dbo].[Person] ([PersonKey])
GO
/****** Object:  StoredProcedure [dbo].[usp_AddRequest]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_AddRequest]
@GrantType int,
@GrantRequestExplantion nvarchar(255),
@GrantRequestAmount money,
@personKey int
As
Declare @Date DateTime =GetDate()
Insert into GrantRequest
(
GrantRequestDate, 
PersonKey, 
GrantTypeKey, 
GrantRequestExplanation, 
GrantRequestAmount)
Values
(
@date,
@personKey,
@GrantType,
@GrantRequestExplantion,
@GrantRequestAmount
)
GO
/****** Object:  StoredProcedure [dbo].[usp_Login]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[usp_Login]
@Email nvarchar(255),
@password nvarchar(50)
As
--get the random seed
Declare @seed int
Declare @personKey int
Select @PersonKey=PersonKey,@seed = PersonPassWordSeed from Person
Where PersonEmail=@Email
--get the hashed password from the database
Declare @DBHash varbinary(500)
Select @DbHash = PersonPassword from Person
Where PersonEmail=@Email
--create a new hash based on the seed and password
Declare @newHash varbinary(500)
Set @newHash=dbo.fx_HashPassword(@seed, @password)
if @DbHash=@newHash
Begin
print 'Login successful'
--get PersonKey
Insert into LoginHistoryTable(PersonKey, LoginTimeStamp)
Values(@PersonKey, GetDate())
Return @PersonKey
End
else
Begin
print 'login unsuccessful'
return -1
End

GO
/****** Object:  StoredProcedure [dbo].[usp_Register]    Script Date: 4/25/2016 2:40:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_Register]
@lastname nvarchar(255),
@firstname nvarchar(255),
@email nvarchar(255),
@password nvarchar(50),
@ApartmentNumber Nvarchar(255) =null,
@Street nvarchar(255),
@City nvarchar(255)='Seattle',
@State nchar(2)='WA',
@Zipcode nvarchar(11),
@HomePhone nvarchar(13) = null,
@WorkPhone nvarchar(13) = null
As
--check to make sure person doesn't exit
If not exists
   (Select PersonKey
      From Person
	  Where PersonLastName=@LastName
	  And PersonFirstName=@FirstName
	  And PersonEmail = @Email)
Begin--begin the block of if not exists
--get seed and hash the password
Declare @Seed int
Set @Seed = dbo.fx_GetSeed()
Declare @hash varbinary(500)
set @hash=dbo.fx_HashPassword(@seed,@Password)
--begin the transaction
Begin tran
--begin the try catch
Begin Try
--insert into tables
Insert into Person
(
   PersonLastName, 
   PersonFirstName, 
   PersonEmail, 
   PersonPassWord, 
   PersonEntryDate, 
   PersonPassWordSeed
)
Values
(
   @LastName,
   @FirstName,
   @Email,
   @hash,
   getDate(),
   @seed
)
--get the current person key
Declare @PersonKey int
Set @PersonKey=IDENT_CURRENT('Person')
Insert into PersonAddress
(
   PersonAddressApt, 
   PersonAddressStreet, 
   PersonAddressCity, 
   PersonAddressState, 
   PersonAddressZip, 
   PersonKey
)
Values
(
   @ApartmentNumber,
   @Street,
   @City,
   @State,
   @Zipcode,
   @PersonKey
)

if @homePhone is not null
  Begin
    Insert into Contact
    (
       ContactNumber, 
       ContactTypeKey, 
       PersonKey
    )
    Values
    (
       @HomePhone,
	   1,
	   @PersonKey
    )
  End
if @WorkPhone is not null
  Begin
     Insert into Contact
    (
       ContactNumber, 
       ContactTypeKey, 
       PersonKey
    )
    Values
    (
       @WorkPhone,
	   2,
	   @PersonKey
    )
  End
  Commit tran
End try
Begin Catch
Rollback tran
Return -1
End catch
End
Else
Begin
Return -1
End
GO

