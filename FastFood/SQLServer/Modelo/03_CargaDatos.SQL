-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Carga datos de prueba a la base de datos
-- Programado por :  Eric G. Coronel Castillo
-- Teléfono       :  (511) 996-664-457
-- Email          :  gcoronelc@gmail.com
-- Blog           :  gcoronelc.blogspot.com


-- =============================================
-- Seleccionar la Base de Datos
-- =============================================

USE FASTFOOD;
go

-- Carga Datos a la tabla EMPLEADO
----------------------------------

Insert Into Empleado Values( 'E00001', 'Fernández Rodriguez', 'Mariela', 'Lince', '440-1222', 'E00001' )
Insert Into Empleado Values( 'E00002', 'Almanza Olguín', 'Karla', 'Los Olivos', '456-5999', 'E00002' )
Insert Into Empleado Values( 'E00003', 'Aguilar Rojas', 'Jesús', 'Rimac', '459-8126', 'E00003' )
Insert Into Empleado Values( 'E00004', 'QuinecheTenorio', 'Patricia', 'Miraflores', '870-3519', 'E00004' )
Insert Into Empleado Values( 'E00005', 'Pazos Saavedra', 'Juan', 'Lince', '870-3519', 'E00005' )
Insert Into Empleado Values( 'E00006', 'Pereda Chávez', 'José', 'Rimac', 'None', 'E00006' )


-- Carga Datos a la tabla DOCUMENTO
-----------------------------------

Set Identity_Insert Documento ON
Insert Into Documento( IdDocumento, NomDocumento, Serie, ConDocumento) Values( 1, 'Boleta', 1, 31 )
Insert Into Documento( IdDocumento, NomDocumento, Serie, ConDocumento) Values( 2, 'Factura', 1, 31 )
Set Identity_Insert Documento OFF


-- Carga Datos a la tabla CLIENTE
---------------------------------

INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00001', 'Pedro Diaz', '15437648', 'Lince', '472-2388','C00001' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00002', 'Hugo Valencia', '54788932', 'Magdalena', '456-3472','C00002' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00003', 'César Bustamante', '35776284', 'San Martin de Porres', '381-0589','C00003' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00004', 'Guino Henostroza', '14667934', 'Callao', '265-5744','C00004' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00005', 'Dario Rosas', '14824794', 'Huacho', '512-4782','C00005' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00006', 'Cesar Oceda', '67458712', 'Los Olivos', '525-6723','C00006' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00007', 'Juan Mori', '12349876', 'Lima', '345-1276','C00007' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00008', 'Herles Apari', '76234562', 'Lima', '768-3782','C00008' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00009', 'Fundo "Ricardo Marcelo', '55882244', 'Huacho', '456-9865','C00009' )
INSERT INTO Cliente( IdCliente, NomCliente, RUC, DirCliente, TelCliente,Clave )
	VALUES( 'C00010', 'Maribel Carrion', '23946192', 'Lima', '223-7482','C00010' )
go


-- Carga datos a la tabla CATEGORIA
-----------------------------------

Set Identity_Insert Categoria ON
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 1, 'Bebidas', 'BEB', 5 )
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 2, 'Carnes', 'CAR', 1 )
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 3, 'Pollo', 'POL', 1 )
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 4, 'Postres', 'POS', 1 )
Insert Into Categoria( IdCategoria, NomCategoria, Prefijo, ConCategoria ) Values( 5, 'Combos', 'COM', 6 )
Set Identity_Insert Categoria OFF


-- Carga datos a la tabla ARTICULO
----------------------------------

Insert Into Articulo Values( 'BEB00001', 1, 'Gaseosa (Mediana)', 2.0 )
Insert Into Articulo Values( 'BEB00002', 1, 'Gaseosa ( 1 Litro)', 3.5 )
Insert Into Articulo Values( 'BEB00003', 1, 'Gaseosa (1.5 Litro)', 4.5 )
Insert Into Articulo Values( 'BEB00004', 1, 'Cerveza Cristal (Chica)', 5.0 )
Insert Into Articulo Values( 'COM00001', 5, 'Combo Económico', 7.99 )
Insert Into Articulo Values( 'COM00002', 5, 'Combo Personal', 10.99 )
Insert Into Articulo Values( 'COM00003', 5, 'Combo Especial', 13.99 )
Insert Into Articulo Values( 'COM00004', 5, 'Combo Familiar', 28.99 )
Insert Into Articulo Values( 'COM00005', 5, 'Combo para dos', 16.99 )


-- Carga datos a la tabla PARAMETRO
-----------------------------------

Insert Into Parametro Values( 'Delivery', '10.0' )
Insert Into Parametro Values( 'IGV', '18.0' )
Insert Into Parametro Values( 'Empleado', '7' )
Insert Into Parametro Values( 'Pedido', '61' )
Insert Into Parametro Values( 'Cliente', '11' )


-- Carga datos a la tabla PROMOCION
-----------------------------------

Set Identity_Insert Promocion ON
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 1,    0.1,    30.0,  0 )
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 2,   30.1,    50.0,  2 )
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 3,   50.1,   100.0,  4 )
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 4,  100.1,   500.0,  6 )
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 5,  500.1,  1000.0,  8 )
Insert Into Promocion(IdPromocion, MontoMin, MontoMax, Porcentaje ) Values( 6, 1000.1, 10000.0, 10 )
Set Identity_Insert Promocion OFF



-- Carga Datos a la tabla PEDIDO

-- Enero 2001

Insert Into Pedido Values( 001,  1, 'E00001', '001-000001', '20010105', NULL,     'Pero',       50,     0,    9,      59,     0, 0 )
Insert Into Pedido Values( 002,  2, 'E00001', '001-000001', '20010105', 'C00002', NULL,         80,     0,    14.4,   94.4,   0, 0 )
Insert Into Pedido Values( 003,  1, 'E00002', '001-000002', '20010106', NULL,     'Magaly',     100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 004,  2, 'E00002', '001-000002', '20010106', 'C00008', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 005,  1, 'E00003', '001-000003', '20010107', NULL,     'Doris',      200,    0,    36,     236,    0, 0 )
Insert Into Pedido Values( 006,  2, 'E00003', '001-000003', '20010107', 'C00004', NULL,         300,    0,    54,     354,    0, 0 )
Insert Into Pedido Values( 007,  1, 'E00004', '001-000004', '20010108', NULL,     'Claudia',    100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 008,  2, 'E00004', '001-000004', '20010108', 'C00005', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 009,  1, 'E00005', '001-000005', '20010109', NULL,     'Patricia',   150,    0,    27,     177,    0, 0 )
Insert Into Pedido Values( 010,  2, 'E00005', '001-000005', '20010109', 'C00004', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 011,  1, 'E00006', '001-000006', '20010110', NULL,     'Edgard',     100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 012,  2, 'E00006', '001-000006', '20010110', 'C00007', NULL,         166,    0,    29.88,  195.88, 0, 0 )
Insert Into Pedido Values( 013,  1, 'E00001', '001-000007', '20010111', NULL,     'Carlos',     55,     0,    9.9,    64.9,   0, 0 )
Insert Into Pedido Values( 014,  2, 'E00001', '001-000007', '20010111', 'C00008', NULL,         166,    0,    29.88,  195.88, 0, 0 )
Insert Into Pedido Values( 015,  1, 'E00002', '001-000008', '20010112', NULL,     'César',      55,     0,    9.9,    64.9,   0, 0 )
Insert Into Pedido Values( 016,  2, 'E00002', '001-000008', '20010112', 'C00004', NULL,         120,    0,    21.6,   141.6,  0, 0 )
Insert Into Pedido Values( 017,  1, 'E00003', '001-000009', '20010113', NULL,     'Manuel',     144,    0,    25.92,  169.92, 0, 0 )
Insert Into Pedido Values( 018,  2, 'E00003', '001-000009', '20010113', 'C00003', NULL,         120,    0,    21.6,   141.6,  0, 0 )
Insert Into Pedido Values( 019,  1, 'E00004', '001-000010', '20010114', NULL,     'José',       144,    0,    25.92,  169.92, 0, 0 )
Insert Into Pedido Values( 020,  2, 'E00004', '001-000010', '20010114', 'C00005', NULL,         135,    0,    24.3,   159.3,  0, 0 )


-- Febreroo 2001

Insert Into Pedido Values( 021,  1, 'E00001', '001-000011', '20010205', NULL,     'Pero',       50,     0,    9,      59,     0, 0 )
Insert Into Pedido Values( 022,  2, 'E00001', '001-000011', '20010205', 'C00002', NULL,         80,     0,    14.4,   94.4,   0, 0 )
Insert Into Pedido Values( 023,  1, 'E00002', '001-000012', '20010206', NULL,     'Magaly',     100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 024,  2, 'E00002', '001-000012', '20010206', 'C00008', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 025,  1, 'E00003', '001-000013', '20010207', NULL,     'Doris',      200,    0,    36,     236,    0, 0 )
Insert Into Pedido Values( 026,  2, 'E00003', '001-000013', '20010207', 'C00004', NULL,         300,    0,    54,     354,    0, 0 )
Insert Into Pedido Values( 027,  1, 'E00004', '001-000014', '20010208', NULL,     'Claudia',    100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 028,  2, 'E00004', '001-000014', '20010208', 'C00005', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 029,  1, 'E00005', '001-000015', '20010209', NULL,     'Martha',     150,    0,    27,     177,    0, 0 )
Insert Into Pedido Values( 030,  2, 'E00005', '001-000015', '20010209', 'C00004', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 031,  1, 'E00006', '001-000016', '20010210', NULL,     'Edgard',     100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 032,  2, 'E00006', '001-000016', '20010210', 'C00007', NULL,         166,    0,    29.88,  195.88, 0, 0 )
Insert Into Pedido Values( 033,  1, 'E00001', '001-000017', '20010211', NULL,     'Carlos',     55,     0,    9.9,    64.9,   0, 0 )
Insert Into Pedido Values( 034,  2, 'E00001', '001-000017', '20010211', 'C00008', NULL,         166,    0,    29.88,  195.88, 0, 0 )
Insert Into Pedido Values( 035,  1, 'E00002', '001-000018', '20010212', NULL,     'César',      55,     0,    9.9,    64.9,   0, 0 )
Insert Into Pedido Values( 036,  2, 'E00002', '001-000018', '20010212', 'C00004', NULL,         120,    0,    21.6,   141.6,  0, 0 )
Insert Into Pedido Values( 037,  1, 'E00003', '001-000019', '20010213', NULL,     'Ricardo',    144,    0,    25.92,  169.92, 0, 0 )
Insert Into Pedido Values( 038,  2, 'E00003', '001-000019', '20010213', 'C00003', NULL,         120,    0,    21.6,   141.6,  0, 0 )
Insert Into Pedido Values( 039,  1, 'E00004', '001-000020', '20010214', NULL,     'José',       144,    0,    25.92,  169.92, 0, 0 )
Insert Into Pedido Values( 040,  2, 'E00004', '001-000020', '20010214', 'C00005', NULL,         135,    0,    24.3,   159.3,  0, 0 )


-- Marzo 2001

Insert Into Pedido Values( 041,  1, 'E00001', '001-000021', '20010305', NULL,     'Pero',       50,     0,    9,      59,     0, 0 )
Insert Into Pedido Values( 042,  2, 'E00001', '001-000021', '20010305', 'C00002', NULL,         80,     0,    14.4,   94.4,   0, 0 )
Insert Into Pedido Values( 043,  1, 'E00002', '001-000022', '20010306', NULL,     'Delia',     100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 044,  2, 'E00002', '001-000022', '20010306', 'C00008', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 045,  1, 'E00003', '001-000023', '20010307', NULL,     'Doris',      200,    0,    36,     236,    0, 0 )
Insert Into Pedido Values( 046,  2, 'E00003', '001-000023', '20010307', 'C00004', NULL,         300,    0,    54,     354,    0, 0 )
Insert Into Pedido Values( 047,  1, 'E00004', '001-000024', '20010308', NULL,     'Claudia',    100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 048,  2, 'E00004', '001-000024', '20010308', 'C00005', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 049,  1, 'E00005', '001-000025', '20010309', NULL,     'Martha',     150,    0,    27,     177,    0, 0 )
Insert Into Pedido Values( 050,  2, 'E00005', '001-000025', '20010309', 'C00004', NULL,         90,     0,    16.2,   106.2,  0, 0 )
Insert Into Pedido Values( 051,  1, 'E00006', '001-000026', '20010310', NULL,     'Edgard',     100,    0,    18,     118,    0, 0 )
Insert Into Pedido Values( 052,  2, 'E00006', '001-000026', '20010310', 'C00007', NULL,         166,    0,    29.88,  195.88, 0, 0 )
Insert Into Pedido Values( 053,  1, 'E00001', '001-000027', '20010311', NULL,     'Carlos',     55,     0,    9.9,    64.9,   0, 0 )
Insert Into Pedido Values( 054,  2, 'E00001', '001-000027', '20010311', 'C00008', NULL,         166,    0,    29.88,  195.88, 0, 0 )
Insert Into Pedido Values( 055,  1, 'E00002', '001-000028', '20010312', NULL,     'César',      55,     0,    9.9,    64.9,   0, 0 )
Insert Into Pedido Values( 056,  2, 'E00002', '001-000028', '20010312', 'C00004', NULL,         120,    0,    21.6,   141.6,  0, 0 )
Insert Into Pedido Values( 057,  1, 'E00003', '001-000029', '20010313', NULL,     'Ricardo',    144,    0,    25.92,  169.92, 0, 0 )
Insert Into Pedido Values( 058,  2, 'E00003', '001-000029', '20010313', 'C00003', NULL,         120,    0,    21.6,   141.6,  0, 0 )
Insert Into Pedido Values( 059,  1, 'E00004', '001-000030', '20010314', NULL,     'José',       144,    0,    25.92,  169.92, 0, 0 )
Insert Into Pedido Values( 060,  2, 'E00004', '001-000030', '20010314', 'C00005', NULL,         135,    0,    24.3,   159.3,  0, 0 )
