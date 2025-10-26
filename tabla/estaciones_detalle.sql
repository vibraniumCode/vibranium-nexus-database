USE [NEXUS]
GO

/****** Object:  Table [dbo].[estaciones_detalle]    Script Date: 26/10/2025 11:56:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estaciones_detalle](
	[id_detalle] [int] IDENTITY(1,1) NOT NULL,
	[estacion] [int] NULL,
	[impuesto] [int] NULL,
	[importe] [numeric](18, 2) NULL,
	[fec_carga] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


