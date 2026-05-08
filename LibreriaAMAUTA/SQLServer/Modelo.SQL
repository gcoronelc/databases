/**
 *
 * DBMS              :  SQL Server
 * Base de Datos     :  AMAUTA
 * Descripción       :  Base de Datos de la Librería Universitaria "Amauta"
 * Script            :  Crea la Base de Datos
 * Creao por         :  Dr. Eric Gustavo Coronel Castillo
 * Email             :  gcoronelc@gmail.com
 * Blog              :  http://gcoronelc.blogspot.com
 * Cursos virtuales  :  https://gcoronelc.github.io/
 * Canal Youtube     :  https://www.youtube.com/DesarrollaSoftware
 * Fecha creación    :  03-MAY-2026
 * 
**/


-- -----------------------------------------------------------------------------
-- 1. CREACIÓN DE LA BASE DE DATOS
-- -----------------------------------------------------------------------------

USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='AMAUTA' ) )
BEGIN
	CREATE DATABASE AMAUTA;
END;
GO

USE AMAUTA;
GO


-- ======================================================
-- 2. ELIMINA TABLAS
-- ======================================================

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='VENTA' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.VENTA;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='CLIENTE' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.CLIENTE;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='EMPLEADO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.EMPLEADO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='LIBRO' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.LIBRO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects 
	WHERE name='CATEGORIA' and xtype = 'u') )
BEGIN
	DROP TABLE dbo.CATEGORIA;
END;
GO



-- -----------------------------------------------------------------------------
-- 3. CREACIÓN DE TABLAS
-- -----------------------------------------------------------------------------

-- Tabla: CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria   INT             NOT NULL IDENTITY(1,1),
    nombre         VARCHAR(50)     NOT NULL,
    descripcion    VARCHAR(200)        NULL,
    CONSTRAINT PK_CATEGORIA         PRIMARY KEY (id_categoria),
    CONSTRAINT UQ_CATEGORIA_NOMBRE  UNIQUE      (nombre)
);
GO

-- Tabla: LIBRO
CREATE TABLE LIBRO (
    id_libro       INT             NOT NULL IDENTITY(1,1),
    titulo         VARCHAR(200)    NOT NULL,
    autor          VARCHAR(100)    NOT NULL,
    precio         DECIMAL(8,2)    NOT NULL,
    stock          INT             NOT NULL CONSTRAINT DF_LIBRO_STOCK DEFAULT 0,
    id_categoria   INT             NOT NULL,
    CONSTRAINT PK_LIBRO         PRIMARY KEY (id_libro),
    CONSTRAINT FK_LIBRO_CAT     FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria),
    CONSTRAINT CK_LIBRO_PRECIO  CHECK (precio > 0),
    CONSTRAINT CK_LIBRO_STOCK   CHECK (stock  >= 0)
);
GO

-- Tabla: CLIENTE
-- tipo  : ESTUDIANTE | DOCENTE | EXTERNO
-- estado: ACTIVO | INACTIVO | SUSPENDIDO
CREATE TABLE CLIENTE (
    id_cliente  INT             NOT NULL IDENTITY(1,1),
    nombre      VARCHAR(100)    NOT NULL,
    apellido    VARCHAR(100)    NOT NULL,
    correo      VARCHAR(100)    NOT NULL,
    tipo        VARCHAR(10)     NOT NULL,
    estado      VARCHAR(11)     NOT NULL CONSTRAINT DF_CLIENTE_ESTADO DEFAULT 'ACTIVO',
    CONSTRAINT PK_CLIENTE           PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_CLIENTE_CORREO    UNIQUE      (correo),
    CONSTRAINT CK_CLIENTE_TIPO      CHECK (tipo   IN ('ESTUDIANTE','DOCENTE','EXTERNO')),
    CONSTRAINT CK_CLIENTE_ESTADO    CHECK (estado IN ('ACTIVO','INACTIVO','SUSPENDIDO'))
);
GO

-- Tabla: EMPLEADO
-- usuario: nombre de usuario único para autenticación
-- clave  : hash SHA-256 de la contraseña (64 caracteres hexadecimales)
--          generado con: LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256','texto'), 2))
CREATE TABLE EMPLEADO (
    id_empleado INT             NOT NULL IDENTITY(1,1),
    nombre      VARCHAR(100)    NOT NULL,
    apellido    VARCHAR(100)    NOT NULL,
    cargo       VARCHAR(50)     NOT NULL,
    usuario     VARCHAR(50)     NOT NULL,
    clave       VARCHAR(64)     NOT NULL,
    CONSTRAINT PK_EMPLEADO          PRIMARY KEY (id_empleado),
    CONSTRAINT UQ_EMPLEADO_USUARIO  UNIQUE      (usuario)
);
GO

-- Tabla: VENTA
-- Reglas de negocio:
--   R1: id_cliente debe tener estado = 'ACTIVO'
--   R2: descuento = 15% DOCENTE | 10% ESTUDIANTE | 0% EXTERNO
--   R3: stock de LIBRO debe ser >= cantidad solicitada
--   monto_final = precio_unitario * cantidad * (1 - descuento / 100)
CREATE TABLE VENTA (
    id_venta        INT             NOT NULL IDENTITY(1,1),
    fecha           DATE            NOT NULL,
    cantidad        INT             NOT NULL,
    precio_unitario DECIMAL(8,2)    NOT NULL,
    descuento       DECIMAL(5,2)    NOT NULL CONSTRAINT DF_VENTA_DESCUENTO DEFAULT 0.00,
    monto_final     DECIMAL(10,2)   NOT NULL,
    id_libro        INT             NOT NULL,
    id_cliente      INT             NOT NULL,
    id_empleado     INT             NOT NULL,
    CONSTRAINT PK_VENTA             PRIMARY KEY (id_venta),
    CONSTRAINT FK_VENTA_LIBRO       FOREIGN KEY (id_libro)
        REFERENCES LIBRO(id_libro),
    CONSTRAINT FK_VENTA_CLIENTE     FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT FK_VENTA_EMPLEADO    FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO(id_empleado),
    CONSTRAINT CK_VENTA_CANTIDAD    CHECK (cantidad  > 0),
    CONSTRAINT CK_VENTA_DESCUENTO   CHECK (descuento >= 0 AND descuento <= 100)
);
GO



-- -----------------------------------------------------------------------------
-- 4. DATOS DE PRUEBA
-- -----------------------------------------------------------------------------

-- CATEGORIA
INSERT INTO CATEGORIA (nombre, descripcion) VALUES
('Ingeniería de Sistemas',  'Programación, algoritmos y arquitectura de software'),
('Ciencias Básicas',        'Matemáticas, física y estadística'),
('Administración',          'Gestión empresarial y finanzas'),
('Humanidades',             'Filosofía, comunicación y ética');
GO

-- LIBRO
INSERT INTO LIBRO (titulo, autor, precio, stock, id_categoria) VALUES
('Clean Code',                          'Robert C. Martin',    89.90,  35, 1),
('Java: The Complete Reference',        'Herbert Schildt',    120.00,  30, 1),
('Patrones de Diseño',                  'Gang of Four',        95.50,  28, 1),
('Cálculo Diferencial e Integral',      'James Stewart',      110.00,  40, 2),
('Estadística para Ingeniería',         'Douglas Montgomery',  98.00,  32, 2),
('Administración Estratégica',          'Fred David',          75.00,  38, 3),
('Ética Profesional en Ingeniería',     'Martin Curd',         55.00,  55, 4);
GO

-- CLIENTE
INSERT INTO CLIENTE (nombre, apellido, correo, tipo, estado) VALUES
('Luis',     'Torres Ríos',     'ltorres@uni.edu.pe',    'ESTUDIANTE', 'ACTIVO'),
('María',    'Paredes Vega',    'mparedes@uni.edu.pe',   'ESTUDIANTE', 'ACTIVO'),
('Carlos',   'Mendoza León',    'cmendoza@uni.edu.pe',   'DOCENTE',    'ACTIVO'),
('Ana',      'Flores Castillo', 'aflores@uni.edu.pe',    'DOCENTE',    'ACTIVO'),
('Roberto',  'Huamán Quispe',   'rhuaman@gmail.com',     'EXTERNO',    'ACTIVO'),
('Jorge',    'Salas Puma',      'jsalas@uni.edu.pe',     'ESTUDIANTE', 'INACTIVO'),
('Patricia', 'Rojas Díaz',      'projasuni@uni.edu.pe',  'ESTUDIANTE', 'SUSPENDIDO');
GO

-- EMPLEADO
-- Credenciales (solo referencia del docente):
--   cvillanueva / carmen123
--   pquispe     / pedro456
--   sramos      / sofia789
-- Función hash: LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'clave'), 2))
INSERT INTO EMPLEADO (nombre, apellido, cargo, usuario, clave) VALUES
('Carmen', 'Villanueva Paz', 'Cajera',
    'cvillanueva',
    LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'carmen123'), 2))),
('Pedro',  'Quispe Mamani',  'Vendedor',
    'pquispe',
    LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pedro456'), 2))),
('Sofia',  'Ramos Torres',   'Supervisora',
    'sramos',
    LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'sofia789'), 2)));
GO

-- VENTA (datos base ya transaccionados)
-- Venta 1: Luis Torres (ESTUDIANTE 10%) compra Clean Code x1
INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                   id_libro, id_cliente, id_empleado)
VALUES (CAST(GETDATE() AS DATE), 1, 89.90, 10.00, ROUND(89.90 * 1 * 0.90, 2), 1, 1, 1);
UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 1;

-- Venta 2: Carlos Mendoza (DOCENTE 15%) compra Java Complete Reference x2
INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                   id_libro, id_cliente, id_empleado)
VALUES (CAST(GETDATE() AS DATE), 2, 120.00, 15.00, ROUND(120.00 * 2 * 0.85, 2), 2, 3, 2);
UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 2;

-- Venta 3: Roberto Huamán (EXTERNO 0%) compra Administración Estratégica x1
INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                   id_libro, id_cliente, id_empleado)
VALUES (CAST(GETDATE() AS DATE), 1, 75.00, 0.00, ROUND(75.00 * 1 * 1.00, 2), 6, 5, 3);
UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 6;
GO
