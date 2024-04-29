/**
 *
 * DBMS              :  SQL Server
 * Base de Datos     :  EDUCA2
 * Descripción       :  Base de Datos de control académico sencillo
 * Script            :  Crea la Base de Datos
 * Creao por         :  Ing. Eric Gustavo Coronel Castillo
 * Email             :  gcoronelc@gmail.com
 * Blog              :  http://gcoronelc.blogspot.com
 * Cursos virtuales  :  https://gcoronelc.github.io/
 * Canal Youtube     :  https://www.youtube.com/DesarrollaSoftware
 * Fecha creación    :  15-Enero-2009
 * 1ra actualización :  15-Junio-2023
 *                      Tabla EMPLEADO para saber quien ha registrado la matricula y el pago.
 *                      Campo MATRICULA.mat_tipo para saber el tipo de matricula.
 * 
**/


-- ======================================================
-- CREA LA BASE DE DATOS
-- ======================================================

USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='EDUCA2' ) )
BEGIN
	CREATE DATABASE EDUCA2;
END;
GO

USE EDUCA2;
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

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='EMPLEADO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.EMPLEADO;
END;
GO


-- ======================================================
-- CREACION DE TABLAS
-- ======================================================


CREATE TABLE dbo.CURSO
( 
	cur_id               INT IDENTITY ( 1,1 ) ,
	cur_nombre           varchar(100)  NOT NULL ,
	cur_vacantes         int  NOT NULL ,
	cur_matriculados     int  NOT NULL 
	CONSTRAINT DF_CURSO_MATRICULADOS
		 DEFAULT  0,
	cur_profesor         varchar(100)  NULL ,
	cur_precio           money  NOT NULL ,
	CONSTRAINT pk_curso PRIMARY KEY (cur_id ASC),
	CONSTRAINT u_curso_nombre UNIQUE (cur_nombre  ASC),
	CONSTRAINT  chk_curso_vacantes
		CHECK  ( cur_vacantes > 0 ) ,
	CONSTRAINT  chk_curso_matriculados
		CHECK  ( cur_matriculados >= 0 AND cur_matriculados <= cur_vacantes ) ,
	CONSTRAINT  chk_curso_precio
		CHECK  ( cur_precio > 0 ) 
)
go



CREATE TABLE dbo.ALUMNO
( 
	alu_id               INT IDENTITY ( 1,1 ) ,
	alu_nombre           varchar(100)  NOT NULL ,
	alu_direccion        varchar(100)  NOT NULL ,
	alu_telefono         varchar(20)  NULL ,
	alu_email            varchar(50)  NULL ,
	CONSTRAINT PK_ALUMNO PRIMARY KEY (alu_id ASC),
	CONSTRAINT U_ALUMNO_EMAIL UNIQUE (alu_email  ASC),
	CONSTRAINT U_ALUMNO_NOMBRE UNIQUE (alu_nombre  ASC)
)
go



CREATE TABLE dbo.EMPLEADO
( 
	emp_id               integer IDENTITY ( 1,1 ) ,
	emp_apellido         varchar(100)  NOT NULL ,
	emp_nombre           varchar(100)  NOT NULL ,
	emp_direccion        varchar(100)  NOT NULL ,
	emp_email            varchar(100)  NOT NULL ,
	emp_usuario          varchar(20)  NOT NULL ,
	emp_clave            varchar(100)  NOT NULL ,
	CONSTRAINT XPKEMPLEADO PRIMARY KEY (emp_id ASC)
)
go



CREATE TABLE dbo.MATRICULA
( 
	cur_id               INT  NOT NULL ,
	alu_id               INT  NOT NULL ,
	emp_id               integer  NOT NULL ,
	mat_tipo             varchar(20)  NOT NULL 
	CONSTRAINT chk_matricula_tipo
		CHECK  ( mat_tipo IN ('REGULAR','BECA','MEDIABECA') ),
	mat_fecha            datetime  NOT NULL ,
	mat_precio           money  NOT NULL ,
	mat_cuotas           int  NOT NULL ,
	mat_nota             int  NULL ,
	CONSTRAINT PK_MATRICULA PRIMARY KEY (cur_id ASC,alu_id ASC),
	CONSTRAINT FK_MATRICULA_CURSO FOREIGN KEY (cur_id) REFERENCES dbo.CURSO(cur_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
CONSTRAINT FK_MATRICULA_ALUMNO FOREIGN KEY (alu_id) REFERENCES dbo.ALUMNO(alu_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
CONSTRAINT FK_MATRICULA_EMPLEADO FOREIGN KEY (emp_id) REFERENCES dbo.EMPLEADO(emp_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT  CHK_MATRICULA_PRECIO
		CHECK  ( MAT_PRECIO >= 0.0 ) ,
	CONSTRAINT  CHK_MATRICULA_CUOTAS
		CHECK  ( MAT_CUOTAS > 0 ) 
)
go



CREATE TABLE dbo.PAGO
( 
	cur_id               INT  NOT NULL ,
	alu_id               INT  NOT NULL ,
	pag_cuota            int  NOT NULL ,
	emp_id               integer  NOT NULL ,
	pag_fecha            datetime  NOT NULL ,
	pag_importe          money  NOT NULL ,
	CONSTRAINT PK_PAGO PRIMARY KEY (cur_id ASC,alu_id ASC,pag_cuota ASC),
	CONSTRAINT FK_PAGO_MATRICULA FOREIGN KEY (cur_id,alu_id) REFERENCES dbo.MATRICULA(cur_id,alu_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
CONSTRAINT FK_PAGO_EMPLEADO FOREIGN KEY (emp_id) REFERENCES dbo.EMPLEADO(emp_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
)
go




-- ======================================================
-- DATOS DE LA TABLA ALUMNO
-- ======================================================

SET IDENTITY_INSERT dbo.Alumno ON;
GO

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

SET IDENTITY_INSERT dbo.Alumno OFF;
GO


-- ======================================================
-- DATOS DE LA TABLA CURSO
-- ======================================================

SET IDENTITY_INSERT dbo.Curso ON;
GO

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(1,'SQL Server Implementación',30,1000.0,'Gustavo coronel');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(2,'SQL Server Administración',18,1200.0,' ');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(3,'Inteligencia de Negocios',18,1500.0,'Sergio Matsukawa');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(4,'Programación Transact-SQL',18,1200.0,NULL);

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(5,'Java Fundamentos',30,1600.0,'Gustavo Coronel');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(6,'Java Cliente-Servidor',24,1600.0,'Gustavo Coronel');

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(7,'GESTION DE PROYECTOS',30,2200.0,'Ricardo Marcelo');
GO

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(8,'PROGRAMACION CON PYTHON',30,1500.0,'');
GO

SET IDENTITY_INSERT dbo.Curso OFF;
GO


-- ======================================================
-- DATOS DE LA TABLA EMPLEADO
-- ======================================================

SET IDENTITY_INSERT dbo.empleado ON;
GO

Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(1,'AGUERO RAMOS','EMILIO','Lima','emilio@gmail.com','eaguero','cazador');
Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(2,'SANCHEZ ROMERO','KATHIA','Miraflores','kathia@yahoo.es','ksanchez','suerte');
Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(3,'LUNG WON','FELIX','Los Olivos','gato@hotmail.com','flung','por100pre');
Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(4,'CASTILLO RAMOS','EDUARDO','Barrios altos','lalo@gmail.com','ecastillo','hastalavista');
Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(5,'MILICICH FLORES','LAURA','Collique','laura@usil.pe','lmilicich','turuleka');
Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(6,'DELGADO BARRERA','KENNETH','La punta','pochita@gmail.com','kdelgado','noimporta');
Insert Into dbo.empleado(emp_id,emp_apellido,emp_nombre,emp_direccion,emp_email,emp_usuario,emp_clave) 
Values(7,'GARCIA SOLIS','JOSE ELVIS','Barranco','pepe@gmail.com','jgarcia','noselodigas');
GO

SET IDENTITY_INSERT dbo.empleado OFF;
GO

-- Operaciones finales

SET DATEFORMAT DMY
GO

DECLARE @ANIO VARCHAR(10);
SET @ANIO =  cast(year(getdate()) as varchar);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(1, 5, 2, 'MEDIABECA', '15-04-' + @ANIO +' 10:30',500.0,1,15);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(1, 3, 3, 'REGULAR', '16-04-' + @ANIO +' 11:45',1000.0,2,18);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(1, 4, 2, 'REGULAR', '18-04-' +@ANIO +' 08:33',1000.0,3,12);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 1, 4, 'MEDIABECA', '15-04-' + @ANIO +' 12:33',500.0,1,16);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 2, 3, 'REGULAR', '01-05-' + @ANIO +' 15:34',1000.0,2,10);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 3, 4, 'REGULAR', '03-05-' + @ANIO +' 16:55',1000.0,3,14);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 4, 1, 'MEDIABECA', '04-05-' + @ANIO +' 17:00',500.0,1,18);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(2, 5, 3, 'MEDIABECA', '06-05-' + @ANIO +' 13:12',500.0,1,17);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(3, 7, 2, 'REGULAR', '02-06-' + @ANIO +' 13:12',1500.0,2,15);

INSERT INTO dbo.MATRICULA ( cur_id, alu_id, emp_id, mat_tipo, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
VALUES(4, 9, 2, 'REGULAR', '03-06-' + @ANIO +' 11:10',1200.0,2,15);
GO

SELECT * FROM MATRICULA;

-- ======================================================
-- Actualizar la columna matriculados en la tabla curso
-- ======================================================

UPDATE dbo.CURSO
SET cur_matriculados = (
	SELECT COUNT(*) FROM dbo.MATRICULA
	WHERE dbo.MATRICULA.cur_id = dbo.CURSO.cur_id );
GO

-- ======================================================
-- CARGA DATOS EN LA TABLA PAGO
-- ======================================================

set dateformat dmy
go

declare @anio varchar(10)
set @anio = cast(year(getdate()) as varchar)

insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(1,3,1,3,'16-04-' + @anio,500)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(1,3,2,5,'16-05-' + @anio,500)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(1,4,1,2,'18-04-' + @anio,400)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(1,4,2,5,'18-05-' + @anio,300)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(2,1,1,4,'15-04-' + @anio,500)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(2,2,1,3,'01-05-' + @anio,500)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(2,3,1,4,'03-05-' + @anio,400)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(2,3,2,5,'03-06-' + @anio,300)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(2,4,1,1,'04-05-' + @anio,500)
insert into dbo.PAGO(cur_id,alu_id,pag_cuota,emp_id,pag_fecha,pag_importe) values(2,5,1,3,'06-05-' + @anio,500)
go


-- ======================================================
-- FIN
-- ======================================================

select * from dbo.ALUMNO
select * from dbo.CURSO
select * from dbo.MATRICULA
select * from dbo.PAGO
go
