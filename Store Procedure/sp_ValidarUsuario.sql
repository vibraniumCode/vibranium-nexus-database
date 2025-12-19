USE [NexusDB]
GO

/****** Object:  StoredProcedure [dbo].[sp_ValidarUsuario]    Script Date: 19/12/2025 17:49:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_ValidarUsuario]
    @usuario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id, 
        nombre,        
        usuario, 
        password, 
        activo,
        email,        
        fechaRegistro 
    FROM usuarios
    WHERE usuario = @usuario;
END;

GO


