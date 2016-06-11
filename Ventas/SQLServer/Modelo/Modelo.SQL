/*
Empresa        :  EGCC
Software       :  Sistema de Ventas
DBMS           :  SQL SERVER
Esquema        :  ventas
Script         :  Crea la base de datos con sus respectivas tablas
Responsable    :  Ing. Eric Gustavo Coronel Castillo
Telefono       :  (511) 9966-64457
Email          :  gcoronelc@gmail.com
Blog           :  http://gcoronelc.blogspot.com
Creado el      :  20-FEB-2015

20-FEB-2015 Se agrega la tabla USUARIO.
20-FEB-2015 Se modifica la PK de la tabla PAGO y se agrega un UNIQUE (IdVenta,IdTipo).
*/



-- =============================================
-- Creación de la Base de Datos
-- =============================================

USE master;
go

IF( EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'VENTAS' ) )
BEGIN
	DROP DATABASE VENTAS;
END;
go

CREATE DATABASE VENTAS;
go


-- =============================================
-- Seleccionar la Base de Datos
-- =============================================

USE VENTAS;


-- =============================================
-- CREACION DE TABLAS DE EMPLEADOS
-- =============================================

CREATE TABLE EMPLEADO
( 
	idemp                int IDENTITY ,
	nombre               varchar(50)  NOT NULL ,
	apellido             varchar(50)  NOT NULL ,
	email                varchar(50)  NOT NULL ,
	telefono             varchar(20)  NULL ,
	CONSTRAINT XPKEMPLEADO PRIMARY KEY  NONCLUSTERED (idemp ASC)
);
go

SET IDENTITY_INSERT dbo.EMPLEADO ON;  
GO  
  

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO) 
VALUES(1001,'CLAUDIA','RAMOS','cramos@gmail.com',NULL);

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO)  
VALUES(1002,'ANGELICA','TORRES','atorres@gmail.com','967345634');

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO)  
VALUES(1003,'KARLA','GUTIERREZ','kgutierrez@gmail.com','995466783');

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO)  
VALUES(1004,'LEONOR','CARRASCO','lcarrasco@gmail.com','986754373');

GO


SET IDENTITY_INSERT dbo.EMPLEADO OFF;  
GO




-- =============================================
-- CREACION DE TABLAS DEL USUARIOS
-- =============================================

CREATE TABLE USUARIO
( 
	idemp                int  NOT NULL ,
	usuario              varchar(20)  NOT NULL ,
	clave                varbinary(100)  NOT NULL ,
	estado               smallint  NOT NULL 
	CONSTRAINT CHK_USUARIO_ESTADO CHECK  ( estado=1 OR estado=0 ),
	CONSTRAINT XPKUSUARIO PRIMARY KEY  NONCLUSTERED (idemp ASC),
	CONSTRAINT FK_USUARIO_EMPLEADO FOREIGN KEY (idemp) REFERENCES EMPLEADO(idemp)
)
go


INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1002,'atorres',HashBytes('SHA1','suerte'),1);

INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1003,'kgutierrez',HashBytes('SHA1','alegria'),1);

INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1004,'lcarrasco',HashBytes('SHA1','felicidad'),0);

GO



-- =============================================
-- CREACION DE TABLAS DEL CATALOGO
-- =============================================


CREATE TABLE CATEGORIA
( 
	idcat                int  NOT NULL ,
	nombre               VARCHAR(50)  NOT NULL ,
	CONSTRAINT XPKCATEGORIA PRIMARY KEY  NONCLUSTERED (idcat ASC)
);
go


INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(1,'LINEA BLANCA');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(2,'MENAJE');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(3,'CAMA');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(4,'MUEBLES');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(5,'ROPA DE DAMAS');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(6,'ROPA DE CABALLEROS');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(7,'ROPA DE SEÑORITAS');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(8,'ROPA DE NIÑOS');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(9,'ROPA DE NIÑAS');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(10,'ELECTRODOMESTICOS');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(11,'COMPUTO');
GO


CREATE TABLE PRODUCTO
( 
	idprod               int IDENTITY ,
	idcat                int  NOT NULL ,
	nombre               VARCHAR(100)  NOT NULL ,
	precio               NUMERIC(10,2)  NOT NULL ,
	stock                int  NOT NULL ,
	CONSTRAINT XPKPRODUCTO PRIMARY KEY  NONCLUSTERED (idprod ASC),
	CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (idcat) REFERENCES CATEGORIA(idcat)
);
go

SET IDENTITY_INSERT dbo.PRODUCTO ON;  
GO

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(1,1,'COCINA',900.0,456);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(2,7,'PANTALON',150.0,4567);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(3,1,'REFRIGERADORA',1300.0,690);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(4,7,'POLO DE VERANO',95.00,150);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(5,6,'CAMISA COLOR VERDE',140.00,250);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(6,6,'CAMISA DE CUADROS PEQUEÑOS',140.00,350);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(7,6,'PANTALON MODELO A1',1180.00,450);

GO

SET IDENTITY_INSERT dbo.PRODUCTO OFF;  
GO



-- =============================================
-- CREACION DE TABLAS DE VENTAS
-- =============================================

CREATE TABLE VENTA
( 
	idventa              int IDENTITY ,
	idemp                int  NOT NULL ,
	cliente              VARCHAR(100)  NOT NULL ,
	fecha                datetime  NOT NULL ,
	importe              NUMERIC(10,2)  NOT NULL ,
	CONSTRAINT XPKVENTA PRIMARY KEY  CLUSTERED (idventa ASC),
	CONSTRAINT R_VENTA_EMPLEADO FOREIGN KEY (idemp) REFERENCES USUARIO(idemp)
);
go


CREATE TABLE DETALLE
( 
	iddetalle            int IDENTITY ,
	idventa              int  NOT NULL ,
	idprod               int  NOT NULL ,
	cant                 NUMERIC  NOT NULL ,
	precio               NUMERIC(10,2)  NOT NULL ,
	subtotal             NUMERIC(10,2)  NULL ,
	CONSTRAINT XPKDETALLE PRIMARY KEY  CLUSTERED (iddetalle ASC),
	CONSTRAINT FK_DETALLE_PRODUCTO FOREIGN KEY (idprod) REFERENCES PRODUCTO(idprod),
	CONSTRAINT FK_DETALLE_VENTA FOREIGN KEY (idventa) REFERENCES VENTA(idventa)
);
go

CREATE UNIQUE INDEX U_DETALLE ON DETALLE
( 
	idventa               ASC,
	idprod                ASC
);
go




-- =============================================
-- CREACION DE TABLAS DE PAGOS
-- =============================================

CREATE TABLE TIPO_PAGO
( 
	idtipo               int  NOT NULL ,
	nombre               VARCHAR(50)  NOT NULL ,
	CONSTRAINT XPKTIPO_PAGO PRIMARY KEY (idtipo ASC)
);
go


INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(1,'EFECTIVO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(2,'TARJETA CREDITO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(3,'TARJETA DE DEBITO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(4,'CHEQUE');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(5,'NOTA DE CREDITO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(6,'BONO EFECTIVO');
GO


CREATE TABLE PAGO
( 
	idpago               int IDENTITY ,
	idventa              int  NOT NULL ,
	idtipo               int  NOT NULL ,
	detalle              VARCHAR(100)  NOT NULL ,
	importe              NUMERIC(10,2)  NOT NULL ,
	obs                  VARCHAR(1000)  NOT NULL ,
	CONSTRAINT XPKPAGO PRIMARY KEY (idpago ASC),
	CONSTRAINT FK_PAGO_VENTA FOREIGN KEY (idventa) REFERENCES VENTA(idventa),
	CONSTRAINT FK_PAGO_TIPO_PAGO FOREIGN KEY (idtipo) REFERENCES TIPO_PAGO(idtipo)
);
go


CREATE UNIQUE INDEX U_PAGO_UNIQUE ON PAGO
( 
	idventa               ASC,
	idtipo                ASC
);
go



