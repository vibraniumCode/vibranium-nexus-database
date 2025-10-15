CREATE TABLE clientes (
	id INT IDENTITY (1,1) PRIMARY KEY,
	nombre VARCHAR (255) NOT NULL,
	direccion VARCHAR (255) NOT NULL,
	cuit INT UNIQUE NOT NULL,
	created_by INT,
	created_at DATETIME2 DEFAULT GETDATE() NOT NULL,
	updated_by INT,
	updated_at DATETIME2 DEFAULT GETDATE() NOT NULL,

	FOREIGN KEY (created_by) REFERENCES usuarios(id),
	FOREIGN KEY (updated_by) REFERENCES usuarios(id)
);