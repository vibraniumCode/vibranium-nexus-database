--EXEC [sp_combustible]
CREATE OR ALTER PROCEDURE [dbo].[sp_combustible]
(
	@id            INT = NULL,
	@tipo          VARCHAR(60) = NULL,
	@accion        CHAR(5) = NULL
)

AS
BEGIN
    SET NOCOUNT ON;
		
	IF @accion = 'NEW'
		BEGIN
			INSERT INTO TCombustible SELECT @tipo
		END

	IF @accion = 'UPD'
		BEGIN
			UPDATE TCombustible SET txtDesc = @tipo WHERE idTC = @id
		END

	IF @accion = 'DLTE'
		BEGIN
			DELETE FROM TCombustible WHERE idTC = @id
		END

	SELECT * FROM TCombustible

END
GO


