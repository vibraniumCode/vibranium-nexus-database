USE [NexusDB]
GO

/****** Object:  Table [dbo].[empresas]    Script Date: 19/12/2025 16:53:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[empresas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](255) NOT NULL,
	[cuit] [varchar](20) NOT NULL,
	[ingBrutos] [varchar](20) NOT NULL,
	[direccion] [varchar](255) NULL,
	[cp] [char](4) NULL,
	[localidad] [varchar](50) NULL,
	[provincia] [varchar](50) NULL,
	[telefono] [varchar](15) NULL,
	[actividad] [date] NULL,
	[created_by] [int] NULL,
	[created_at] [datetime2](7) NULL DEFAULT (getdate()),
	[updated_by] [int] NULL,
	[updated_at] [datetime2](7) NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[cuit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ingBrutos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


