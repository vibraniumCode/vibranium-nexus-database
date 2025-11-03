USE [NEXUS]
GO

/****** Object:  Table [dbo].[Combustible]    Script Date: 26/10/2025 11:55:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE Combustible
CREATE TABLE [dbo].[Combustible](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipo] [int] NOT NULL,
	[precio] [numeric](18, 4) NOT NULL,
	[idEmpresa] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SELECT * FROM [Combustible]
INSERT INTO Combustible SELECT 1,150.23,1029
INSERT INTO Combustible SELECT 2,1350.23,1029

INSERT INTO Combustible SELECT 2,1350.23,1031

CREATE TABLE TCombustible
(
	idTC INT IDENTITY(1,1),
	txtDesc VARCHAR(50),
)

INSERT INTO TCombustible select 'INFINIA'
INSERT INTO TCombustible select 'DIESEL'
INSERT INTO TCombustible select 'SUPER'

SELECT * FROM TCombustible
SELECT * FROM Timpuestos
SELECT * FROM Combustible WHERE idEmpresa = 1029
SELECT * FROM empGral WHERE idEmpresa = 1029

INSERT INTO empGral SELECT 1029,1,4,21.00,GETDATE()


select * from empresas