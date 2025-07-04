/*
Empresa          :  EGCC
Software         :  Sistema de Restaurantes
DBMS             :  SQL SERVER
Base de datos    :  RestauranteDB
Script           :  Crea la base de datos con sus respectivas tablas
Responsable      :  Dr. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Sitio Web        :  https://gcoronelc.blogspot.com/
Blog             :  https://gcoronelc.github.io/
Creado el        :  04.JUL.2025
*/


-- =============================================
-- CREACIÓN DE LA BASE DE DATOS
-- =============================================

IF( NOT EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'RestauranteDB' ) )
BEGIN
	CREATE DATABASE RestauranteDB;
END;
go

USE RestauranteDB;
go

DROP TABLE IF EXISTS DETALLE_PEDIDO;
DROP TABLE IF EXISTS COMPROBANTE_DETALLE;
DROP TABLE IF EXISTS PEDIDO;
DROP TABLE IF EXISTS COMPROBANTE;
DROP TABLE IF EXISTS OCUPACION_MESA;
DROP TABLE IF EXISTS MENU;
DROP TABLE IF EXISTS CATEGORIA_MENU;
DROP TABLE IF EXISTS RESERVA;
DROP TABLE IF EXISTS MESAS;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS USUARIO;
DROP TABLE IF EXISTS ROLES;
DROP TABLE IF EXISTS ESTADO_COMPROBANTE;
DROP TABLE IF EXISTS ESTADO_MESA;
DROP TABLE IF EXISTS ESTADO_PEDIDO;
go

-- =============================================
-- CREACION DE TABLAS 
-- =============================================

-- 1. Tabla de roles de usuario
CREATE TABLE ROLES (
    id_rol           INT IDENTITY(1,1) PRIMARY KEY,
    nombre_rol       VARCHAR(30) NOT NULL
);
GO

-- 2. Tabla de usuarios
CREATE TABLE USUARIO (
    id_usuario       INT IDENTITY(1,1) PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    usuario          VARCHAR(50) NOT NULL UNIQUE,
    password_hash    VARCHAR(200) NOT NULL,
    id_rol           INT NOT NULL,
    activo           INT NOT NULL DEFAULT 1,
    fecha_registro   DATETIME DEFAULT GETDATE(),
    email            VARCHAR(100),
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (id_rol) REFERENCES ROLES(id_rol)
);
GO

-- 3. Tabla de clientes
CREATE TABLE CLIENTE (
    id_cliente      INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL,
    telefono        VARCHAR(20),
    email           VARCHAR(100),
    es_generico     INT NOT NULL DEFAULT 0
);
GO

-- 4. Catálogo de categorías del menú
CREATE TABLE CATEGORIA_MENU (
    id_categoria    INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion     VARCHAR(200)
);
GO

-- 5. Tabla de menú
CREATE TABLE MENU (
    id_menu         INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    descripcion     VARCHAR(200),
    precio          DECIMAL(10,2) NOT NULL,
    activo          INT NOT NULL DEFAULT 1,
    id_categoria    INT NOT NULL,
    CONSTRAINT FK_Menu_Categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_MENU(id_categoria)
);
GO

-- 6. Catálogo de estados de mesa
CREATE TABLE ESTADO_MESA (
    id_estado_mesa   INT IDENTITY(1,1) PRIMARY KEY,
    nombre_estado    VARCHAR(30) NOT NULL UNIQUE,
    descripcion      VARCHAR(100)
);
GO

-- 7. Tabla de mesas
CREATE TABLE MESAS (
    id_mesa           INT IDENTITY(1,1) PRIMARY KEY,
    numero_mesa       INT NOT NULL UNIQUE,
    capacidad         INT NOT NULL CHECK (capacidad > 0),
    id_estado_mesa    INT NOT NULL,
    CONSTRAINT FK_Mesas_Estado FOREIGN KEY (id_estado_mesa) REFERENCES ESTADO_MESA(id_estado_mesa)
);
GO

-- 8. Tabla de reservas
CREATE TABLE RESERVA (
    id_reserva      INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente      INT NOT NULL,
    id_mesa         INT NOT NULL,
    fecha_reserva   DATE NOT NULL,
    hora_reserva    TIME NOT NULL,
    num_personas    INT NOT NULL CHECK (num_personas > 0),
    id_usuario      INT NOT NULL,
    estado          VARCHAR(20) NOT NULL, -- Activa, Cancelada, Cumplida
    CONSTRAINT FK_Reserva_Cliente FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    CONSTRAINT FK_Reserva_Mesa FOREIGN KEY (id_mesa) REFERENCES MESAS(id_mesa),
    CONSTRAINT FK_Reserva_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);
GO

-- 9. Tabla de ocupación de mesa
CREATE TABLE OCUPACION_MESA (
    id_ocupacion        INT IDENTITY(1,1) PRIMARY KEY,
    id_mesa             INT NOT NULL,
    id_cliente          INT NOT NULL,
    fecha_hora_inicio   DATETIME NOT NULL,
    fecha_hora_fin      DATETIME,
    num_comensales      INT NOT NULL CHECK (num_comensales > 0),
    id_reserva          INT,
    id_usuario          INT NOT NULL, -- Mesero
    estado              VARCHAR(20) NOT NULL, -- Ocupada, Cerrada
    CONSTRAINT FK_Ocupacion_Mesa FOREIGN KEY (id_mesa) REFERENCES MESAS(id_mesa),
    CONSTRAINT FK_Ocupacion_Cliente FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    CONSTRAINT FK_Ocupacion_Reserva FOREIGN KEY (id_reserva) REFERENCES RESERVA(id_reserva),
    CONSTRAINT FK_Ocupacion_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);
GO

-- 10. Catálogo de estados de pedido
CREATE TABLE ESTADO_PEDIDO (
    id_estado_pedido   INT IDENTITY(1,1) PRIMARY KEY,
    nombre_estado      VARCHAR(30) NOT NULL UNIQUE,
    descripcion        VARCHAR(100)
);
GO

-- 11. Tabla de pedidos
CREATE TABLE PEDIDO (
    id_pedido           INT IDENTITY(1,1) PRIMARY KEY,
    id_ocupacion        INT NOT NULL,
    fecha_hora          DATETIME NOT NULL DEFAULT GETDATE(),
    id_estado_pedido    INT NOT NULL,
    id_usuario          INT NOT NULL,
    notas               VARCHAR(200),
    CONSTRAINT FK_Pedido_Ocupacion FOREIGN KEY (id_ocupacion) REFERENCES OCUPACION_MESA(id_ocupacion),
    CONSTRAINT FK_Pedido_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT FK_Pedido_Estado FOREIGN KEY (id_estado_pedido) REFERENCES ESTADO_PEDIDO(id_estado_pedido)
);
GO

-- 12. Tabla de detalle de pedido
CREATE TABLE DETALLE_PEDIDO (
    id_detalle_pedido   INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido           INT NOT NULL,
    id_menu             INT NOT NULL,
    cantidad            INT NOT NULL CHECK (cantidad > 0),
    precio_unitario     DECIMAL(10,2) NOT NULL,
    subtotal            DECIMAL(10,2) NOT NULL,
    id_estado_pedido    INT NOT NULL,
    CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    CONSTRAINT FK_DetallePedido_Menu FOREIGN KEY (id_menu) REFERENCES MENU(id_menu),
    CONSTRAINT FK_DetallePedido_Estado FOREIGN KEY (id_estado_pedido) REFERENCES ESTADO_PEDIDO(id_estado_pedido)
);
GO

-- 13. Catálogo de estados de comprobante
CREATE TABLE ESTADO_COMPROBANTE (
    id_estado_comprobante   INT IDENTITY(1,1) PRIMARY KEY,
    nombre_estado           VARCHAR(30) NOT NULL UNIQUE,
    descripcion             VARCHAR(100)
);
GO

-- 14. Tabla de comprobantes
CREATE TABLE COMPROBANTE (
    id_comprobante          INT IDENTITY(1,1) PRIMARY KEY,
    id_ocupacion            INT NOT NULL UNIQUE,
    fecha_emision           DATETIME NOT NULL DEFAULT GETDATE(),
    subtotal                DECIMAL(12,2) NOT NULL,
    impuesto                DECIMAL(12,2) NOT NULL,
    total                   DECIMAL(12,2) NOT NULL,
    metodo_pago             VARCHAR(50) NOT NULL,
    id_usuario              INT NOT NULL,
    id_estado_comprobante   INT NOT NULL,
    CONSTRAINT FK_Comprobante_Ocupacion FOREIGN KEY (id_ocupacion) REFERENCES OCUPACION_MESA(id_ocupacion),
    CONSTRAINT FK_Comprobante_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT FK_Comprobante_Estado FOREIGN KEY (id_estado_comprobante) REFERENCES ESTADO_COMPROBANTE(id_estado_comprobante)
);
GO

-- 15. Tabla de detalle de comprobante
CREATE TABLE COMPROBANTE_DETALLE (
    id_comprobante_detalle   INT IDENTITY(1,1) PRIMARY KEY,
    id_comprobante           INT NOT NULL,
    id_menu                  INT NOT NULL,
    cantidad                 INT NOT NULL CHECK (cantidad > 0),
    precio_unitario          DECIMAL(10,2) NOT NULL,
    subtotal                 DECIMAL(10,2) NOT NULL,
    descripcion              VARCHAR(200),
    CONSTRAINT FK_ComprobanteDetalle_Comprobante FOREIGN KEY (id_comprobante) REFERENCES COMPROBANTE(id_comprobante),
    CONSTRAINT FK_ComprobanteDetalle_Menu FOREIGN KEY (id_menu) REFERENCES MENU(id_menu)
);
GO



