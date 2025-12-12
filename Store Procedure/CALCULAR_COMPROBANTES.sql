/*
BEGIN TRAN
	EXEC CALCULAR_COMPROBANTES
		@IdEmpresa = 1029,
		@ImporteTotal = 50000,
		@LitrosPromedio = 50,
		@MargenLitros = 2,
		@ImporteMin = 4000,
		@ImporteMax = 12000,@IdCombustible=8
ROLLBACK
*/
 ALTER PROCEDURE CALCULAR_COMPROBANTES
	@IdEmpresa INT,
    @ImporteTotal DECIMAL(18,2),
    @LitrosPromedio DECIMAL(10,2),
    @MargenLitros DECIMAL(10,2) = 2,
    @ImporteMin DECIMAL(18,2),
    @ImporteMax DECIMAL(18,2),
	@IdCombustible INT
    --@PrecioPorLitro DECIMAL(18,4) = 10000  -- precio por litro fijo opcional
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @Restante DECIMAL(18,2) = @ImporteTotal,
        @Litros DECIMAL(10,2),
        @Importe DECIMAL(18,2),
        @ComprobanteNro INT = 0,
        @LitroMin DECIMAL(10,2),
        @LitroMax DECIMAL(10,2),
		@nroTiquet INT,
		@grupoFactura INT,
		@FechaActual DATETIME = GETDATE(),
		@HoraActual VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 108);

    SET @LitroMin = @LitrosPromedio - @MargenLitros;
    SET @LitroMax = @LitrosPromedio + @MargenLitros;
	SET @grupoFactura = (SELECT CASE WHEN ID_GRUPO = 1 THEN 1 ELSE ID_GRUPO + 1 END FROM GRUPO_FACTURA)

    DECLARE @Comprobantes TABLE (
        NroComprobante INT,
        Litros DECIMAL(10,2),
        Importe DECIMAL(18,2)
    );

    WHILE @Restante > 0
    BEGIN
        -- Litros aleatorios entre el rango permitido (48 a 52 si promedio=50 y margen=2)
        SET @Litros = ROUND(RAND() * (@LitroMax - @LitroMin) + @LitroMin, 2);

        -- Importe aleatorio entre el rango definido
        SET @Importe = ROUND(RAND() * (@ImporteMax - @ImporteMin) + @ImporteMin, 2);

        -- Si supera lo que queda, lo ajustamos
        IF @Importe > @Restante
            SET @Importe = @Restante;

		EXEC @nroTiquet = sp_crearFactura @IdEmpresa;

        INSERT INTO @Comprobantes (NroComprobante ,Litros, Importe)
        VALUES (@nroTiquet, @Litros, @Importe);

        SET @Restante -= @Importe;
        SET @ComprobanteNro += 1;

        IF @ComprobanteNro > 1000 BREAK;
    END;

    -- Resultado detallado
	INSERT INTO COMPROBANTE_HISTORICO
    SELECT 
        NroComprobante,
        Litros,
        Importe,
		@grupoFactura,
		CAST(@FechaActual AS DATE),  
		CONVERT(VARCHAR(8), DATEADD(HOUR, +3, GETDATE()), 108)

    FROM @Comprobantes;
	
	UPDATE GRUPO_FACTURA SET ID_GRUPO = ID_GRUPO + 1

	SELECT 
		N_FACTURA AS NroComprobante,
		N_LITROS  AS Litros,
		IMPORTE   AS Importe 
	FROM COMPROBANTE_HISTORICO

    -- Resultado resumen
    SELECT 
        COUNT(*) AS CantidadComprobantes,
        SUM(Importe) AS TotalCalculado
    FROM @Comprobantes;

END;
