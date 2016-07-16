-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea Restricciones
-- Programado por :  Eric G. Coronel Castillo
-- Teléfono       :  (511) 996-664-457
-- Email          :  gcoronelc@gmail.com
-- Blog           :  gcoronelc.blogspot.com

-- =============================================
-- Seleccionar la Base de Datos
-- =============================================

USE FASTFOOD;
go

-- PRIMARY KEY
--------------

ALTER TABLE DetallePedido
	ADD CONSTRAINT pk_DetallePedido
	PRIMARY KEY (IdPedido, IdArticulo)
go

ALTER TABLE Pedido
	ADD CONSTRAINT pk_Pedido
	PRIMARY KEY (idPedido)
go

ALTER TABLE Cliente
       	ADD CONSTRAINT pk_Cliente
	PRIMARY KEY (IdCliente)
go

ALTER TABLE Documento
	ADD CONSTRAINT pk_Documento
	PRIMARY KEY (IdDocumento)
go

ALTER TABLE Articulo
       	ADD CONSTRAINT pk_Articulo
	PRIMARY KEY (IdArticulo)
go

ALTER TABLE Categoria
       	ADD CONSTRAINT pk_Categoria
	PRIMARY KEY (IdCategoria)
go

ALTER TABLE Empleado
       	ADD CONSTRAINT pk_Empleado
	PRIMARY KEY (idEmpleado)
go

ALTER TABLE Parametro
       	ADD CONSTRAINT pk_Parametro
	PRIMARY KEY (Campo)
go

ALTER TABLE Promocion
       	ADD CONSTRAINT pk_Promocion
	PRIMARY KEY (IdPromocion)
go


-- FOREIGN KEY
--------------

ALTER TABLE detallepedido
       	ADD CONSTRAINT fk_Pedido
	FOREIGN KEY (IdPedido)
       	REFERENCES Pedido
go


ALTER TABLE detallepedido
       	ADD CONSTRAINT fk_Articulo
	FOREIGN KEY (IdArticulo)
       	REFERENCES Articulo
go


ALTER TABLE Pedido
       	ADD CONSTRAINT fk_Cliente
	FOREIGN KEY (IdCliente)
       	REFERENCES Cliente
go


ALTER TABLE Pedido
       	ADD CONSTRAINT fk_Documento
	FOREIGN KEY (IdDocumento)
       	REFERENCES Documento
go


ALTER TABLE Pedido
       	ADD CONSTRAINT fk_Empleado
	FOREIGN KEY (IdEmpleado)
       	REFERENCES Empleado
go


ALTER TABLE Articulo
       	ADD CONSTRAINT fk_Categoria
	FOREIGN KEY (IdCategoria)
       	REFERENCES Categoria
go


-- UNIQUE
---------

ALTER TABLE Categoria
	ADD CONSTRAINT u_Prefijo
	UNIQUE NONCLUSTERED (prefijo)
go


-- DEFAULT
----------

ALTER TABLE Pedido
	ADD CONSTRAINT df_Delivery
	DEFAULT 0 FOR Delivery

ALTER TABLE Pedido
	ADD CONSTRAINT df_Estado
	DEFAULT 0 FOR Estado

-- CHECK
--------

ALTER TABLE Pedido
	ADD CONSTRAINT chk_Delivery
	CHECK (Delivery IN (0,1))

ALTER TABLE Pedido
	ADD CONSTRAINT chk_Estado
	CHECK (Estado IN (0,1,2,3,4))
