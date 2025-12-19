USE [NexusDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_Clientes]    Script Date: 19/12/2025 17:41:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Clientes](
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
		SELECT 'OK' AS Resultado, 'No se detectaron cambios pero la operaci�n fue exitosa' AS Mensaje

END

IF @accion = 'DLET'
BEGIN
	DELETE FROM clientes WHERE id = @id
	SELECT 'OK' AS Resultado, 'Cliente eliminado correctamente' AS Mensaje
END

GO


