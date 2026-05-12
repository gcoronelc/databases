/**
 *
 * DBMS              :  SQL Server
 * Base de Datos     :  AMAUTA
 * Descripción       :  Base de Datos de la Librería Universitaria "Amauta"
 * Script            :  Consultas utiles
 * Creao por         :  Dr. Eric Gustavo Coronel Castillo
 * Email             :  gcoronelc@gmail.com
 * Blog              :  http://gcoronelc.blogspot.com
 * Cursos virtuales  :  https://gcoronelc.github.io/
 * Canal Youtube     :  https://www.youtube.com/DesarrollaSoftware
 * Fecha creación    :  10-MAY-2026
 * 
**/


-- -----------------------------------------------------------------------------
-- 1. ACTIVAR LA BASE DE DATOS AMAUTA
-- -----------------------------------------------------------------------------

USE AMAUTA;
GO


-- -----------------------------------------------------------------------------
-- 2. CONSULTAS SQL BÁSICAS
-- -----------------------------------------------------------------------------

-- C1: Listar todos los libros con su categoría y stock actual
SELECT L.id_libro,
       L.titulo,
       L.autor,
       C.nombre        AS categoria,
       L.precio,
       L.stock
FROM   LIBRO L
JOIN   CATEGORIA C ON L.id_categoria = C.id_categoria
ORDER  BY C.nombre, L.titulo;

-- C2: Listar clientes ACTIVOS con tipo y correo
SELECT C.id_cliente,
       CONCAT(C.apellido, ', ', C.nombre)  AS cliente,
       T.nombre tipo,
       C.correo
FROM   CLIENTE C
JOIN   TIPO_CLIENTE T ON C.id_tipo_cliente = T.id_tipo_cliente
WHERE  C.estado = 'ACTIVO'
ORDER  BY tipo, C.apellido;

-- C3: Mostrar todas las ventas con datos completos
SELECT V.id_venta,
       V.fecha,
       L.titulo                                AS libro,
       CONCAT(CL.nombre, ' ', CL.apellido)    AS cliente,
       TC.nombre tipo,
       CONCAT(E.nombre,  ' ', E.apellido)     AS empleado,
       V.cantidad,
       V.precio_unitario,
       V.descuento,
       V.monto_final
FROM   VENTA V
JOIN   LIBRO    L  ON V.id_libro    = L.id_libro
JOIN   CLIENTE  CL ON V.id_cliente  = CL.id_cliente
JOIN   TIPO_CLIENTE TC ON CL.id_tipo_cliente = TC.id_tipo_cliente
JOIN   EMPLEADO E  ON V.id_empleado = E.id_empleado
ORDER  BY V.fecha DESC;

-- C4: Total recaudado por tipo de cliente
SELECT TC.nombre tipo,
       COUNT(V.id_venta)        AS total_ventas,
       SUM(V.monto_final)       AS total_recaudado,
       AVG(V.monto_final)       AS ticket_promedio
FROM   VENTA V
JOIN   CLIENTE CL ON V.id_cliente = CL.id_cliente
JOIN   TIPO_CLIENTE TC ON CL.id_tipo_cliente = TC.id_tipo_cliente
GROUP  BY TC.nombre
ORDER  BY total_recaudado DESC;

-- C5: Libros con stock menor a 10 (alerta de reposición)
SELECT titulo, autor, stock
FROM   LIBRO
WHERE  stock < 10
ORDER  BY stock ASC;

-- -----------------------------------------------------------------------------
-- 5. TRANSACCIÓN DE REFERENCIA (para la práctica JDBC)
-- -----------------------------------------------------------------------------

-- Verificar resultado inicial
SELECT titulo, stock FROM LIBRO WHERE id_libro = 3;

-- Escenario: Registrar la venta de 2 ejemplares de "Patrones de Diseño" (id=3)
-- para María Paredes (id=2, ESTUDIANTE, ACTIVO), atendida por Pedro Quispe (id=2).

BEGIN TRANSACTION;

    -- [AUTH] Autenticar empleado
    -- En JDBC: SELECT id_empleado FROM EMPLEADO
    --          WHERE usuario = ? AND clave = LOWER(CONVERT(VARCHAR(64),HASHBYTES('SHA2_256',?),2))
    -- Resultado: id_empleado = 2 → autenticado

    -- [R1] Verificar que el cliente esté ACTIVO
    -- En JDBC: SELECT estado, tipo FROM CLIENTE WHERE id_cliente = ?
    -- Resultado: estado='ACTIVO', tipo='ESTUDIANTE' → descuento = 10%

    -- [R3] Verificar stock suficiente
    -- En JDBC: SELECT stock FROM LIBRO WHERE id_libro = ?
    -- stock actual = 8  >=  2 solicitados → CONTINUAR

    -- [INSERT] Registrar la venta
    INSERT INTO VENTA (fecha, cantidad, precio_unitario, descuento, monto_final,
                       id_libro, id_cliente, id_empleado)
    VALUES (CAST(GETDATE() AS DATE), 2, 95.50, 10.00,
            ROUND(95.50 * 2 * 0.90, 2), 3, 2, 2);

    -- [UPDATE] Descontar el stock del libro
    UPDATE LIBRO SET stock = stock - 2 WHERE id_libro = 3;

COMMIT;
GO

-- Verificar resultado final
SELECT titulo, stock FROM LIBRO WHERE id_libro = 3;
