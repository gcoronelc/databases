-- Tabla de Clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    telefono VARCHAR(15)
);

-- Datos de prueba para Clientes
INSERT INTO clientes VALUES (1, 'Juan Pérez', 'juan@mail.com', '123456789');
INSERT INTO clientes VALUES (2, 'Ana Gómez', 'ana@mail.com', '987654321');


-- Tabla de Tipos de Habitaciones
CREATE TABLE tipos_habitacion (
    id_tipo INT PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- Datos de prueba para Tipos de Habitaciones
INSERT INTO tipos_habitacion VALUES (1, 'Simple', 100.00);
INSERT INTO tipos_habitacion VALUES (2, 'Doble', 150.00);
INSERT INTO tipos_habitacion VALUES (3, 'Suite', 300.00);


-- Tabla de Estados de Habitaciones
CREATE TABLE estados_habitacion (
    id_estado INT PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
);

-- Datos de prueba para Estados de Habitaciones
INSERT INTO estados_habitacion VALUES (1, 'Libre');
INSERT INTO estados_habitacion VALUES (2, 'Ocupada');
INSERT INTO estados_habitacion VALUES (3, 'Mantenimiento');


-- Tabla de Habitaciones
CREATE TABLE habitaciones (
    id_habitacion INT PRIMARY KEY,
    id_tipo INT NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_tipo) REFERENCES tipos_habitacion(id_tipo),
    FOREIGN KEY (id_estado) REFERENCES estados_habitacion(id_estado)
);

-- Datos de prueba para Habitaciones
INSERT INTO habitaciones VALUES (1, 1, 1);
INSERT INTO habitaciones VALUES (2, 2, 2);
INSERT INTO habitaciones VALUES (3, 3, 1);


-- Tabla de Reservas
CREATE TABLE reservas (
    id_reserva INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_habitacion INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    estado VARCHAR(15) DEFAULT 'Pendiente',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_habitacion) REFERENCES habitaciones(id_habitacion)
);

-- Datos de prueba para Reservas
INSERT INTO reservas VALUES (1, 1, 1, '2024-10-15', '2024-10-17', 'Pendiente');
INSERT INTO reservas VALUES (2, 2, 2, '2024-10-16', '2024-10-18', 'Confirmada');


-- Tabla de Pagos
CREATE TABLE pagos (
    id_pago INT PRIMARY KEY,
    id_reserva INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

-- Datos de prueba para Pagos
INSERT INTO pagos VALUES (1, 1, 200.00, '2024-10-14', 'Tarjeta');


-- Tabla de Servicios Adicionales
CREATE TABLE servicios (
    id_servicio INT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- Datos de prueba para Servicios
INSERT INTO servicios VALUES (1, 'Desayuno', 10.00);
INSERT INTO servicios VALUES (2, 'Transporte', 25.00);


-- Tabla de Servicios por Reserva
CREATE TABLE servicios_reserva (
    id_servicio_reserva INT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

-- Datos de prueba para Servicios por Reserva
INSERT INTO servicios_reserva VALUES (1, 1, 1, 2); -- 2 desayunos para la reserva 1
INSERT INTO servicios_reserva VALUES (2, 1, 2, 1); -- 1 transporte para la reserva 1