/*
Empresa          :  EGCC
Software         :  Sistema de Administración de Gimnasio
DBMS             :  SQL SERVER
Base de datos    :  GimnasioDB
Script           :  Crea la base de datos con sus respectivas tablas.
Responsable      :  Dr. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Blog             :  http://gcoronelc.blogspot.com
Cursos virtuales :  https://gcoronelc.github.io/
Canal Youtube    :  https://www.youtube.com/DesarrollaSoftware
Creado el        :  06-MAY-2025
*/


-- =============================================
-- CREACIÓN DE LA BASE DE DATOS
-- =============================================

USE master;
go

IF( NOT EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'GimnasioDB' ) )
BEGIN
	CREATE DATABASE GimnasioDB;
END;
go

USE GimnasioDB;
go

DROP TABLE IF EXISTS PAGOS;
DROP TABLE IF EXISTS SUSCRIPCIONES;
DROP TABLE IF EXISTS CLIENTES;
DROP TABLE IF EXISTS PLANES;
DROP TABLE IF EXISTS METODOSPAGO;
DROP TABLE IF EXISTS PERSONAL;
DROP TABLE IF EXISTS ROLES;
GO


-- =============================================
-- CREACION DE TABLAS 
-- =============================================


CREATE TABLE Clientes
( 
	ClienteID            int IDENTITY ( 1,1 ) ,
	Nombre               nvarchar(100)  NOT NULL ,
	Apellido             nvarchar(100)  NOT NULL ,
	DNI                  varchar(20)  NOT NULL ,
	Email                nvarchar(100)  NULL ,
	Telefono             nvarchar(20)  NULL ,
	FechaAlta            datetime  NULL 
	CONSTRAINT Default_Value_198_825109045
		 DEFAULT   GetDate( ),
	CONSTRAINT XPKClientes PRIMARY KEY (ClienteID ASC),
	CONSTRAINT XAK1Clientes UNIQUE (DNI  ASC)
)
go



CREATE TABLE Roles
( 
	RolID                int  NOT NULL ,
	NombreRol            nvarchar(50)  NOT NULL ,
	CONSTRAINT XPKRoles PRIMARY KEY (RolID ASC),
	CONSTRAINT XAK1Roles UNIQUE (NombreRol  ASC)
)
go



CREATE TABLE Personal
( 
	PersonalID           int IDENTITY ( 1,1 ) ,
	Nombre               nvarchar(100)  NOT NULL ,
	Apellido             nvarchar(100)  NOT NULL ,
	Usuario              nvarchar(50)  NOT NULL ,
	ClaveHash            nvarchar(256)  NOT NULL ,
	RolID                int  NOT NULL ,
	CONSTRAINT XPKPersonal PRIMARY KEY (PersonalID ASC),
	CONSTRAINT XAK1Personal UNIQUE (Usuario  ASC),
	CONSTRAINT FK_Personal_Rol FOREIGN KEY (RolID) REFERENCES Roles(RolID)
)
go



CREATE TABLE Planes
( 
	PlanID               int NOT NULL ,
	Nombre               nvarchar(100)  NOT NULL ,
	DuracionMeses        int  NOT NULL 
	CONSTRAINT Validation_Rule_231_1317329899
		CHECK  ( DuracionMeses >    0 ),
	Precio               decimal(10,2)  NOT NULL 
	CONSTRAINT Validation_Rule_234_722660364
		CHECK  ( Precio >=    0 ),
	CreadoPor            int  NOT NULL ,
	FechaCreacion        datetime  NULL 
	CONSTRAINT Default_Value_213_2020196317
		 DEFAULT   GetDate( ),
	CONSTRAINT XPKPlanes PRIMARY KEY (PlanID ASC),
	CONSTRAINT FK_Planes_Personal FOREIGN KEY (CreadoPor) REFERENCES Personal(PersonalID)
)
go



CREATE TABLE Suscripciones
( 
	SuscripcionID        int IDENTITY ( 1,1 ) ,
	ClienteID            int  NOT NULL ,
	PlanID               int  NOT NULL ,
	FechaInicio          datetime  NOT NULL ,
	FechaFin             datetime  NOT NULL ,
	Activa               int  NOT NULL 
	CONSTRAINT Default_Value_225_1635811509
		 DEFAULT  1,
	RegistradoPor        int  NOT NULL ,
	FechaRegistro        datetime  NULL 
	CONSTRAINT Default_Value_229_60934357
		 DEFAULT   GetDate( ),
	CONSTRAINT XPKSuscripciones PRIMARY KEY (SuscripcionID ASC),
	CONSTRAINT FK_Suscripciones_Cliente FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
CONSTRAINT FK_Suscripciones_Plan FOREIGN KEY (PlanID) REFERENCES Planes(PlanID),
CONSTRAINT FK_Suscripciones_Personal FOREIGN KEY (RegistradoPor) REFERENCES Personal(PersonalID)
)
go



CREATE TABLE MetodosPago
( 
	MetodoPagoID         int  NOT NULL ,
	Nombre               nvarchar(50)  NOT NULL ,
	CONSTRAINT XPKMetodosPago PRIMARY KEY (MetodoPagoID ASC),
	CONSTRAINT XAK1MetodosPago UNIQUE (Nombre  ASC)
)
go



CREATE TABLE Pagos
( 
	PagoID               int IDENTITY ( 1,1 ) ,
	SuscripcionID        int  NOT NULL ,
	FechaPago            datetime  NOT NULL 
	CONSTRAINT Default_Value_247_955456823
		 DEFAULT   GetDate( ),
	Monto                decimal(10,2)  NOT NULL 
	CONSTRAINT Validation_Rule_304_1565938671
		CHECK  ( Monto >=    0 ),
	MetodoPagoID         int  NOT NULL ,
	ProcesadoPor         int  NOT NULL ,
	CONSTRAINT XPKPagos PRIMARY KEY (PagoID ASC),
	CONSTRAINT FK_Pagos_Suscripcion FOREIGN KEY (SuscripcionID) REFERENCES Suscripciones(SuscripcionID),
CONSTRAINT FK_Pagos_Metodo FOREIGN KEY (MetodoPagoID) REFERENCES MetodosPago(MetodoPagoID),
CONSTRAINT FK_Pagos_Personal FOREIGN KEY (ProcesadoPor) REFERENCES Personal(PersonalID)
)
go


-- =============================================
-- CARGAR DATOS DE PRUEBA
-- =============================================


-- Insertar Roles
INSERT INTO Roles (RolID, NombreRol) VALUES 
(1, 'Administrador de Planes'),
(2, 'Recepcionista'),
(3, 'Cajero');
GO

-- Insertar Personal
INSERT INTO Personal (Nombre, Apellido, Usuario, ClaveHash, RolID) VALUES
('Laura', 'Martínez', 'lmartinez', 'HASH1', 1), -- Administradora de Planes
('Carlos', 'López', 'clopez', 'HASH2', 2),      -- Recepcionista
('Ana', 'García', 'agarcia', 'HASH3', 3);       -- Cajera
GO

-- Insertar Métodos de Pago
INSERT INTO MetodosPago (MetodoPagoID, Nombre) VALUES 
(1, 'Contado'),
(2, 'Tarjeta de crédito'),
(3, 'Transferencia bancaria');
GO

-- Insertar Planes
INSERT INTO Planes (PlanID, Nombre, DuracionMeses, Precio, CreadoPor) VALUES 
(1, 'Plan Mensual', 1, 120, 1),
(2, 'Plan Trimestral', 3, 330, 1),
(3, 'Plan Anual', 12, 1200, 1);
GO


-- Insertar Clientes
INSERT INTO Clientes (Nombre, Apellido, DNI, Email, Telefono) VALUES
('Juan', 'Pérez', '30123456', 'juan.perez@email.com', '1155551234'),
('María', 'González', '30123457', 'maria.gonzalez@email.com', '1155551235'),
('Carlos', 'Sánchez', '30123458', 'carlos.sanchez@email.com', '1155551236'),
('Laura', 'Ramírez', '30123459', 'laura.ramirez@email.com', '1155551237'),
('Pedro', 'Fernández', '30123460', 'pedro.fernandez@email.com', '1155551238'),
('Sofía', 'López', '30123461', 'sofia.lopez@email.com', '1155551239'),
('Martín', 'Díaz', '30123462', 'martin.diaz@email.com', '1155551240'),
('Valentina', 'Suárez', '30123463', 'valentina.suarez@email.com', '1155551241'),
('Lucía', 'Silva', '30123464', 'lucia.silva@email.com', '1155551242'),
('Diego', 'Castro', '30123465', 'diego.castro@email.com', '1155551243'),
('Camila', 'Molina', '30123466', 'camila.molina@email.com', '1155551244'),
('Nicolás', 'Vega', '30123467', 'nicolas.vega@email.com', '1155551245'),
('Agustina', 'Rojas', '30123468', 'agustina.rojas@email.com', '1155551246'),
('Manuel', 'Herrera', '30123469', 'manuel.herrera@email.com', '1155551247'),
('Julieta', 'Medina', '30123470', 'julieta.medina@email.com', '1155551248');
GO

-- Insertar Suscripciones (10 activas, 5 no activas)
-- Asumimos ID de planes 1-3, clientes 1-15, recepcionista (ID 2)
-- Fechas actuales y simuladas para estado


-- ACTIVAS

INSERT INTO Suscripciones (ClienteID, PlanID, FechaInicio, FechaFin, Activa, RegistradoPor, FechaRegistro)
VALUES 
(1, 1, GETDATE() - 40, GETDATE(), 1, 2, GETDATE() - 42),
(2, 2, GETDATE() - 35, GETDATE(), 1, 2, GETDATE() - 37),
(3, 1, GETDATE() - 30, GETDATE(), 1, 2, GETDATE() - 32),
(4, 1, GETDATE() - 25, GETDATE(), 1, 2, GETDATE() - 40),
(5, 3, GETDATE() - 20, GETDATE(), 1, 2, GETDATE() - 22),
(6, 2, GETDATE() - 15, GETDATE(), 1, 2, GETDATE() - 18),
(7, 1, GETDATE() - 12, GETDATE(), 1, 2, GETDATE() - 14),
(8, 2, GETDATE() - 10, GETDATE(), 1, 2, GETDATE() - 13),
(9, 1, GETDATE() - 8,  GETDATE(), 1, 2, GETDATE() - 10),
(10, 3, GETDATE() - 5, GETDATE(), 1, 2, GETDATE() - 8);
GO

-- NO ACTIVAS
INSERT INTO Suscripciones (ClienteID, PlanID, FechaInicio, FechaFin, Activa, RegistradoPor, FechaRegistro)
VALUES 
(11, 1, GETDATE() - 65, GETDATE(), 0, 2, GETDATE() - 68),
(12, 2, GETDATE() - 60, GETDATE(), 0, 2, GETDATE() - 65),
(13, 1, GETDATE() - 40, GETDATE(), 0, 2, GETDATE() - 41),
(14, 3, GETDATE() - 400, GETDATE(), 0, 2,GETDATE() - 400),
(15, 2, GETDATE() - 70, GETDATE(), 0, 2, GETDATE() - 76),
(1, 1, GETDATE() - 300, GETDATE(), 0, 2, GETDATE() - 303),
(5, 1, GETDATE() - 350, GETDATE(), 0, 2, GETDATE() - 355),
(6, 2, GETDATE() - 460, GETDATE(), 0, 2, GETDATE() - 464);
GO

-- Actualizar fecha de fin

UPDATE S
SET S.FechaFin = DATEADD(MONTH, P.DuracionMeses, S.FechaInicio)
FROM Suscripciones S
JOIN Planes P ON S.PlanID = P.PlanID;
GO


-- Insertar Pagos (1 por cada suscripción)
-- Cajero = ID 3, método de pago rotativo entre 1 y 3
-- Generar un pago por cada suscripción, con fecha 3 días antes de FechaInicio

INSERT INTO Pagos (SuscripcionID, FechaPago, Monto, MetodoPagoID, ProcesadoPor)
SELECT 
    S.SuscripcionID,
    DATEADD(DAY, -3, S.FechaInicio) AS FechaPago,
    P.Precio,
    -- Elegir aleatoriamente entre los métodos de pago existentes
    ABS(CHECKSUM(NEWID())) % 3 + 1 AS MetodoPagoID,
    3 AS ProcesadoPor -- Asumimos que el cajero tiene PersonalID = 3
FROM Suscripciones S
JOIN Planes P ON S.PlanID = P.PlanID;
GO


