USE [NEXUS]
GO

/****** Object:  Table [dbo].[empresa_detalle]    Script Date: 26/10/2025 11:56:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--drop table [empGral]
CREATE TABLE [dbo].[empGral](
	[idDetalle] [int] IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NULL,
	[idCombustible] [int] NULL,
	[idImpuesto] [int] NULL,
	[importe] [numeric](18, 2) NULL,
	[fecCarga] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[idDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


