CREATE OR ALTER PROCEDURE sp_Clientes(
	@id INT = NULL,
	@nombre VARCHAR (50) = NULL,
	@direccion VARCHAR (50) = NULL,
	@cuit VARCHAR (50) = NULL,
	@accion VARCHAR (4),
	@fecha_cr DATE,
	@fecha_act DATE
)
AS 

IF @accion = 'CTA'
BEGIN
	SELECT id, nombre, direccion, cuit FROM clientes
	return 0;
END 

SET @fecha_cr = GETDATE()
SET @fecha_act = GETDATE()

IF @accion = 'ISRT'
BEGIN
	INSERT INTO clientes VALUES (@nombre, @direccion, @cuit, @fecha_cr, @fecha_act)  
	return 0;
END

IF @accion = 'EDIT'
BEGIN
	UPDATE clientes SET
	nombre = @nombre,
	direccion = @direccion,
	cuit = @cuit
	WHERE id = @id 
END

IF @accion = 'DLET'
BEGIN
	DELETE FROM clientes WHERE id = @id
	return 0;
END
