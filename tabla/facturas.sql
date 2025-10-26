USE [NEXUS]
GO

/****** Object:  Table [dbo].[facturas]    Script Date: 26/10/2025 11:56:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[facturas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nroFactura] [int] NOT NULL,
	[fecha] [datetime2](7) NULL,
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
	[nroFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[facturas] ADD  DEFAULT (getdate()) FOR [fecha]
GO

ALTER TABLE [dbo].[facturas] ADD  DEFAULT (getdate()) FOR [created_at]
GO

ALTER TABLE [dbo].[facturas] ADD  DEFAULT (getdate()) FOR [updated_at]
GO


