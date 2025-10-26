CREATE OR ALTER PROCEDURE [dbo].[sp_Clientes](
	@id INT = NULL,
	@nombre VARCHAR (50) = NULL,
	@direccion VARCHAR (50) = NULL,
	@cuit VARCHAR (50) = NULL,
	@user INT = NULL,
	@accion VARCHAR (4)
)
AS 

DECLARE @fecha DATE
SET @fecha = GETDATE()

IF @accion = 'CTA'
BEGIN
	SELECT id, nombre, direccion, cuit FROM clientes
	return 0;
END 

IF @accion = 'NEW'
BEGIN
	INSERT INTO clientes 
	SELECT @nombre, 
		   @direccion, 
		   @cuit, 
		   @user, 
		   @fecha, 
		   NULL,
		   NULL
	SELECT 'OK' AS Resultado, 'Cliente insertado correctamente' AS Mensaje
END

IF @accion = 'EDIT'
BEGIN
	UPDATE clientes SET
		 nombre = @nombre
		,direccion = @direccion
		,cuit = @cuit
		,updated_by = @user
		,updated_at = @fecha
	WHERE id = @id 

	IF @@ROWCOUNT > 0
		SELECT 'OK' AS Resultado, 'Cliente actualizado correctamente' AS Mensaje, * 
		FROM clientes WHERE id = @id
	ELSE
		SELECT 'OK' AS Resultado, 'No se detectaron cambios pero la operación fue exitosa' AS Mensaje

END

IF @accion = 'DLET'
BEGIN
	DELETE FROM clientes WHERE id = @id
	SELECT 'OK' AS Resultado, 'Cliente eliminado correctamente' AS Mensaje
END
GO


