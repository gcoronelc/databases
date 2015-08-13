/*
 *
 * DBMS           :  MySQL Server
 * Base de Datos  :  RECURSOS
 * Descripción    :  Base de Datos de Recursos Humanos
 * Script         :  Crea la Base de Datos
 * Responsable    :  Ing. Eric Gustavo Coronel Castillo
 * Email          :  gcoronelc@gmail.com
 * Blog           :  gcoronelc.blogspot.com
 * Fecha          :  01-ENE-2010
 *
*/

-- ==========================================================
-- Creación de la Base de Datos
-- ==========================================================

CREATE DATABASE IF NOT EXISTS RECURSOS;

-- ==========================================================
-- Seleccionar la Base de Datos
-- ==========================================================

USE RECURSOS;

-- ==========================================================
-- Eliminar las tablas en caso existan
-- ==========================================================

DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS departamento;
DROP TABLE IF EXISTS ubicacion;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS control;

-- ==========================================================
-- Crear la Tabla de Puestos de Trabajo: cargo
-- ==========================================================

CREATE TABLE cargo (
    idcargo     CHAR(3) NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    sueldo_min  NUMERIC(6) NOT NULL,
    sueldo_max  NUMERIC(6) NOT NULL,
    CONSTRAINT pk_cargo PRIMARY KEY ( idcargo )
) ENGINE = INNODB ;

-- ==========================================================
-- Crear la Tabla de Oficinas: ubicacion
-- ==========================================================

CREATE TABLE ubicacion (
    idubicacion   char(3) NOT NULL,
    ciudad        VARCHAR(15) NOT NULL,
    direccion     VARCHAR(40) NOT NULL,
    CONSTRAINT pk_ubicacion PRIMARY KEY ( idubicacion )
) ENGINE = INNODB ;

-- ==========================================================
-- Crear la Tabla de Departamentos: departamento
-- ==========================================================

CREATE TABLE departamento (
    iddepartamento  NUMERIC(3) NOT NULL,
    nombre          VARCHAR(20) NOT NULL,
    idubicacion     CHAR(3) NOT NULL,
    CONSTRAINT pk_departamento PRIMARY KEY ( iddepartamento ),
    CONSTRAINT fk_departamento_ubicacion 
        FOREIGN KEY ( idubicacion ) 
        REFERENCES ubicacion ( idubicacion )
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT
) ENGINE = INNODB ;

-- ==========================================================
-- Crear la Tabla de Empleados: empleado
-- ==========================================================

CREATE TABLE empleado (
    idempleado     CHAR(5)     NOT NULL,
    apellido       VARCHAR(20) NOT NULL,
    nombre         VARCHAR(20) NOT NULL,
    fecingreso     date        NOT NULL,
    email          VARCHAR(30) NULL,
    telefono       VARCHAR(20) NULL,
    idcargo        CHAR(3)     NOT NULL,
    iddepartamento NUMERIC(3)  NOT NULL,
    sueldo         NUMERIC(6)  NOT NULL,
    comision       NUMERIC(6)  NULL,
    jefe           CHAR(5)     NULL,
    CONSTRAINT pk_empleado PRIMARY KEY ( idempleado ),
    CONSTRAINT fk_empleado_cargo 
        FOREIGN KEY ( idcargo ) 
        REFERENCES cargo ( idcargo )
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,
    CONSTRAINT fk_empleado_departamento 
        FOREIGN KEY ( iddepartamento ) 
        REFERENCES departamento ( iddepartamento )
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,
    CONSTRAINT fk_empleado_empleado 
        FOREIGN KEY ( jefe ) 
        REFERENCES empleado ( idempleado )
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT
) ENGINE = INNODB;


-- ==========================================================
-- Crear la Tabla de Usuarios: usuario
-- ==========================================================

CREATE TABLE usuario (
	idempleado            char(5)   NOT NULL,
	usuario               varchar(20)   NOT NULL,
	clave                 varchar(40)   NOT NULL,
	estado                integer   NOT NULL,
	CONSTRAINT pk_usuario PRIMARY KEY (idempleado),
	CONSTRAINT  fk_usuario_empleado 
    FOREIGN KEY (idempleado) 
    REFERENCES empleado (idempleado)
    ON DELETE RESTRICT 
    ON UPDATE RESTRICT    
) ENGINE = INNODB;

-- ==========================================================
-- Crear la Tabla de Parametros: control
-- ==========================================================

CREATE TABLE control (
    parametro   VARCHAR(20) NOT NULL,
    valor       VARCHAR(100) NOT NULL,
    CONSTRAINT pk_control PRIMARY KEY ( parametro )
) ENGINE = INNODB ;

-- ==========================================================
-- Cargar datos a la tabla: cargo
-- ==========================================================

INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C01', 'Gerente General', 15000, 50000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C02', 'Gerente', 10000, 15000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C03', 'Empleado', 7000, 10000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C04', 'Analista', 5000, 7000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C05', 'Vendedor', 3000, 5000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C06', 'Oficinista', 1500, 3000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C07', 'Programador', 2500, 6000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C08', 'Investigador', 6000, 8000 );
INSERT INTO cargo ( idcargo, nombre, sueldo_min, sueldo_max ) VALUES ( 'C09', 'Digitador', 1000, 1500 );

-- ==========================================================
-- Cargar datos a la tabla: ubicacion
-- ==========================================================

INSERT INTO ubicacion ( idubicacion, ciudad, direccion ) VALUES ( 'U01', 'Lima', 'Av. Benavides 534 - Miraflores' );
INSERT INTO ubicacion ( idubicacion, ciudad, direccion ) VALUES ( 'U02', 'Trujillo', 'Calle Primavera 1235 - Cercado' );
INSERT INTO ubicacion ( idubicacion, ciudad, direccion ) VALUES ( 'U03', 'Arequipa', 'Av. Central 2517 - Cercado' );
INSERT INTO ubicacion ( idubicacion, ciudad, direccion ) VALUES ( 'U04', 'Lima', 'Av. La Marina 3456 - San Miguel' );

-- ==========================================================
-- Cargar datos a la tabla: departamento
-- ==========================================================

INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 100, 'Gerencia', 'U01' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 101, 'Contabilidad', 'U01' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 102, 'Investigacion', 'U03' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 103, 'Ventas', 'U01' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 104, 'Operaciones', 'U01' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 105, 'Sistemas', 'U04' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 106, 'Recursos Humanos', 'U04' );
INSERT INTO departamento ( iddepartamento, nombre, idubicacion ) VALUES ( 107, 'Finanzas', 'U01' );

-- ==========================================================
-- Cargar datos a la tabla: empleado
-- ==========================================================

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0001', 'Coronel', 'Gustavo', '20000401', 'gcoronel@gmail.com', '9666-4457', 'C01', 100, 25000, NULL, NULL );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0002', 'Fernandez', 'Claudia', '20000501', 'cfernandez@gmail.com', '9345-8365', 'C03', 100, 8000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0003', 'Matsukawa', 'Sergio', '20000401', 'smatsukawa@gmail.com', '9772-8369', 'C02', 102, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0004', 'Diaz', 'Mariela', '20000410', 'mdiaz@gmail.com', '8654-6734', 'C06', 102, 1800, NULL, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0005', 'Martinez', 'Roberto', '20000405', 'rmartinez@gmail.com', NULL, 'C08', 102, 7000, 500, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0006', 'Espinoza', 'Miguel', '20000406', 'mespinoza@gmail.com', NULL, 'C08', 102, 7500, 500, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0007', 'Ramos', 'Vanessa', '20020406', 'vramos@gmail.com', '9456-3456', 'C08', 102, 7000, 500, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0008', 'Flores', 'Julio', '20000401', 'jflores@gmail.com', NULL, 'C07', 102, 3500, 1000, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0009', 'Marcelo', 'Ricardo', '20000401', 'rmarcelo@gmail.com', '9936-2966', 'C02', 101, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0010', 'Barrios', 'Guisella', '20010115', 'gbarrios@gmail.com', '9023-4512', 'C03', 101, 8000, NULL, 'E0009' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0011', 'Cuellar', 'Lucy', '20030218', 'lcuellar@gmail.com', NULL, 'C06', 101, 2000, NULL, 'E0009' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0012', 'Valencia', 'Hugo', '20000501', 'hvalencia@gmail.com', '9732-5601', 'C02', 105, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0013', 'Veliz', 'Fortunato', '20000505', 'fveliz@gmail.com', '9826-7603', 'C04', 105, 6000, NULL, 'E0012' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0014', 'Aguero', 'Octavio', '20000515', 'oaguero@gmail.com', NULL, 'C07', 105, 3000, 300, 'E0012' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0015', 'Rosales', 'Cesar', '20030315', 'crosales@gmail.com', NULL, 'C07', 105, 2500, 300, 'E0012' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0016', 'Villarreal', 'Nora', '20000501', 'nvillarreal@gmail.com', '9371-3641', 'C02', 103, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0017', 'Romero', 'Alejandra', '20000503', 'aromero@gmail.com', '8345-9526', 'C03', 103, 7500, NULL, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0018', 'Valdiviezo', 'Jennifer', '20000612', 'jvaldiviezo@gmail.com', '9263-5172', 'C06', 103, 2000, NULL, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0019', 'Muchotrigo', 'Omar', '20000512', 'omuchotrigo@gmail.com', '9963-5542', 'C05', 103, 3500, 500, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0020', 'Baltazar', 'Victor', '20000518', 'vbaltazar@gmail.com', '9893-4433', 'C05', 103, 3000, 800, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0021', 'Castillo', 'Ronald', '20010518', 'rcastillo@gmail.com', '9234-3487', 'C05', 103, 3000, 800, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0022', 'Espilco', 'Luis', '20020417', 'lespilco@gmail.com', '9554-3456', 'C05', 103, 3000, 300, 'E0016' );


-- ==========================================================
-- Cargar datos a la tabla: usuario
-- ==========================================================

INSERT INTO usuario ( idempleado, usuario, clave, estado ) VALUES ( 'E0001', 'gcoronelc', SHA('super'), 1 );
INSERT INTO usuario ( idempleado, usuario, clave, estado ) VALUES ( 'E0018', 'jvaldiviezo', SHA('gatita'), 1 );
INSERT INTO usuario ( idempleado, usuario, clave, estado ) VALUES ( 'E0011', 'lcuellar', SHA('tigresa'), 0 );
INSERT INTO usuario ( idempleado, usuario, clave, estado ) VALUES ( 'E0008', 'jflores', SHA('cazador'), 1 );
INSERT INTO usuario ( idempleado, usuario, clave, estado ) VALUES ( 'E0021', 'rcastillo', SHA('cerroeb'), 0 );



-- ==========================================================
-- Cargar datos a la tabla: control
-- ==========================================================

INSERT INTO control ( parametro, valor ) VALUES ( 'Cargo', '9' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Ubicacion', '4' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Departamento', '107' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Empleado', '22' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Responsable', 'Eric Gustavo Coronel Castillo' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Email', 'gcoronelc@gmail.com' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Blog', 'gcoronelc.blogspot.com' );


-- ==========================================================
-- Crea el usuario
-- ==========================================================

USE MYSQL;
GRANT ALL PRIVILEGES ON *.* TO 'recursos'@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION;
FLUSH PRIVILEGES;
USE RECURSOS;

USE MYSQL;
GRANT ALL PRIVILEGES ON *.* TO 'recursos'@'localhost' IDENTIFIED BY 'admin' WITH GRANT OPTION;
FLUSH PRIVILEGES;
USE RECURSOS;