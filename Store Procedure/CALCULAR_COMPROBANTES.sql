USE [NexusDB]
GO
/****** Object:  StoredProcedure [dbo].[CALCULAR_COMPROBANTES]    Script Date: 16/02/2026 18:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [CALCULAR_COMPROBANTES] 50,1,100000,50,2,10000,20000,8,'20260101','20260228'

ALTER PROCEDURE [dbo].[CALCULAR_COMPROBANTES]
	@IdEmpresa INT,
	@IdCliente INT,
    @ImporteTotal DECIMAL(18,2),
    @LitrosPromedio DECIMAL(10,2),
    @MargenLitros DECIMAL(10,2) = 2,
    @ImporteMin DECIMAL(18,2),
    @ImporteMax DECIMAL(18,2),
	@IdCombustible INT,
	@FechaDesde DATE,
	@FechaHasta DATE,
	@MargenDias INT = 2
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
		@FechaActual VARCHAR(10),
		@HoraActual VARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(HOUR, +3, GETDATE()), 108),
		@UltFactura INT,
		@FechaFactura DATE,
		@FechaAnterior DATE,
		@DiasDisponibles INT,
		@DiaAleatorio INT,
		@DiaMin INT,
		@DiaMax INT
    
    -- Validar que FechaDesde sea menor que FechaHasta
    IF @FechaDesde > @FechaHasta
    BEGIN
        RAISERROR('La fecha desde no puede ser mayor que la fecha hasta', 16, 1);
        RETURN;
    END;
    
    SET @LitroMin = @LitrosPromedio - @MargenLitros;
    SET @LitroMax = @LitrosPromedio + @MargenLitros;
	SET @grupoFactura = (SELECT CASE WHEN ID_GRUPO = 1 THEN 1 ELSE ID_GRUPO + 1 END FROM GRUPO_FACTURA);
	SET @UltFactura = (SELECT ISNULL(MAX(n_factura), 0) 
                   FROM [COMPROBANTE_HISTORICO] 
                   WHERE idEstacion = @IdEmpresa);
	SET @FechaAnterior = @FechaDesde;
	SET @DiasDisponibles = DATEDIFF(DAY, @FechaDesde, @FechaHasta);
    
    DECLARE @Comprobantes TABLE (
        NroComprobante INT,
        Litros DECIMAL(10,2),
        Importe DECIMAL(18,2),
        FechaComprobante DATE
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
        
        -- Generar fecha con margen de días (similar a litros y importes)
        -- Rango: @FechaAnterior + 1 día hasta @FechaAnterior + MargenDias
        --IF @FechaAnterior >= @FechaHasta
        --BEGIN
        --    RAISERROR('No hay más fechas disponibles dentro del rango. Se generaron %d comprobantes.', 16, 1, @ComprobanteNro);
        --    BREAK;
        --END;
        
        SET @DiaMin = 1;  -- Mínimo 1 día adelante (progresivo)
        SET @DiaMax = @MargenDias;
        
        -- Generar salto aleatorio entre DiaMin y DiaMax
        SET @DiaAleatorio = CAST(RAND() * (@DiaMax - @DiaMin + 1) + @DiaMin AS INT);
        SET @FechaFactura = DATEADD(DAY, @DiaAleatorio, @FechaAnterior);
        
        -- Si supera el límite, ajustar a la fecha final
        IF @FechaFactura > @FechaHasta
            SET @FechaFactura = @FechaHasta;
        
        SET @FechaActual = CONVERT(VARCHAR(10), @FechaFactura, 103);
        
		EXEC @nroTiquet = sp_crearFactura @IdEmpresa;
        
        INSERT INTO @Comprobantes (NroComprobante, Litros, Importe, FechaComprobante)
        VALUES (@nroTiquet, @Litros, @Importe, @FechaFactura);
        
        SET @Restante -= @Importe;
        SET @ComprobanteNro += 1;
        SET @FechaAnterior = @FechaFactura;
        
        IF @ComprobanteNro > 1000 BREAK;
    END;
    
    -- Insertar en histórico
	INSERT INTO COMPROBANTE_HISTORICO
    SELECT 
        NroComprobante,
        Litros,
        Importe,
		@grupoFactura,
		FechaComprobante,
		@HoraActual,
		@IdEmpresa,
		@IdCliente
    FROM @Comprobantes;
	
	UPDATE GRUPO_FACTURA SET ID_GRUPO = ID_GRUPO + 1;
	
    -- Resultado detallado
	SELECT 
		N_FACTURA AS NroComprobante,
		N_LITROS  AS Litros,
		IMPORTE   AS Importe,
		FECHA AS FechaFactura
	FROM COMPROBANTE_HISTORICO
	WHERE 
		idEstacion = @IdEmpresa AND
		N_FACTURA > @UltFactura;
    
    -- Resultado resumen
    SELECT 
        COUNT(*) AS CantidadComprobantes,
        SUM(Importe) AS TotalCalculado
    FROM @Comprobantes;
END;
