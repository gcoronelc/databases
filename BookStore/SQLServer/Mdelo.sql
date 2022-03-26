/**
 * Empresa           :  BookStore S.A.C.
 * Software          :  Sistema de Comercialización y Control de Stock  (SCCS)
 * DBMS              :  SQL Server
 * Esquema           :  dbo
 * Script            :  Crea los objetos de la base de datos y carga datos de prueba
 * Autor             :  Eric Gustavo Coronel Castillo
 * Email             :  gcoronelc@gmail.com
 * Sitio Web         :  www.desarrollasoftware.com
 * Blog              :  gcoronelc.blogspot.com
 * Cursos virtuales  :  gcoronelc.github.io
 * Canal de youtube  :  www.youtube.com/desarrollasoftware
**/

-- ======================================================
-- CREACIÓN DE LA BASE DE DATOS
-- ======================================================

USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='BOOKSTORE' ) )
BEGIN
	CREATE DATABASE BOOKSTORE;
END;
GO

USE BOOKSTORE;
GO


-- ======================================================
-- ELIMINACIÓN DE TABLAS
-- ======================================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='VENTA' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.VENTA;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PUBLICACION' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PUBLICACION;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='TIPO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.TIPO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='PROMOCION' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.PROMOCION;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='USUARIO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.USUARIO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='EMPLEADO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.EMPLEADO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='CONTROL' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.CONTROL;
END;
GO  
  
-- ==========================================================
-- Creación de la Tablas
-- ==========================================================


CREATE TABLE dbo.EMPLEADO
(
	idempleado           INT NOT NULL ,
	apellido             VARCHAR(100) NOT NULL ,
	nombre               VARCHAR(100) NOT NULL ,
	direccion            VARCHAR(150) NOT NULL ,
	email                VARCHAR(100) NOT NULL ,
CONSTRAINT  XPKempleado PRIMARY KEY (idempleado)
);
GO


CREATE TABLE dbo.USUARIO
(
	idempleado           INT NOT NULL ,
	usuario              VARCHAR(20) NOT NULL ,
	clave                VARCHAR(100) NOT NULL ,
	activo               INT NOT NULL ,
CONSTRAINT  XPKUSUARIO PRIMARY KEY (idempleado),
CONSTRAINT FK_USUARIO_EMPLEADO FOREIGN KEY (idempleado) REFERENCES dbo.EMPLEADO (idempleado)
);
GO

CREATE TABLE dbo.TIPO
(
	idtipo               CHAR(3) NOT NULL ,
	descripcion          VARCHAR(100) NOT NULL ,
	contador             INT NOT NULL ,
CONSTRAINT  XPKTipo PRIMARY KEY (idtipo)
);
GO


CREATE TABLE DBO.PUBLICACION
(
	idpublicacion        CHAR(8) NOT NULL ,
	titulo               VARCHAR(150) NOT NULL ,
	idtipo               CHAR(3) NOT NULL ,
	autor                VARCHAR(150) NOT NULL ,
	nroedicion           INT NOT NULL ,
	precio               MONEY NOT NULL ,
	stock                INT NOT NULL ,
CONSTRAINT  XPKPublicacion PRIMARY KEY (idpublicacion),
CONSTRAINT FK_PUBLICACION_TIPO FOREIGN KEY (idtipo) REFERENCES dbo.TIPO (idtipo)
);
GO


CREATE TABLE dbo.VENTA
(
	idventa              INT NOT NULL ,
	cliente              VARCHAR(150) NOT NULL ,
	fecha                DATETIME NOT NULL ,
	idempleado           INT NOT NULL ,
	idpublicacion        CHAR(8) NOT NULL ,
	cantidad             INT NOT NULL ,
	precio               MONEY NOT NULL ,
	dcto                 MONEY NOT NULL ,
	subtotal             MONEY NOT NULL ,
	impuesto             MONEY NOT NULL ,
	total                MONEY NOT NULL ,
CONSTRAINT  XPKVenta PRIMARY KEY (idventa),
CONSTRAINT FK_VENTA_PUBLICACION FOREIGN KEY (idpublicacion) REFERENCES dbo.PUBLICACION (idpublicacion),
CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (idempleado) REFERENCES dbo.EMPLEADO (idempleado)
);
GO


CREATE TABLE dbo.PROMOCION
(
	idpromocion          INT NOT NULL ,
	cantmin              INT NOT NULL ,
	cantmax              INT NOT NULL ,
	porcentaje           NUMERIC(8,2) NOT NULL ,
CONSTRAINT  XPKPromocion PRIMARY KEY (idpromocion)
);
GO


CREATE TABLE dbo.CONTROL
(
	parametro            VARCHAR(50) NOT NULL ,
	valor                VARCHAR(150) NOT NULL ,
CONSTRAINT  XPKControl PRIMARY KEY (parametro)
);
GO

-- ==========================================================
-- Cargar Datos de Prueba
-- ==========================================================

-- Tabla: tipo

   Insert Into dbo.tipo( idtipo,descripcion,contador ) Values( 'LIB','Libro',10 );
   Insert Into dbo.tipo( idtipo,descripcion,contador ) Values( 'REV','Revista',3 );
   Insert Into dbo.tipo( idtipo,descripcion,contador ) Values( 'SEP','Separata',8 );
	GO

-- Libros

   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00001','LIB','Power Builder','William B. Heys',1, 50.00,1000);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00002','LIB','Visual Basic','Joel Carrasco',2,45.00,1500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00003','LIB','Programación C/S con VB','Kenneth L. Spenver',1,45.00,450);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00004','LIB','JavaScript a través de Ejemplos','Jery Honeycutt',1,35.00,720);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00005','LIB','UNIX en 12 lecciones','Juan Matías Matías',1,25.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00006','LIB','Visual Basic y SQL Server','Eric G. Coronel Castillo',1,35.00,5000);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00007','LIB','Power Builder y SQL Server','Eric G. Coronel Castillo',1,35.00,5000);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00008','LIB','PHP y MySQL','Eric G. Coronel Castillo',1,55.00,5000);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00009','LIB','Lenguaje de Programación Java 2','Eric G. Coronel Castillo',1,55.00,5000);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00010','LIB','Oracle Database','Eric G. Coronel Castillo',1,75.00,5000);
	GO

-- Revistas

   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00001','REV','Eureka','GrapPeru',1,4.00,770);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00002','REV','El Programador','Desarrolla Software SAC',1,6.00,1200);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00003','REV','La Revista del Programador','DotNET SAC',1,10.00,590);
	GO

-- Separatas

   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00001','SEP','Java Orientado a Objetos','Eric G. Coronel C.',1,20.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00002','SEP','Desarrollo Web con Java','Eric G. Coronel C.',1,20.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00003','SEP','Electrónica Aplicada','Hugo Valencia M.',1,20.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00004','SEP','Circuitos Digitales','Hugo Valencia M.',1,20.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00005','SEP','SQL Server Básico','Sergio Matsukawa',1,20.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00006','SEP','SQL Server Avanzado','Sergio Matsukawa',1,20.00,500);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00007','SEP','Windows Server Fundamentos','Hugo Valencia',1,8.00,1190);
   Insert Into dbo.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00008','SEP','windows Server Administración','Sergio Matsukawa ',1,10.00,2000);
	GO

-- promociones

   Insert Into dbo.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(1,1,4,0);
   Insert Into dbo.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(2,5,10,0.05);
   Insert Into dbo.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(3,11,20,0.10);
   Insert Into dbo.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(4,21,50,0.13);
   Insert Into dbo.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(5,51,100,0.16);
   Insert Into dbo.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(6,101,10000,0.20);
	GO

-- empleados

   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(1,'AGUERO RAMOS','EMILIO','Lima','emilio@gmail.com');
   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(2,'SANCHEZ ROMERO','KATHIA','Miraflores','kathia@yahoo.es');
   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(3,'LUNG WON','FELIX','Los Olivos','gato@hotmail.com');
   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(4,'CASTILLO RAMOS','EDUARDO','Barrios altos','lalo@gmail.com');
   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(5,'MILICICH FLORES','LAURA','Collique','laura@usil.pe');
   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(6,'DELGADO BARRERA','KENNETH','La punta','pochita@gmail.com');
   Insert Into dbo.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(7,'GARCIA SOLIS','JOSE ELVIS','Barranco','pepe@gmail.com');
   GO


 -- usuarios  
   
   Insert Into dbo.usuario(idempleado,usuario,clave,activo) Values(1,'eaguero','cazador',1);
   Insert Into dbo.usuario(idempleado,usuario,clave,activo) Values(2,'ksanchez','suerte',1);
   Insert Into dbo.usuario(idempleado,usuario,clave,activo) Values(3,'flung','por100pre',0);
   Insert Into dbo.usuario(idempleado,usuario,clave,activo) Values(4,'ecastillo','hastalavista',1);
   Insert Into dbo.usuario(idempleado,usuario,clave,activo) Values(5,'lmilicich','turuleka',0);
   Insert Into dbo.usuario(idempleado,usuario,clave,activo) Values(6,'kdelgado','noimporta',1);   
   GO

-- ventas

   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(01,'ISIL',   05,GETDATE() - 60,'LIB00003',2,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(02,'UNI',    01,GETDATE() - 59,'REV00002',4,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(03,'Pedro',  03,GETDATE() - 58,'LIB00005',6,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(04,'Pablo',  02,GETDATE() - 58,'SEP00002',1,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(05,'Vilma',  01,GETDATE() - 57,'LIB00003',3,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(06,'Betty',  05,GETDATE() - 57,'REV00002',7,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(07,'Mercy',  06,GETDATE() - 56,'LIB00010',3,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(08,'Cesar', 03,GETDATE() - 55,'SEP00002',5,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(09,'Delia',  06,GETDATE() - 54,'LIB00006',8,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(10,'Nora',   05,GETDATE() - 53 ,'SEP00008',2,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(11,'Marcelo',02,GETDATE() - 52,'SEP00007',5,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(12,'Edgar',  02,GETDATE() - 51,'LIB00006',3,0,0,0,0,0);
	GO

  insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(13,'IPAE',   03,GETDATE() - 50,'LIB00003',2,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(14,'ISL',    06,GETDATE() - 49,'REV00002',4,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(15,'UNI',    01,GETDATE() - 47,'LIB00005',6,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(16,'Carmen', 03,GETDATE() - 47,'SEP00005',1,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(17,'Delia',  05,GETDATE() - 47,'LIB00003',3,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(18,'Ricardo',01,GETDATE() - 40,'REV00002',7,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(19,'Claudia',04,GETDATE() - 37,'LIB00005',3,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(20,'Roberto',06,GETDATE() - 37,'SEP00006',5,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(21,'Nora',  02,GETDATE() - 32,'LIB00006',8,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(22,'Elena',  01,GETDATE() - 32,'SEP00004',2,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(23,'Cynthia',04,GETDATE() - 29,'SEP00007',5,0,0,0,0,0);
   insert Into dbo.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(24,'Alejandra',03,GETDATE() - 29,'LIB00007',3,0,0,0,0,0);
	GO

	select * from dbo.venta;

-- Actualizar ventas

   update dbo.venta
   set precio = (select precio from dbo.publicacion
                  where publicacion.idpublicacion = venta.idpublicacion)
   from dbo.venta;
	GO

   update dbo.venta
   set dcto = (select porcentaje from dbo.promocion
                  where venta.cantidad between cantmin and cantmax) * precio
   from dbo.venta;
	GO

   update dbo.venta
   set total = cantidad * (precio - dcto);
	GO

   update dbo.venta
   set subtotal = total / 1.18;
	GO
		
   update dbo.venta
   set impuesto = total - subtotal;
	GO

-- control

   Insert Into dbo.control(parametro,valor) Values('IGV','0.18');
   Insert Into dbo.control(parametro,valor) Values('VENTA','24');
   Insert Into dbo.control(parametro,valor) Values('EMPLEADO','7');
   Insert Into dbo.control(parametro,valor) Values('EMPRESA','Desarrolla Software');   
   Insert Into dbo.control(parametro,valor) Values('SITE','www.desarrollasoftware.com'); 
	GO


-- =============================================
-- PARTE FINAL
-- =============================================

SELECT * FROM dbo.TIPO;
SELECT * FROM dbo.PUBLICACION;
SELECT * FROM dbo.VENTA;
GO

