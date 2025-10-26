USE [NEXUS]
GO

/****** Object:  Table [dbo].[clientes]    Script Date: 26/10/2025 11:55:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[clientes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](255) NOT NULL,
	[direccion] [varchar](255) NOT NULL,
	[cuit] [varchar](13) NULL,
	[created_by] [int] NULL,
	[created_at] [date] NULL,
	[updated_by] [int] NULL,
	[updated_at] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


