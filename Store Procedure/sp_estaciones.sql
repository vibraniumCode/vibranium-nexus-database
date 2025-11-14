
CREATE OR ALTER PROCEDURE [dbo].[sp_estaciones]
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
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE @fechaCarga DATE 
		DECLARE @ValueNro INT
		DECLARE @UltNro INT
		
		SET @fechaCarga = GETDATE()
		SET @ValueNro = 10000

		IF @accion = 'CTA'
			BEGIN
				SELECT 
					 id
					,nombre
					,cuit
					,ingBrutos
					,direccion
					,cp
					,localidad
					,provincia
					,telefono
					,Actividad 
				FROM empresas
				RETURN 0;
			END

		IF @accion = 'NEW'
			BEGIN
				IF EXISTS (SELECT 1 FROM empresas WHERE cuit = @cuit)
					BEGIN
						RAISERROR('Ya existe una empresa con el mismo CUIT', 16, 1);
						RETURN;
					END

				SET @UltNro = (SELECT ISNULL(MAX(n_factura),0) FROM facturas)

				INSERT INTO empresas 
				SELECT 
					 @nomEstacion
					,@cuit
					,@ingBrutos
					,@direccion
					,@cp
					,@localidad
					,@provincia
					,@telefono
					,@actividad
					,@idUser
					,@fechaCarga
					,NULL
					,NULL

				SELECT @idEstacion = id FROM empresas WHERE cuit = @cuit

				INSERT INTO FACTURAS 
					SELECT SUM(@UltNro + @ValueNro), @idEstacion
				INSERT INTO f_facturas 
					SELECT SUM(@UltNro + @ValueNro)

				SELECT 
					 'OK' AS Resultado
					,'Empresa insertada correctamente' AS Mensaje
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
		IF @accion = 'DLET'
			BEGIN 
				DELETE FROM empresas WHERE id = @idEstacion
				SELECT 'OK' AS Resultado, 'Empresa eliminada correctamente' AS Mensaje
			END 

	END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
