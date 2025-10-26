USE [NEXUS]
GO

/****** Object:  Table [dbo].[empresas]    Script Date: 26/10/2025 11:55:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
	[Actividad] [date] NULL,
	[created_by] [int] NULL,
	[created_at] [datetime2](7) NULL,
	[updated_by] [int] NULL,
	[updated_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[cuit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ingBrutos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[empresas] ADD  DEFAULT (getdate()) FOR [created_at]
GO

ALTER TABLE [dbo].[empresas] ADD  DEFAULT (getdate()) FOR [updated_at]
GO


