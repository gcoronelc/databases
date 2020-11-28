REM Empresa        :  EUREKABANK
REM Software       :  Sistema de Cuentas de Ahorro
REM DBMS           :  ORACLE
REM Eequema        :  EUREKA
REM Script         :  Crea el esquema EUREKA
REM Responsable    :  Ing. Eric Gustavo Coronel Castillo
REM Email          :  gcoronelc@gmail.com
REM Sitio Web      :  www.desarrollasoftware.com
REM Blog           :  http://gcoronelc.blogspot.com
REM Youtube        :  https://www.youtube.com/c/DesarrollaSoftware



REM 21-MAY-2001 Se agrega comentarios a las columnas.



REM ============================================
REM DESHABILITAR SALIDAS
REM ============================================

SET TERMOUT OFF
SET ECHO OFF


-- =============================================
-- CRACIÓN DE LA APLICACIÓN
-- =============================================

DECLARE
	N INT;
	COMMAND VARCHAR2(200);
BEGIN
	COMMAND := 'DROP USER eureka CASCADE';
	SELECT COUNT(*) INTO N
	FROM DBA_USERS
	WHERE USERNAME = 'EUREKA';
	IF ( N = 1 ) THEN
		EXECUTE IMMEDIATE COMMAND;
	END IF;
END;
/


CREATE USER eureka IDENTIFIED BY admin;

GRANT CONNECT, RESOURCE TO eureka;

ALTER USER EUREKA
QUOTA UNLIMITED ON USERS;

GRANT CREATE VIEW TO eureka;


-- =============================================
-- CONECTARSE A LA APLICACIÓN
-- =============================================

CONNECT eureka/admin


-- =============================================
-- CREACIÓN DE LOS OBJETOS DE LA BASE DE DATOS
-- =============================================




CREATE TABLE EUREKA.Sucursal
(
	chr_sucucodigo       CHAR(3) NOT NULL ,
	vch_sucunombre       VARCHAR(50) NOT NULL ,
	vch_sucuciudad       VARCHAR(30) NOT NULL ,
	vch_sucudireccion    VARCHAR(50) NOT NULL ,
	int_sucucontcuenta   NUMBER(5,0) NOT NULL ,
CONSTRAINT  PK_SUCURSAL PRIMARY KEY (chr_sucucodigo)
);



COMMENT ON TABLE EUREKA.Sucursal IS 'Tabla de sucursales con que cuenta la empresa.';




COMMENT ON COLUMN EUREKA.Sucursal.chr_sucucodigo IS 'Código de sucursal.';




COMMENT ON COLUMN EUREKA.Sucursal.vch_sucunombre IS 'Nombre de sucursal.';




COMMENT ON COLUMN EUREKA.Sucursal.vch_sucuciudad IS 'Ciudad de la sucursal.';




COMMENT ON COLUMN EUREKA.Sucursal.vch_sucudireccion IS 'Dirección de la sucursal.';




COMMENT ON COLUMN EUREKA.Sucursal.int_sucucontcuenta IS 'Contador de cuentas de la sucursal.';



CREATE TABLE EUREKA.Empleado
(
	chr_emplcodigo       CHAR(4) NOT NULL ,
	vch_emplpaterno      VARCHAR(25) NOT NULL ,
	vch_emplmaterno      VARCHAR(25) NOT NULL ,
	vch_emplnombre       VARCHAR(30) NOT NULL ,
	vch_emplciudad       VARCHAR(30) NOT NULL ,
	vch_empldireccion    VARCHAR(50) NOT NULL ,
	vch_emplusuario      VARCHAR(15) NOT NULL ,
	vch_emplclave        VARCHAR(15) NOT NULL ,
CONSTRAINT  PK_EMPLEADO PRIMARY KEY (chr_emplcodigo)
);



COMMENT ON TABLE EUREKA.Empleado IS 'Tabla de empleados.';




COMMENT ON COLUMN EUREKA.Empleado.chr_emplcodigo IS 'Código del empleado.';




COMMENT ON COLUMN EUREKA.Empleado.vch_emplpaterno IS 'Apellido paterno.';




COMMENT ON COLUMN EUREKA.Empleado.vch_emplmaterno IS 'Apellido materno.';




COMMENT ON COLUMN EUREKA.Empleado.vch_emplnombre IS 'Nombre.';




COMMENT ON COLUMN EUREKA.Empleado.vch_emplciudad IS 'Ciudad.';




COMMENT ON COLUMN EUREKA.Empleado.vch_emplusuario IS 'Usuario.';




COMMENT ON COLUMN EUREKA.Empleado.vch_empldireccion IS 'Dirección.';




COMMENT ON COLUMN EUREKA.Empleado.vch_emplclave IS 'Clave.';



CREATE TABLE EUREKA.Asignado
(
	chr_asigcodigo       CHAR(6) NOT NULL ,
	chr_sucucodigo       CHAR(3) NOT NULL ,
	chr_emplcodigo       CHAR(4) NOT NULL ,
	dtt_asigfechaalta    DATE NOT NULL ,
	dtt_asigfechabaja    DATE NULL ,
CONSTRAINT  PK_ASIGNADO PRIMARY KEY (chr_asigcodigo),
CONSTRAINT FK_ASIGNADO_SUCURSAL FOREIGN KEY (chr_sucucodigo) REFERENCES EUREKA.Sucursal (chr_sucucodigo),
CONSTRAINT FK_ASIGNADO_EMPLEADO FOREIGN KEY (chr_emplcodigo) REFERENCES EUREKA.Empleado (chr_emplcodigo)
);



COMMENT ON TABLE EUREKA.Asignado IS 'Esta tabla registra el departamento al que se encuentra asignado un empleado y todo su historial.';




COMMENT ON COLUMN EUREKA.Asignado.chr_asigcodigo IS 'Código de asignado.';




COMMENT ON COLUMN EUREKA.Asignado.chr_sucucodigo IS 'Código de sucursal.';




COMMENT ON COLUMN EUREKA.Asignado.chr_emplcodigo IS 'Código del empleado.';



CREATE TABLE EUREKA.Moneda
(
	chr_monecodigo       CHAR(2) NOT NULL ,
	vch_monedescripcion  VARCHAR(20) NOT NULL ,
CONSTRAINT  PK_MONEDA PRIMARY KEY (chr_monecodigo)
);



COMMENT ON TABLE EUREKA.Moneda IS 'Tabla donde se registran las monedas en que se pueden crear las cuentas.';




COMMENT ON COLUMN EUREKA.Moneda.chr_monecodigo IS 'Código de moneda.';




COMMENT ON COLUMN EUREKA.Moneda.vch_monedescripcion IS 'Nombre de moneda.';



CREATE TABLE EUREKA.Cliente
(
	chr_cliecodigo       CHAR(5) NOT NULL ,
	vch_cliepaterno      VARCHAR(25) NOT NULL ,
	vch_cliematerno      VARCHAR(25) NOT NULL ,
	vch_clienombre       VARCHAR(30) NOT NULL ,
	chr_cliedni          CHAR(8) NOT NULL ,
	vch_clieciudad       VARCHAR(30) NOT NULL ,
	vch_cliedireccion    VARCHAR(50) NOT NULL ,
	vch_clietelefono     VARCHAR(20) NULL ,
	vch_clieemail        VARCHAR(50) NULL ,
CONSTRAINT  PK_CLIENTE PRIMARY KEY (chr_cliecodigo)
);



COMMENT ON TABLE EUREKA.Cliente IS 'Tabla donde se registran todos los clientes.';




COMMENT ON COLUMN EUREKA.Cliente.chr_cliecodigo IS 'Código del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_cliepaterno IS 'Apellido paterno del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_cliematerno IS 'Apellido materno del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_cliedireccion IS 'Dirección del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_clienombre IS 'Nombre del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.chr_cliedni IS 'DNI del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_clieciudad IS 'Nombre de ciudad del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_clieemail IS 'Correo electronico del cliente.';




COMMENT ON COLUMN EUREKA.Cliente.vch_clietelefono IS 'Teléfono del cliente.';



CREATE TABLE EUREKA.Cuenta
(
	chr_cuencodigo       CHAR(8) NOT NULL ,
	chr_monecodigo       CHAR(2) NOT NULL ,
	chr_sucucodigo       CHAR(3) NOT NULL ,
	chr_emplcreacuenta   CHAR(4) NOT NULL ,
	chr_cliecodigo       CHAR(5) NOT NULL ,
	dec_cuensaldo        NUMBER(12,2) NOT NULL ,
	dtt_cuenfechacreacion DATE NOT NULL ,
	vch_cuenestado       VARCHAR(15) DEFAULT  'ACTIVO'  NOT NULL  CONSTRAINT  CHK_CUENTA_ESTADO CHECK (vch_cuenestado IN ('ACTIVO', 'ANULADO', 'CANCELADO')),
	int_cuencontmov      NUMBER(6,0) NOT NULL ,
	chr_cuenclave        CHAR(6) NOT NULL ,
CONSTRAINT  PK_CUENTA PRIMARY KEY (chr_cuencodigo),
CONSTRAINT FK_CUENTA_MONEDA FOREIGN KEY (chr_monecodigo) REFERENCES EUREKA.Moneda (chr_monecodigo),
CONSTRAINT FK_CUENTA_SUCURSAL FOREIGN KEY (chr_sucucodigo) REFERENCES EUREKA.Sucursal (chr_sucucodigo),
CONSTRAINT FK_CUENTE_EMPLEADO FOREIGN KEY (chr_emplcreacuenta) REFERENCES EUREKA.Empleado (chr_emplcodigo),
CONSTRAINT FK_CUENTE_CLIENTE FOREIGN KEY (chr_cliecodigo) REFERENCES EUREKA.Cliente (chr_cliecodigo)
);



COMMENT ON TABLE EUREKA.Cuenta IS 'Tabla donde se registran todas las cuentas y sus saldos.';




COMMENT ON COLUMN EUREKA.Cuenta.chr_cuencodigo IS 'Código de cuenta.';




COMMENT ON COLUMN EUREKA.Cuenta.chr_monecodigo IS 'Código de moneda.';




COMMENT ON COLUMN EUREKA.Cuenta.chr_sucucodigo IS 'Código de sucursal.';




COMMENT ON COLUMN EUREKA.Cuenta.dec_cuensaldo IS 'Saldo de la cuenta.';




COMMENT ON COLUMN EUREKA.Cuenta.dtt_cuenfechacreacion IS 'Fecha de creación de la cuenta.';




COMMENT ON COLUMN EUREKA.Cuenta.chr_emplcreacuenta IS 'Código del empleado.';




COMMENT ON COLUMN EUREKA.Cuenta.vch_cuenestado IS 'Estado de la cuenta.';




COMMENT ON COLUMN EUREKA.Cuenta.int_cuencontmov IS 'Contador de movimientos de la cuenta.';




COMMENT ON COLUMN EUREKA.Cuenta.chr_cliecodigo IS 'Código del cliente.';




COMMENT ON COLUMN EUREKA.Cuenta.chr_cuenclave IS 'Clave de la cuenta.';



CREATE TABLE EUREKA.TipoMovimiento
(
	chr_tipocodigo       CHAR(3) NOT NULL ,
	vch_tipodescripcion  VARCHAR(40) NOT NULL ,
	vch_tipoaccion       VARCHAR(10) NOT NULL  CONSTRAINT  CHK_TIPOMOV_ACCION CHECK (vch_tipoaccion IN ('INGRESO', 'SALIDA')),
	vch_tipoestado       VARCHAR(15) DEFAULT  'ACTIVO'  NOT NULL  CONSTRAINT  CHK_TIPOMOVIMIENTO_ESTADO CHECK (vch_tipoestado IN ('ACTIVO', 'ANULADO', 'CANCELADO')),
CONSTRAINT  PK_TIPOMOVIMIENTO PRIMARY KEY (chr_tipocodigo)
);



COMMENT ON TABLE EUREKA.TipoMovimiento IS 'Tabla de tipos de movimientos.';




COMMENT ON COLUMN EUREKA.TipoMovimiento.chr_tipocodigo IS 'Código del tipo de movimiento.';




COMMENT ON COLUMN EUREKA.TipoMovimiento.vch_tipodescripcion IS 'Descripción del tipo de movimiento.';




COMMENT ON COLUMN EUREKA.TipoMovimiento.vch_tipoaccion IS 'Acción del movimiento, puede ser INGRESO o SALIDA.';




COMMENT ON COLUMN EUREKA.TipoMovimiento.vch_tipoestado IS 'Estado del tipo de movimiento.';



CREATE TABLE EUREKA.Movimiento
(
	chr_cuencodigo       CHAR(8) NOT NULL ,
	int_movinumero       NUMBER(6,0) NOT NULL ,
	dtt_movifecha        DATE NOT NULL ,
	chr_emplcodigo       CHAR(4) NOT NULL ,
	chr_tipocodigo       CHAR(3) NOT NULL ,
	dec_moviimporte      NUMBER(12,2) NOT NULL  CONSTRAINT  CHK_MOVIMIENTO_IMPORTE CHECK (dec_moviimporte >= 0.0),
	chr_cuenreferencia   CHAR(8) NULL ,
CONSTRAINT  PK_MOVIMIENTO PRIMARY KEY (chr_cuencodigo,int_movinumero),
CONSTRAINT FK_MOVIMIENTO_CUENTA FOREIGN KEY (chr_cuencodigo) REFERENCES EUREKA.Cuenta (chr_cuencodigo),
CONSTRAINT FK_MOVIMIENTO_EMPLEADO FOREIGN KEY (chr_emplcodigo) REFERENCES EUREKA.Empleado (chr_emplcodigo),
CONSTRAINT FK_MOVIMIENTO_TIPOMOVIMIENTO FOREIGN KEY (chr_tipocodigo) REFERENCES EUREKA.TipoMovimiento (chr_tipocodigo)
);



COMMENT ON TABLE EUREKA.Movimiento IS 'Tabla donde se registran los movimientos de las cuentas.';




COMMENT ON COLUMN EUREKA.Movimiento.chr_cuencodigo IS 'Código de cuenta.';




COMMENT ON COLUMN EUREKA.Movimiento.int_movinumero IS 'Número de movimiento de la cuenta.';




COMMENT ON COLUMN EUREKA.Movimiento.dtt_movifecha IS 'Fecha del movimiento.';




COMMENT ON COLUMN EUREKA.Movimiento.chr_emplcodigo IS 'Código del empleado.';




COMMENT ON COLUMN EUREKA.Movimiento.chr_tipocodigo IS 'Código del tipo de movimiento.';




COMMENT ON COLUMN EUREKA.Movimiento.dec_moviimporte IS 'Importe del movimiento.';




COMMENT ON COLUMN EUREKA.Movimiento.chr_cuenreferencia IS 'Cuenta referencia, se utiliza en transferencias.';



CREATE TABLE EUREKA.Parametro
(
	chr_paracodigo       CHAR(3) NOT NULL ,
	vch_paradescripcion  VARCHAR(50) NOT NULL ,
	vch_paravalor        VARCHAR(70) NOT NULL ,
	vch_paraestado       VARCHAR(15) DEFAULT  'ACTIVO'  NOT NULL  CONSTRAINT  CHK_PARAMETRO_ESTADO CHECK (vch_paraestado IN ('ACTIVO', 'ANULADO', 'CANCELADO')),
CONSTRAINT  PK_PARAMETRO PRIMARY KEY (chr_paracodigo)
);



COMMENT ON TABLE EUREKA.Parametro IS 'Tabla de parámetros del sistema.';




COMMENT ON COLUMN EUREKA.Parametro.chr_paracodigo IS 'Código de parámetro.';




COMMENT ON COLUMN EUREKA.Parametro.vch_paradescripcion IS 'Descripción del parámetro.';




COMMENT ON COLUMN EUREKA.Parametro.vch_paravalor IS 'Valor del parámetro.';




COMMENT ON COLUMN EUREKA.Parametro.vch_paraestado IS 'Estado del parámetro.,';



CREATE TABLE EUREKA.InteresMensual
(
	chr_monecodigo       CHAR(2) NOT NULL ,
	dec_inteimporte      NUMBER(12,2) NOT NULL ,
CONSTRAINT  PK_INTERESMENSUAL PRIMARY KEY (chr_monecodigo),
CONSTRAINT FK_INTERESMENSUAL_MONEDA FOREIGN KEY (chr_monecodigo) REFERENCES EUREKA.Moneda (chr_monecodigo)
);



COMMENT ON TABLE EUREKA.InteresMensual IS 'Tabla donde se registran los porcentajes de interes mensual que se pagan a las cuentas por sus ahorros.';




COMMENT ON COLUMN EUREKA.InteresMensual.chr_monecodigo IS 'Código de moneda.';



CREATE TABLE EUREKA.CostoMovimiento
(
	chr_monecodigo       CHAR(2) NOT NULL ,
	dec_costimporte      NUMBER(12,2) NOT NULL ,
CONSTRAINT  PK_COSTOMOVIMIENTO PRIMARY KEY (chr_monecodigo),
CONSTRAINT FK_COSTOMOVIMIENTO_MONEDA FOREIGN KEY (chr_monecodigo) REFERENCES EUREKA.Moneda (chr_monecodigo)
);



COMMENT ON TABLE EUREKA.CostoMovimiento IS 'Tabla donde se registran los costos por movimiento según la moneda.';




COMMENT ON COLUMN EUREKA.CostoMovimiento.chr_monecodigo IS 'Código de moneda.';




COMMENT ON COLUMN EUREKA.CostoMovimiento.dec_costimporte IS 'Importe del costo de movimiento.';



CREATE TABLE EUREKA.CargoMantenimiento
(
	chr_monecodigo       CHAR(2) NOT NULL ,
	dec_cargMontoMaximo  NUMBER(12,2) NOT NULL ,
	dec_cargImporte      NUMBER(12,2) NOT NULL ,
CONSTRAINT  PK_CARGOMANTENIMIENTO PRIMARY KEY (chr_monecodigo),
CONSTRAINT fk_cargomantenimiento_moneda FOREIGN KEY (chr_monecodigo) REFERENCES EUREKA.Moneda (chr_monecodigo)
);



COMMENT ON TABLE EUREKA.CargoMantenimiento IS 'Esta tabla registra el cargo por mantenimiento de una cuenta según la moneda.';




COMMENT ON COLUMN EUREKA.CargoMantenimiento.chr_monecodigo IS 'Código de moneda.';




COMMENT ON COLUMN EUREKA.CargoMantenimiento.dec_cargMontoMaximo IS 'Importe máximo.';




COMMENT ON COLUMN EUREKA.CargoMantenimiento.dec_cargImporte IS 'mporte de cargo.';



CREATE TABLE EUREKA.Contador
(
	vch_conttabla        VARCHAR(30) NOT NULL ,
	int_contitem         NUMBER(6,0) NOT NULL ,
	int_contlongitud     NUMBER(3,0) NOT NULL ,
CONSTRAINT  PK_CONTADORES PRIMARY KEY (vch_conttabla)
);



COMMENT ON TABLE EUREKA.Contador IS 'Tabla de contadores para generar las PKs.';




COMMENT ON COLUMN EUREKA.Contador.vch_conttabla IS 'Nombre de  tabla.';




COMMENT ON COLUMN EUREKA.Contador.int_contitem IS 'Contador de tabla para generar los PK.';




COMMENT ON COLUMN EUREKA.Contador.int_contlongitud IS 'Longitud del campo.';


