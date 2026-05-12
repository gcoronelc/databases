/**
 *
 * DBMS              :  SQL Server
 * Base de Datos     :  AMAUTA
 * Descripción       :  Base de Datos de la Librería Universitaria "Amauta"
 * Script            :  Crea la Base de Datos
 * Creado por        :  Dr. Eric Gustavo Coronel Castillo
 * Email             :  gcoronelc@gmail.com
 * Blog              :  http://gcoronelc.blogspot.com
 * Cursos virtuales  :  https://gcoronelc.github.io/
 * Canal Youtube     :  https://www.youtube.com/DesarrollaSoftware
 * Fecha creación    :  10-MAY-2026
 *
**/


-- -----------------------------------------------------------------------------
-- 1. CREACIÓN DE LA BASE DE DATOS
-- -----------------------------------------------------------------------------

SET NOCOUNT ON;
GO

USE master;
GO

IF( NOT EXISTS ( SELECT 1 FROM sys.sysdatabases WHERE name='AMAUTA' ) )
BEGIN
    CREATE DATABASE AMAUTA;
END;
GO

USE AMAUTA;
GO


-- -----------------------------------------------------------------------------
-- 2. ELIMINA TABLAS
-- Orden: hijas primero, luego padres, respetando FK.
-- -----------------------------------------------------------------------------

IF( EXISTS ( SELECT 1 FROM sys.sysobjects
    WHERE name='VENTA' AND xtype='u') )
BEGIN
    DROP TABLE dbo.VENTA;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects
    WHERE name='CLIENTE' AND xtype='u') )
BEGIN
    DROP TABLE dbo.CLIENTE;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects
    WHERE name='EMPLEADO' AND xtype='u') )
BEGIN
    DROP TABLE dbo.EMPLEADO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects
    WHERE name='LIBRO' AND xtype='u') )
BEGIN
    DROP TABLE dbo.LIBRO;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects
    WHERE name='CATEGORIA' AND xtype='u') )
BEGIN
    DROP TABLE dbo.CATEGORIA;
END;
GO

IF( EXISTS ( SELECT 1 FROM sys.sysobjects
    WHERE name='TIPO_CLIENTE' AND xtype='u') )
BEGIN
    DROP TABLE dbo.TIPO_CLIENTE;
END;
GO


-- -----------------------------------------------------------------------------
-- 3. CREACIÓN DE TABLAS
-- -----------------------------------------------------------------------------

-- Tabla: TIPO_CLIENTE
-- Centraliza los tipos de cliente y su descuento asociado.
-- descuento: porcentaje aplicado al monto bruto de la venta.
--   ESTUDIANTE →  15 %
--   DOCENTE    →  20 %
--   TRABAJADOR →  10 %
--   EXTERNO    →   0 %
CREATE TABLE TIPO_CLIENTE (
    id_tipo_cliente INT            NOT NULL IDENTITY(1,1),
    nombre          VARCHAR(20)    NOT NULL,
    descripcion     VARCHAR(100)       NULL,
    descuento       DECIMAL(5,2)   NOT NULL CONSTRAINT DF_TIPO_CLIENTE_DESC DEFAULT 0.00,
    CONSTRAINT PK_TIPO_CLIENTE          PRIMARY KEY (id_tipo_cliente),
    CONSTRAINT UQ_TIPO_CLIENTE_NOMBRE   UNIQUE      (nombre),
    CONSTRAINT CK_TIPO_CLIENTE_DESC     CHECK (descuento >= 0 AND descuento <= 100)
);
GO

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
-- estado: ACTIVO | INACTIVO | SUSPENDIDO
-- El tipo y su descuento se obtienen mediante FK a TIPO_CLIENTE.
CREATE TABLE CLIENTE (
    id_cliente      INT             NOT NULL IDENTITY(1,1),
    nombre          VARCHAR(100)    NOT NULL,
    apellido        VARCHAR(100)    NOT NULL,
    correo          VARCHAR(100)    NOT NULL,
    id_tipo_cliente INT             NOT NULL,
    estado          VARCHAR(11)     NOT NULL CONSTRAINT DF_CLIENTE_ESTADO DEFAULT 'ACTIVO',
    CONSTRAINT PK_CLIENTE           PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_CLIENTE_CORREO    UNIQUE      (correo),
    CONSTRAINT FK_CLIENTE_TIPO      FOREIGN KEY (id_tipo_cliente)
        REFERENCES TIPO_CLIENTE(id_tipo_cliente),
    CONSTRAINT CK_CLIENTE_ESTADO    CHECK (estado IN ('ACTIVO','INACTIVO','SUSPENDIDO'))
);
GO

-- Tabla: EMPLEADO
-- usuario: nombre de usuario único para autenticación.
-- clave  : hash SHA-256 de la contraseña (64 caracteres hexadecimales).
--          Función: LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256','texto'), 2))
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
--   AUTH: el empleado debe autenticarse con usuario y clave antes de operar.
--   R1  : id_cliente debe tener estado = 'ACTIVO'.
--   R2  : descuento se obtiene de TIPO_CLIENTE.descuento según el tipo del cliente.
--   R3  : stock de LIBRO debe ser >= cantidad solicitada.
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

