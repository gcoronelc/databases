/*
 *
 * DBMS           :  Oracle Database
 * Esquema        :  RECUROS
 * Descripción    :  Base de Datos de Recursos Humanos
 * Script         :  Crea la Base de Datos
 * Responsable    :  Ing. Eric Gustavo Coronel Castillo
 * Email          :  gcoronelc@gmail.com
 * Blog           :  gcoronelc.blogspot.com
 * Fecha          :  01-ENE-2010
 *
*/

-- ==========================================================
-- Inicio de Proceso
-- ==========================================================

SET TERMOUT ON
SET ECHO OFF
SET SERVEROUTPUT ON
BEGIN
	DBMS_OUTPUT.PUT_LINE('Inicio del proceso...');
END ;
/
SET TERMOUT OFF

-- ==========================================================
-- CREACIÓN DEL ESQUEMA
-- ==========================================================

-- Verificar Cuenta

declare
  n number(3);
begin
  select count(*) into n from dba_users where username = 'RECURSOS';
  if(n = 1) then
    execute immediate 'drop user recursos cascade';
  end if;
  execute immediate 'create user recursos identified by admin';  
end;
/

-- Asigna privilegios

grant connect, resource to recursos;


-- Conexión con la base de datos

connect recursos/admin


-- ==========================================================
-- Crear la Tabla de Puestos de Trabajo: cargo
-- ==========================================================

CREATE TABLE cargo (
    idcargo     CHAR(3) NOT NULL,
    nombre      VARCHAR2(20) NOT NULL,
    sueldo_min  NUMBER(6) NOT NULL,
    sueldo_max  NUMBER(6) NOT NULL,
    CONSTRAINT pk_cargo PRIMARY KEY ( idcargo )
);

-- ==========================================================
-- Crear la Tabla de Oficinas: ubicacion
-- ==========================================================

CREATE TABLE ubicacion (
    idubicacion   char(3) NOT NULL,
    ciudad        VARCHAR2(15) NOT NULL,
    direccion     VARCHAR2(40) NOT NULL,
    CONSTRAINT pk_ubicacion PRIMARY KEY ( idubicacion )
);

-- ==========================================================
-- Crear la Tabla de Departamentos: departamento
-- ==========================================================

CREATE TABLE departamento (
    iddepartamento  NUMBER(3) NOT NULL,
    nombre          VARCHAR2(20) NOT NULL,
    idubicacion     CHAR(3) NOT NULL,
    CONSTRAINT pk_departamento 
        PRIMARY KEY ( iddepartamento ),
    CONSTRAINT fk_departamento_ubicacion 
        FOREIGN KEY ( idubicacion ) 
        REFERENCES ubicacion ( idubicacion )
);

-- ==========================================================
-- Crear la Tabla de Empleados: empleado
-- ==========================================================

CREATE TABLE empleado (
    idempleado     CHAR(5)     NOT NULL,
    apellido       VARCHAR2(20) NOT NULL,
    nombre         VARCHAR2(20) NOT NULL,
    fecingreso     date        NOT NULL,
    email          VARCHAR2(30) NULL,
    telefono       VARCHAR2(20) NULL,
    idcargo        CHAR(3)     NOT NULL,
    iddepartamento NUMBER(3)  NOT NULL,
    sueldo         NUMBER(6)  NOT NULL,
    comision       NUMBER(6)  NULL,
    jefe           CHAR(5)     NULL,
    CONSTRAINT pk_empleado 
        PRIMARY KEY ( idempleado ),
    CONSTRAINT fk_empleado_cargo 
        FOREIGN KEY ( idcargo ) 
        REFERENCES cargo ( idcargo ),
    CONSTRAINT fk_empleado_departamento 
        FOREIGN KEY ( iddepartamento ) 
        REFERENCES departamento ( iddepartamento ),
    CONSTRAINT fk_empleado_empleado 
        FOREIGN KEY ( jefe ) 
        REFERENCES empleado ( idempleado )
);

-- ==========================================================
-- Crear la Tabla de Parametros: control
-- ==========================================================

CREATE TABLE control (
    parametro   VARCHAR2(20) NOT NULL,
    valor       VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_control PRIMARY KEY ( parametro )
);

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
VALUES ( 'E0001', 'Coronel', 'Gustavo', to_date('20000401','YYYYMMDD'), 'gcoronel@perudev.com', '9666-4457', 'C01', 100, 25000, NULL, NULL );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0002', 'Fernandez', 'Claudia', to_date('20000501','YYYYMMDD'), 'cfernandez@perudev.com', '9345-8365', 'C03', 100, 8000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0003', 'Matsukawa', 'Sergio', to_date('20000401','YYYYMMDD'), 'smatsukawa@perudev.com', '9772-8369', 'C02', 102, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0004', 'Diaz', 'Mariela', to_date('20000410','YYYYMMDD'), 'mdiaz@perudev.com', '8654-6734', 'C06', 102, 1800, NULL, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0005', 'Martinez', 'Roberto', to_date('20000405','YYYYMMDD'), 'rmartinez@perudev.com', NULL, 'C08', 102, 7000, 500, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0006', 'Espinoza', 'Miguel', to_date('20000406','YYYYMMDD'), 'mespinoza@perudev.com', NULL, 'C08', 102, 7500, 500, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0007', 'Ramos', 'Vanessa', to_date('20020406','YYYYMMDD'), 'vramos@perudev.com', '9456-3456', 'C08', 102, 7000, 500, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0008', 'Flores', 'Julio', to_date('20000401','YYYYMMDD'), 'jflores@perudev.com', NULL, 'C07', 102, 3500, 1000, 'E0003' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0009', 'Marcelo', 'Ricardo', to_date('20000401','YYYYMMDD'), 'rmarcelo@perudev.com', '9936-2966', 'C02', 101, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0010', 'Barrios', 'Guisella', to_date('20010115','YYYYMMDD'), 'gbarrios@perudev.com', '9023-4512', 'C03', 101, 8000, NULL, 'E0009' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0011', 'Cuellar', 'Lucy', to_date('20030218','YYYYMMDD'), 'lcuellar@perudev.com', NULL, 'C06', 101, 2000, NULL, 'E0009' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0012', 'Valencia', 'Hugo', to_date('20000501','YYYYMMDD'), 'hvalencia@perudev.com', '9732-5601', 'C02', 105, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0013', 'Veliz', 'Fortunato', to_date('20000505','YYYYMMDD'), 'fveliz@perudev.com', '9826-7603', 'C04', 105, 6000, NULL, 'E0012' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0014', 'Aguero', 'Octavio', to_date('20000515','YYYYMMDD'), 'oaguero@perudev.com', NULL, 'C07', 105, 3000, 300, 'E0012' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0015', 'Rosales', 'Cesar', to_date('20030315','YYYYMMDD'), 'crosales@perudev.com', NULL, 'C07', 105, 2500, 300, 'E0012' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0016', 'Villarreal', 'Nora', to_date('20000501','YYYYMMDD'), 'nvillarreal@perudev.com', '9371-3641', 'C02', 103, 15000, NULL, 'E0001' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0017', 'Romero', 'Alejandra', to_date('20000503','YYYYMMDD'), 'aromero@perudev.com', '8345-9526', 'C03', 103, 7500, NULL, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0018', 'Valdiviezo', 'Jennifer', to_date('20000612','YYYYMMDD'), 'jvaldiviezo@perudev.com', '9263-5172', 'C06', 103, 2000, NULL, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0019', 'Muchotrigo', 'Omar', to_date('20000512','YYYYMMDD'), 'omuchotrigo@perudev.com', '9963-5542', 'C05', 103, 3500, 500, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0020', 'Baltazar', 'Victor', to_date('20000518','YYYYMMDD'), 'vbaltazar@perudev.com', '9893-4433', 'C05', 103, 3000, 800, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0021', 'Castillo', 'Ronald', to_date('20010518','YYYYMMDD'), 'rcastillo@perudev.com', '9234-3487', 'C05', 103, 3000, 800, 'E0016' );

INSERT INTO empleado ( idempleado, apellido, nombre, fecingreso, email, telefono, idcargo, iddepartamento, sueldo, comision, jefe )
VALUES ( 'E0022', 'Espilco', 'Luis', to_date('20020417','YYYYMMDD'), 'lespilco@perudev.com', '9554-3456', 'C05', 103, 3000, 300, 'E0016' );

-- ==========================================================
-- Cargar datos a la tabla: control
-- ==========================================================

INSERT INTO control ( parametro, valor ) VALUES ( 'Cargo', '9' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Ubicacion', '4' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Departamento', '107' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Empleado', '22' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Empresa', 'PeruDev' );
INSERT INTO control ( parametro, valor ) VALUES ( 'Site', 'www.perudev.com' );

COMMIT;