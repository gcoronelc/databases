-- =============================================================================
-- VENTAS ADICIONALES: 3 ventas por categoría (12 ventas en total)
-- Docente: Dr. Eric Gustavo Coronel Castillo
-- Motor: Microsoft SQL Server 2019+
-- =============================================================================
-- Distribución:
--   Categoría 1 - Ingeniería de Sistemas : ventas 4, 5, 6
--   Categoría 2 - Ciencias Básicas       : ventas 7, 8, 9
--   Categoría 3 - Administración         : ventas 10, 11, 12
--   Categoría 4 - Humanidades            : ventas 13, 14, 15
--
-- Combinación de tipos de cliente por grupo:
--   Venta A → ESTUDIANTE (10% descuento)
--   Venta B → DOCENTE    (15% descuento)
--   Venta C → EXTERNO    ( 0% descuento)
--
-- Referencia de IDs:
--   LIBRO  : 1=Clean Code, 2=Java Complete Ref, 3=Patrones Diseño,
--            4=Cálculo, 5=Estadística, 6=Adm. Estratégica, 7=Ética
--   CLIENTE: 1=Luis Torres (EST/ACT), 2=María Paredes (EST/ACT),
--            3=Carlos Mendoza (DOC/ACT), 4=Ana Flores (DOC/ACT),
--            5=Roberto Huamán (EXT/ACT)
--            6=Jorge Salas (EST/INACT) ← NO usar, cliente inactivo
--            7=Patricia Rojas (EST/SUSP) ← NO usar, cliente suspendido
--   EMPLEADO: 1=Carmen Villanueva, 2=Pedro Quispe, 3=Sofía Ramos
-- =============================================================================

USE AMAUTA;
GO

-- -----------------------------------------------------------------------------
-- CATEGORÍA 1: Ingeniería de Sistemas
-- Libros disponibles: 1=Clean Code, 2=Java Ref., 3=Patrones de Diseño
-- -----------------------------------------------------------------------------

-- Venta 4: María Paredes (ESTUDIANTE, 10%) compra Clean Code x2
--          Atendida por: Pedro Quispe
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 2, 89.90, 10.00,
            ROUND(89.90 * 2 * 0.90, 2), 1, 2, 2);
    UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 1;
COMMIT;
GO

-- Venta 5: Carlos Mendoza (DOCENTE, 15%) compra Patrones de Diseño x1
--          Atendida por: Sofía Ramos
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 1, 95.50, 15.00,
            ROUND(95.50 * 1 * 0.85, 2), 3, 3, 3);
    UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 3;
COMMIT;
GO

-- Venta 6: Roberto Huamán (EXTERNO, 0%) compra Java Complete Reference x1
--          Atendida por: Carmen Villanueva
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 1, 120.00, 0.00,
            ROUND(120.00 * 1 * 1.00, 2), 2, 5, 1);
    UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 2;
COMMIT;
GO

-- -----------------------------------------------------------------------------
-- CATEGORÍA 2: Ciencias Básicas
-- Libros disponibles: 4=Cálculo Diferencial, 5=Estadística para Ingeniería
-- -----------------------------------------------------------------------------

-- Venta 7: Luis Torres (ESTUDIANTE, 10%) compra Cálculo x1
--          Atendida por: Carmen Villanueva
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 1, 110.00, 10.00,
            ROUND(110.00 * 1 * 0.90, 2), 4, 1, 1);
    UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 4;
COMMIT;
GO

-- Venta 8: Ana Flores (DOCENTE, 15%) compra Estadística para Ingeniería x2
--          Atendida por: Pedro Quispe
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 2, 98.00, 15.00,
            ROUND(98.00 * 2 * 0.85, 2), 5, 4, 2);
    UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 5;
COMMIT;
GO

-- Venta 9: Roberto Huamán (EXTERNO, 0%) compra Cálculo x2
--          Atendida por: Sofía Ramos
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 2, 110.00, 0.00,
            ROUND(110.00 * 2 * 1.00, 2), 4, 5, 3);
    UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 4;
COMMIT;
GO

-- -----------------------------------------------------------------------------
-- CATEGORÍA 3: Administración
-- Libros disponibles: 6=Administración Estratégica
-- -----------------------------------------------------------------------------

-- Venta 10: María Paredes (ESTUDIANTE, 10%) compra Adm. Estratégica x1
--           Atendida por: Sofía Ramos
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 1, 75.00, 10.00,
            ROUND(75.00 * 1 * 0.90, 2), 6, 2, 3);
    UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 6;
COMMIT;
GO

-- Venta 11: Carlos Mendoza (DOCENTE, 15%) compra Adm. Estratégica x3
--           Atendida por: Carmen Villanueva
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 3, 75.00, 15.00,
            ROUND(75.00 * 3 * 0.85, 2), 6, 3, 1);
    UPDATE LIBRO SET stock = stock - 3 WHERE id_libro = 6;
COMMIT;
GO

-- Venta 12: Roberto Huamán (EXTERNO, 0%) compra Adm. Estratégica x2
--           Atendida por: Pedro Quispe
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 2, 75.00, 0.00,
            ROUND(75.00 * 2 * 1.00, 2), 6, 5, 2);
    UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 6;
COMMIT;
GO

-- -----------------------------------------------------------------------------
-- CATEGORÍA 4: Humanidades
-- Libros disponibles: 7=Ética Profesional en Ingeniería
-- -----------------------------------------------------------------------------

-- Venta 13: Luis Torres (ESTUDIANTE, 10%) compra Ética x1
--           Atendida por: Pedro Quispe
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 1, 55.00, 10.00,
            ROUND(55.00 * 1 * 0.90, 2), 7, 1, 2);
    UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 7;
COMMIT;
GO

-- Venta 14: Ana Flores (DOCENTE, 15%) compra Ética x2
--           Atendida por: Sofía Ramos
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 2, 55.00, 15.00,
            ROUND(55.00 * 2 * 0.85, 2), 7, 4, 3);
    UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 7;
COMMIT;
GO

-- Venta 15: Roberto Huamán (EXTERNO, 0%) compra Ética x1
--           Atendida por: Carmen Villanueva
BEGIN TRANSACTION;
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 1, 55.00, 0.00,
            ROUND(55.00 * 1 * 1.00, 2), 7, 5, 1);
    UPDATE LIBRO SET stock = stock - 1 WHERE id_libro = 7;
COMMIT;
GO

-- =============================================================================
-- VERIFICACIÓN FINAL
-- =============================================================================

-- V1: Total de ventas registradas (debe mostrar 15)
SELECT COUNT(*) AS total_ventas FROM VENTA;

-- V2: Stock actualizado de todos los libros
SELECT L.id_libro,
       L.titulo,
       C.nombre        AS categoria,
       L.stock         AS stock_actual
FROM   LIBRO L
JOIN   CATEGORIA C ON L.id_categoria = C.id_categoria
ORDER  BY C.nombre, L.titulo;

-- V3: Resumen de ventas por categoría y tipo de cliente
SELECT C.nombre                          AS categoria,
       CL.tipo                           AS tipo_cliente,
       COUNT(V.id_venta)                 AS cant_ventas,
       SUM(V.cantidad)                   AS libros_vendidos,
       SUM(V.monto_final)                AS total_recaudado
FROM   VENTA V
JOIN   LIBRO    L  ON V.id_libro   = L.id_libro
JOIN   CATEGORIA C ON L.id_categoria = C.id_categoria
JOIN   CLIENTE  CL ON V.id_cliente = CL.id_cliente
GROUP  BY C.nombre, CL.tipo
ORDER  BY C.nombre, CL.tipo;