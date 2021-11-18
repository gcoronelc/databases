REM Empresa           :  BookStore S.A.C.
REM Software          :  Sistema de Comercialización y Control de Stock  (SCCS)
REM DBMS              :  ORACLE 12G o Superior
REM Esquema           :  BookStore
REM Script            :  Crea el esquema y carga Datos de Prueba
REM Autor             :  Eric Gustavo Coronel Castillo
REM Email             :  gcoronelc@gmail.com
REM Sitio Web         :  www.desarrollasoftware.com
REM Blog              :  gcoronelc.blogspot.com
REM Cursos virtuales  :  gcoronelc.github.io    

-- =============================================
-- Ultimos cambios
-- =============================================
/*

20-Junio-2017: Se agrego la tabla USUARIO.

*/


-- ============================================
-- DESHABILITAR SALIDAS
-- ============================================

-- SET TERMOUT OFF
-- SET ECHO OFF

-- =============================================
-- CRACIÓN DEL USUARIO
-- =============================================

DECLARE
	N INT;
	COMMAND VARCHAR2(200);
BEGIN
	COMMAND := 'DROP USER BOOKSTORE CASCADE';
	SELECT COUNT(*) INTO N
	FROM DBA_USERS
	WHERE USERNAME = 'BOOKSTORE';
	IF ( N = 1 ) THEN
		EXECUTE IMMEDIATE COMMAND;
	END IF;
END;
/

-- Valido para la versión 12
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER BOOKSTORE IDENTIFIED BY admin;

GRANT CONNECT, RESOURCE TO BOOKSTORE;
GRANT CREATE VIEW TO BOOKSTORE;


-- =============================================
-- CONECTARSE A ORACLE
-- =============================================

CONNECT BOOKSTORE/admin

  
  
-- ==========================================================
-- Creación de la Tablas
-- ==========================================================


CREATE TABLE BOOKSTORE.EMPLEADO
(
	idempleado           NUMBER(8) NOT NULL ,
	apellido             VARCHAR2(100) NOT NULL ,
	nombre               VARCHAR2(100) NOT NULL ,
	direccion            VARCHAR2(150) NOT NULL ,
	email                VARCHAR2(100) NOT NULL ,
CONSTRAINT  XPKempleado PRIMARY KEY (idempleado)
);



CREATE TABLE BOOKSTORE.USUARIO
(
	idempleado           NUMBER(8) NOT NULL ,
	usuario              VARCHAR2(20) NOT NULL ,
	clave                VARCHAR2(100) NOT NULL ,
	activo               NUMBER(2) NOT NULL ,
CONSTRAINT  XPKUSUARIO PRIMARY KEY (idempleado),
CONSTRAINT R_8 FOREIGN KEY (idempleado) REFERENCES BOOKSTORE.EMPLEADO (idempleado)
);



CREATE TABLE BOOKSTORE.CONTROL
(
	parametro            VARCHAR2(50) NOT NULL ,
	valor                VARCHAR2(150) NOT NULL ,
CONSTRAINT  XPKControl PRIMARY KEY (parametro)
);



CREATE TABLE BOOKSTORE.TIPO
(
	idtipo               CHAR(3) NOT NULL ,
	descripcion          VARCHAR2(100) NOT NULL ,
	contador             NUMBER(5) NOT NULL ,
CONSTRAINT  XPKLinea PRIMARY KEY (idtipo)
);



CREATE TABLE BOOKSTORE.PUBLICACION
(
	idpublicacion        CHAR(8) NOT NULL ,
	titulo               VARCHAR2(150) NOT NULL ,
	idtipo               CHAR(3) NOT NULL ,
	autor                VARCHAR2(150) NOT NULL ,
	nroedicion           NUMERIC(3) NOT NULL ,
	precio               NUMBER(10,2) NOT NULL ,
	stock                NUMBER(8) NOT NULL ,
CONSTRAINT  XPKPublicacion PRIMARY KEY (idpublicacion),
CONSTRAINT FK_PUBLICACION_TIPO FOREIGN KEY (idtipo) REFERENCES BOOKSTORE.TIPO (idtipo)
);



CREATE TABLE BOOKSTORE.VENTA
(
	idventa              NUMBER(8) NOT NULL ,
	cliente              VARCHAR2(150) NOT NULL ,
	fecha                DATE NOT NULL ,
	idempleado           NUMBER(8) NOT NULL ,
	idpublicacion        CHAR(8) NOT NULL ,
	cantidad             NUMBER(5) NOT NULL ,
	precio               NUMBER(10,2) NOT NULL ,
	dcto                 NUMBER(10,2) NOT NULL ,
	subtotal             NUMBER(10,2) NOT NULL ,
	impuesto             NUMBER(10,2) NOT NULL ,
	total                NUMBER(10,2) NOT NULL ,
CONSTRAINT  XPKVenta PRIMARY KEY (idventa),
CONSTRAINT FK_VENTA_PUBLICACION FOREIGN KEY (idpublicacion) REFERENCES BOOKSTORE.PUBLICACION (idpublicacion),
CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (idempleado) REFERENCES BOOKSTORE.EMPLEADO (idempleado)
);



CREATE TABLE BOOKSTORE.PROMOCION
(
	idpromocion          NUMBER(8) NOT NULL ,
	cantmin              NUMBER(8) NOT NULL ,
	cantmax              NUMBER(8) NOT NULL ,
	porcentaje           NUMBER(8,2) NOT NULL ,
CONSTRAINT  XPKPromocion PRIMARY KEY (idpromocion)
);


-- ==========================================================
-- Cargar Datos de Prueba
-- ==========================================================

-- Tabla: tipo

   Insert Into BOOKSTORE.tipo( idtipo,descripcion,contador ) Values( 'LIB','Libro',10 );
   Insert Into BOOKSTORE.tipo( idtipo,descripcion,contador ) Values( 'REV','Revista',3 );
   Insert Into BOOKSTORE.tipo( idtipo,descripcion,contador ) Values( 'SEP','Separata',8 );


-- Libros

   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00001','LIB','Power Builder','William B. Heys',1, 50.00,1000);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00002','LIB','Visual Basic','Joel Carrasco',2,45.00,1500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00003','LIB','Programación C/S con VB','Kenneth L. Spenver',1,45.00,450);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00004','LIB','JavaScript a través de Ejemplos','Jery Honeycutt',1,35.00,720);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00005','LIB','UNIX en 12 lecciones','Juan Matías Matías',1,25.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00006','LIB','Visual Basic y SQL Server','Eric G. Coronel Castillo',1,35.00,5000);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00007','LIB','Power Builder y SQL Server','Eric G. Coronel Castillo',1,35.00,5000);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00008','LIB','PHP y MySQL','Eric G. Coronel Castillo',1,55.00,5000);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00009','LIB','Lenguaje de Programación Java 2','Eric G. Coronel Castillo',1,55.00,5000);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00010','LIB','Oracle Database','Eric G. Coronel Castillo',1,75.00,5000);


-- Revistas

   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00001','REV','Eureka','GrapPeru',1,4.00,770);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00002','REV','El Programador','Desarrolla Software SAC',1,6.00,1200);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00003','REV','La Revista del Programador','DotNET SAC',1,10.00,590);


-- Separatas

   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00001','SEP','Java Orientado a Objetos','Eric G. Coronel C.',1,20.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00002','SEP','Desarrollo Web con Java','Eric G. Coronel C.',1,20.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00003','SEP','Electrónica Aplicada','Hugo Valencia M.',1,20.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00004','SEP','Circuitos Digitales','Hugo Valencia M.',1,20.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00005','SEP','SQL Server Básico','Sergio Matsukawa',1,20.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00006','SEP','SQL Server Avanzado','Sergio Matsukawa',1,20.00,500);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00007','SEP','Windows Server Fundamentos','Hugo Valencia',1,8.00,1190);
   Insert Into BOOKSTORE.publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00008','SEP','windows Server Administración','Sergio Matsukawa ',1,10.00,2000);


-- promociones

   Insert Into BOOKSTORE.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(1,1,4,0);
   Insert Into BOOKSTORE.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(2,5,10,0.05);
   Insert Into BOOKSTORE.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(3,11,20,0.10);
   Insert Into BOOKSTORE.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(4,21,50,0.13);
   Insert Into BOOKSTORE.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(5,51,100,0.16);
   Insert Into BOOKSTORE.promocion(idpromocion,cantmin,cantmax,porcentaje) Values(6,101,10000,0.20);


-- empleados

   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(1,'AGUERO RAMOS','EMILIO','Lima','emilio@gmail.com');
   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(2,'SANCHEZ ROMERO','KATHIA','Miraflores','kathia@yahoo.es');
   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(3,'LUNG WON','FELIX','Los Olivos','gato@hotmail.com');
   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(4,'CASTILLO RAMOS','EDUARDO','Barrios altos','lalo@gmail.com');
   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(5,'MILICICH FLORES','LAURA','Collique','laura@usil.pe');
   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(6,'DELGADO BARRERA','KENNETH','La punta','pochita@gmail.com');
   Insert Into BOOKSTORE.empleado(idempleado,apellido,nombre,direccion,email) 
     Values(7,'GARCIA SOLIS','JOSE ELVIS','Barranco','pepe@gmail.com');
     
 -- usuarios  
   
   Insert Into BOOKSTORE.usuario(idempleado,usuario,clave,activo) Values(1,'eaguero','cazador',1);
   Insert Into BOOKSTORE.usuario(idempleado,usuario,clave,activo) Values(2,'ksanchez','suerte',1);
   Insert Into BOOKSTORE.usuario(idempleado,usuario,clave,activo) Values(3,'flung','por100pre',0);
   Insert Into BOOKSTORE.usuario(idempleado,usuario,clave,activo) Values(4,'ecastillo','hastalavista',1);
   Insert Into BOOKSTORE.usuario(idempleado,usuario,clave,activo) Values(5,'lmilicich','turuleka',0);
   Insert Into BOOKSTORE.usuario(idempleado,usuario,clave,activo) Values(6,'kdelgado','noimporta',1);   
   
-- ventas

   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(01,'ISIL',   05,SYSDATE - 60,'LIB00003',2,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(02,'UNI',    01,SYSDATE - 59,'REV00002',4,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(03,'Pedro',  03,SYSDATE - 58,'LIB00005',6,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(04,'Pablo',  02,SYSDATE - 58,'SEP00002',1,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(05,'Vilma',  01,SYSDATE - 57,'LIB00003',3,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(06,'Betty',  05,SYSDATE - 57,'REV00002',7,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(07,'Mercy',  06,SYSDATE - 56,'LIB00010',3,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(08,'Cesar', 03,SYSDATE - 55,'SEP00002',5,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(09,'Delia',  06,SYSDATE - 54,'LIB00006',8,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(10,'Nora',   05,SYSDATE - 53 ,'SEP00008',2,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(11,'Marcelo',02,SYSDATE - 52,'SEP00007',5,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(12,'Edgar',  02,SYSDATE - 51,'LIB00006',3,0,0,0,0,0);



  insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(13,'IPAE',   03,SYSDATE - 50,'LIB00003',2,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(14,'ISL',    06,SYSDATE - 49,'REV00002',4,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(15,'UNI',    01,SYSDATE - 47,'LIB00005',6,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(16,'Carmen', 03,SYSDATE - 47,'SEP00005',1,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(17,'Delia',  05,SYSDATE - 47,'LIB00003',3,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(18,'Ricardo',01,SYSDATE - 40,'REV00002',7,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(19,'Claudia',04,SYSDATE - 37,'LIB00005',3,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(20,'Roberto',06,SYSDATE - 37,'SEP00006',5,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(21,'Nora',  02,SYSDATE - 32,'LIB00006',8,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(22,'Elena',  01,SYSDATE - 32,'SEP00004',2,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(23,'Cynthia',04,SYSDATE - 29,'SEP00007',5,0,0,0,0,0);
   insert Into BOOKSTORE.venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(24,'Alejandra',03,SYSDATE - 29,'LIB00007',3,0,0,0,0,0);

-- Actualizar ventas

   update BOOKSTORE.venta
    set precio = (select precio from BOOKSTORE.publicacion
                  where publicacion.idpublicacion = venta.idpublicacion);

   update BOOKSTORE.venta
    set dcto = (select porcentaje from BOOKSTORE.promocion
                  where venta.cantidad between cantmin and cantmax) * precio;

   update BOOKSTORE.venta
    set total = cantidad * (precio - dcto);

   update BOOKSTORE.venta
    set subtotal = total / 1.18;
		
   update BOOKSTORE.venta
    set impuesto = total - subtotal;

-- control

   Insert Into BOOKSTORE.control(parametro,valor) Values('IGV','0.18');
   Insert Into BOOKSTORE.control(parametro,valor) Values('VENTA','24');
   Insert Into BOOKSTORE.control(parametro,valor) Values('EMPLEADO','7');
   Insert Into BOOKSTORE.control(parametro,valor) Values('EMPRESA','Desarrolla Software');   
   Insert Into BOOKSTORE.control(parametro,valor) Values('SITE','www.desarrollasoftware.com'); 


-- Confirmar operaciones

  commit;

-- =============================================
-- HABILITAR SALIDAS
-- =============================================

SET TERMOUT ON
SET ECHO ON
SHOW USER
SET LINESIZE 600
SET PAGESIZE 5000
SELECT * FROM CAT;

