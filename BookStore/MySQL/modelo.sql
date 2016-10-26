-- Empresa        :  BookStore S.A.C.
-- Software       :  Sistema de Comercialización y control de stock  (SCCS)
-- DBMS           :  MySQL
-- Base de Datos  :  BookStore
-- Script         :  Crea la base de datos y carga Datos de Prueba a la Base de Datos
-- Programado por :  Eric Gustavo Coronel Castillo
-- Email          :  gcoronelc@gmail.com
-- Site           :  gcoronelc.blogspot.com

-- ==========================================================
-- Creación de la Base de Datos
-- ==========================================================

   CREATE DATABASE IF NOT EXISTS bookstore;

-- ==========================================================
-- Seleccionar la Base de Datos
-- ==========================================================

   USE bookstore;

-- ==========================================================
-- Eliminar las tablas en caso existan
-- ==========================================================

   DROP TABLE IF EXISTS venta;
   DROP TABLE IF EXISTS publicacion;
   DROP TABLE IF EXISTS tipo;
   DROP TABLE IF EXISTS empleado;
   DROP TABLE IF EXISTS promocion;
   DROP TABLE IF EXISTS control;

-- ==========================================================
-- Creación de la Tablas
-- ==========================================================

   CREATE TABLE tipo (
       idtipo               char(3) NOT NULL,
       descripcion          varchar(20) NOT NULL,
       contador             int NOT NULL,
       CONSTRAINT pk_tipo PRIMARY KEY (idtipo),
       KEY idx_tipo (idtipo)
   )  ENGINE = INNODB;

   CREATE TABLE promocion (
       idpromocion          smallint NOT NULL,
       cantmin              smallint NOT NULL,
       cantmax              smallint NOT NULL,
       porcentaje           decimal(4,2) NOT NULL,
       CONSTRAINT pk_promocion PRIMARY KEY (idpromocion),
       KEY idx_promocion (idpromocion)
   )  ENGINE = INNODB;

   CREATE TABLE publicacion (
       idpublicacion        char(8) NOT NULL,
       titulo               varchar(30) NOT NULL,
       autor                varchar(50) NOT NULL,
       nroedicion           smallint NOT NULL,
       precio               decimal(8,2) NOT NULL,
       stock                smallint NOT NULL,
       idtipo               char(3) NOT NULL,
       CONSTRAINT pk_publicacion PRIMARY KEY (idpublicacion),
       KEY idx_publicacion_01 (idpublicacion),
       CONSTRAINT fk_publicacion_tipo 
            FOREIGN KEY (idtipo)
            REFERENCES tipo (idtipo)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
       KEY idx_publicacion_02 (idtipo)
   )  ENGINE = INNODB;

   CREATE TABLE empleado (
       idempleado           int NOT NULL,
       apellido             varchar(30) NOT NULL,
       nombre               varchar(30) NOT NULL,
       usuario              varchar(15) NOT NULL,
       clave                varchar(10) NOT NULL,
       CONSTRAINT pk_empleado PRIMARY KEY (idempleado),
       KEY idx_empleado (idempleado)
   ) ENGINE = INNODB;

   CREATE TABLE venta (
       idventa              int NOT NULL,
       cliente              varchar(30) NOT NULL,
       fecha                datetime NOT NULL,
       idempleado           int NOT NULL,
       idpublicacion        char(8) NOT NULL,
       cantidad             smallint NOT NULL,
       precio               decimal(8,2) NOT NULL,
       dcto                 decimal(8,2) NOT NULL,
       subtotal             decimal(8,2) NOT NULL,
       impuesto             decimal(8,2) NOT NULL,
       total                decimal(8,2) NOT NULL,
       CONSTRAINT pk_venta PRIMARY KEY (idventa),
       KEY idx_venta_01 (idventa),
       CONSTRAINT fk_venta_publicacion 
            FOREIGN KEY (idpublicacion)
            REFERENCES publicacion  (idpublicacion)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
       KEY idx_venta_02 (idpublicacion),
       CONSTRAINT fk_venta_empleado 
            FOREIGN KEY (idempleado)
            REFERENCES empleado  (idempleado)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
       KEY idx_venta_03 (idempleado)
   )  ENGINE = INNODB;

   CREATE TABLE control (
       parametro            varchar(25) NOT NULL,
       valor                varchar(25) NOT NULL,
       CONSTRAINT pk_control PRIMARY KEY (parametro)
   ) ENGINE = INNODB;


-- ==========================================================
-- Cargar Datos de Prueba
-- ==========================================================

-- Tabla: tipo

   Insert Into tipo( idtipo,descripcion,contador ) Values( 'LIB','Libro',10 );
   Insert Into tipo( idtipo,descripcion,contador ) Values( 'REV','Revista',3 );
   Insert Into tipo( idtipo,descripcion,contador ) Values( 'SEP','Separata',8 );


-- Libros

   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00001','LIB','Power Builder 6.0','William B. Heys',1, 50.00,1000);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00002','LIB','Visual Basic 6.0','Joel Carrasco',2,45.00,1500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00003','LIB','Programación C/S con VB','Kenneth L. Spenver',1,45.00,450);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00004','LIB','VBScript a través de Ejemplos','Jery Honeycutt',1,35.00,720);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00005','LIB','UNIX en 12 lecciones','Juan Matías Matías',1,25.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00006','LIB','Visual Basic y SQL Server','Eric G. Coronel Castillo',1,35.00,5000);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00007','LIB','Power Builder y SQL Server','Eric G. Coronel Castillo',1,35.00,5000);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00008','LIB','PHP y MySQL','Eric G. Coronel Castillo',1,55.00,5000);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00009','LIB','Lenguaje de Programación Java 2','Eric G. Coronel Castillo',1,55.00,5000);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('LIB00010','LIB','Oracle Database 10g','Eric G. Coronel Castillo',1,75.00,5000);


-- Revistas

   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00001','REV','Eureka','GrapPeru',1,4.00,770);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00002','REV','El Programador','ElectroSoft S.A.C.',1,6.00,1200);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('REV00003','REV','La Revista del Programador','PeruDev',1,10.00,590);


-- Separatas

   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00001','SEP','Power Builder 7.0 Básico','Eric G. Coronel C.',1,20.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00002','SEP','Power Builder 7.0 Avanzado','Eric G. Coronel C.',1,20.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00003','SEP','Visual Basic 6.0 Básico','Hugo Valencia M.',1,20.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00004','SEP','Visual Bsic 6.0 Avanzado','Hugo Valencia M.',1,20.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00005','SEP','SQL Server 7.0 Básico','Sergio Matsukawa',1,20.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00006','SEP','SQL Server 7.0 Avanzado','Sergio Matsukawa',1,20.00,500);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00007','SEP','Windows 2000','Hugo Valencia',1,8.00,1190);
   Insert Into publicacion( idpublicacion,idtipo,titulo,autor,nroedicion,precio,stock ) 
    Values('SEP00008','SEP','windows 2000','Sergio Matsukawa ',1,10.00,2000);


-- promociones

   Insert Into promocion(idpromocion,cantmin,cantmax,porcentaje) Values(1,1,4,0);
   Insert Into promocion(idpromocion,cantmin,cantmax,porcentaje) Values(2,5,10,0.03);
   Insert Into promocion(idpromocion,cantmin,cantmax,porcentaje) Values(3,11,20,0.05);
   Insert Into promocion(idpromocion,cantmin,cantmax,porcentaje) Values(4,21,50,0.07);
   Insert Into promocion(idpromocion,cantmin,cantmax,porcentaje) Values(5,51,100,0.10);
   Insert Into promocion(idpromocion,cantmin,cantmax,porcentaje) Values(6,101,1000,0.12);


-- empleados

   Insert Into empleado(idempleado,apellido,nombre,usuario,clave) 
     Values(1,'AGUERO RAMOS','EMILIO','eaguero','123456');
   Insert Into empleado(idempleado,apellido,nombre,usuario,clave) 
     Values(2,'SANCHEZ ROMERO','KATHIA','ksanchez','123456');
   Insert Into empleado(idempleado,apellido,nombre,usuario,clave) 
     Values(3,'LUNG WON','FELIX','flung','123456');
   Insert Into empleado(idempleado,apellido,nombre,usuario,clave) 
     Values(4,'CASTILLO RAMOS','EDUARDO','ecastillo','123456');
   Insert Into empleado(idempleado,apellido,nombre,usuario,clave) 
     Values(5,'MILICICH FLORES','LAURA','lmilicich','123456');
   Insert Into empleado(idempleado,apellido,nombre,usuario,clave) 
     Values(6,'DELGADO BARRERA','KENNETH','kdelgado','123456');
     
   
-- ventas

   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(01,'ISIL',   05,date_sub(sysdate(),interval 60 day),'LIB00003',2,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(02,'UNI',    01,date_sub(sysdate(),interval 59 day),'REV00002',4,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(03,'Pedro',  03,date_sub(sysdate(),interval 58 day),'LIB00005',6,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(04,'Pablo',  02,date_sub(sysdate(),interval 58 day),'SEP00002',1,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(05,'Vilma',  01,date_sub(sysdate(),interval 57 day),'LIB00003',3,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(06,'Betty',  05,date_sub(sysdate(),interval 57 day),'REV00002',7,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(07,'Mercy',  06,date_sub(sysdate(),interval 56 day),'LIB00010',3,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(08,'Cesar', 03,date_sub(sysdate(),interval 55 day),'SEP00002',5,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(09,'Delia',  06,date_sub(sysdate(),interval 54 day),'LIB00006',8,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(10,'Nora',   05,date_sub(sysdate(),interval 53 day),'SEP00008',2,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(11,'Marcelo',02,date_sub(sysdate(),interval 52 day),'SEP00007',5,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(12,'Edgar',  02,date_sub(sysdate(),interval 51 day),'LIB00006',3,0,0,0,0,0);



  insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(13,'IPAE',   03,date_sub(sysdate(),interval 50 day),'LIB00003',2,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(14,'ISL',    06,date_sub(sysdate(),interval 49 day),'REV00002',4,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(15,'UNI',    01,date_sub(sysdate(),interval 47 day),'LIB00005',6,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(16,'Carmen', 03,date_sub(sysdate(),interval 47 day),'SEP00005',1,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(17,'Delia',  05,date_sub(sysdate(),interval 47 day),'LIB00003',3,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(18,'Ricardo',01,date_sub(sysdate(),interval 40 day),'REV00002',7,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(19,'Claudia',04,date_sub(sysdate(),interval 37 day),'LIB00005',3,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(20,'Roberto',06,date_sub(sysdate(),interval 37 day),'SEP00006',5,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(21,'Nora',  02,date_sub(sysdate(),interval 32 day),'LIB00006',8,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(22,'Elena',  01,date_sub(sysdate(),interval 32 day),'SEP00004',2,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(23,'Cynthia',04,date_sub(sysdate(),interval 29 day),'SEP00007',5,0,0,0,0,0);
   insert into venta (idventa,cliente,idempleado,fecha,idpublicacion,cantidad,precio,dcto,subtotal,impuesto,total)
    values(24,'Alejandra',03,date_sub(sysdate(),interval 29 day),'LIB00007',3,0,0,0,0,0);

-- Actualizar ventas

   update venta
    set precio = (select precio from publicacion
                  where publicacion.idpublicacion = venta.idpublicacion);

   update venta
    set dcto = (select porcentaje from promocion
                  where venta.cantidad between cantmin and cantmax) * precio;

   update venta
    set total = cantidad * (precio - dcto);

   update venta
    set subtotal = total / 1.19;
		
   update venta
    set impuesto = total - subtotal;

-- control

   Insert Into control(parametro,valor) Values('IGV','0.18');
   Insert Into control(parametro,valor) Values('venta','24');
   Insert Into control(parametro,valor) Values('Empresa','PeruDev');
   Insert Into control(parametro,valor) Values('Empleado','6');
   Insert Into control(parametro,valor) Values('Site','www.perudev.net'); 

