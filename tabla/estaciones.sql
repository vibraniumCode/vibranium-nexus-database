USE [NexusDB]
GO

/****** Object:  Table [dbo].[estaciones]    Script Date: 19/12/2025 16:59:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[estaciones](
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
	[created_at] [datetime2](7) NULL,
	[updated_by] [int] NULL,
	[updated_at] [datetime2](7) NULL,
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

ALTER TABLE [dbo].[estaciones] ADD  DEFAULT (getdate()) FOR [created_at]
GO

ALTER TABLE [dbo].[estaciones] ADD  DEFAULT (getdate()) FOR [updated_at]
GO

ALTER TABLE [dbo].[estaciones]  WITH CHECK ADD  CONSTRAINT [FK_estaciones_created_by] FOREIGN KEY([created_by])
REFERENCES [dbo].[usuarios] ([id])
GO

ALTER TABLE [dbo].[estaciones] CHECK CONSTRAINT [FK_estaciones_created_by]
GO

ALTER TABLE [dbo].[estaciones]  WITH CHECK ADD  CONSTRAINT [FK_estaciones_updated_by] FOREIGN KEY([updated_by])
REFERENCES [dbo].[usuarios] ([id])
GO

ALTER TABLE [dbo].[estaciones] CHECK CONSTRAINT [FK_estaciones_updated_by]
GO


