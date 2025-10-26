--
-- Esquema de la Base de Datos para la aplicaci�n Nexus
-- Este archivo define la estructura de las tablas para clientes, empresas,
-- facturas y el registro de cargas de combustible.
--

-- ------------------------------------------------------------------------------------------------------
-- Tabla de Usuarios
-- Almacena la informaci�n de los usuarios de la aplicaci�n.
-- Se usa para rastrear qui�n crea o modifica registros en otras tablas,
-- lo que permite un control de procesos y auditor�a robusto.
-- ------------------------------------------------------------------------------------------------------
CREATE TABLE usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    fecha_creacion DATETIME2 DEFAULT GETDATE()
);

SELECT * FROM usuarios
INSERT into usuarios select 'MLopez','vibraniumcode@gmail.com',getdate()


CREATE TABLE estaciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
	ingBrutos VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(255),
    cp CHAR(4),
	localidad VARCHAR(50),
	provincia VARCHAR(50),
	telefono VARCHAR(15),
	actividad DATE,
    -- Campos de auditor�a para control de procesos
    created_by INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by INT,
    updated_at DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (created_by) REFERENCES usuarios(id),
    FOREIGN KEY (updated_by) REFERENCES usuarios(id)
);
SELECT * FROM empresas
INSERT INTO empresas select 'Nexus','1122323455','1122234455','calle 7 numero 691','1884','berazategui','buenos aires','1122334455',getdate(),1,getdate(),null,null

-- ------------------------------------------------------------------------------------------------------
-- Tabla de Empresas
-- Almacena los datos de las empresas.
-- Tambi�n incluye campos de auditor�a para rastrear las modificaciones.
-- ------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------
-- Tabla de Combustible
-- Contiene el cat�logo de tipos de combustible disponibles.
-- ------------------------------------------------------------------------------------------------------
CREATE TABLE Combustible
(
	id INT PRIMARY KEY IDENTITY(1,1),
	tipo VARCHAR(25) NOT NULL,
	precio NUMERIC(18,4) NOT NULL
);

/*
INSERT COMBUSTIBLE SELECT 'INFINIA', 10897.98
INSERT COMBUSTIBLE SELECT 'DIESEL', 3567.12
INSERT COMBUSTIBLE SELECT 'SUPER', 3567.12
*/

CREATE TABLE Timpuestos (
	id INT PRIMARY KEY IDENTITY(1,1),
	tipo VARCHAR(50) NOT NULL
);

/*
INSERT INTO Timpuestos SELECT 'ITC'
INSERT INTO Timpuestos SELECT 'IDC'
INSERT INTO Timpuestos SELECT 'IMPUESTO ITERNO A NIVEL ITEM'
INSERT INTO Timpuestos SELECT 'IVA'
INSERT INTO Timpuestos SELECT 'Imp. Hidr. Carb.'
INSERT INTO Timpuestos SELECT 'Imp. Comb. Liq.'
INSERT INTO Timpuestos SELECT 'Imp. Matanza Variable 1.5%'
*/

CREATE TABLE estaciones_detalle
(
	id_detalle INT IDENTITY(1,1) PRIMARY KEY,
	estacion INT,
	impuesto INT,
	importe NUMERIC(18,2),
	fec_carga DATE
)

INSERT INTO estaciones_detalle SELECT 1,1,1500.00, GETDATE()
INSERT INTO estaciones_detalle SELECT 1,2,12500.00, GETDATE()
INSERT INTO estaciones_detalle SELECT 1,3,11500.00, GETDATE()
INSERT INTO estaciones_detalle SELECT 5,2,2500.00, GETDATE()











---- ------------------------------------------------------------------------------------------------------
---- Tabla de Clientes
---- Almacena la informaci�n de los clientes para los tickets de servicio.
---- Incluye claves for�neas que se vinculan a la tabla de usuarios.
---- ------------------------------------------------------------------------------------------------------
--CREATE TABLE clientes (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    nombre VARCHAR(255) NOT NULL,
--    dni VARCHAR(20) NOT NULL UNIQUE,
    
--    -- Campos de auditor�a para control de procesos
--    created_by VARCHAR(255),
--    created_at DATETIME2 DEFAULT GETDATE(),
--    updated_by VARCHAR(255),
--    updated_at DATETIME2 DEFAULT GETDATE(),

--    -- Restricci�n de clave for�nea a la tabla de usuarios
--    FOREIGN KEY (created_by) REFERENCES usuarios(id),
--    FOREIGN KEY (updated_by) REFERENCES usuarios(id)
--);




-- ------------------------------------------------------------------------------------------------------
-- Tabla de Facturas
-- Registra cada factura de manera �nica para garantizar la integridad.
-- ------------------------------------------------------------------------------------------------------
CREATE TABLE facturas (
	id INT PRIMARY KEY IDENTITY(1,1),
	nroFactura INT NOT NULL UNIQUE, -- nro de factura es unico en esta tabla
	fecha DATETIME2 DEFAULT GETDATE(),
    
    -- Campos de auditor�a para control de procesos
    created_by VARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by VARCHAR(255),
    updated_at DATETIME2 DEFAULT GETDATE(),

    -- Restricciones de claves for�neas
    FOREIGN KEY (created_by) REFERENCES usuarios(id),
    FOREIGN KEY (updated_by) REFERENCES usuarios(id)
);

-- ------------------------------------------------------------------------------------------------------
-- Tabla de Carga de Combustible
-- Registra cada transacci�n de carga. Vinculada a Empresas, Combustible y Facturas.
-- ------------------------------------------------------------------------------------------------------
CREATE TABLE tcarga_combustible
(
	id INT PRIMARY KEY IDENTITY(1,1),
	idEmpresa INT NOT NULL,
	idTipo INT NOT NULL,
	litros NUMERIC(9,4) NOT NULL,
	monto  NUMERIC(18,4) NOT NULL,
	idFactura INT NOT NULL UNIQUE, -- Se vincula a la tabla de facturas
    
    -- Campos de auditor�a para control de procesos
    created_by VARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by VARCHAR(255),
    updated_at DATETIME2 DEFAULT GETDATE(),

    -- Restricciones de claves for�neas
    FOREIGN KEY (idEmpresa) REFERENCES empresas(id),
    FOREIGN KEY (idTipo) REFERENCES Combustible(id),
    FOREIGN KEY (idFactura) REFERENCES facturas(id),
    FOREIGN KEY (created_by) REFERENCES usuarios(id),
    FOREIGN KEY (updated_by) REFERENCES usuarios(id)
);





