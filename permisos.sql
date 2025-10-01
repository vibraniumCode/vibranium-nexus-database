-- Otorgar permisos SELECT a la tabla empresas
GRANT SELECT ON dbo.empresas TO mlopez_nexus;
GRANT SELECT ON dbo.combustible TO mlopez_nexus;
GRANT SELECT ON dbo.Timpuestos TO mlopez_nexus;
GRANT EXECUTE ON OBJECT::dbo.sp_impuestos TO mlopez_nexus;
GRANT EXECUTE ON OBJECT::dbo.sp_estaciones TO mlopez_nexus;