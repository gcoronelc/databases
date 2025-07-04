/*
Empresa          :  EGCC
Software         :  Sistema de Restaurantes
DBMS             :  SQL SERVER
Base de datos    :  RestauranteDB
Script           :  Carga datos de prueba
Responsable      :  Dr. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Sitio Web        :  https://gcoronelc.blogspot.com/
Blog             :  https://gcoronelc.github.io/
Creado el        :  04.JUL.2025
*/


-- =====================================================================
-- Limpieza de tablas
-- =====================================================================

USE RestauranteDB;
GO

DECLARE @CONT INT;
SET @CONT = ( SELECT COUNT(1) FROM MESAS );
IF( @CONT > 0 )
BEGIN

	DELETE FROM DETALLE_PEDIDO;
	DBCC CHECKIDENT ('DETALLE_PEDIDO', RESEED, 0);

	DELETE FROM COMPROBANTE_DETALLE;
	DBCC CHECKIDENT ('COMPROBANTE_DETALLE', RESEED, 0);

	DELETE FROM PEDIDO;
	DBCC CHECKIDENT ('PEDIDO', RESEED, 0);

	DELETE FROM COMPROBANTE;
	DBCC CHECKIDENT ('COMPROBANTE', RESEED, 0);

	DELETE FROM OCUPACION_MESA;
	DBCC CHECKIDENT ('OCUPACION_MESA', RESEED, 0);

	DELETE FROM MENU;
	DBCC CHECKIDENT ('MENU', RESEED, 0);

	DELETE FROM CATEGORIA_MENU;
	DBCC CHECKIDENT ('CATEGORIA_MENU', RESEED, 0);

	DELETE FROM RESERVA;
	DBCC CHECKIDENT ('RESERVA', RESEED, 0);

	DELETE FROM MESAS;
	DBCC CHECKIDENT ('MESAS', RESEED, 0);

	DELETE FROM CLIENTE;
	DBCC CHECKIDENT ('CLIENTE', RESEED, 0);

	DELETE FROM USUARIO;
	DBCC CHECKIDENT ('USUARIO', RESEED, 0);

	DELETE FROM ROLES;
	DBCC CHECKIDENT ('ROLES', RESEED, 0);

	DELETE FROM ESTADO_COMPROBANTE;
	DBCC CHECKIDENT ('ESTADO_COMPROBANTE', RESEED, 0);

	DELETE FROM ESTADO_MESA;
	DBCC CHECKIDENT ('ESTADO_MESA', RESEED, 0);

	DELETE FROM ESTADO_PEDIDO;
	DBCC CHECKIDENT ('ESTADO_PEDIDO', RESEED, 0);

END;
GO


-- =============================================
-- Inserción de Datos Iniciales
-- =============================================


-- Insertar estados iniciales (ejemplo) para MESAS, PEDIDO, COMPROBANTE
INSERT INTO ESTADO_MESA (nombre_estado, descripcion) VALUES
('Disponible', 'Mesa libre y lista para ser usada'),
('Ocupada', 'Mesa actualmente ocupada por clientes'),
('Reservada', 'Mesa reservada para un cliente'),
('Limpieza', 'Mesa fuera de servicio por limpieza');
GO

INSERT INTO ESTADO_PEDIDO (nombre_estado, descripcion) VALUES
('En preparación', 'El pedido está siendo preparado'),
('Listo', 'El pedido está listo para ser entregado'),
('Servido', 'El pedido fue entregado al cliente'),
('Anulado', 'El pedido fue cancelado'),
('Facturado', 'El pedido fue incluido en el comprobante');
GO

INSERT INTO ESTADO_COMPROBANTE (nombre_estado, descripcion) VALUES
('Pagada', 'Comprobante pagado en su totalidad'),
('Anulada', 'Comprobante anulado'),
('Pendiente', 'Comprobante emitido, pendiente de pago');
GO

-- Insertar roles
INSERT INTO ROLES (nombre_rol) VALUES
('Mesero'),
('Cajero'),
('Cocina'),
('Gerente'),
('Recepcionista');
GO

-- Insertar usuarios (asumiendo id_rol: 1=Mesero, 2=Cajero, 3=Cocina, 4=Gerente)
INSERT INTO USUARIO (nombre, usuario, password_hash, id_rol, activo, email)
VALUES
('Juan Pérez',        'jperez',    'pass123', 1, 1, 'jperez@restaurante.com'),
('María López',       'mlopez',    'pass123', 1, 1, 'mlopez@restaurante.com'),
('Carlos Sánchez',    'csanchez',  'pass123', 1, 1, 'csanchez@restaurante.com'),
('Laura Ramírez',     'lramirez',  'pass123', 1, 1, 'lramirez@restaurante.com'),
('Ana Torres',        'atorres',   'pass123', 2, 1, 'atorres@restaurante.com'),
('Luis Gómez',        'lgomez',    'pass123', 2, 1, 'lgomez@restaurante.com'),
('Pedro Díaz',        'pdiaz',     'pass123', 3, 1, 'pdiaz@restaurante.com'),
('Sofía Morales',     'smorales',  'pass123', 3, 1, 'smorales@restaurante.com'),
('Ricardo Castillo',  'rcastillo', 'pass123', 4, 1, 'rcastillo@restaurante.com'),
('Verónica Flores',   'vflores',   'pass123', 4, 1, 'vflores@restaurante.com'),
('Sandra Huamán',   'shuaman', 'pass123', 5, 1, 'shuaman@restaurante.com'),
('Jorge Aguilar',   'jaguilar','pass123', 5, 1, 'jaguilar@restaurante.com');
GO


-- Insertar clientes
INSERT INTO CLIENTE (nombre, apellido, telefono, email, es_generico) VALUES
('Juan',         'Pérez',       '988123001', 'juan.perez@mail.com', 0),
('María',        'López',       '988123002', 'maria.lopez@mail.com', 0),
('Carlos',       'Sánchez',     '988123003', 'carlos.sanchez@mail.com', 0),
('Ana',          'Ramírez',     '988123004', 'ana.ramirez@mail.com', 0),
('Luis',         'Gómez',       '988123005', 'luis.gomez@mail.com', 0),
('Sofía',        'Torres',      '988123006', 'sofia.torres@mail.com', 0),
('Pedro',        'Díaz',        '988123007', 'pedro.diaz@mail.com', 0),
('Valeria',      'Morales',     '988123008', 'valeria.morales@mail.com', 0),
('Diego',        'Castillo',    '988123009', 'diego.castillo@mail.com', 0),
('Camila',       'Flores',      '988123010', 'camila.flores@mail.com', 0),
('Renato',       'Chávez',      '988123011', 'renato.chavez@mail.com', 0),
('Daniela',      'Rojas',       '988123012', 'daniela.rojas@mail.com', 0),
('Javier',       'Vega',        '988123013', 'javier.vega@mail.com', 0),
('Lucía',        'Herrera',     '988123014', 'lucia.herrera@mail.com', 0),
('Martín',       'Mendoza',     '988123015', 'martin.mendoza@mail.com', 0),
('Fiorella',     'Molina',      '988123016', 'fiorella.molina@mail.com', 0),
('Andrés',       'Campos',      '988123017', 'andres.campos@mail.com', 0),
('Paula',        'Suárez',      '988123018', 'paula.suarez@mail.com', 0),
('Samuel',       'Paredes',     '988123019', 'samuel.paredes@mail.com', 0),
('Carolina',     'Aguilar',     '988123020', 'carolina.aguilar@mail.com', 0),
('Miguel',       'Cruz',        '988123021', 'miguel.cruz@mail.com', 0),
('Alejandra',    'Soto',        '988123022', 'alejandra.soto@mail.com', 0),
('Rodrigo',      'Fuentes',     '988123023', 'rodrigo.fuentes@mail.com', 0),
('Patricia',     'Guerrero',    '988123024', 'patricia.guerrero@mail.com', 0),
('Francisco',    'Salazar',     '988123025', 'francisco.salazar@mail.com', 0),
('Carmen',       'Navarro',     '988123026', 'carmen.navarro@mail.com', 0),
('Óscar',        'Peña',        '988123027', 'oscar.pena@mail.com', 0),
('Elena',        'Ortega',      '988123028', 'elena.ortega@mail.com', 0),
('Raúl',         'Vilchez',     '988123029', 'raul.vilchez@mail.com', 0),
('Natalia',      'Caballero',   '988123030', 'natalia.caballero@mail.com', 0),
('Gonzalo',      'Peralta',     '988123031', 'gonzalo.peralta@mail.com', 0),
('Milagros',     'Reyes',       '988123032', 'milagros.reyes@mail.com', 0),
('Sergio',       'Cornejo',     '988123033', 'sergio.cornejo@mail.com', 0),
('Gabriela',     'Montoya',     '988123034', 'gabriela.montoya@mail.com', 0),
('Adrián',       'Rivera',      '988123035', 'adrian.rivera@mail.com', 0),
('Mónica',       'Rosales',     '988123036', 'monica.rosales@mail.com', 0),
('Erick',        'Bermúdez',    '988123037', 'erick.bermudez@mail.com', 0),
('Lorena',       'Palacios',    '988123038', 'lorena.palacios@mail.com', 0),
('Fernando',     'Valle',       '988123039', 'fernando.valle@mail.com', 0),
('Alicia',       'García',      '988123040', 'alicia.garcia@mail.com', 0),
('Henry',        'Espinoza',    '988123041', 'henry.espinoza@mail.com', 0),
('Romina',       'Quispe',      '988123042', 'romina.quispe@mail.com', 0),
('Bruno',        'Villanueva',  '988123043', 'bruno.villanueva@mail.com', 0),
('Melanie',      'Escobar',     '988123044', 'melanie.escobar@mail.com', 0),
('Esteban',      'Silva',       '988123045', 'esteban.silva@mail.com', 0),
('Isabel',       'Barreto',     '988123046', 'isabel.barreto@mail.com', 0),
('Dante',        'Ruiz',        '988123047', 'dante.ruiz@mail.com', 0),
('Cecilia',      'Martínez',    '988123048', 'cecilia.martinez@mail.com', 0),
('Cristian',     'Bravo',       '988123049', 'cristian.bravo@mail.com', 0),
('Cliente',      'Genérico',    NULL,        NULL,                     1);
GO


-- Insertar categorías de menú
INSERT INTO CATEGORIA_MENU (nombre_categoria, descripcion) VALUES
('Entradas',        'Platos para iniciar la comida'),
('Plato Fuerte',    'Platos principales del restaurante'),
('Postres',         'Dulces y postres variados'),
('Bebidas',         'Bebidas frías y calientes'),
('Especialidades',  'Platos especiales de la casa');
GO

-- Insertar menú (20 ítems) con categorías asignadas
INSERT INTO MENU (nombre, descripcion, precio, activo, id_categoria) VALUES
('Ensalada César',         'Lechuga, crutones, parmesano y salsa césar',                        18.00, 1, 1),
('Papa a la Huancaína',    'Papas amarillas con salsa de ají y queso',                          16.00, 1, 1),
('Causa Limeña',           'Masa de papa amarilla rellena de pollo y mayonesa',                 17.00, 1, 1),
('Anticuchos',             'Brochetas de corazón de res al carbón',                             20.00, 1, 1),
('Lomo Saltado',           'Tiras de lomo, cebolla, tomate, papas fritas y arroz',              32.00, 1, 2),
('Arroz con Pollo',        'Arroz verde con presa de pollo y salsa huancaína',                  28.00, 1, 2),
('Ají de Gallina',         'Pollo deshilachado en salsa cremosa de ají amarillo',               27.00, 1, 2),
('Ceviche de Pescado',     'Pescado fresco marinado en limón con cebolla y ají',                29.00, 1, 2),
('Seco de Cordero',        'Cordero guisado en salsa de cilantro, acompañado de frijoles',      35.00, 1, 2),
('Tarta de Queso',         'Cheesecake tradicional con base de galleta',                        14.00, 1, 3),
('Suspiro a la Limeña',    'Postre peruano con manjar y merengue',                              13.00, 1, 3),
('Helado Artesanal',       'Bola de helado de vainilla, chocolate o fresa',                     11.00, 1, 3),
('Mousse de Maracuyá',     'Postre suave de maracuyá y crema',                                  13.00, 1, 3),
('Chicha Morada',          'Bebida tradicional de maíz morado',                                 8.00, 1, 4),
('Limonada Frozen',        'Limonada frappé bien fría',                                         8.00, 1, 4),
('Refresco de Maracuyá',   'Refresco natural de maracuyá',                                      9.00, 1, 4),
('Café Americano',         'Café filtrado tradicional',                                         7.00, 1, 4),
('Infusión de Hierbas',    'Tisana de hierbas naturales',                                       7.00, 1, 4),
('Piqueo Gourmet',         'Tabla variada de bocados especiales de la casa',                    36.00, 1, 5);
GO


-- Insertar 20 mesas con diferentes capacidades
INSERT INTO MESAS (numero_mesa, capacidad, id_estado_mesa)
VALUES
(1,  2, 1), (2,  2, 1), (3,  4, 1), (4,  4, 1), (5,  6, 1),
(6,  6, 1), (7,  8, 1), (8,  8, 1), (9,  2, 1), (10, 2, 1),
(11, 4, 1), (12, 4, 1), (13, 6, 1), (14, 6, 1), (15, 8, 1),
(16, 8, 1), (17, 2, 1), (18, 2, 1), (19, 4, 1), (20, 4, 1);
GO


-- =====================================================================
-- Datos desde reservas hasta comprobantes
-- =====================================================================

-- Limpieza de tablas temporales por si existen
IF OBJECT_ID('tempdb..#gen_reservas') IS NOT NULL DROP TABLE #gen_reservas;
IF OBJECT_ID('tempdb..#map_reserva') IS NOT NULL DROP TABLE #map_reserva;
IF OBJECT_ID('tempdb..#map_ocupacion') IS NOT NULL DROP TABLE #map_ocupacion;
IF OBJECT_ID('tempdb..#map_pedido') IS NOT NULL DROP TABLE #map_pedido;

DECLARE @today DATE = CAST(GETDATE() AS DATE);

-- 1. Generar los datos base de 50 reservas
SELECT TOP 50
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS seq,
    DATEADD(MONTH, -((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 5),
            DATEADD(DAY, 1 - DAY(@today), @today)) AS mes_base,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 28 + 1) AS dia,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 20 + 1) AS id_mesa,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 10 + 1) AS id_usuario,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 50 + 1) AS id_cliente,
    (CASE (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 3
        WHEN 0 THEN 'Activa'
        WHEN 1 THEN 'Cancelada'
        ELSE 'Cumplida'
    END) AS estado,
    CAST(CAST(12 + (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 5) AS VARCHAR) + ':00:00' AS TIME) AS hora_reserva,
    2 + (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 4) AS num_personas
INTO #gen_reservas
FROM sys.objects;

-- 2. Insertar las reservas y mapear los IDs reales generados
SELECT 
    seq,
    id_cliente,
    id_mesa,
    -- Nunca después de hoy
    CASE 
        WHEN DATEADD(DAY, dia-1, mes_base) > @today
            THEN @today
        ELSE DATEADD(DAY, dia-1, mes_base)
    END AS fecha_reserva,
    hora_reserva,
    num_personas,
    id_usuario,
    estado
INTO #map_reserva
FROM #gen_reservas
ORDER BY seq;

-- Insertar y obtener id_reserva
ALTER TABLE #map_reserva ADD id_reserva INT;
DECLARE @seq INT, @id_cliente INT, @id_mesa INT, @fecha DATE, @hora TIME, @num INT, @id_usuario INT, @estado NVARCHAR(20), @id_reserva INT;
DECLARE reserva_cur CURSOR FOR
    SELECT seq, id_cliente, id_mesa, fecha_reserva, hora_reserva, num_personas, id_usuario, estado FROM #map_reserva ORDER BY seq;
OPEN reserva_cur;
FETCH NEXT FROM reserva_cur INTO @seq, @id_cliente, @id_mesa, @fecha, @hora, @num, @id_usuario, @estado;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO RESERVA (id_cliente, id_mesa, fecha_reserva, hora_reserva, num_personas, id_usuario, estado)
    VALUES (@id_cliente, @id_mesa, @fecha, @hora, @num, @id_usuario, @estado);
    SET @id_reserva = SCOPE_IDENTITY();
    UPDATE #map_reserva SET id_reserva = @id_reserva WHERE seq = @seq;
    FETCH NEXT FROM reserva_cur INTO @seq, @id_cliente, @id_mesa, @fecha, @hora, @num, @id_usuario, @estado;
END
CLOSE reserva_cur;
DEALLOCATE reserva_cur;

-- 3. Insertar ocupación por cada reserva y mapear IDs
CREATE TABLE #map_ocupacion (
    seq INT,
    id_ocupacion INT,
    id_reserva INT,
    id_usuario INT,
    fecha_hora_inicio DATETIME
);

DECLARE @id_ocupacion INT, @fecha_hora_inicio DATETIME;
DECLARE ocupacion_cur CURSOR FOR
    SELECT seq, id_reserva, id_cliente, id_mesa, fecha_reserva, hora_reserva, num_personas, id_usuario
    FROM #map_reserva
    ORDER BY seq;
OPEN ocupacion_cur;
FETCH NEXT FROM ocupacion_cur INTO @seq, @id_reserva, @id_cliente, @id_mesa, @fecha, @hora, @num, @id_usuario;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @fecha_hora_inicio = DATEADD(MINUTE, 0, CAST(@fecha AS DATETIME) + CAST(@hora AS DATETIME));
    INSERT INTO OCUPACION_MESA (id_mesa, id_cliente, fecha_hora_inicio, fecha_hora_fin, num_comensales, id_reserva, id_usuario, estado)
    VALUES (@id_mesa, @id_cliente, @fecha_hora_inicio, DATEADD(HOUR, 2, @fecha_hora_inicio), @num, @id_reserva, @id_usuario, 'Cerrada');
    SET @id_ocupacion = SCOPE_IDENTITY();
    INSERT INTO #map_ocupacion VALUES (@seq, @id_ocupacion, @id_reserva, @id_usuario, @fecha_hora_inicio);
    FETCH NEXT FROM ocupacion_cur INTO @seq, @id_reserva, @id_cliente, @id_mesa, @fecha, @hora, @num, @id_usuario;
END
CLOSE ocupacion_cur;
DEALLOCATE ocupacion_cur;

-- 4. Insertar pedido por ocupación y mapear IDs
CREATE TABLE #map_pedido (
    seq INT,
    id_pedido INT,
    id_ocupacion INT,
    id_usuario INT,
    fecha_hora DATETIME
);

DECLARE @id_pedido INT;
DECLARE pedido_cur CURSOR FOR
    SELECT seq, id_ocupacion, id_usuario, fecha_hora_inicio FROM #map_ocupacion ORDER BY seq;
OPEN pedido_cur;
FETCH NEXT FROM pedido_cur INTO @seq, @id_ocupacion, @id_usuario, @fecha_hora_inicio;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO PEDIDO (id_ocupacion, fecha_hora, id_estado_pedido, id_usuario, notas)
    VALUES (@id_ocupacion, @fecha_hora_inicio, 3, @id_usuario, 'Pedido generado automáticamente');
    SET @id_pedido = SCOPE_IDENTITY();
    INSERT INTO #map_pedido VALUES (@seq, @id_pedido, @id_ocupacion, @id_usuario, @fecha_hora_inicio);
    FETCH NEXT FROM pedido_cur INTO @seq, @id_ocupacion, @id_usuario, @fecha_hora_inicio;
END
CLOSE pedido_cur;
DEALLOCATE pedido_cur;

-- 5. Insertar comprobante por ocupación
DECLARE comprobante_cur CURSOR FOR
    SELECT seq, id_ocupacion, id_usuario FROM #map_ocupacion ORDER BY seq;
DECLARE @id_comprobante INT;
OPEN comprobante_cur;
FETCH NEXT FROM comprobante_cur INTO @seq, @id_ocupacion, @id_usuario;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO COMPROBANTE (id_ocupacion, fecha_emision, subtotal, impuesto, total, metodo_pago, id_usuario, id_estado_comprobante)
    VALUES (@id_ocupacion, GETDATE(), 100.00 + (@id_ocupacion % 40) * 2, 18.00 + (@id_ocupacion % 5), 118.00 + (@id_ocupacion % 45) * 2, 
            CASE WHEN @id_ocupacion % 2 = 0 THEN 'Efectivo' ELSE 'Tarjeta' END, @id_usuario, 1);
    FETCH NEXT FROM comprobante_cur INTO @seq, @id_ocupacion, @id_usuario;
END
CLOSE comprobante_cur;
DEALLOCATE comprobante_cur;

-- Limpieza de tablas temporales
DROP TABLE IF EXISTS #gen_reservas;
DROP TABLE IF EXISTS #map_reserva;
DROP TABLE IF EXISTS #map_ocupacion;
DROP TABLE IF EXISTS #map_pedido;
GO


-- Limpieza previa de temporales (por si existen)
IF OBJECT_ID('tempdb..#det_pedido') IS NOT NULL DROP TABLE #det_pedido;
IF OBJECT_ID('tempdb..#map_comprobante') IS NOT NULL DROP TABLE #map_comprobante;

-- 1. Obtener el id_pedido y su id_ocupacion (desde el paso anterior)
--    y el comprobante asociado
SELECT 
    p.id_pedido, 
    p.id_ocupacion,
    c.id_comprobante
INTO #map_comprobante
FROM PEDIDO p
JOIN COMPROBANTE c ON p.id_ocupacion = c.id_ocupacion
WHERE p.id_pedido > (SELECT ISNULL(MIN(id_pedido),0) FROM PEDIDO) - 1 -- para asegurar solo los nuevos, si lo repites

-- 2. Insertar de 1 a 3 detalles por pedido (y comprobante), usando productos aleatorios

DECLARE @min_menu INT, @max_menu INT;
SELECT @min_menu = MIN(id_menu), @max_menu = MAX(id_menu) FROM MENU;

DECLARE @i INT = 1, @num_pedidos INT, @id_pedido INT, @id_ocupacion INT, @id_comprobante INT;
SELECT @num_pedidos = COUNT(*) FROM #map_comprobante;

DECLARE pedido_cur CURSOR FOR
    SELECT id_pedido, id_ocupacion, id_comprobante FROM #map_comprobante ORDER BY id_pedido;
OPEN pedido_cur;
FETCH NEXT FROM pedido_cur INTO @id_pedido, @id_ocupacion, @id_comprobante;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @num_det INT = 1 + ABS(CHECKSUM(NEWID())) % 3; -- de 1 a 3 detalles
    DECLARE @j INT = 0;
    WHILE @j < @num_det
    BEGIN
        DECLARE @id_menu INT = @min_menu + ABS(CHECKSUM(NEWID())) % (@max_menu - @min_menu + 1);
        DECLARE @cantidad INT = 1 + ABS(CHECKSUM(NEWID())) % 3;
        DECLARE @precio_unitario DECIMAL(10,2);
        SELECT @precio_unitario = precio FROM MENU WHERE id_menu = @id_menu;

        -- Insertar en DETALLE_PEDIDO
        INSERT INTO DETALLE_PEDIDO (id_pedido, id_menu, cantidad, precio_unitario, subtotal, id_estado_pedido)
        VALUES (@id_pedido, @id_menu, @cantidad, @precio_unitario, @cantidad * @precio_unitario, 3); -- 3: Servido

        -- Insertar en COMPROBANTE_DETALLE
        INSERT INTO COMPROBANTE_DETALLE (id_comprobante, id_menu, cantidad, precio_unitario, subtotal, descripcion)
        VALUES (@id_comprobante, @id_menu, @cantidad, @precio_unitario, @cantidad * @precio_unitario, 
                (SELECT nombre FROM MENU WHERE id_menu = @id_menu));

        SET @j = @j + 1;
    END
    FETCH NEXT FROM pedido_cur INTO @id_pedido, @id_ocupacion, @id_comprobante;
END
CLOSE pedido_cur;
DEALLOCATE pedido_cur;

-- Limpieza de temporales
DROP TABLE IF EXISTS #map_comprobante;
GO



-- =====================================================================
-- Datos desde ocupacion_mesa hasta comprobantes
-- =====================================================================


-- Limpieza de temporales previos
IF OBJECT_ID('tempdb..#oc_mesa') IS NOT NULL DROP TABLE #oc_mesa;
IF OBJECT_ID('tempdb..#pedidos_sinres') IS NOT NULL DROP TABLE #pedidos_sinres;
IF OBJECT_ID('tempdb..#comprobantes_sinres') IS NOT NULL DROP TABLE #comprobantes_sinres;

DECLARE @today DATE = CAST(GETDATE() AS DATE);

-- 1. Insertar 50 ocupaciones SIN reserva
SELECT TOP 50
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS seq,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 20 + 1) AS id_mesa,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 50 + 1) AS id_cliente,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 10 + 1) AS id_usuario,
    2 + (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 4) AS num_comensales,
    DATEADD(MONTH, -((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 5),
        DATEADD(DAY, 1 - DAY(@today), @today)) AS mes_base,
    ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) % 28 + 1) AS dia
INTO #oc_mesa
FROM sys.objects;

ALTER TABLE #oc_mesa ADD fecha_hora_inicio DATETIME, fecha_hora_fin DATETIME;
UPDATE #oc_mesa SET 
    fecha_hora_inicio = DATEADD(HOUR, 13 + (seq % 9), CAST(DATEADD(DAY, dia-1, mes_base) AS DATETIME)),
    fecha_hora_fin    = DATEADD(HOUR, 15 + (seq % 9), CAST(DATEADD(DAY, dia-1, mes_base) AS DATETIME));

ALTER TABLE #oc_mesa ADD id_ocupacion INT;

-- Insertar ocupaciones y guardar ID generado
DECLARE @seq INT, @id_mesa INT, @id_cliente INT, @id_usuario INT, @num_comensales INT, @fecha_hora_inicio DATETIME, @fecha_hora_fin DATETIME, @id_ocupacion INT;
DECLARE ocupacion_cur CURSOR FOR
    SELECT seq, id_mesa, id_cliente, id_usuario, num_comensales, fecha_hora_inicio, fecha_hora_fin
    FROM #oc_mesa
    ORDER BY seq;
OPEN ocupacion_cur;
FETCH NEXT FROM ocupacion_cur INTO @seq, @id_mesa, @id_cliente, @id_usuario, @num_comensales, @fecha_hora_inicio, @fecha_hora_fin;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO OCUPACION_MESA (id_mesa, id_cliente, fecha_hora_inicio, fecha_hora_fin, num_comensales, id_reserva, id_usuario, estado)
    VALUES (@id_mesa, @id_cliente, @fecha_hora_inicio, @fecha_hora_fin, @num_comensales, NULL, @id_usuario, 'Cerrada');
    SET @id_ocupacion = SCOPE_IDENTITY();
    UPDATE #oc_mesa SET id_ocupacion = @id_ocupacion WHERE seq = @seq;
    FETCH NEXT FROM ocupacion_cur INTO @seq, @id_mesa, @id_cliente, @id_usuario, @num_comensales, @fecha_hora_inicio, @fecha_hora_fin;
END
CLOSE ocupacion_cur;
DEALLOCATE ocupacion_cur;

-- 2. Insertar pedidos por ocupación
CREATE TABLE #pedidos_sinres (
    seq INT,
    id_pedido INT,
    id_ocupacion INT,
    id_usuario INT
);
DECLARE @id_pedido INT;
DECLARE pedido_cur CURSOR FOR
    SELECT seq, id_ocupacion, id_usuario FROM #oc_mesa ORDER BY seq;
OPEN pedido_cur;
FETCH NEXT FROM pedido_cur INTO @seq, @id_ocupacion, @id_usuario;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Usamos fecha_hora_inicio de la ocupación como fecha del pedido
    DECLARE @pedido_fecha DATETIME;
    SELECT @pedido_fecha = fecha_hora_inicio FROM #oc_mesa WHERE seq = @seq;

    INSERT INTO PEDIDO (id_ocupacion, fecha_hora, id_estado_pedido, id_usuario, notas)
    VALUES (@id_ocupacion, @pedido_fecha, 3, @id_usuario, 'Pedido generado automáticamente');
    SET @id_pedido = SCOPE_IDENTITY();
    INSERT INTO #pedidos_sinres VALUES (@seq, @id_pedido, @id_ocupacion, @id_usuario);
    FETCH NEXT FROM pedido_cur INTO @seq, @id_ocupacion, @id_usuario;
END
CLOSE pedido_cur;
DEALLOCATE pedido_cur;

-- 3. Insertar comprobantes por ocupación
CREATE TABLE #comprobantes_sinres (
    seq INT,
    id_comprobante INT,
    id_ocupacion INT,
    id_usuario INT
);
DECLARE @id_comprobante INT;
DECLARE comp_cur CURSOR FOR
    SELECT seq, id_ocupacion, id_usuario FROM #oc_mesa ORDER BY seq;
OPEN comp_cur;
FETCH NEXT FROM comp_cur INTO @seq, @id_ocupacion, @id_usuario;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO COMPROBANTE (id_ocupacion, fecha_emision, subtotal, impuesto, total, metodo_pago, id_usuario, id_estado_comprobante)
    VALUES (@id_ocupacion, GETDATE(), 100.00 + (@id_ocupacion % 40) * 2, 18.00 + (@id_ocupacion % 5), 118.00 + (@id_ocupacion % 45) * 2, 
            CASE WHEN @id_ocupacion % 2 = 0 THEN 'Efectivo' ELSE 'Tarjeta' END, @id_usuario, 1);
    SET @id_comprobante = SCOPE_IDENTITY();
    INSERT INTO #comprobantes_sinres VALUES (@seq, @id_comprobante, @id_ocupacion, @id_usuario);
    FETCH NEXT FROM comp_cur INTO @seq, @id_ocupacion, @id_usuario;
END
CLOSE comp_cur;
DEALLOCATE comp_cur;

-- 4. Insertar detalles de pedido y comprobante
DECLARE @min_menu INT, @max_menu INT;
SELECT @min_menu = MIN(id_menu), @max_menu = MAX(id_menu) FROM MENU;

DECLARE @id_menu INT, @cantidad INT, @precio_unitario DECIMAL(10,2), @id_estado_pedido INT;
DECLARE det_cur CURSOR FOR
    SELECT p.seq, p.id_pedido, p.id_ocupacion, p.id_usuario, c.id_comprobante
    FROM #pedidos_sinres p
    JOIN #comprobantes_sinres c ON p.id_ocupacion = c.id_ocupacion
    ORDER BY p.seq;
OPEN det_cur;
FETCH NEXT FROM det_cur INTO @seq, @id_pedido, @id_ocupacion, @id_usuario, @id_comprobante;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @num_det INT = 1 + ABS(CHECKSUM(NEWID())) % 3;
    DECLARE @j INT = 0;
    WHILE @j < @num_det
    BEGIN
        SET @id_menu = @min_menu + ABS(CHECKSUM(NEWID())) % (@max_menu - @min_menu + 1);
        SET @cantidad = 1 + ABS(CHECKSUM(NEWID())) % 3;
        SELECT @precio_unitario = precio FROM MENU WHERE id_menu = @id_menu;

        -- Detalle de pedido
        INSERT INTO DETALLE_PEDIDO (id_pedido, id_menu, cantidad, precio_unitario, subtotal, id_estado_pedido)
        VALUES (@id_pedido, @id_menu, @cantidad, @precio_unitario, @cantidad * @precio_unitario, 3);

        -- Detalle de comprobante
        INSERT INTO COMPROBANTE_DETALLE (id_comprobante, id_menu, cantidad, precio_unitario, subtotal, descripcion)
        VALUES (@id_comprobante, @id_menu, @cantidad, @precio_unitario, @cantidad * @precio_unitario, 
                (SELECT nombre FROM MENU WHERE id_menu = @id_menu));

        SET @j = @j + 1;
    END
    FETCH NEXT FROM det_cur INTO @seq, @id_pedido, @id_ocupacion, @id_usuario, @id_comprobante;
END
CLOSE det_cur;
DEALLOCATE det_cur;

-- Limpieza de temporales
DROP TABLE IF EXISTS #oc_mesa;
DROP TABLE IF EXISTS #pedidos_sinres;
DROP TABLE IF EXISTS #comprobantes_sinres;
GO


-- =====================================================================
-- Actualiza comprobante
-- =====================================================================



UPDATE C
SET C.total = (SELECT SUM(D.subtotal) FROM COMPROBANTE_DETALLE D WHERE C.id_comprobante = D.id_comprobante)
FROM COMPROBANTE C
GO

UPDATE COMPROBANTE
SET subtotal = total / 1.18;
GO

UPDATE COMPROBANTE
SET impuesto = total - subtotal;
GO


select * from COMPROBANTE where id_comprobante = 2;
select * from COMPROBANTE_DETALLE where id_comprobante = 2;
go

