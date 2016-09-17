-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea los objetos de la base de datos
-- Programado por :  Eric G. Coronel Castillo
-- Teléfono       :  (511) 996-664-457
-- Email          :  gcoronelc@gmail.com
-- Blog           :  gcoronelc.blogspot.com


-- =============================================
-- Creación de la Base de Datos
-- =============================================

USE MASTER;
go

IF( EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'FASTFOOD' ) )
BEGIN
	DROP DATABASE FASTFOOD;
END;
go

CREATE DATABASE FASTFOOD;
go


-- =============================================
-- Seleccionar la Base de Datos
-- =============================================

USE FASTFOOD;
go

-- Si las tablas existen, hay que eliminarlas
---------------------------------------------

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Promocion' )
	DROP TABLE Promocion
go

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'Parametro' )
   DROP TABLE Parametro
go

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'DetallePedido' )
   DROP TABLE DetallePedido
go

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Pedido' )
	DROP TABLE Pedido
go

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Empleado' )
	DROP TABLE Empleado
go

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Articulo' )
	DROP TABLE Articulo
go

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Categoria' )
	DROP TABLE Categoria
go

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Cliente' )
	DROP TABLE Cliente
go

IF EXISTS ( SELECT name FROM sysobjects
	WHERE type = 'U' AND name = 'Documento' )
	DROP TABLE Documento
go


-- Creación de Tablas
---------------------

CREATE TABLE DetallePedido (
       IdPedido             int NOT NULL,
       IdArticulo           varchar(8) NOT NULL,
       Cantidad             int NOT NULL,
       PreVenta             money NOT NULL,
       SubTotal             money NOT NULL
)
go

CREATE TABLE Pedido (
       idPedido             int NOT NULL,
       IdDocumento          int NOT NULL,
       IdEmpleado           char(6) NOT NULL,
       NumDocumento         varchar(15) NOT NULL,
       Fecha                datetime NOT NULL,
       IdCliente            char(6) NULL,
       NomCliente           varchar(35) NULL,
       Monto                money NOT NULL,
       Descuento            money NOT NULL,
       IGV                  money NOT NULL,
       Total                money NOT NULL,
       Delivery             bit,
       Estado               smallint NOT NULL
)
go

CREATE TABLE Cliente (
       IdCliente            char(6) NOT NULL,
       NomCliente           varchar(50) NOT NULL,
       RUC                  char(11) NOT NULL,
       DirCliente           varchar(60) NOT NULL,
       TelCliente           char(8) NULL,
       Clave                varchar(10) NULL
)
go

CREATE TABLE Documento (
       IdDocumento          int IDENTITY,
       NomDocumento         varchar(10) NULL,
       Serie                int NOT NULL,
       ConDocumento         int NOT NULL
)
go

CREATE TABLE Articulo (
       IdArticulo           varchar(8) NOT NULL,
       IdCategoria          int NOT NULL,
       NomArticulo          varchar(35) NOT NULL,
       PreArticulo          money NOT NULL
)
go

CREATE TABLE Categoria (
       IdCategoria          int IDENTITY,
       NomCategoria         varchar(25) NOT NULL,
       Prefijo              char(3) NOT NULL,
       ConCategoria         int NOT NULL
)
go

CREATE TABLE Empleado (
       idEmpleado           char(6) NOT NULL,
       ApeEmpleado          varchar(20) NOT NULL,
       NomEmpleado          varchar(20) NOT NULL,
       DirEmpleado          varchar(60) NULL,
       TelEmpleado          char(8) NULL,
       Contraseña           varchar(10) NOT NULL
)
go

CREATE TABLE Promocion (
       IdPromocion          int IDENTITY,
       MontoMin             money NOT NULL,
       MontoMax             money NOT NULL,
       Porcentaje           int NOT NULL
)
go

CREATE TABLE Parametro (
       Campo                varchar(20) NOT NULL,
       Valor                varchar(20) NOT NULL
)
go

