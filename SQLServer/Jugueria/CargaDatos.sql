/*
Empresa          :  EGCC
Software         :  Sistema de ventas de una jugueria.
DBMS             :  SQL SERVER
Base de datos    :  JugueriaDB
Script           :  Carga datos de prueba.
Responsable      :  Mag. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Sitio Web        :  www.desarrollasoftware.com
Blog             :  http://gcoronelc.blogspot.com
Cursos virtuales :  https://gcoronelc.github.io/
Canal Youtube    :  https://www.youtube.com/DesarrollaSoftware
Creado el        :  24-OCT-2024
*/


-- =============================================
-- ACTIVAR LA BASE DE DATOS
-- =============================================

USE master;
go


-- =============================================
-- CARGAR DATOS DE PRUEBA
-- =============================================

-- Datos de prueba para Categorías
INSERT INTO categoria VALUES (1, 'Jugos Naturales');
INSERT INTO categoria VALUES (2, 'Smoothies');
INSERT INTO categoria VALUES (3, 'Ensaladas de Frutas');
GO


-- Datos de prueba para Productos

SET IDENTITY_INSERT dbo.producto ON;  
GO 

INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (1, 'Jugo de Naranja', 1, 5.00, 60);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (2, 'Smoothie de Fresa', 2, 8.00, 50);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (3, 'Ensalada de Frutas Mixta', 3, 10.00, 80);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (4, 'Jugo de Mango', 1, 6.00, 45);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (5, 'Smoothie de Plátano', 2, 7.50, 40);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (6, 'Jugo de Papaya', 1, 5.50, 55);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (7, 'Smoothie de Piña', 2, 7.00, 80);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (8, 'Ensalada de Frutas Tropicales', 3, 12.00, 50);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (9, 'Jugo de Sandía', 1, 5.75, 70);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (10, 'Smoothie de Kiwi', 2, 9.00, 70);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (11, 'Jugo de Zanahoria', 1, 6.25, 35);
INSERT INTO producto(id_producto,nombre,id_categoria,precio,stock) VALUES (12, 'Smoothie de Mora', 2, 8.50, 45);
GO

SET IDENTITY_INSERT dbo.producto OFF;  
GO 



-- Datos de prueba para Promociones

SET IDENTITY_INSERT dbo.promocion ON;  
GO 

INSERT INTO promocion(id_promocion,nombre,fecha_inicio,fecha_fin) VALUES (1, 'Descuento Verano', '20240101', '20240331');
INSERT INTO promocion(id_promocion,nombre,fecha_inicio,fecha_fin) VALUES (2, 'La Salud es primero', '20240501', '20240630');
INSERT INTO promocion(id_promocion,nombre,fecha_inicio,fecha_fin) VALUES (3, 'Por la Patria', '20240801', '20241031');
GO

SET IDENTITY_INSERT dbo.promocion OFF;  
GO 


-- Datos de prueba para Productos en Promoción

SET IDENTITY_INSERT dbo.producto_promocion ON;  
GO 

INSERT INTO producto_promocion(id_producto_promocion,id_promocion,id_producto,porc_descuento) VALUES (1, 1, 1, 10.00); -- 10% de descuento 
INSERT INTO producto_promocion(id_producto_promocion,id_promocion,id_producto,porc_descuento) VALUES (2, 2, 3, 15.00); -- 15% de descuento 
INSERT INTO producto_promocion(id_producto_promocion,id_promocion,id_producto,porc_descuento) VALUES (3, 3, 4, 10.00); -- 10% de descuento 
INSERT INTO producto_promocion(id_producto_promocion,id_promocion,id_producto,porc_descuento) VALUES (4, 3, 7, 20.00); -- 20% de descuento 
GO

SET IDENTITY_INSERT dbo.producto_promocion OFF;  
GO 



-- Datos de prueba para Empleados

SET IDENTITY_INSERT dbo.empleado ON;  
GO 

INSERT INTO empleado(id_empleado,nombre,telefono,usuario,clave) VALUES (1, 'Carlos Martínez', '123456789', 'carlos', 'clave123');
INSERT INTO empleado(id_empleado,nombre,telefono,usuario,clave) VALUES (2, 'Ana Gómez', '987654321', 'ana', 'segura456');
go

SET IDENTITY_INSERT dbo.empleado OFF;  
GO 


-- Datos de prueba para Ventas

SET IDENTITY_INSERT dbo.venta ON;  
GO 

INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (1, 1,  '20240915', 0, 0, 25.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (2, 2,  '20240916', 0, 0, 18.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (3, 1,  '20240917', 0, 0, 30.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (4, 2,  '20240918', 0, 0, 20.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (5, 1,  '20240919', 0, 0, 45.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (6, 2,  '20240920', 0, 0, 22.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (7, 1,  '20240921', 0, 0, 28.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (8, 2,  '20240922', 0, 0, 35.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (9, 1,  '20240923', 0, 0, 40.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (10, 2, '20240924', 0, 0, 50.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (11, 1, '20240925', 0, 0, 32.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (12, 2, '20240926', 0, 0, 27.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (13, 1, '20240927', 0, 0, 38.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (14, 2, '20240928', 0, 0, 45.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (15, 1, '20240929', 0, 0, 36.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (16, 2, '20240930', 0, 0, 25.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (17, 1, '20241001', 0, 0, 42.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (18, 2, '20241002', 0, 0, 33.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (19, 1, '20241003', 0, 0, 47.00);
INSERT INTO venta(id_venta,id_empleado,fecha,importe,impuesto,total) VALUES (20, 2, '20241004', 0, 0, 29.00);
GO

SET IDENTITY_INSERT dbo.venta OFF;  
GO 



-- Datos de prueba para Detalles de Venta

SET IDENTITY_INSERT dbo.detalle_venta ON;  
GO

INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (1, 1, 1, 2, 5.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (2, 1, 2, 1, 8.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (3, 2, 3, 1, 10.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (4, 3, 4, 3, 6.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (5, 3, 5, 1, 7.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (6, 4, 6, 2, 5.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (7, 5, 7, 2, 7.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (8, 5, 8, 1, 12.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (9, 6, 9, 1, 5.75, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (10, 6, 10, 2, 9.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (11, 7, 11, 1, 6.25, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (12, 7, 12, 1, 8.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (13, 8, 1, 2, 5.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (14, 8, 3, 1, 10.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (15, 9, 4, 2, 6.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (16, 9, 5, 1, 7.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (17, 10, 6, 3, 5.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (18, 10, 7, 1, 7.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (19, 11, 8, 2, 12.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (20, 11, 9, 1, 5.75, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (21, 12, 10, 1, 9.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (22, 12, 11, 1, 6.25, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (23, 13, 1, 3, 5.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (24, 13, 2, 1, 8.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (25, 14, 3, 2, 10.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (26, 14, 4, 1, 6.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (27, 15, 5, 1, 7.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (28, 15, 6, 2, 5.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (29, 16, 7, 3, 7.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (30, 16, 8, 1, 12.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (31, 17, 9, 1, 5.75, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (32, 17, 10, 2, 9.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (33, 18, 11, 2, 6.25, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (34, 18, 12, 1, 8.50, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (35, 19, 1, 3, 5.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (36, 19, 2, 1, 8.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (37, 20, 3, 2, 10.00, 0);
INSERT INTO detalle_venta(id_detalle,id_venta,id_producto,cantidad,precio,subtotal) VALUES (38, 20, 4, 1, 6.00, 0);
GO

SET IDENTITY_INSERT dbo.detalle_venta OFF;  
GO


-- Scripts finales

UPDATE detalle_venta 
set subtotal = precio * cantidad;
go

update venta 
set total = (select sum(subtotal) from detalle_venta d where d.id_venta = v.id_venta)
from venta v
go

update venta 
set importe = total / 1.18;
go

update venta 
set impuesto = total - importe;
go

select * from venta where id_venta in (1,2,3);
select * from detalle_venta where id_venta in (1,2,3);
go

