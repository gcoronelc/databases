/*
Empresa          :  EGCC
Software         :  Sistema de Alquiler de Vehiculos
DBMS             :  SQL SERVER
Base de datos    :  BDRentaFacil
Script           :  Crea la base de datos con sus respectivas tablas.
Responsable      :  Mag. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Blog             :  http://gcoronelc.blogspot.com
Cursos virtuales :  https://gcoronelc.github.io/
Canal Youtube    :  https://www.youtube.com/DesarrollaSoftware
Creado el        :  16-OCT-2024
Actualizado el   :  02-MAY-2025 Tabla CONCEPTO, Columna GARANTIA
*/


-- =============================================
-- CREACIÓN DE LA BASE DE DATOS
-- =============================================

USE master;
go

IF( NOT EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'BDRentaFacil' ) )
BEGIN
	CREATE DATABASE BDRentaFacil;
END;
go

USE BDRentaFacil;
go

DROP TABLE IF EXISTS PAGO;
DROP TABLE IF EXISTS METODO;
DROP TABLE IF EXISTS ALQUILER;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS VEHICULO;
DROP TABLE IF EXISTS EMPLEADO;
DROP TABLE IF EXISTS MARCA;
DROP TABLE IF EXISTS ESTADO;
DROP TABLE IF EXISTS TIPO;
DROP TABLE IF EXISTS CONCEPTO;
GO



-- =============================================
-- CREACION DE TABLAS 
-- =============================================


CREATE TABLE dbo.CLIENTE
( 
	id_cliente           int IDENTITY ( 1,1 ) ,
	nombre               varchar(100)  NOT NULL ,
	email                varchar(100)  NOT NULL ,
	telefono             varchar(20)  NOT NULL ,
	CONSTRAINT XPKCLIENTE PRIMARY KEY (id_cliente ASC),
	CONSTRAINT XAK1CLIENTE UNIQUE (email  ASC)
)
go



CREATE TABLE dbo.MARCA
( 
	id_marca             int  NOT NULL ,
	nombre               varchar(50)  NOT NULL ,
	CONSTRAINT XPKMARCA PRIMARY KEY (id_marca ASC)
)
go



CREATE TABLE dbo.TIPO
( 
	id_tipo              int  NOT NULL ,
	descripcion          varchar(20)  NOT NULL ,
	descripcion_ampliada varchar(1000)  NOT NULL ,
	costo_alquiler       decimal(10,2)  NOT NULL ,
	garantia             numeric(10,2)  NOT NULL ,
	CONSTRAINT XPKTIPO PRIMARY KEY (id_tipo ASC)
)
go



CREATE TABLE dbo.ESTADO
( 
	id_estado            int  NOT NULL ,
	descripcion          varchar(20)  NOT NULL ,
	descripcion_ampliada varchar(1000)  NOT NULL ,
	CONSTRAINT XPKESTADO PRIMARY KEY (id_estado ASC)
)
go




CREATE TABLE VEHICULO
( 
	id_vehiculo          int IDENTITY ( 1,1 ) ,
	placa                varchar(10)  NOT NULL ,
	id_marca             int  NOT NULL ,
	id_tipo              int  NOT NULL ,
	id_estado            int  NOT NULL ,
	CONSTRAINT XPKVEHICULO PRIMARY KEY (id_vehiculo ASC),
	CONSTRAINT XAK1VEHICULO UNIQUE (placa  ASC),
	CONSTRAINT FK_VEHICULO_MARCA FOREIGN KEY (id_marca) REFERENCES MARCA(id_marca),
	CONSTRAINT FK_VEHICULO_TIPO FOREIGN KEY (id_tipo) REFERENCES TIPO(id_tipo),
	CONSTRAINT FK_VEHICULO_ESTADO FOREIGN KEY (id_estado) REFERENCES ESTADO(id_estado)
)
go



CREATE TABLE dbo.EMPLEADO
( 
	id_empleado          integer IDENTITY ( 1,1 ) ,
	nombre               varchar(100)  NOT NULL ,
	email                varchar(100)  NOT NULL ,
	telefono             varchar(20)  NOT NULL ,
	usuario              varchar(20)  NOT NULL ,
	clave                varchar(20)  NOT NULL ,
	CONSTRAINT XPKEMPLEADO PRIMARY KEY (id_empleado ASC),
	CONSTRAINT XAK1EMPLEADO UNIQUE (usuario  ASC),
	CONSTRAINT XAK2EMPLEADO UNIQUE (email  ASC)
)
go



CREATE TABLE dbo.ALQUILER
( 
	id_alquiler          int IDENTITY ( 1,1 ) ,
	id_empleado          integer  NULL ,
	id_cliente           int  NOT NULL ,
	id_vehiculo          int  NOT NULL ,
	fecha_inicio         datetime  NOT NULL ,
	fecha_fin            datetime  NOT NULL ,
	fecha_entrega        datetime  NOT NULL ,
	costo                decimal(10,2)  NOT NULL ,
	garantia             numeric(10,2)  NOT NULL ,
	CONSTRAINT XPKALQUILER PRIMARY KEY (id_alquiler ASC),
	CONSTRAINT FK_ALQUILER_CLIENTE FOREIGN KEY (id_cliente) REFERENCES dbo.CLIENTE(id_cliente),
	CONSTRAINT FK_ALQUILER_VEHICULO FOREIGN KEY (id_vehiculo) REFERENCES dbo.VEHICULO(id_vehiculo),
	CONSTRAINT R_8 FOREIGN KEY (id_empleado) REFERENCES dbo.EMPLEADO(id_empleado)
)
go



CREATE TABLE dbo.METODO
( 
	id_metodo            int  NOT NULL ,
	descripcion          varchar(50)  NOT NULL ,
	CONSTRAINT XPKMETODO PRIMARY KEY (id_metodo ASC)
)
go


CREATE TABLE CONCEPTO
( 
	id_concepto          integer  NOT NULL ,
	descripcion          varchar(50)  NOT NULL ,
	CONSTRAINT XPKCONCEPTO PRIMARY KEY (id_concepto ASC)
)
go


CREATE TABLE PAGO
( 
	id_pago              int IDENTITY ( 1,1 ) ,
	id_empleado          int  NOT NULL ,
	id_alquiler          int  NOT NULL ,
	id_metodo            int  NOT NULL ,
	id_concepto          integer  NOT NULL ,
	fecha                datetime  NOT NULL ,
	importe              decimal(10,2)  NOT NULL ,
	CONSTRAINT XPKPAGO PRIMARY KEY (id_pago ASC),
	CONSTRAINT FK_PAGO_ALQUILER FOREIGN KEY (id_alquiler) REFERENCES ALQUILER(id_alquiler),
	CONSTRAINT FK_PAGO_METODO FOREIGN KEY (id_metodo) REFERENCES METODO(id_metodo),
	CONSTRAINT FK_PAGO_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado),
	CONSTRAINT FK_PAGO_CONCEPTO FOREIGN KEY (id_concepto) REFERENCES CONCEPTO(id_concepto)
)
go



-- =============================================
-- CARGAR DATOS DE PRUEBA
-- =============================================


-- Tabla de Marcas

INSERT INTO marca(id_marca,nombre) VALUES (1, 'Toyota');
INSERT INTO marca(id_marca,nombre) VALUES (2, 'Ford');
INSERT INTO marca(id_marca,nombre) VALUES (3, 'Chevrolet');
INSERT INTO marca(id_marca,nombre) VALUES (4, 'Nissan');
INSERT INTO marca(id_marca,nombre) VALUES (5, 'Hyundai');
GO


-- Tabla de Tipos de Vehículos

INSERT INTO tipo(id_tipo,descripcion,descripcion_ampliada,costo_alquiler,garantia) 
VALUES (1, 'Auto', 'Vehículo pequeño adecuado para el transporte urbano.', 50.00, 4000.00);
INSERT INTO tipo(id_tipo,descripcion,descripcion_ampliada,costo_alquiler,garantia)
VALUES (2, 'Camioneta', 'Vehículo de mayor capacidad y fuerza, adecuado para carga ligera.', 80.00, 5000.00);
INSERT INTO tipo(id_tipo,descripcion,descripcion_ampliada,costo_alquiler,garantia)
VALUES (3, 'SUV', 'Vehículo deportivo utilitario con mayor espacio y tracción.', 100.00, 6000.00);
INSERT INTO tipo(id_tipo,descripcion,descripcion_ampliada,costo_alquiler,garantia)
VALUES (4, 'Van', 'Vehículo con gran capacidad de pasajeros, ideal para familias grandes.', 120.00, 7000.00);
INSERT INTO tipo(id_tipo,descripcion,descripcion_ampliada,costo_alquiler,garantia)
VALUES (5, 'Motocicleta', 'Vehículo de dos ruedas, económico y ágil para el transporte urbano.', 30.00, 2000.00);
GO

-- Tabla de Estados de Vehículos

INSERT INTO estado(id_estado,descripcion,descripcion_ampliada) VALUES (1, 'Disponible', 'El vehículo está disponible para alquilar.');
INSERT INTO estado(id_estado,descripcion,descripcion_ampliada) VALUES (2, 'Alquilado', 'El vehículo está actualmente alquilado a un cliente.');
INSERT INTO estado(id_estado,descripcion,descripcion_ampliada) VALUES (3, 'Mantenimiento', 'El vehículo está en proceso de mantenimiento o reparación.');
GO


-- Tabla de Vehículos

SET IDENTITY_INSERT dbo.vehiculo ON;  
GO  

INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (1, 'ABC-123', 1, 1, 1);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (2, 'DEF-456', 2, 2, 3);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (3, 'GHI-789', 3, 3, 1);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (4, 'JKL-101', 4, 4, 3);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (5, 'MNO-112', 5, 5, 1);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (6, 'PQR-131', 1, 1, 2);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (7, 'STU-415', 2, 2, 1);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (8, 'VWX-161', 3, 3, 1);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (9, 'YZA-718', 4, 4, 3);
INSERT INTO vehiculo(id_vehiculo,placa,id_marca,id_tipo,id_estado) VALUES (10, 'BCD-192', 5, 5,1);
GO

SET IDENTITY_INSERT dbo.vehiculo OFF;  
GO  


-- Tabla de Clientes

SET IDENTITY_INSERT dbo.cliente ON;  
GO  

INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (1, 'Carlos Mejía', 'carlos@mail.com', '123456789');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (2, 'Lucía Vela', 'lucia@mail.com', '987654321');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (3, 'Pedro Rojas', 'pedro@mail.com', '456123789');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (4, 'María Sánchez', 'maria@mail.com', '789456123');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (5, 'José Díaz', 'jose@mail.com', '321654987');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (6, 'Ana López', 'ana@mail.com', '654789321');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (7, 'Luis Torres', 'luis@mail.com', '987321654');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (8, 'Laura Rivera', 'laura@mail.com', '159753486');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (9, 'Miguel Fernández', 'miguel@mail.com', '753951486');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (10, 'Claudia Pérez', 'claudia@mail.com', '951753486');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (11, 'Sofía Ramírez', 'sofia@mail.com', '852963741');
INSERT INTO cliente(id_cliente,nombre,email,telefono) VALUES (12, 'Fernando Castro', 'fernando@mail.com', '963852741');
GO

SET IDENTITY_INSERT dbo.cliente OFF;  
GO


-- Datos para Empleados

SET IDENTITY_INSERT dbo.EMPLEADO ON;  
GO

INSERT INTO EMPLEADO(id_empleado,nombre,email,telefono,usuario,clave)
VALUES(1,'ENRIQUE REYES','ereyes@gmail.com','996325456','ereyes','secreto');
INSERT INTO EMPLEADO(id_empleado,nombre,email,telefono,usuario,clave)
VALUES(2,'DAYANA MILLER','dmiller@gmail.com','999265147','dmiller','princesa');
INSERT INTO EMPLEADO(id_empleado,nombre,email,telefono,usuario,clave)
VALUES(3,'SERGIO VELASQUEZ','svelasquez@gmail.com','996688452','svelasquez','goliat');
GO

SET IDENTITY_INSERT dbo.EMPLEADO OFF;  
GO

-- Tabla de Alquileres

SET IDENTITY_INSERT dbo.alquiler ON;  
GO

INSERT INTO alquiler(id_alquiler,id_empleado,id_cliente,id_vehiculo,fecha_inicio,fecha_fin,fecha_entrega,costo,garantia) 
VALUES (1, 1, 1, 1, GETDATE()-10, GETDATE()-5, GETDATE()-5, 0,0);
INSERT INTO alquiler(id_alquiler,id_empleado,id_cliente,id_vehiculo,fecha_inicio,fecha_fin,fecha_entrega,costo,garantia) 
VALUES (2, 1, 2, 3, GETDATE()-9, GETDATE()-4, GETDATE()-4, 0,0);
INSERT INTO alquiler(id_alquiler,id_empleado,id_cliente,id_vehiculo,fecha_inicio,fecha_fin,fecha_entrega,costo,garantia) 
VALUES (3, 1, 4, 6, GETDATE()-2, GETDATE()+5, GETDATE()+5, 0,0);
INSERT INTO alquiler(id_alquiler,id_empleado,id_cliente,id_vehiculo,fecha_inicio,fecha_fin,fecha_entrega,costo,garantia) 
VALUES (4, 2, 6, 4, GETDATE()+2, GETDATE()+7, GETDATE()+7, 0,0);
GO

SET IDENTITY_INSERT dbo.alquiler OFF;  
GO

UPDATE ALQUILER
SET costo = T.costo_alquiler * DATEDIFF(DAY,A.fecha_inicio,A.fecha_fin),
	garantia = T.garantia
FROM ALQUILER A
JOIN VEHICULO V ON A.id_vehiculo = V.id_vehiculo
JOIN TIPO T ON V.id_tipo = T.id_tipo;
GO


-- Tabla de Métodos de Pago

INSERT INTO metodo(id_metodo,descripcion) VALUES (1, 'Tarjeta');
INSERT INTO metodo(id_metodo,descripcion) VALUES (2, 'Efectivo');
INSERT INTO metodo(id_metodo,descripcion) VALUES (3, 'Transferencia Bancaria');
GO



-- Tabla de Conceptos de Pago

INSERT INTO concepto(id_concepto,descripcion) VALUES (1, 'Alquiler');
INSERT INTO concepto(id_concepto,descripcion) VALUES (2, 'Garantia');
GO



-- Tabla de Pagos

declare @pagos table(
	id                   int identity(1,1),
	id_empleado          integer  NULL ,
	id_alquiler          int  NOT NULL ,
	id_metodo            int  NOT NULL ,
	id_concpto           int  NOT NULL,
	fecha                datetime  NOT NULL ,
	importe              decimal(10,2)  NOT NULL
);
declare @id_max int, @id_actual int;
declare @fecha1 datetime, @fecha2 datetime, @fecha3 datetime;
declare @costo1 decimal(10,2), @costo2 decimal(10,2), @garantia decimal(10,2)
declare @vehiculo int, @empleado int;
declare @cuota1 decimal(10,2), @cuota2 decimal(10,2);
declare @fecha_cuota1 datetime;
select @id_max = max(id_alquiler) from ALQUILER;
set @id_actual = 1;
while(@id_actual<=@id_max)
begin
	select 
		@fecha1=fecha_inicio, @fecha2=fecha_fin, @fecha3=fecha_entrega,
		@empleado = id_empleado, @costo1 = costo, @vehiculo = id_vehiculo, @garantia = garantia
	from ALQUILER where id_alquiler=@id_actual;
	-- Cuota 1
	set @cuota1 = @costo1 / 2;
	set @fecha_cuota1 = @fecha1;
	if(@fecha_cuota1 > GETDATE()) set @fecha_cuota1 = GETDATE();
	insert into @pagos(id_alquiler,id_empleado,id_metodo,id_concpto,fecha,importe) 
	values(@id_actual,@empleado,1,1,@fecha_cuota1,@cuota1);
	-- Garantia
	insert into @pagos(id_alquiler,id_empleado,id_metodo,id_concpto,fecha,importe) 
	values(@id_actual,@empleado,2,2,@fecha_cuota1,@garantia);
	-- Verificar si hay segunda cuota
	if(@fecha1 > GETDATE() OR @fecha3 > GETDATE()) -- Se trata de una reserva
	begin
		set @id_actual = @id_actual + 1;
		continue;
	end;
	-- Cuota 2
	set @cuota2 = @cuota1;
	if(@fecha3 > @fecha3)
	begin
		select @costo2 = costo_alquiler * DATEDIFF(DAY,@fecha1,@fecha3)
		from VEHICULO v 
		join TIPO t on t.id_tipo = v.id_tipo
		where v.id_vehiculo = @vehiculo;
		set @cuota2 = @costo2 - @cuota1;
	end;
	insert into @pagos(id_alquiler,id_empleado,id_metodo,id_concpto,fecha,importe) 
	values(@id_actual,@empleado,2,1,@fecha3,@cuota2);
	-- Sentencia al final
	set @id_actual = @id_actual + 1;
end;

insert into PAGO(id_alquiler,id_empleado,id_metodo,id_concepto,fecha,importe)
select id_alquiler,id_empleado,id_metodo,id_concpto,fecha,importe from @pagos order by fecha;
go

SELECT * FROM ALQUILER;
select * from PAGO;
GO

