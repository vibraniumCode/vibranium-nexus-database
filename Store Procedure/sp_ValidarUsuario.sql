CREATE OR ALTER PROCEDURE [dbo].[sp_ValidarUsuario]
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


