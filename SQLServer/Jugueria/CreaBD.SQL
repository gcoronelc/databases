/*
Empresa          :  EGCC
Software         :  Sistema de ventas de una jugueria.
DBMS             :  SQL SERVER
Base de datos    :  JugueriaDB
Script           :  Crea la base de datos con sus respectivas tablas.
Responsable      :  Mag. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Sitio Web        :  www.desarrollasoftware.com
Blog             :  http://gcoronelc.blogspot.com
Cursos virtuales :  https://gcoronelc.github.io/
Canal Youtube    :  https://www.youtube.com/DesarrollaSoftware
Creado el        :  24-OCT-2024
*/


-- =============================================
-- CREACIÓN DE LA BASE DE DATOS
-- =============================================

USE master;
go

IF( EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'JugueriaDB' ) )
BEGIN
	DROP DATABASE JugueriaDB;
END;
go

CREATE DATABASE JugueriaDB;
go


-- =============================================
-- SELECCIONAR LA BASE DE DATOS
-- =============================================

USE JugueriaDB;
GO


-- =============================================
-- CREACION DE TABLAS 
-- =============================================


CREATE TABLE dbo.EMPLEADO
( 
	id_empleado          int IDENTITY ( 1,1 ) ,
	nombre               varchar(100)  NOT NULL ,
	telefono             varchar(15)  NOT NULL ,
	usuario              varchar(20)  NOT NULL ,
	clave                varchar(20)  NOT NULL ,
	CONSTRAINT XPKEMPLEADO PRIMARY KEY (id_empleado ASC),
	CONSTRAINT XAK1EMPLEADO UNIQUE (usuario  ASC)
)
go



CREATE TABLE dbo.VENTA
( 
	id_venta             int IDENTITY ( 1,1 ) ,
	id_empleado          int  NOT NULL ,
	fecha                datetime  NULL ,
	importe              numeric(10,2)  NOT NULL ,
	impuesto             numeric(10,2)  NOT NULL ,
	total                numeric(10,2)  NOT NULL ,
	CONSTRAINT XPKVENTA PRIMARY KEY (id_venta ASC),
	CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES dbo.EMPLEADO(id_empleado)
)
go



CREATE TABLE dbo.CATEGORIA
( 
	id_categoria         int  NOT NULL ,
	nombre               varchar(100)  NOT NULL ,
	CONSTRAINT XPKCATEGORIA PRIMARY KEY (id_categoria ASC)
)
go



CREATE TABLE dbo.PRODUCTO
( 
	id_producto          int IDENTITY ( 1,1 ) ,
	id_categoria         int  NOT NULL ,
	nombre               varchar(100)  NOT NULL ,
	precio               numeric(10,2)  NOT NULL ,
	stock                integer  NOT NULL ,
	CONSTRAINT XPKPRODUCTO PRIMARY KEY (id_producto ASC),
	CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (id_categoria) REFERENCES dbo.CATEGORIA(id_categoria)
)
go



CREATE TABLE dbo.DETALLE_VENTA
( 
	id_detalle           int IDENTITY ( 1,1 ) ,
	id_venta             int  NOT NULL ,
	id_producto          int  NOT NULL ,
	cantidad             int  NOT NULL ,
	precio               numeric(10,2)  NOT NULL ,
	subtotal             numeric(10,2)  NOT NULL ,
	CONSTRAINT XPKDETALLE_VENTA PRIMARY KEY (id_detalle ASC),
	CONSTRAINT FK_DETALLE_VENTA_VENTA FOREIGN KEY (id_venta) REFERENCES dbo.VENTA(id_venta),
	CONSTRAINT FK_DETALLE_VENTA_PRODUCTO FOREIGN KEY (id_producto) REFERENCES dbo.PRODUCTO(id_producto)
)
go



CREATE TABLE dbo.PROMOCION
( 
	id_promocion         int IDENTITY ( 1,1 ) ,
	nombre               varchar(100)  NOT NULL ,
	fecha_inicio         datetime  NOT NULL ,
	fecha_fin            datetime  NOT NULL ,
	CONSTRAINT XPKPROMOCION PRIMARY KEY (id_promocion ASC)
)
go



CREATE TABLE dbo.PRODUCTO_PROMOCION
( 
	id_producto_promocion int IDENTITY ( 1,1 ) ,
	id_promocion         int  NOT NULL ,
	id_producto          int  NOT NULL ,
	porc_descuento       decimal(5,2)  NOT NULL ,
	CONSTRAINT XPKPRODUCTO_PROMOCION PRIMARY KEY (id_producto_promocion ASC),
	CONSTRAINT FK_PRODUCTO_PROMOCIION_PROMOCION FOREIGN KEY (id_promocion) REFERENCES dbo.PROMOCION(id_promocion),
CONSTRAINT FK_PRODUCTO_PROMOCION_PRODUCTO FOREIGN KEY (id_producto) REFERENCES dbo.PRODUCTO(id_producto)
)
go


