
-- ======================================================
-- TABLA MATRICULA
-- ======================================================

USE EDUCA;
GO

CREATE TABLE dbo.NUEVOS_ALUMNOS(
	alu_nombre VARCHAR(100) NOT NULL,
	alu_direccion VARCHAR(100) NOT NULL,
	alu_telefono VARCHAR(20) NULL,
	alu_email VARCHAR(50) NULL
);
GO


INSERT INTO dbo.NUEVOS_ALUMNOS(alu_nombre,alu_direccion, alu_telefono, alu_email)
VALUES( 'YESENIA VIRHUEZ','LA MOLINA','897678567','yesenia@hotmail.com');
go

INSERT INTO dbo.NUEVOS_ALUMNOS(alu_nombre,alu_direccion, alu_telefono, alu_email)
VALUES( 'GLADYS REYES CORTIJO','SAN MIGUEL','456879023','gladys@hotmail.com')
go

INSERT INTO dbo.NUEVOS_ALUMNOS(alu_nombre,alu_direccion, alu_telefono, alu_email) 
VALUES( 'GABRIEL FLORES ARROYO','SAN MIGUEL','435679456','gabriel@gmail.com')
go

INSERT INTO dbo.NUEVOS_ALUMNOS(alu_nombre,alu_direccion, alu_telefono, alu_email) 
VALUES( 'LUIS ROJAS CASTRO','LOS OLIVOS','546784768','lrojas@hotmail.com')
go

INSERT INTO dbo.NUEVOS_ALUMNOS(alu_nombre,alu_direccion, alu_telefono, alu_email) 
VALUES( 'WILLY SANCHEZ CACHAY','SAN ISIDRO','345879567','wsanchez@gmail.com')
go

INSERT INTO dbo.NUEVOS_ALUMNOS(alu_nombre,alu_direccion, alu_telefono, alu_email) 
VALUES( 'SANDRA SOLER GARCIA','SURCO','967435672','ssoler@gmail.com')
go

select * from dbo.NUEVOS_ALUMNOS;
go
