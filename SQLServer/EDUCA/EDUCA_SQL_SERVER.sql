/**
 *
 * DBMS           :  SQL Server
 * Base de Datos  :  EDUCA
 * Descripción    :  Base de Datos de control académico sencillo
 * Script         :  Crea la Base de Datos
 * Creao por      :  Ing. Eric Gustavo Coronel Castillo
 * Email          :  gcoronelc@gmail.com
 * Web site       :  http://gcoronelc.blogspot.com
 * Fecha          :  15-Enero-2009
 * 
**/


-- ======================================================
-- CREA LA BASE DE DATOS
-- ======================================================

USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='EDUCA' ) )
BEGIN
	CREATE DATABASE EDUCA;
END;
GO

USE EDUCA;
GO

-- ======================================================
-- ELIMINA TABLA
-- ======================================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PAGO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PAGO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='MATRICULA' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.MATRICULA;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='CURSO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.CURSO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='ALUMNO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.ALUMNO;
END;
GO

-- ======================================================
-- TABLA ALUMNO
-- ======================================================

CREATE TABLE dbo.ALUMNO
( 
	alu_id               INT  NOT NULL ,
	alu_nombre           varchar(100)  NOT NULL ,
	alu_direccion        varchar(100)  NOT NULL ,
	alu_telefono         varchar(20)  NULL ,
	alu_email            varchar(50)  NULL 	
);
GO

-- ======================================================
-- TABLA CURSO
-- ======================================================

CREATE TABLE dbo.CURSO
( 
	cur_id               INT IDENTITY ( 1,1 ) NOT NULL ,
	cur_nombre           varchar(100)  NOT NULL ,
	cur_vacantes         int  NOT NULL ,
	cur_matriculados     int  NOT NULL ,
	cur_profesor         varchar(100)  NULL ,
	cur_precio           money  NOT NULL 
);
GO


-- ======================================================
-- TABLA MATRICULA
-- ======================================================


CREATE TABLE dbo.MATRICULA
( 
	cur_id               INT  NOT NULL ,
	alu_id               INT  NOT NULL ,
	mat_fecha            datetime  NOT NULL ,
	mat_precio           money  NOT NULL ,
	mat_cuotas           int  NOT NULL ,
	mat_nota             int  NULL 
);
GO


-- ======================================================
-- TABLA PAGO
-- ======================================================

CREATE TABLE dbo.PAGO
( 
	cur_id               INT  NOT NULL ,
	alu_id               INT  NOT NULL ,
	pag_cuota            int  NOT NULL ,
	pag_fecha            datetime  NOT NULL ,
	pag_importe          money  NOT NULL 
);
GO

-- ======================================================
-- RESTRICCIONES DE LA TABLA ALUMNO
-- ======================================================

ALTER TABLE dbo.ALUMNO
	ADD CONSTRAINT PK_ALUMNO 
	PRIMARY KEY CLUSTERED (alu_id ASC);
go

ALTER TABLE dbo.ALUMNO
	ADD CONSTRAINT U_ALUMNO_EMAIL 
	UNIQUE (alu_email  ASC);
go

ALTER TABLE dbo.ALUMNO
	ADD CONSTRAINT U_ALUMNO_NOMBRE 
	UNIQUE (alu_nombre  ASC);
go

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 1,'YESENIA VIRHUEZ','LOS OLIVOS','986412345','yesenia@hotmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 2,'OSCAR ALVARADO FERNANDEZ','MIRAFLORES',NULL,'oscar@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 3,'GLADYS REYES CORTIJO','SAN BORJA','875643562','gladys@hotmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 4,'SARA RIEGA FRIAS','SAN ISIDRO',NULL,'sara@yahoo.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 5,'JHON VELASQUEZ DEL CASTILLO','LOS OLIVOS','78645345','jhon@movistar.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 6,'RODRIGUEZ ROJAS, RENZO ROBERT','SURCO','673465235','rrodrigiez@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 7,'CALERO MORALES, EMELYN DALILA','LA MOLINA','896754652','ecalero@peru.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 8,'KAREN FUENTES','San Isidro','555-5555','KAFUENTES@HOTMAIL.COM');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 9,'Yamina Ruiz','San Isidro','965-4521','yami_ruiz@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES(10,'MARIA EULALIA VELASQUEZ TORVISCO','SURCO','6573456','mvelasques@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES(11,'FIORELLA LIZET VITELLA REYES','SAN BORJA','5468790','fvitela@outlook.com');
GO

-- ======================================================
-- RESTRICCIONES DE LA TABLA CURSO
-- ======================================================

-- CLAVE PRIMARIA

ALTER TABLE dbo.CURSO
	ADD CONSTRAINT pk_curso 
	PRIMARY KEY CLUSTERED (cur_id ASC);
go


-- El nombre del curso es único

ALTER TABLE dbo.CURSO
	ADD CONSTRAINT u_curso_nombre 
	UNIQUE (cur_nombre  ASC);
go

-- Vacantes mayor que cero

ALTER TABLE dbo.CURSO
	ADD CONSTRAINT  chk_curso_vacantes
		CHECK  ( cur_vacantes > 0 ); 
go

-- Matriculados mayor o igual que cero, y menor o igual que las vacantes

ALTER TABLE dbo.CURSO
	ADD CONSTRAINT  chk_curso_matriculados
		CHECK  ( cur_matriculados >= 0 AND cur_matriculados <= cur_vacantes ) ;
go

-- Precio mayor que cero
ALTER TABLE dbo.CURSO
	ADD CONSTRAINT  chk_curso_precio
		CHECK  ( cur_precio > 0 );
go


-- Matriculados por defecto es CERO

ALTER TABLE dbo.CURSO
	ADD CONSTRAINT DF_CURSO_MATRICULADOS
		 DEFAULT  0 FOR cur_matriculados
go


-- Insertar Datos

SET IDENTITY_INSERT dbo.Curso ON;
GO

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(1,'SQL Server Implementación',24,1000.0,'Gustavo coronel');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(2,'SQL Server Administración',24,1000.0,' ');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(3,'Inteligencia de Negocios',24,1500.0,'Sergio Matsukawa');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(4,'Programación Transact-SQL',24,1200.0,NULL);

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(5,'Java Fundamentos',24,1600.0,'Gustavo Coronel');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(6,'Java Cliente-Servidor',24,1600.0,'Gustavo Coronel');

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(7,'GESTION DE PROYECTOS',24,2200.0,'RICARDO MARCELO');
GO

SET IDENTITY_INSERT dbo.Curso OFF;
GO


-- ======================================================
-- RESTRICCIONES DE LA TABLA MATRICULA
-- ======================================================

ALTER TABLE dbo.MATRICULA
	ADD CONSTRAINT PK_MATRICULA 
	PRIMARY KEY CLUSTERED (cur_id ASC,alu_id ASC);
go

ALTER TABLE dbo.MATRICULA
	ADD CONSTRAINT FK_MATRICULA_CURSO 
	FOREIGN KEY (cur_id) 
	REFERENCES dbo.CURSO(cur_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;
GO

ALTER TABLE dbo.MATRICULA
	ADD CONSTRAINT FK_MATRICULA_ALUMNO 
	FOREIGN KEY (alu_id) 
	REFERENCES dbo.ALUMNO(alu_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;
go


ALTER TABLE dbo.MATRICULA
	ADD CONSTRAINT  CHK_MATRICULA_PRECIO
		CHECK  ( MAT_PRECIO > 0.0 );
go

ALTER TABLE dbo.MATRICULA
	ADD CONSTRAINT  CHK_MATRICULA_CUOTAS
		CHECK  ( MAT_CUOTAS > 0 );
go

ALTER TABLE dbo.MATRICULA
	ADD CONSTRAINT  CHK_MATRICULA_NOTA
		CHECK  ( (MAT_NOTA = NULL) OR (MAT_NOTA BETWEEN 0 AND 20) );
go




SET DATEFORMAT DMY
GO

DECLARE @ANIO VARCHAR(10);
SET @ANIO =  cast(year(getdate()) as varchar);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(1, 5,'15-04-' + @ANIO +' 10:30',800.0,1,15);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(1, 3,'16-04-' + @ANIO +' 11:45',1000.0,2,18);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(1, 4,'18-04-' +@ANIO +' 08:33',1200.0,3,12);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 1,'15-04-' + @ANIO +' 12:33',800.0,1,16);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 2,'01-05-' + @ANIO +' 15:34',1000.0,2,10);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 3,'03-05-' + @ANIO +' 16:55',1300.0,3,14);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 4,'04-05-' + @ANIO +' 17:00',400.0,1,18);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 5,'06-05-' + @ANIO +' 13:12',750.0,1,17);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(3, 7,'02-06-' + @ANIO +' 13:12',950.0,2,15);

GO


-- ======================================================
-- Actualizar la columna matriculados en la tabla curso
-- ======================================================

UPDATE dbo.CURSO
SET cur_matriculados = (
	SELECT COUNT(*) FROM dbo.MATRICULA
	WHERE dbo.MATRICULA.cur_id = dbo.CURSO.cur_id );
GO

-- ======================================================
-- RESTRICCIONES EN LA TABLA PAGO
-- ======================================================

-- Clave Primaria

ALTER TABLE dbo.PAGO
	ADD CONSTRAINT PK_PAGO 
	PRIMARY KEY CLUSTERED (cur_id ASC,alu_id ASC,pag_cuota ASC);
go

-- Clave Foránea

ALTER TABLE dbo.PAGO
	ADD CONSTRAINT FK_PAGO_MATRICULA 
	FOREIGN KEY (cur_id,alu_id) 
	REFERENCES dbo.MATRICULA(cur_id,alu_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

-- Cargar Datos

set dateformat dmy
go

declare @anio varchar(10)
set @anio = cast(year(getdate()) as varchar)
insert into dbo.PAGO values(1,3,1,'16-04-' + @anio,500)
insert into dbo.PAGO values(1,3,2,'16-05-' + @anio,500)
insert into dbo.PAGO values(1,4,1,'18-04-' + @anio,400)
insert into dbo.PAGO values(1,4,2,'18-05-' + @anio,400)
insert into dbo.PAGO values(2,1,1,'15-04-' + @anio,800)
insert into dbo.PAGO values(2,2,1,'01-05-' + @anio,500)
insert into dbo.PAGO values(2,3,1,'03-05-' + @anio,430)
insert into dbo.PAGO values(2,3,2,'03-06-' + @anio,430)
insert into dbo.PAGO values(2,4,1,'04-05-' + @anio,400)
insert into dbo.PAGO values(2,5,1,'06-05-' + @anio,750)
go


-- ======================================================
-- FIN
-- ======================================================

select * from dbo.ALUMNO
select * from dbo.CURSO
select * from dbo.MATRICULA
select * from dbo.PAGO
go
