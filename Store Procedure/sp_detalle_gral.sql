/*
exec sp_detalle_gral 1029
exec sp_detalle_gral 1029,1,5,12,new
exec sp_detalle_gral 1029,1,5,null,DLET
*/

CREATE OR ALTER PROCEDURE sp_detalle_gral
(
	@idEmpresa INT,
	@idCombustible INT = NULL,
	@idImpuesto INT = NULL,
	@monto NUMERIC(18,9) = NULL,
	@accion CHAR(4) = NULL
)

AS
DECLARE @value INT 

BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @accion = 'NEW'
			BEGIN
				SET @value = (SELECT 1 FROM empGral WHERE 
								idEmpresa = @idEmpresa AND
								idCombustible = @idCombustible AND
								idImpuesto = @idImpuesto)
				IF @value IS NULL
					BEGIN
						INSERT INTO empGral 
							SELECT 
								 @idEmpresa
								,@idCombustible
								,@idImpuesto
								,@monto
								,GETDATE()

						RETURN 0;
					END
				ELSE
					BEGIN
						RAISERROR('Ya existe el impuesto', 16, 1);
						RETURN;
					END
			END

		IF @accion = 'DLET'
			BEGIN
				DELETE FROM empGral 
				WHERE
					idEmpresa = @idEmpresa 
					AND idCombustible = @idCombustible
					AND idImpuesto = @idImpuesto

				SELECT 'Se elimino correctamente' AS message
				RETURN 0;
			END

		IF @accion = 'UPD'
			BEGIN
				UPDATE empGral SET 
					importe = @monto
				WHERE
					idEmpresa = @idEmpresa 
					AND idCombustible = @idCombustible
					AND idImpuesto = @idImpuesto

				SELECT 'Se actualizo correctamente' AS message
				RETURN 0;
			END

		SELECT 
			 nombre 
			,cuit
			,ingBrutos iibb
			,CONCAT(direccion, ' - CP(', cp, ')') direccion
			,localidad
			,provincia
			,telefono
		FROM empresas
		WHERE 
			id = @idEmpresa
		
		SELECT 
			 idCombustible
			,SUM(importe) AS importe
		INTO #TMP_CI
		FROM empGral 
		WHERE 
			idEmpresa = @idEmpresa
		GROUP BY 
			idCombustible

		SELECT 
			 tc.txtDesc AS Combustible
			,c.precio AS Imp_combustible
			,SUM(tmp.importe) AS Imp_impuesto
			,SUM(c.precio + tmp.importe) AS Imp_total
		FROM Combustible c
			INNER JOIN TCombustible tc ON tc.idTC = c.idTipo
			INNER JOIN #TMP_CI tmp ON tmp.idCombustible = c.id 
		WHERE 
			c.idEmpresa = @idEmpresa
		GROUP BY 
			 tc.txtDesc
			,c.precio

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

