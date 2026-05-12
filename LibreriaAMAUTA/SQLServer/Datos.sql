/**
 * DBMS              :  SQL Server
 * Base de Datos     :  AMAUTA
 * Descripción       :  Datos de prueba - Librería Universitaria "Amauta"
 *                      4 ventas x categoría x mes x 36 meses (2023-2025)
 *                      4 tipos de cliente por mes.
 *                      Total: 576 ventas históricas + 4 base = 580
 * Creado por        :  Dr. Eric Gustavo Coronel Castillo
 * Fecha             :  10-MAY-2026
 * PREREQUISITO      :  AMAUTA_v3.sql ejecutado previamente
 **/


SET NOCOUNT ON;
GO

USE AMAUTA;
GO

-- ==========================================================
-- PASO 1: Deshabilitar restricciones FK
-- ==========================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- ==========================================================
-- PASO 2: Eliminar datos (hijas primero)
-- DELETE individual por tabla, cada uno en su propio lote (GO).
-- La tabla debe estar VACÍA antes del RESEED para que
-- DBCC CHECKIDENT RESEED,0 genere correctamente ID=1.
-- ==========================================================
DELETE FROM dbo.VENTA;
GO

DELETE FROM dbo.CLIENTE;
GO

DELETE FROM dbo.EMPLEADO;
GO

DELETE FROM dbo.LIBRO;
GO

DELETE FROM dbo.CATEGORIA;
GO

DELETE FROM dbo.TIPO_CLIENTE;
GO

-- PASO 3: Reiniciar IDENTITY a 1
-- Con la tabla VACÍA, RESEED,0 garantiza que el próximo ID=1.
-- Cada RESEED en su propio lote (GO).
-- ==========================================================

DBCC CHECKIDENT ('dbo.VENTA',        RESEED, 1);
GO

DBCC CHECKIDENT ('dbo.CLIENTE',      RESEED, 1);
GO

DBCC CHECKIDENT ('dbo.EMPLEADO',     RESEED, 1);
GO

DBCC CHECKIDENT ('dbo.LIBRO',        RESEED, 1);
GO

DBCC CHECKIDENT ('dbo.CATEGORIA',    RESEED, 1);
GO

DBCC CHECKIDENT ('dbo.TIPO_CLIENTE', RESEED, 1);
GO

-- PASO 4: Insertar datos (padres primero)
-- ==========================================================

-- 4.1 TIPO_CLIENTE
INSERT INTO dbo.TIPO_CLIENTE (nombre, descripcion, descuento) VALUES
('ESTUDIANTE', 'Estudiante matriculado en institución educativa', 15.00),
('DOCENTE',    'Docente o profesor en actividad',                 20.00),
('TRABAJADOR', 'Trabajador administrativo o técnico',            10.00),
('EXTERNO',    'Cliente externo sin beneficio de descuento',      0.00);
GO

-- 4.2 CATEGORIA
INSERT INTO dbo.CATEGORIA (nombre, descripcion) VALUES
('Ingeniería de Sistemas',  'Programación, algoritmos y arquitectura de software'),
('Ciencias Básicas',        'Matemáticas, física y estadística'),
('Administración',          'Gestión empresarial y finanzas'),
('Humanidades',             'Filosofía, comunicación y ética');
GO

-- 4.3 LIBRO
INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Clean Code', 'Robert C. Martin', 89.90, 96, 1);
GO

INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Java: The Complete Reference', 'Herbert Schildt', 120.00, 96, 1);
GO

INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Patrones de Diseño', 'Gang of Four', 95.50, 96, 1);
GO

INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Cálculo Diferencial e Integral', 'James Stewart', 110.00, 140, 2);
GO

INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Estadística para Ingeniería', 'Douglas Montgomery', 98.00, 140, 2);
GO

INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Administración Estratégica', 'Fred David', 75.00, 269, 3);
GO

INSERT INTO dbo.LIBRO (titulo, autor, precio, stock, id_categoria)
VALUES ('Ética Profesional en Ingeniería', 'Martin Curd', 55.00, 269, 4);
GO

-- 4.4 EMPLEADO
INSERT INTO dbo.EMPLEADO (nombre, apellido, cargo, usuario, clave)
VALUES ('Carmen', 'Villanueva Paz', 'Cajera', 'cvillanueva',
    LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'carmen123'), 2)));
GO

INSERT INTO dbo.EMPLEADO (nombre, apellido, cargo, usuario, clave)
VALUES ('Pedro', 'Quispe Mamani', 'Vendedor', 'pquispe',
    LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pedro456'), 2)));
GO

INSERT INTO dbo.EMPLEADO (nombre, apellido, cargo, usuario, clave)
VALUES ('Sofia', 'Ramos Torres', 'Supervisora', 'sramos',
    LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'sofia789'), 2)));
GO

-- 4.5 CLIENTE
INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Luis', 'Torres Ríos', 'ltorres@uni.edu.pe', 1, 'ACTIVO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('María', 'Paredes Vega', 'mparedes@uni.edu.pe', 1, 'ACTIVO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Carlos', 'Mendoza León', 'cmendoza@uni.edu.pe', 2, 'ACTIVO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Ana', 'Flores Castillo', 'aflores@uni.edu.pe', 2, 'ACTIVO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Roberto', 'Huamán Quispe', 'rhuaman@gmail.com', 4, 'ACTIVO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Jorge', 'Salas Puma', 'jsalas@uni.edu.pe', 1, 'INACTIVO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Patricia', 'Rojas Díaz', 'projasuni@uni.edu.pe', 1, 'SUSPENDIDO');
GO

INSERT INTO dbo.CLIENTE (nombre, apellido, correo, id_tipo_cliente, estado)
VALUES ('Ricardo', 'Vega Paredes', 'rvega@uni.edu.pe', 3, 'ACTIVO');
GO

-- 4.6 VENTAS BASE (2026-05-10)
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado)
VALUES ('2026-05-10',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock = stock - 1 WHERE id_libro = 1;
GO

INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado)
VALUES ('2026-05-10',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock = stock - 2 WHERE id_libro = 2;
GO

INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado)
VALUES ('2026-05-10',1,75.00,0.00,ROUND(75.00*1*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock = stock - 1 WHERE id_libro = 6;
GO

INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado)
VALUES ('2026-05-10',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock = stock - 1 WHERE id_libro = 7;
GO

-- 4.7 VENTAS HISTÓRICAS (576 ventas: enero 2023 – diciembre 2025)
--     Lote por mes: 16 INSERT+UPDATE por GO (4 categorías x 4 tipos)

-- ======== AÑO 2023 ========
-- ENERO 2023
-- Ing. Sistemas
-- V5: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V6: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V7: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V8: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V9: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V10: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V11: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V12: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V13: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V14: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V15: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V16: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V17: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V18: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V19: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V20: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-01-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- FEBRERO 2023
-- Ing. Sistemas
-- V21: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V22: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V23: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V24: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V25: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V26: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V27: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V28: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V29: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V30: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V31: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V32: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V33: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V34: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V35: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V36: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-02-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- MARZO 2023
-- Ing. Sistemas
-- V37: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V38: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V39: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V40: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V41: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V42: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V43: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V44: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V45: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V46: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V47: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V48: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V49: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V50: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V51: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V52: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-03-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- ABRIL 2023
-- Ing. Sistemas
-- V53: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V54: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V55: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V56: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V57: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V58: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V59: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V60: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V61: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V62: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V63: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V64: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V65: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V66: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V67: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V68: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-04-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- MAYO 2023
-- Ing. Sistemas
-- V69: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V70: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V71: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V72: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V73: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V74: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V75: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V76: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V77: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V78: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V79: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V80: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V81: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V82: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V83: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V84: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-05-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- JUNIO 2023
-- Ing. Sistemas
-- V85: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V86: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V87: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V88: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V89: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V90: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V91: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V92: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V93: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V94: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V95: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V96: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V97: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V98: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V99: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V100: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-06-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- JULIO 2023
-- Ing. Sistemas
-- V101: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V102: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V103: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V104: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V105: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V106: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V107: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V108: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V109: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V110: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V111: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V112: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V113: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V114: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V115: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V116: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-07-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- AGOSTO 2023
-- Ing. Sistemas
-- V117: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V118: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V119: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V120: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V121: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V122: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V123: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V124: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V125: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V126: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V127: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V128: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V129: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V130: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V131: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V132: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-08-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- SEPTIEMBRE 2023
-- Ing. Sistemas
-- V133: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V134: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V135: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V136: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V137: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V138: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V139: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V140: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V141: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V142: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V143: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V144: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V145: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V146: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V147: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V148: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-09-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- OCTUBRE 2023
-- Ing. Sistemas
-- V149: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V150: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V151: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V152: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V153: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V154: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V155: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V156: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V157: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V158: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V159: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V160: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V161: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V162: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V163: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V164: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-10-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- NOVIEMBRE 2023
-- Ing. Sistemas
-- V165: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V166: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V167: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V168: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V169: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V170: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V171: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V172: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V173: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V174: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V175: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V176: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V177: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V178: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V179: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V180: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-11-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- DICIEMBRE 2023
-- Ing. Sistemas
-- V181: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V182: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V183: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V184: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V185: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V186: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V187: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V188: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V189: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V190: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V191: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V192: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V193: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V194: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V195: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V196: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2023-12-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- ======== AÑO 2024 ========
-- ENERO 2024
-- Ing. Sistemas
-- V197: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V198: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V199: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V200: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V201: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V202: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V203: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V204: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V205: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V206: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V207: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V208: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V209: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V210: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V211: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V212: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-01-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- FEBRERO 2024
-- Ing. Sistemas
-- V213: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V214: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V215: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V216: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V217: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V218: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V219: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V220: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V221: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V222: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V223: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V224: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V225: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V226: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V227: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V228: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-02-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- MARZO 2024
-- Ing. Sistemas
-- V229: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V230: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V231: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V232: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V233: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V234: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V235: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V236: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V237: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V238: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V239: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V240: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V241: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V242: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V243: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V244: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-03-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- ABRIL 2024
-- Ing. Sistemas
-- V245: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V246: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V247: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V248: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V249: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V250: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V251: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V252: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V253: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V254: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V255: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V256: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V257: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V258: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V259: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V260: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-04-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- MAYO 2024
-- Ing. Sistemas
-- V261: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V262: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V263: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V264: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V265: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V266: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V267: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V268: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V269: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V270: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V271: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V272: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V273: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V274: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V275: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V276: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-05-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- JUNIO 2024
-- Ing. Sistemas
-- V277: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V278: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V279: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V280: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V281: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V282: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V283: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V284: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V285: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V286: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V287: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V288: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V289: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V290: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V291: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V292: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-06-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- JULIO 2024
-- Ing. Sistemas
-- V293: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V294: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V295: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V296: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V297: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V298: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V299: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V300: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V301: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V302: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V303: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V304: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V305: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V306: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V307: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V308: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-07-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- AGOSTO 2024
-- Ing. Sistemas
-- V309: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V310: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V311: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V312: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V313: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V314: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V315: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V316: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V317: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V318: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V319: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V320: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V321: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V322: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V323: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V324: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-08-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- SEPTIEMBRE 2024
-- Ing. Sistemas
-- V325: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V326: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V327: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V328: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V329: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V330: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V331: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V332: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V333: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V334: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V335: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V336: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V337: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V338: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V339: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V340: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-09-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- OCTUBRE 2024
-- Ing. Sistemas
-- V341: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V342: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V343: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V344: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V345: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V346: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V347: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V348: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V349: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V350: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V351: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V352: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V353: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V354: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V355: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V356: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-10-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- NOVIEMBRE 2024
-- Ing. Sistemas
-- V357: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V358: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V359: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V360: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V361: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V362: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V363: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V364: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V365: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V366: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V367: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V368: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V369: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V370: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V371: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V372: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-11-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- DICIEMBRE 2024
-- Ing. Sistemas
-- V373: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V374: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V375: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V376: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V377: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V378: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V379: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V380: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V381: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V382: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V383: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V384: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V385: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V386: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V387: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V388: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2024-12-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- ======== AÑO 2025 ========
-- ENERO 2025
-- Ing. Sistemas
-- V389: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V390: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V391: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V392: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V393: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V394: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V395: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V396: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V397: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V398: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V399: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V400: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V401: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V402: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V403: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V404: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-01-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- FEBRERO 2025
-- Ing. Sistemas
-- V405: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V406: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V407: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V408: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V409: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V410: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V411: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V412: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V413: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V414: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V415: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V416: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V417: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V418: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V419: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V420: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-02-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- MARZO 2025
-- Ing. Sistemas
-- V421: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V422: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V423: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V424: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V425: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V426: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V427: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V428: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V429: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V430: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V431: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V432: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V433: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V434: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V435: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V436: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-03-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- ABRIL 2025
-- Ing. Sistemas
-- V437: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V438: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V439: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V440: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V441: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V442: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V443: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V444: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V445: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V446: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V447: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V448: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V449: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V450: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V451: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V452: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-04-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- MAYO 2025
-- Ing. Sistemas
-- V453: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V454: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V455: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V456: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V457: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V458: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V459: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V460: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V461: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V462: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V463: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V464: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V465: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V466: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V467: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V468: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-05-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- JUNIO 2025
-- Ing. Sistemas
-- V469: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V470: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V471: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V472: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V473: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V474: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V475: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V476: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V477: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V478: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V479: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V480: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V481: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V482: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V483: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V484: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-06-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- JULIO 2025
-- Ing. Sistemas
-- V485: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V486: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V487: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V488: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V489: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V490: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V491: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V492: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V493: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V494: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V495: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V496: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V497: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V498: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V499: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V500: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-07-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- AGOSTO 2025
-- Ing. Sistemas
-- V501: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V502: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V503: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V504: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V505: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V506: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V507: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V508: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V509: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V510: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V511: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V512: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V513: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V514: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V515: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V516: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-08-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- SEPTIEMBRE 2025
-- Ing. Sistemas
-- V517: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V518: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V519: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V520: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V521: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V522: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V523: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V524: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V525: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V526: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V527: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V528: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V529: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V530: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V531: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V532: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-09-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- OCTUBRE 2025
-- Ing. Sistemas
-- V533: ESTUDIANTE 15% · Clean Code x1 = S/76.42
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-05',1,89.90,15.00,ROUND(89.90*1*0.85,2),1,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V534: DOCENTE 20% · Java: The Complete Reference x2 = S/192.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-12',2,120.00,20.00,ROUND(120.00*2*0.80,2),2,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- V535: TRABAJADOR 10% · Patrones de Diseño x1 = S/85.95
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-19',1,95.50,10.00,ROUND(95.50*1*0.90,2),3,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V536: EXTERNO 0% · Clean Code x2 = S/179.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-26',2,89.90,0.00,ROUND(89.90*2*1.00,2),1,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- Ciencias Básicas
-- V537: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V538: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V539: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V540: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V541: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V542: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V543: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V544: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V545: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V546: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V547: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V548: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-10-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- NOVIEMBRE 2025
-- Ing. Sistemas
-- V549: ESTUDIANTE 15% · Java: The Complete Reference x1 = S/102.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-05',1,120.00,15.00,ROUND(120.00*1*0.85,2),2,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V550: DOCENTE 20% · Patrones de Diseño x2 = S/152.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-12',2,95.50,20.00,ROUND(95.50*2*0.80,2),3,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- V551: TRABAJADOR 10% · Clean Code x1 = S/80.91
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-19',1,89.90,10.00,ROUND(89.90*1*0.90,2),1,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=1;
-- V552: EXTERNO 0% · Java: The Complete Reference x2 = S/240.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-26',2,120.00,0.00,ROUND(120.00*2*1.00,2),2,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=2;
-- Ciencias Básicas
-- V553: ESTUDIANTE 15% · Cálculo Diferencial e Integral x1 = S/93.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-05',1,110.00,15.00,ROUND(110.00*1*0.85,2),4,1,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V554: DOCENTE 20% · Estadística para Ingeniería x2 = S/156.80
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-12',2,98.00,20.00,ROUND(98.00*2*0.80,2),5,3,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- V555: TRABAJADOR 10% · Cálculo Diferencial e Integral x1 = S/99.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-19',1,110.00,10.00,ROUND(110.00*1*0.90,2),4,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=4;
-- V556: EXTERNO 0% · Estadística para Ingeniería x2 = S/196.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-26',2,98.00,0.00,ROUND(98.00*2*1.00,2),5,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=5;
-- Administración
-- V557: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,1,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V558: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,3,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V559: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V560: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V561: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,1,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V562: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,3,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V563: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V564: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-11-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO

-- DICIEMBRE 2025
-- Ing. Sistemas
-- V565: ESTUDIANTE 15% · Patrones de Diseño x1 = S/81.17
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-05',1,95.50,15.00,ROUND(95.50*1*0.85,2),3,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=3;
-- V566: DOCENTE 20% · Clean Code x2 = S/143.84
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-12',2,89.90,20.00,ROUND(89.90*2*0.80,2),1,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=1;
-- V567: TRABAJADOR 10% · Java: The Complete Reference x1 = S/108.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-19',1,120.00,10.00,ROUND(120.00*1*0.90,2),2,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=2;
-- V568: EXTERNO 0% · Patrones de Diseño x2 = S/191.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-26',2,95.50,0.00,ROUND(95.50*2*1.00,2),3,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=3;
-- Ciencias Básicas
-- V569: ESTUDIANTE 15% · Estadística para Ingeniería x1 = S/83.30
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-05',1,98.00,15.00,ROUND(98.00*1*0.85,2),5,2,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V570: DOCENTE 20% · Cálculo Diferencial e Integral x2 = S/176.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-12',2,110.00,20.00,ROUND(110.00*2*0.80,2),4,4,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- V571: TRABAJADOR 10% · Estadística para Ingeniería x1 = S/88.20
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-19',1,98.00,10.00,ROUND(98.00*1*0.90,2),5,8,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=5;
-- V572: EXTERNO 0% · Cálculo Diferencial e Integral x2 = S/220.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-26',2,110.00,0.00,ROUND(110.00*2*1.00,2),4,5,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=4;
-- Administración
-- V573: ESTUDIANTE 15% · Administración Estratégica x1 = S/63.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-05',1,75.00,15.00,ROUND(75.00*1*0.85,2),6,2,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V574: DOCENTE 20% · Administración Estratégica x2 = S/120.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-12',2,75.00,20.00,ROUND(75.00*2*0.80,2),6,4,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- V575: TRABAJADOR 10% · Administración Estratégica x1 = S/67.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-19',1,75.00,10.00,ROUND(75.00*1*0.90,2),6,8,1);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=6;
-- V576: EXTERNO 0% · Administración Estratégica x2 = S/150.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-26',2,75.00,0.00,ROUND(75.00*2*1.00,2),6,5,2);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=6;
-- Humanidades
-- V577: ESTUDIANTE 15% · Ética Profesional en Ingeniería x1 = S/46.75
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-05',1,55.00,15.00,ROUND(55.00*1*0.85,2),7,2,3);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V578: DOCENTE 20% · Ética Profesional en Ingeniería x2 = S/88.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-12',2,55.00,20.00,ROUND(55.00*2*0.80,2),7,4,1);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
-- V579: TRABAJADOR 10% · Ética Profesional en Ingeniería x1 = S/49.50
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-19',1,55.00,10.00,ROUND(55.00*1*0.90,2),7,8,2);
UPDATE dbo.LIBRO SET stock=stock-1 WHERE id_libro=7;
-- V580: EXTERNO 0% · Ética Profesional en Ingeniería x2 = S/110.00
INSERT INTO dbo.VENTA (fecha,cantidad,precio_unitario,descuento,monto_final,id_libro,id_cliente,id_empleado) VALUES ('2025-12-26',2,55.00,0.00,ROUND(55.00*2*1.00,2),7,5,3);
UPDATE dbo.LIBRO SET stock=stock-2 WHERE id_libro=7;
GO


-- ==========================================================
-- PASO 5: Reactivar y revalidar restricciones FK
-- ==========================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

-- ==========================================================
-- PASO 6: VERIFICACIÓN FINAL
-- ==========================================================

-- V1: Conteo por tabla
SELECT 'TIPO_CLIENTE' AS tabla, COUNT(*) AS total FROM dbo.TIPO_CLIENTE UNION ALL
SELECT 'CATEGORIA',             COUNT(*)           FROM dbo.CATEGORIA    UNION ALL
SELECT 'LIBRO',                 COUNT(*)           FROM dbo.LIBRO        UNION ALL
SELECT 'EMPLEADO',              COUNT(*)           FROM dbo.EMPLEADO     UNION ALL
SELECT 'CLIENTE',               COUNT(*)           FROM dbo.CLIENTE      UNION ALL
SELECT 'VENTA',                 COUNT(*)           FROM dbo.VENTA;
GO

-- V2: Stock final
SELECT L.id_libro, L.titulo, C.nombre AS categoria, L.stock AS stock_final
FROM   dbo.LIBRO L
JOIN   dbo.CATEGORIA C ON L.id_categoria = C.id_categoria
ORDER  BY C.nombre, L.titulo;
GO

-- V3: Ventas por año y tipo de cliente
SELECT YEAR(V.fecha)      AS anio, TC.nombre AS tipo_cliente,
       COUNT(V.id_venta)  AS cant_ventas,
       SUM(V.cantidad)    AS libros_vendidos,
       SUM(V.monto_final) AS total_ventas
FROM   dbo.VENTA V
JOIN   dbo.CLIENTE      CL ON V.id_cliente       = CL.id_cliente
JOIN   dbo.TIPO_CLIENTE TC ON CL.id_tipo_cliente = TC.id_tipo_cliente
GROUP  BY YEAR(V.fecha), TC.nombre
ORDER  BY anio, TC.nombre;
GO

-- V4: Ventas por año y categoría
SELECT YEAR(V.fecha)      AS anio, CA.nombre AS categoria,
       COUNT(V.id_venta)  AS cant_ventas,
       SUM(V.cantidad)    AS libros_vendidos,
       SUM(V.monto_final) AS total_ventas
FROM   dbo.VENTA V
JOIN   dbo.LIBRO     L  ON V.id_libro     = L.id_libro
JOIN   dbo.CATEGORIA CA ON L.id_categoria = CA.id_categoria
GROUP  BY YEAR(V.fecha), CA.nombre
ORDER  BY anio, CA.nombre;
GO

-- V5: Total general por año
SELECT YEAR(V.fecha)      AS anio,
       COUNT(V.id_venta)  AS cant_ventas,
       SUM(V.monto_final) AS total_ventas
FROM   dbo.VENTA V
GROUP  BY YEAR(V.fecha)
ORDER  BY anio;
GO