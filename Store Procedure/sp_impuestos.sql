USE [NexusDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_impuestos]    Script Date: 19/12/2025 17:48:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--EXEC [sp_impuestos]
CREATE   PROCEDURE [dbo].[sp_impuestos]
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
			INSERT INTO Timpuestos SELECT @tipo
		END

	IF @accion = 'UPD'
		BEGIN
			UPDATE Timpuestos SET tipo = @tipo WHERE id = @id
		END

	IF @accion = 'DLTE'
		BEGIN
			IF EXISTS(SELECT 1 FROM empgral WHERE idImpuesto = @id)
				BEGIN
					SELECT 'ERROR' AS Resultado, 'No se puede eliminar porque esta enlazada a una estación.'  AS Mensaje
					RETURN 0;
				END
			DELETE FROM Timpuestos WHERE id = @id
		END

	SELECT * FROM Timpuestos

END

GO


