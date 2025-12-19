USE [NexusDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_detalle_gral]    Script Date: 19/12/2025 17:47:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
exec sp_detalle_gral 50
exec sp_detalle_gral 1029,3,1,12,new,1
exec sp_detalle_gral 1029,1,1,null,DLET,2
*/

CREATE   PROCEDURE [dbo].[sp_detalle_gral]
(
	@idEmpresa INT,
	@idCombustible INT = NULL,
	@idImpuesto INT = NULL,
	@monto NUMERIC(18,9) = NULL,
	@accion CHAR(4) = NULL,
	@idAccion INT = NULL
)

AS
DECLARE @value INT 

BEGIN
	SET NOCOUNT ON;

	DROP TABLE IF EXISTS TMP_CI;
	CREATE TABLE TMP_CI
	(
	 idCombustible INT,
	 importe NUMERIC(18,2)
	)

	BEGIN TRY
		IF @accion = 'NEW' 
			BEGIN
				IF @idAccion = 1
					BEGIN
						IF EXISTS(SELECT 1 FROM TCombustible WHERE idTC = @idCombustible) --VALIDO SI EXISTE EL COMBUSTIBLE
							BEGIN
								SET @value = (SELECT 1 FROM Combustible WHERE idEmpresa = @idEmpresa AND idTipo = @idCombustible) --GUARDO EL VALOR DE 1 = SI / 0 = N0 SOBRE SI YA CONTIENE EL COMBUSTIBLE SELECCIONADO
								IF @value IS NULL
									BEGIN
										--INSERT
										INSERT INTO Combustible 
											SELECT 
												@idCombustible,
												@monto,
												@idEmpresa

										INSERT INTO empGral 
											SELECT 
												@idEmpresa,
												@idCombustible,
												1,--IVA
												0.21,
												GETDATE()
								
										SELECT 'C - Se inserto correctamente' AS message
										RETURN 0;
									END
								ELSE
									BEGIN
										RAISERROR('Ya existe el combustible', 16, 1);
										RETURN;
									END
							END
						ELSE
							BEGIN
								RAISERROR('No existe el tipo de combustible', 16, 1);
								RETURN;
							END
					END
				ELSE IF @idAccion = 2
					BEGIN
						IF EXISTS(SELECT 1 FROM Timpuestos WHERE id = @idImpuesto) --VALIDO SI EXISTE EL IMPUESTO
							BEGIN
								--GUARDO VALOR PARA VER SI YA TIENE EL IMPUESTO PARA EL COMBUSTIBLE Y LA EMPRESA SELECCIONADO
								SET @value = (SELECT 1 FROM empGral WHERE 
												idEmpresa = @idEmpresa AND
												idCombustible = @idCombustible AND
												idImpuesto = @idImpuesto)
								IF @value IS NULL
									BEGIN
										--INSERT
										INSERT INTO empGral 
											SELECT 
												 @idEmpresa
												,@idCombustible
												,@idImpuesto
												,@monto
												,GETDATE()

										SELECT 'I - Se inserto correctamente' AS message
										RETURN 0;
									END
								ELSE
									BEGIN
										RAISERROR('Ya existe el impuesto', 16, 1);
										RETURN;
									END
							END
						ELSE
							BEGIN
								RAISERROR('No existe el tipo de impuesto', 16, 1);
								RETURN;
							END
					END
				ELSE
					BEGIN
						RAISERROR('Falta ingresar el @idAccion', 16, 1);
						RETURN;
					END
			END

		IF @accion = 'DLET'
			BEGIN
				IF @idAccion = 1
					BEGIN
						DELETE FROM empGral 
						WHERE
							idEmpresa = @idEmpresa 
							AND idCombustible = @idCombustible

						DELETE FROM Combustible 
						WHERE 
							idTipo = @idCombustible AND 
							idEmpresa = @idEmpresa

						SELECT 'C - Se elimino correctamente' AS message
						RETURN 0;
					END
				ELSE IF @idAccion = 2
					BEGIN
						DELETE FROM empGral 
						WHERE
							idEmpresa = @idEmpresa 
							AND idCombustible = @idCombustible
							AND idImpuesto = @idImpuesto

						SELECT 'I - Se elimino correctamente' AS message
						RETURN 0;
					END
			END

		IF @accion = 'UPD'
			BEGIN
				IF @idAccion = 1
					BEGIN
						UPDATE Combustible SET 
							precio = @monto
						WHERE
							idEmpresa = @idEmpresa 
							AND idTipo = @idCombustible

						SELECT 'PC - Se actualizo correctamente' AS message
						RETURN 0;
					END
				ELSE IF @idAccion = 2
					BEGIN
						UPDATE empGral SET 
							importe = @monto
						WHERE
							idEmpresa = @idEmpresa 
							AND idCombustible = @idCombustible
							AND idImpuesto = @idImpuesto

						SELECT 'PI - Se actualizo correctamente' AS message
						RETURN 0;
					END
			END

		SELECT 
			 nombre 
			,cuit
			,ingBrutos iibb
			,CONCAT(direccion, ' - CP(', cp, ')') direccion
			,localidad
			,provincia
			,telefono
			,FORMAT(actividad, 'dd/MM/yyyy') AS actividad
		FROM empresas
		WHERE 
			id = @idEmpresa
		
		INSERT INTO TMP_CI
		SELECT 
			 idCombustible
			,SUM(importe) AS importe
		FROM empGral 
		WHERE 
			idEmpresa = @idEmpresa
		GROUP BY 
			idCombustible

		SELECT 
			ROW_NUMBER() OVER (ORDER BY tc.txtDesc) as rn,
			 tc.idTC as id
			,tc.txtDesc AS Combustible
			,c.precio AS Imp_combustible
			,ISNULL(SUM(tmp.importe), 0) AS Imp_impuesto
			,c.precio + ISNULL(SUM(tmp.importe), 0) AS Imp_total
		FROM Combustible c
			INNER JOIN TCombustible tc ON tc.idTC = c.idTipo
			LEFT JOIN TMP_CI tmp ON tmp.idCombustible = c.idTipo
		WHERE 
			c.idEmpresa = @idEmpresa
		GROUP BY 
			 tc.idTC 
			,tc.txtDesc
			,c.precio
		ORDER BY tc.txtDesc

		SELECT 
			  eg.idCombustible
			 ,t.tipo
			 ,eg.importe
		FROM empGral eg
			INNER JOIN Timpuestos t ON t.id = eg.idImpuesto
		WHERE 
			idEmpresa = @idEmpresa
		ORDER BY idCombustible

	END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO


