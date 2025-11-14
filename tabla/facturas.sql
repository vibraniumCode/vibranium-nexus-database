
CREATE TABLE facturas (
	id_facturas INT IDENTITY(1,1) PRIMARY KEY,
	n_factura BIGINT NOT NULL UNIQUE,
	empresa_id INT NOT NULL,
	FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

CREATE TABLE f_facturas (
	num_factura BIGINT NOT NULL 
);
GO

select * from facturas
select * from f_facturas
select * from empresas

