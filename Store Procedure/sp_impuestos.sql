--EXEC sp_impuestos 'CHT', 1,1,3
--EXEC sp_impuestos 'DET', 1
CREATE OR ALTER PROCEDURE sp_impuestos
(
	@accion CHAR(5),
	@idEstacion INT,
	@idImpuesto INT = NULL,
	@meses INT = NULL
)

AS

BEGIN
    SET NOCOUNT ON;
		
	IF @accion = 'DET' --DETALLE ESTACION
	BEGIN
		SELECT 
			e.nombre,
			t.tipo, 
			ed.importe, 
			ed.fec_carga 
		FROM estaciones_detalle ed
			INNER JOIN empresas e ON e.id = ed.estacion
			INNER JOIN Timpuestos t ON t.id = ed.impuesto
		WHERE ed.estacion = @idEstacion AND ed.fec_carga = (
			SELECT MAX(fec_carga)
			FROM estaciones_detalle
			WHERE estacion = @idEstacion
		); 
		RETURN;
	END
	IF @accion = 'CHT'
	  BEGIN
		DECLARE @max_fec DATETIME;
		SELECT @max_fec = MAX(fec_carga) FROM estaciones_detalle WHERE estacion = @idEstacion;
		SELECT '@max_fec',@max_fec
		IF @max_fec IS NULL
		BEGIN
		  -- No hay datos
		  SELECT CAST(NULL AS VARCHAR(20)) AS mesLabel, 0 AS total, NULL AS tipo, NULL AS impuestoId;
		  RETURN;
		END

		-- Empezamos desde el primer día del mes del max_fec y retrocedemos (meses - 1) para cubrir meses completos
		SELECT
		  t.id AS impuestoId,
		  t.tipo,
		  YEAR(ed.fec_carga) AS yr,
		  MONTH(ed.fec_carga) AS mth,
		  FORMAT(ed.fec_carga, 'yyyy-MM') AS mesLabel,
		  SUM(ed.importe) AS total
		FROM estaciones_detalle ed
		  INNER JOIN Timpuestos t ON t.id = ed.impuesto
		WHERE ed.estacion = @idEstacion
		  AND ed.fec_carga >= DATEADD(MONTH, -(@meses - 1), DATEFROMPARTS(YEAR(@max_fec), MONTH(@max_fec), 1))
		  AND (@idImpuesto IS NULL OR ed.impuesto = @idImpuesto)
		GROUP BY t.id, t.tipo, YEAR(ed.fec_carga), MONTH(ed.fec_carga), FORMAT(ed.fec_carga, 'yyyy-MM')
		ORDER BY YEAR(ed.fec_carga), MONTH(ed.fec_carga);
		RETURN;
	END
END