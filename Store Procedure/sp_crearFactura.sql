USE [NexusDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_crearFactura]    Script Date: 19/12/2025 17:44:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
begin tran
	exec sp_crearFactura 1029
rollback
*/

CREATE   PROCEDURE [dbo].[sp_crearFactura] (
	@empresa_id INT --parametro que le voy a pasar al sp
	)
AS
BEGIN

DECLARE @nuevo_num BIGINT;
DECLARE @ultimo_num BIGINT;


SELECT @ultimo_num = MAX(n_factura) FROM facturas WHERE empresa_id = @empresa_id -- MAX() para buscar el valor mas alto dentro de las facturas
SELECT @nuevo_num = CAST(ABS(CHECKSUM(NEWID())) AS BIGINT) % 500 + @ultimo_num

IF NOT EXISTS (SELECT 1 FROM facturas WHERE n_factura = @nuevo_num)
BEGIN

	INSERT INTO facturas (n_factura, empresa_id) VALUES (@nuevo_num, @empresa_id);

	INSERT INTO f_facturas (num_factura) VALUES (@nuevo_num)

	RETURN  @nuevo_num 

END 
ELSE
BEGIN
    EXEC sp_crearFactura @empresa_id;
END 
END
GO


