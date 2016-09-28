-- Empresa           :  FastFood Restaurant
-- Producto          :  Servicio de Comida Rápida
-- Software          :  Sistema de Atención al Público (SAP)
-- DBMS              :  MySQL
-- Base de Datos     :  FastFood
-- Script            :  Crea la base de datos y sus respectivos objetos
-- Programado por    :  Ing. Eric G. Coronel Castillo
-- Teléfono          :  (511) 996-664-457
-- Email             :  gcoronelc@gmail.com
-- Blog              :     http://gcoronelc.blogspot.com
-- Fecha de creación : Abril-2001

-- 28/09/2016 gcoronelc Agrega la columna stock a la tabla ARTICULO.

-- =============================================
-- Creacióe la Base de Datos
-- =============================================

CREATE DATABASE 
IF NOT EXISTS FASTFOOD;


-- =============================================
-- Seleccionar la Base de Datos
-- =============================================

USE FASTFOOD;

-- =============================================
-- Eliminar las tablas en caso existan
-- =============================================

DROP TABLE IF EXISTS promocion;
DROP TABLE IF EXISTS parametro;
DROP TABLE IF EXISTS detallepedido;
DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS articulo;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS documento;

-- =============================================
-- Creación de las Tablas
-- =============================================

CREATE TABLE Promocion (
       IdPromocion          tinyint unsigned AUTO_INCREMENT,
       MontoMin             numeric(10,2) NOT NULL,
       MontoMax             numeric(10,2) NOT NULL,
       Porcentaje           tinyint unsigned NOT NULL,
       CONSTRAINT pkPromocion PRIMARY KEY(IdPromocion)
) ENGINE = INNODB;


CREATE TABLE Parametro (
       Campo                varchar(20) NOT NULL,
       Valor                varchar(20) NOT NULL,
       CONSTRAINT pkParametro PRIMARY KEY(Campo)
) ENGINE = INNODB;


CREATE TABLE Categoria (
       IdCategoria          tinyint unsigned AUTO_INCREMENT,
       NomCategoria         varchar(25) NOT NULL,
       Prefijo              char(3) NOT NULL UNIQUE,
       ConCategoria         int NOT NULL,
       CONSTRAINT pkCategoria PRIMARY KEY(IdCategoria)
) ENGINE = INNODB;


CREATE TABLE Articulo (
       IdArticulo           char(8) NOT NULL,
       IdCategoria          tinyint unsigned NOT NULL,
       NomArticulo          varchar(50) NOT NULL,
       PreArticulo          numeric(10,2) NOT NULL,
       stock                int NOT NULL,
       CONSTRAINT pkArticulo PRIMARY KEY(IdArticulo),
       CONSTRAINT fkArticuloCategoria
            FOREIGN KEY(IdCategoria)
            REFERENCES Categoria(IdCategoria)
) ENGINE = INNODB;


CREATE TABLE Cliente (
       IdCliente            char(6) NOT NULL,
       NomCliente           varchar(50) NOT NULL,
       RUC                  char(11) NOT NULL,
       DirCliente           varchar(60) NOT NULL,
       TelCliente           varchar(20) NULL,
       Clave                varchar(10) NULL,
       CONSTRAINT pkCliente PRIMARY KEY(IdCliente)
) ENGINE = INNODB;


CREATE TABLE Empleado (
       idEmpleado           char(6) NOT NULL,
       ApeEmpleado          varchar(30) NOT NULL,
       NomEmpleado          varchar(30) NOT NULL,
       DirEmpleado          varchar(60) NULL,
       TelEmpleado          varchar(20) NULL,
       Clave                varchar(10) NOT NULL,
       CONSTRAINT pkEmpleado PRIMARY KEY(idEmpleado)
) ENGINE = INNODB;


CREATE TABLE Documento (
       IdDocumento          tinyint unsigned AUTO_INCREMENT,
       NomDocumento         varchar(20) NULL,
       Serie                tinyint unsigned NOT NULL,
       ConDocumento         int NOT NULL,
       CONSTRAINT pkDocumento PRIMARY KEY(IdDocumento)
) ENGINE = INNODB;


CREATE TABLE Pedido (
       idPedido             int NOT NULL,
       IdDocumento          tinyint unsigned NOT NULL,
       IdEmpleado           char(6) NOT NULL,
       NumDocumento         varchar(15) NOT NULL,
       Fecha                datetime NOT NULL,
       IdCliente            char(6) NULL,
       NomCliente           varchar(40) NULL,
       Importe              numeric(10,2) NOT NULL,
       Descuento            numeric(10,2) NOT NULL,
       Subtotal             numeric(10,2) NOT NULL,
       IGV                  numeric(10,2) NOT NULL,
       Total                numeric(10,2) NOT NULL,
       Delivery             tinyint unsigned NOT NULL DEFAULT 0,
       Estado               tinyint unsigned NULL DEFAULT 0,
       CONSTRAINT pkPedido PRIMARY KEY(idPedido),
       CONSTRAINT fkPedidoDocumento
            FOREIGN KEY(IdDocumento)
            REFERENCES Documento(IdDocumento),
       CONSTRAINT fkPedidoEmpleado
            FOREIGN KEY(IdEmpleado)
            REFERENCES Empleado(IdEmpleado),
       CONSTRAINT fkPedidoCliente
            FOREIGN KEY(IdCliente)
            REFERENCES Cliente(IdCliente)
) ENGINE=INNODB;


CREATE TABLE DetallePedido (
       IdPedido             int NOT NULL,
       IdArticulo           char(8) NOT NULL,
       Cantidad             smallint unsigned NOT NULL,
       PreVenta             numeric(10,2) NOT NULL,
       SubTotal             numeric(10,2) NOT NULL,
       CONSTRAINT pkDetallePedido 
            PRIMARY KEY(idPedido,IdArticulo),
       CONSTRAINT fkDetallePedidoPedido
            FOREIGN KEY(IdPedido)
            REFERENCES Pedido(IdPedido),
       CONSTRAINT fkDetallePedidoArticulo
            FOREIGN KEY(IdArticulo)
            REFERENCES Articulo(IdArticulo)
) ENGINE=INNODB;



USE MYSQL;
GRANT ALL PRIVILEGES ON *.* TO 'fastfood'@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION;
FLUSH PRIVILEGES;
USE FASTFOOD;

USE MYSQL;
GRANT ALL PRIVILEGES ON *.* TO 'fastfood'@'localhost' IDENTIFIED BY 'admin' WITH GRANT OPTION;
FLUSH PRIVILEGES;
USE FASTFOOD;


select database() as "current databse";