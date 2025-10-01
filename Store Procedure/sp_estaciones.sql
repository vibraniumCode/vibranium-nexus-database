CREATE OR ALTER PROCEDURE sp_estaciones
(
	@nomEstacion VARCHAR(50) = NULL,
	@cuit        VARCHAR(20)  = NULL,
	@ingBrutos   VARCHAR(20)  = NULL,
	@direccion   VARCHAR(50) = NULL,
	@cp          CHAR(4)      = NULL,
	@localidad   VARCHAR(50)  = NULL,
	@provincia   VARCHAR(50)  = NULL,
	@telefono    VARCHAR(15)  = NULL,
	@actividad   DATE         = NULL,
	@idUser      INT          = NULL,
	@idEstacion  INT          = NULL,
	@accion      CHAR(4)
)

AS

DECLARE @fechaCarga DATE 
SET @fechaCarga = GETDATE()

IF @accion = 'CTA'
	BEGIN
		SELECT * FROM empresas
		RETURN 0;
	END

IF @accion = 'EDIT'
	BEGIN
		UPDATE empresas SET
			 nombre     = @nomEstacion
			,cuit       = @cuit 
			,ingBrutos  = @ingBrutos
			,direccion  = @direccion
			,cp         = @cp
			,localidad  = @localidad
			,provincia  = @provincia
			,telefono   = @telefono
			,Actividad  = @actividad
			,updated_by = @idUser
			,updated_at = @fechaCarga
		WHERE id = @idEstacion

		SELECT * FROM empresas WHERE id = @idEstacion
	END
