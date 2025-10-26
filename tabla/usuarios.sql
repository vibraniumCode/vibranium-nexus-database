CREATE TABLE usuarios
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(100),
	usuario VARCHAR(10) UNIQUE,
	password VARCHAR(255),
	email VARCHAR(100) UNIQUE,
	activo BIT DEFAULT 1,
	fechaRegistro DATETIME DEFAULT GETDATE(),
	ultimo_login DATETIME NULL
)

--INSERT INTO usuarios SELECT 'Marcos Lopez', 'mlopez', '$2b$10$JncrtnTwCQhqEhdhSbjVBe3b/qSLidYFsR/B8n1gDt.0uoAwvJSC6','vibraniumcode@gmail.com',1,getdate(),null
select * from usuarios

ALTER TABLE estaciones 
ADD CONSTRAINT FK_estaciones_created_by 
FOREIGN KEY (created_by) 
REFERENCES usuarios(id) 
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE estaciones 
ADD CONSTRAINT FK_estaciones_updated_by 
FOREIGN KEY (updated_by) 
REFERENCES usuarios(id) 
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO